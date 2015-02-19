package org.fao.geonet.services.ogp.client;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpHeaders;
import org.apache.http.NameValuePair;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.entity.ContentType;
import org.fao.geonet.exceptions.BadServerResponseEx;
import org.fao.geonet.utils.AbstractHttpRequest;
import org.fao.geonet.utils.GeonetHttpRequestFactory;
import org.springframework.http.client.ClientHttpResponse;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

/**
 * Client for OGP server.
 * <p/>
 * Created on 02/02/2015.
 *
 * @author <a href="mailto:juanluisrp@geocat.net">Juan Luis Rodriguez</a>.
 */
public class OgpClient extends AbstractHttpRequest {


    public OgpClient(String protocol, String host, int port, GeonetHttpRequestFactory requestFactory) {
        super(protocol, host, port, requestFactory);
        setMethod(Method.GET);
    }

    public String executeQuery(OgpQuery query) throws IOException {
        addParameters(query.getRequest());
        setAddress("/solr/select");
        HttpRequestBase httpMethod = setupHttpMethod();
        httpMethod.addHeader(HttpHeaders.ACCEPT, ContentType.APPLICATION_JSON.getMimeType());
        return executeAndReadResponse(httpMethod);

    }

    /**
     * Request remote OGP server a concrete metadata identifier and return its response as text.
     *
     * @param layerId the layer identifier.
     * @return the returned html from upstream OGP server
     */
    public String getMetadataAsHtml(String layerId) throws IOException {
        addParam("id", layerId);
        setAddress("/getMetadata");
        HttpRequestBase httpMethod = setupHttpMethod();
        httpMethod.addHeader(HttpHeaders.ACCEPT, ContentType.WILDCARD.getMimeType());

        return executeAndReadResponse(httpMethod);
    }

    private void addParameters(List<NameValuePair> parameters) {
        for (NameValuePair nvp : parameters) {
            super.addParam(nvp.getName(), nvp.getValue());
        }
    }

    private String executeAndReadResponse(HttpRequestBase httpMethod) throws IOException {
        final ClientHttpResponse httpResponse = doExecute(httpMethod);

        if (httpResponse.getRawStatusCode() > 399) {
            throw new BadServerResponseEx(httpResponse.getStatusText() +
                    " -- URI: " + httpMethod.getURI() +
                    " -- Response Code: " + httpResponse.getRawStatusCode());
        }

        try {
            InputStream body = httpResponse.getBody();
            return IOUtils.toString(body);
        } finally {
            httpMethod.releaseConnection();
            sentData = getSentData(httpMethod);
        }
    }


    public String executeRawQuery(OgpQuery query) throws IOException {
        addParameters(query.getParametersUsingQueryString());
        setAddress("/solr/select");
        HttpRequestBase httpMethod = setupHttpMethod();
        httpMethod.addHeader(HttpHeaders.ACCEPT, ContentType.APPLICATION_JSON.getMimeType());
        return executeAndReadResponse(httpMethod);

    }

    /**
     * Retrieve the XML metadata for a given layer identifier.
     *
     * @param layerId layer identifier.
     * @return the XML metadata as String.
     * @throws BadServerResponseEx when upstream server returns an error code.
     * @throws IOException         if there is any problem connecting with the upstream server or configuring the server request
     *                             data.
     */
    public String getMetadataAsXml(String layerId) throws IOException {
        addParam("id", layerId);
        addParam("download", false);
        setAddress("/getMetadata/xml");
        HttpRequestBase httpMethod = setupHttpMethod();
        httpMethod.addHeader(HttpHeaders.ACCEPT, ContentType.APPLICATION_XML.getMimeType());

        return executeAndReadResponse(httpMethod);
    }


}