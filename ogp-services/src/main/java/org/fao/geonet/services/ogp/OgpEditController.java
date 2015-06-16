package org.fao.geonet.services.ogp;

import jeeves.server.context.ServiceContext;
import jeeves.services.ReadWriteController;
import org.apache.commons.lang.StringUtils;
import org.fao.geonet.Logger;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.domain.ISODate;
import org.fao.geonet.domain.MetadataType;
import org.fao.geonet.kernel.DataManager;
import org.fao.geonet.kernel.SchemaManager;
import org.fao.geonet.kernel.setting.SettingManager;
import org.fao.geonet.services.ogp.business.TransformService;
import org.fao.geonet.services.ogp.client.OgpClient;
import org.fao.geonet.utils.GeonetHttpRequestFactory;
import org.fao.geonet.utils.Log;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Controller for the editor wizard.
 * Created by JuanLuis on 15/05/2015.
 */
@Controller("ogp.editController")
@ReadWriteController
@SessionAttributes({"wizardFormBean"})
public class OgpEditController {
    private final Logger logger;
    @Autowired
    private DataManager metadataManager;
    @Autowired
    private SchemaManager schemaManager;
    @Autowired
    private SettingManager settingManager;
    @Autowired
    private OgpController ogpController;
    @Autowired
    private TransformService transformService;
    private final GeonetHttpRequestFactory requestFactory;


    public OgpEditController() {
        logger = Log.createLogger("ogp.editController", "ogp");
        requestFactory = new GeonetHttpRequestFactory();

    }

    @ModelAttribute("wizardFormBean")
    public OgpEditFormBean createWizardFormBean() {
        return new OgpEditFormBean();
    }

    @RequestMapping(value = "{lang}/ogp.edit.clearStatus", produces = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody ResponseEntity<Object> resetSessionAttributes(SessionStatus sessionStatus, @PathVariable("lang") String lang) {
        sessionStatus.setComplete();
        return new ResponseEntity<Object>(Boolean.TRUE, HttpStatus.OK);
    }

    @RequestMapping(value = "/{lang}/ogp.edit.addRecord", produces = MediaType.APPLICATION_JSON_VALUE)
    public
    @ResponseBody
    ResponseEntity<Object> addDatasetMetadata(@ModelAttribute("wizardFormBean") OgpEditFormBean wizardFormBean,
                                              @RequestParam("mefFile") MultipartFile file,
                                              @RequestParam(value = "step") String stepString, @PathVariable("lang") String lang) {
        if (logger.isDebugEnabled()) {
            logger.debug("Adding dataset metadata " + wizardFormBean.toString());
            logger.debug("Import step: " + stepString);
        }
        Step step;
        try {
            step = Step.valueOf(stepString);
        } catch (IllegalArgumentException iae) {
            // IAE is thrown when stepString doesn't contain any valid Step item
            return new ResponseEntity<Object>("'step' parameter value is not valid. It must be one of " + Arrays.toString(Step.values()),
                    HttpStatus.BAD_REQUEST);
        }


        if (!file.isEmpty()) {
            try {
                InputStream content = file.getInputStream();
                Element md = Xml.loadStream(content);
                String metadataSchema = metadataManager.autodetectSchema(md, null);
                if (metadataSchema == null) {
                    updateWizardObject(wizardFormBean, null, step);
                    return new ResponseEntity<Object>("Schema not supported", HttpStatus.BAD_REQUEST);
                }
                md = transformService.convertToIso19115_3(md);

                updateWizardObject(wizardFormBean, md, step);

            } catch (JDOMException jde) {
                updateWizardObject(wizardFormBean, null, step);
                return new ResponseEntity<Object>("Not a valid XML document", HttpStatus.BAD_REQUEST);
            } catch (Exception e) {
                updateWizardObject(wizardFormBean, null, step);
                return new ResponseEntity<Object>("Error: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } else {
            return new ResponseEntity<Object>("File is empty", HttpStatus.BAD_REQUEST);
        }
        String[] result = {Boolean.TRUE.toString()};
        return new ResponseEntity<Object>(result, HttpStatus.OK);
    }

    @RequestMapping(value = "/{lang}/ogp.edit.importOgpRecord", produces = MediaType.APPLICATION_JSON_VALUE)
    public
    @ResponseBody
    ResponseEntity<Object> addOgpMetadata(@ModelAttribute("wizardFormBean") OgpEditFormBean wizardFormBean,
                                              @RequestParam(value = "layerId") String layerId, @PathVariable("lang") String lang) {
        try {
            Element ogpMetadata = ogpController.getMetadataAsElement(layerId);
            wizardFormBean.setOgpImportedMetadata(ogpMetadata);
            wizardFormBean.setLocalMetadataRecord(null);
        } catch (IOException e) {
            String result = "There was an error contacting OGP server.";
            wizardFormBean.setOgpImportedMetadata(null);
            return new ResponseEntity<Object>(result, HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (JDOMException e) {
            String result = "Error parsing the metadata: " + e.getMessage();
            return new ResponseEntity<Object>(result, HttpStatus.INTERNAL_SERVER_ERROR);

        } catch (Exception e) {
            String result = "Error parsing o transforming the metadata: " + e.getMessage();
            return new ResponseEntity<Object>(result, HttpStatus.INTERNAL_SERVER_ERROR);

        }
        return new ResponseEntity<Object>(Boolean.TRUE.toString(), HttpStatus.OK);
    }

    @RequestMapping(value="/{lang}/ogp.edit.doImport", produces = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody ResponseEntity<Object> doImport(@ModelAttribute("wizardFormBean") OgpEditFormBean wizardFormBean,
                                                         SessionStatus status,
                                                         @RequestBody OgpDoEditBean formBean, @PathVariable("lang") String lang) {
        Element template = null;
        Element metadata = null;
        String createdId;

        // Retrieve the template from the database.
        if (StringUtils.isNotBlank(formBean.getTemplateId())) {
            try {
                template = metadataManager.getMetadata(formBean.getTemplateId());
                if (template == null) {
                    String result = "Could not find the template " + formBean.getTemplateId();
                    return createErrorResponse(result, HttpStatus.BAD_REQUEST);
                }
            } catch (Exception e) {
                String result = "Could not retrieve the template " + formBean.getTemplateId();
                return createErrorResponse(result, HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }
        if (StringUtils.isEmpty(formBean.getGroup())) {
            String result = "Group not valid";
            return createErrorResponse(result, HttpStatus.BAD_REQUEST);
        }
        try {
            Path etlMergeStylesheet = schemaManager.getSchemaDir("iso19115-3").resolve(Geonet.Path.PROCESS_STYLESHEETS)
                    .resolve("etl-merge.xsl");
            Path templateMergeStylesheet = schemaManager.getSchemaDir("iso19115-3").resolve(Geonet.Path.PROCESS_STYLESHEETS)
                    .resolve("template-merge.xsl");
            if (template != null) {
                metadata = template;
                if (formBean.isDatasetImported() && wizardFormBean.getDatasetMetadata() != null) {
                    metadata = Xml.transformWithXmlParam(template, etlMergeStylesheet.toString(), "etlXml", Xml.getString(wizardFormBean.getDatasetMetadata()));
                }
                Element step2Metadata = null;
                if (formBean.isLocalRecordImported() && wizardFormBean.getLocalMetadataRecord() != null) {
                    step2Metadata = wizardFormBean.getLocalMetadataRecord();
                } else if (formBean.isOgpRecordImported() && wizardFormBean.getOgpImportedMetadata() != null) {
                    step2Metadata = wizardFormBean.getOgpImportedMetadata();
                }
                if (step2Metadata != null) {
                    metadata = Xml.transformWithXmlParam(step2Metadata, templateMergeStylesheet.toString(), "templateXml", Xml.getString(metadata));
                }
            } else {
                // not from template
                // Check if we have at least one record to edit
                if (wizardFormBean.getLocalMetadataRecord() == null && wizardFormBean.getOgpImportedMetadata() == null && wizardFormBean.getDatasetMetadata() == null) {
                    String result = "Before you can edit the record you must import a dataset, a local record or a remote one from OGP";
                    return createErrorResponse(result, HttpStatus.BAD_REQUEST);
                }
                if (formBean.isDatasetImported() && wizardFormBean.getDatasetMetadata() != null) {
                    metadata = wizardFormBean.getDatasetMetadata();
                }
                Element step2Metadata = null;
                if (formBean.isLocalRecordImported() && wizardFormBean.getLocalMetadataRecord() != null) {
                    step2Metadata = wizardFormBean.getLocalMetadataRecord();
                } else if (formBean.isOgpRecordImported() && wizardFormBean.getOgpImportedMetadata() != null) {
                    step2Metadata = wizardFormBean.getOgpImportedMetadata();
                }
                if (metadata == null && step2Metadata != null) {
                    metadata = step2Metadata;
                } else if (metadata != null && step2Metadata !=null) {
                    metadata = Xml.transformWithXmlParam(step2Metadata, etlMergeStylesheet.toString(), "etlXml", Xml.getString(metadata));
                }
            }
            if (metadata == null) {
                String result = "Not enough data to perform the operation. Please restart the wizard.";
                return createErrorResponse(result, HttpStatus.INTERNAL_SERVER_ERROR);
            }

            // Save the record
            // Import record
            String uuid = UUID.randomUUID().toString();
            String date = new ISODate().toString();
            ServiceContext context = ServiceContext.get();
            int userId = context.getUserSession().getUserIdAsInt();
            String docType = null, category = null;
            boolean updateFixedInfo = true, indexImmediate = true;
            createdId = metadataManager.insertMetadata(context, "iso19115-3" , metadata, uuid,
                    userId, formBean.getGroup(), settingManager.getSiteId(), MetadataType.METADATA.codeString, docType, category, date, date, updateFixedInfo, indexImmediate);

        } catch (Exception e) {
            String result = "Error creating the record: " + e.getMessage();
            return createErrorResponse(result, HttpStatus.INTERNAL_SERVER_ERROR);
        }

        status.setComplete();

        return new ResponseEntity<Object>(createdId, HttpStatus.OK);
    }


    @RequestMapping(value = "{lang}/ogp.edit.preview")
    public @ResponseBody ResponseEntity<Object> previewMetadata(@ModelAttribute("wizardFormBean") OgpEditFormBean wizardFormBean,
                                                                @RequestParam("step") String stepParam,
                                                                @PathVariable("lang") String lang) {
        Step step;
        Element metadata = null;
        String result = "";
        try {
            step = Step.valueOf(stepParam);
        } catch (IllegalArgumentException iae) {
            // IAE is thrown when stepString doesn't contain any valid Step item

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            return new ResponseEntity<Object>("'step' parameter value is not valid. It must be one of " + Arrays.toString(Step.values()),
                    headers, HttpStatus.BAD_REQUEST);
        }

        switch (step) {
            case importXmlMetadata:
                metadata = wizardFormBean.getLocalMetadataRecord();
                break;
            case importDataProperties:
                metadata = wizardFormBean.getDatasetMetadata();
                break;
        }

        if (metadata != null) {
            result = Xml.getString(metadata);
        }


        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.TEXT_HTML);
        return new ResponseEntity<Object>(result, headers, HttpStatus.OK);
    }

    /**
     * Create an error response in the form {"error": result}.
     * @param result error text.
     * @param status HTTP server response status.
     * @return a new ResponseEntity.
     */
    private ResponseEntity<Object> createErrorResponse(String result, HttpStatus status) {
        Map<String, String> result2 = new HashMap<>();
        result2.put("error", result);
        return new ResponseEntity<Object>(result2, status);
    }

    private void updateWizardObject(OgpEditFormBean bean, Element metadata, Step step) {
        switch (step) {
            case importDataProperties:
                bean.setDatasetMetadata(metadata);
                break;
            case importXmlMetadata:
                bean.setLocalMetadataRecord(metadata);
                break;
        }
    }

    /**
     * Retrieves the metadata from the remote server and return it transformed to ISO-19115-3 standard.
     * @param layerId remote metadata identifier.
     * @return the metadata transformed.
     * @throws Exception
     */
    public Element getMetadataAsElement(String layerId) throws Exception {

        OgpClient client = getOgpClient();
        String metadata = client.getMetadataAsXml(layerId);
        Element originalMd = Xml.loadString(metadata, false);
        return transformService.convertToIso19115_3(originalMd);
    }

    /**
     * Create a new OgpClient.
     *
     * @return an OgpClient configured with the URL set in Settings.
     */
    private OgpClient getOgpClient() {
        String host = settingManager.getValue(OgpClient.OGP_CLOUD_HOST);
        int port = settingManager.getValueAsInt(OgpClient.OGP_CLOUD_PORT);
        String protocol = settingManager.getValue(OgpClient.OGP_CLOUD_PROTOCOL);
        return new OgpClient(protocol, host, port, requestFactory);
    }

    /**
     * Wizard step
     */
    public enum Step {
        importDataProperties,
        importXmlMetadata

    }

}
