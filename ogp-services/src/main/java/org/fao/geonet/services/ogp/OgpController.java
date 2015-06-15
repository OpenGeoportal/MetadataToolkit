package org.fao.geonet.services.ogp;

import jeeves.server.context.ServiceContext;
import jeeves.services.ReadWriteController;
import org.apache.commons.lang.StringUtils;
import org.fao.geonet.Logger;
import org.fao.geonet.domain.ISODate;
import org.fao.geonet.domain.MetadataType;
import org.fao.geonet.kernel.DataManager;
import org.fao.geonet.kernel.SchemaManager;
import org.fao.geonet.kernel.setting.SettingManager;
import org.fao.geonet.services.ogp.business.TransformService;
import org.fao.geonet.services.ogp.client.OgpClient;
import org.fao.geonet.services.ogp.client.OgpQuery;
import org.fao.geonet.services.ogp.responses.DataTypeResponse;
import org.fao.geonet.utils.GeonetHttpRequestFactory;
import org.fao.geonet.utils.Log;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.UUID;


/**
 * Retrieves the data types available in the OGP server.
 * Created by JuanLuis on 28/01/2015.
 */
@Controller("ogp.controller")
@ReadWriteController
public class OgpController {
    private final Logger logger;

    @Autowired
    private DataManager dataManager;
    @Autowired
    private SchemaManager schemaManager;
    @Autowired
    private SettingManager settingManager;

    @Autowired
    private TransformService transformService;

    private final GeonetHttpRequestFactory requestFactory;

    public OgpController() {
        logger = Log.createLogger("ogp.dataType", "ogp");
        requestFactory = new GeonetHttpRequestFactory();

        logger.warning("Initialising OdpDataTypes");
    }

    @RequestMapping(value = "/{lang}/ogp.dataTypes", produces = {
            MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})

    public
    @ResponseBody
    DataTypeResponse getTypes(@PathVariable("lang") String lang) {
        DataTypeResponse rep = new DataTypeResponse();
        rep.setDataType("TestDataType");
        return rep;
    }


    /**
     * Query to OGP server about the metadata restrictions given by <code>formBean</code> parameter.
     * @param formBean search parameters
     * @param lang not used.
     * @return a list of OGP cloud metadata. See OpenGeoPortal documentation about the format of the response
     *          (http://opengeoportal.org/software/open-geoportal).
     * @throws IOException
     */
    @RequestMapping(value = "/{lang}/ogp.dataTypes.search", produces = {
            MediaType.APPLICATION_JSON_VALUE})
    public
    @ResponseBody
    String processForm(@RequestBody OgpSearchFormBean formBean, @PathVariable("lang") String lang) throws IOException {
        OgpClient client = getOgpClient();
        if (StringUtils.isBlank(formBean.getSolrQuery())) {
            OgpQuery query = new OgpQuery(formBean);
            return client.executeQuery(query);
        } else {
            OgpQuery query = new OgpQuery(formBean);
            return client.executeRawQuery(query);
        }
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
     * Use this method to retrieve the remote metadata in HTML format
     *
     * @param layerId remote metadata identifier.
     * @return the metadata as HTML.
     * @throws IOException
     */
    @RequestMapping(value = "/{lang}/ogp.dataTypes.getMetadata", produces = {
            MediaType.TEXT_HTML_VALUE})
    public
    @ResponseBody
    String getMetadata(@RequestParam(value = "layerId") String layerId, @PathVariable("lang") String lang) throws IOException {
        OgpClient client = getOgpClient();
        return client.getMetadataAsHtml(layerId);
    }

    /**
     * Retrieve a metadata from the remote OGP server, transform it to ISO-19115-3 if needed and create a new GeoNetwork
     * metadata with that content
     *
     * @param layerId metadata remote identifier.
     * @param group   GeoNetwork group to be assigned to the metadata
     * @return the created metadata identifier or a -1 if there was any error.
     */
    @RequestMapping(value = "/{lang}/ogp.dataTypes.import", produces = {MediaType.APPLICATION_JSON_VALUE})
    public
    @ResponseBody
    String importMetadata(@RequestParam(value = "layerId") String layerId, @RequestParam(value = "group") String group, @PathVariable("lang") String lang) {
        String createdId = "-1";
        try {
            Element transformedMd = getMetadataAsElement(layerId);
            // Import record
            String uuid = UUID.randomUUID().toString();
            String date = new ISODate().toString();
            ServiceContext context = ServiceContext.get();
            int userId = context.getUserSession().getUserIdAsInt();
            String docType = null, category = null;
            boolean ufo = false, indexImmediate = true;
            createdId = dataManager.insertMetadata(context, "iso19115-3", transformedMd, uuid,
                    userId, group, settingManager.getSiteId(), MetadataType.METADATA.codeString, docType, category, date, date, ufo, indexImmediate);


        } catch (Exception e) {
            logger.error("Error importing OGP metadata");
            logger.error(e);
        }
        return createdId;
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
}
