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
import org.fao.geonet.services.ogp.client.OgpQuery;
import org.fao.geonet.services.ogp.responses.DataTypeResponse;
import org.fao.geonet.utils.GeonetHttpRequestFactory;
import org.fao.geonet.utils.Log;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;


/**
 * Retrieves the data types available in the OGP server.
 * Created by JuanLuis on 28/01/2015.
 */
@Controller("ogp.dataTypes")
@ReadWriteController
public class OgpDataTypes {
    protected Logger logger;

    @Autowired
    private DataManager dataManager;
    @Autowired
    private SchemaManager schemaManager;
    @Autowired
    private SettingManager settingManager;

    @Autowired
    private TransformService transformService;

    private GeonetHttpRequestFactory requestFactory;
    public OgpDataTypes() {
        logger = Log.createLogger("ogp.dataType", "ogp");
        requestFactory = new GeonetHttpRequestFactory();

        logger.warning("Initialising OdpDataTypes");
    }

    @RequestMapping(value = "/{lang}/ogp.dataTypes", produces = {
            MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})

    public @ResponseBody DataTypeResponse getTypes() {
        DataTypeResponse rep = new DataTypeResponse();
        rep.setDataType("TestDataType");
        return rep;
    }
    @RequestMapping(value = "/{lang}/ogp.dataTypes.search", produces = {
            MediaType.APPLICATION_JSON_VALUE})
    public @ResponseBody String processForm(@RequestBody OgpSearchFormBean formBean) throws IOException {
        OgpClient client = new OgpClient("http", "geodata.tufts.edu", 80, requestFactory);
        if (StringUtils.isBlank(formBean.getSolrQuery())) {
            OgpQuery query = new OgpQuery(formBean);
            return client.executeQuery(query);
        } else {
            OgpQuery query = new OgpQuery(formBean);
            return client.executeRawQuery(query);
        }
    }

    @RequestMapping(value = "/{lang}/ogp.dataTypes.getMetadata", produces = {
            MediaType.TEXT_HTML_VALUE})
    public @ResponseBody String getMetadata(@RequestParam(value = "layerId") String layerId) throws IOException {
        OgpClient client = new OgpClient("http", "geodata.tufts.edu", 80, requestFactory);
        return client.getMetadataAsHtml(layerId);
    }

    @RequestMapping(value="/{lang}/ogp.dataTypes.import", produces = {MediaType.APPLICATION_JSON_VALUE})
    public @ResponseBody String importMetadata(@RequestParam(value = "layerId") String layerId, @RequestParam(value = "group") String group) {
        String metadata = null;
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
            createdId = dataManager.insertMetadata(context, "iso19115-3" , transformedMd, uuid,
                    userId, group, settingManager.getSiteId(), MetadataType.METADATA.codeString, docType, category, date, date, ufo, indexImmediate);


        } catch (Exception e) {
            e.printStackTrace();
        }
        return createdId;
    }

    public Element getMetadataAsElement(String layerId) throws Exception {
        OgpClient client = new OgpClient("http", "geodata.tufts.edu", 80, requestFactory);
        String metadata = client.getMetadataAsXml(layerId);
        Element originalMd = Xml.loadString(metadata, false);
        Element transformedMd = transformService.convertToIso19115_3(originalMd);
        return transformedMd;
    }


}
