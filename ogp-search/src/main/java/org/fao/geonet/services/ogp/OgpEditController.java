package org.fao.geonet.services.ogp;

import jeeves.services.ReadWriteController;
import org.fao.geonet.Logger;
import org.fao.geonet.kernel.DataManager;
import org.fao.geonet.utils.Log;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.Arrays;

/**
 * Created by JuanLuis on 15/05/2015.
 */
@Controller("ogp.editController")
@ReadWriteController
@SessionAttributes({"wizardFormBean"})
public class OgpEditController {
    protected Logger logger;
    @Autowired
    private DataManager metadataManager;

    public OgpEditController() {
        logger = Log.createLogger("ogp.editController", "ogp");

    }

    @ModelAttribute("wizardFormBean")
    public OgpEditFormBean createWizardFormBean() {
        return new OgpEditFormBean();
    }

    @RequestMapping(value = "/{lang}/ogp.edit.addRecord", produces = MediaType.APPLICATION_JSON_VALUE)
    public
    @ResponseBody
    ResponseEntity<Object> addDatasetMetadata(@ModelAttribute("wizardFormBean") OgpEditFormBean wizardFormBean,
                                              @RequestParam("mefFile") MultipartFile file,
                                              @RequestParam(value = "step") String stepString) {
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
     * Wizard step
     */
    public enum Step {
        importDataProperties,
        importXmlMetadata

    }

}
