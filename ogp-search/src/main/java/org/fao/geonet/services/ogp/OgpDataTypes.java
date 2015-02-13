package org.fao.geonet.services.ogp;

import org.apache.commons.lang.StringUtils;
import org.fao.geonet.Logger;
import org.fao.geonet.services.ogp.client.OgpClient;
import org.fao.geonet.services.ogp.client.OgpQuery;
import org.fao.geonet.services.ogp.responses.DataTypeResponse;
import org.fao.geonet.utils.GeonetHttpRequestFactory;
import org.fao.geonet.utils.Log;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;

/**
 * Retrieves the data types available in the OGP server.
 * Created by JuanLuis on 28/01/2015.
 */
@Controller("ogp.dataTypes")
public class OgpDataTypes {
    protected Logger logger;
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
            OgpQuery query = new OgpQuery(formBean);;
            return client.executeRawQuery(query);
        }
    }

    @RequestMapping(value = "/{lang}/ogp.dataTypes.getMetadata", produces = {
            MediaType.TEXT_HTML_VALUE})
    public @ResponseBody String getMetadata(@RequestParam(value = "layerId") String layerId) throws IOException {
        OgpClient client = new OgpClient("http", "geodata.tufts.edu", 80, requestFactory);
        return client.getMetadataAsHtml(layerId);
    }


}
