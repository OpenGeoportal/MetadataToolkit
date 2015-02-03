package org.fao.geonet.services.ogp.client;

import org.apache.commons.lang.StringUtils;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.fao.geonet.services.ogp.OgpSearchFormBean;

import java.util.ArrayList;
import java.util.List;

/**
 * Created on 02/02/2015.
 *
 * @author <a href="mailto:juanluisrp@geocat.net">Juan Luis Rodriguez</a>.
 */
public class OgpQuery {
    private static final String RANGE_FORMAT = "%s:[%s TO %s]";
    private static final String SIMPLE_FILTER_QUERY = "%s:%s";
    private static final String FILTER_QUERY_KEY = "fq";
    public static final String Q = "q";
    public static final String QF = "qf";
    private OgpSearchFormBean searchParameters;

    public OgpQuery(OgpSearchFormBean parameters) {
        if (parameters == null) {
            throw new IllegalArgumentException("OgpSearchFormBean cannot be null in OgpQuery constructor");
        }
        this.searchParameters = parameters;
    }

    public List<NameValuePair> getRequest() {
        List<NameValuePair> nvps = new ArrayList<>();
        buildQuery(nvps, searchParameters);

        return nvps;
    }

    private void buildQuery(List<NameValuePair> nvps, OgpSearchFormBean searchParameters) {
        buildRangeQueryString(nvps, OgpRecord.CONTENT_DATE, searchParameters.getDateRangeContentFrom(),
                searchParameters.getDateRangeContentTo());
        buildRangeQueryString(nvps, OgpRecord.TIMESTAMP, searchParameters.getDateSolrTimestampFrom(),
                searchParameters.getDateSolrTimestampTo());
        buildSimpleFilterQuery(nvps, OgpRecord.LAYER_ID, searchParameters.getOgpLayerId());
        buildSimpleFilterQuery(nvps, OgpRecord.ORIGINATOR, searchParameters.getOriginator());

        if (StringUtils.isNotBlank(searchParameters.getThemeKeyword())) {
            nvps.add(new BasicNameValuePair(Q, searchParameters.getThemeKeyword()));
        } else {
            nvps.add(new BasicNameValuePair(Q, searchParameters.getThemeKeyword()));
        }
        nvps.add(new BasicNameValuePair(QF, "LayerDisplayNameSynonyms^0.2 ThemeKeywordsSynonymsLcsh^0.1 PlaceKeywordsSynonyms^0.1"));
        buildSimpleFilterQueryFromArray(nvps, OgpRecord.INSTITUTION , searchParameters.getDataRepository());
        buildSimpleFilterQueryFromArray(nvps, OgpRecord.DATA_TYPE, searchParameters.getDataType());
        buildSimpleFilterQueryFromArray(nvps, OgpRecord.ISO_TOPIC_CATEGORY, searchParameters.getTopic());

        // System parameters
        nvps.add(new BasicNameValuePair("wt", "json")); // JSON output
        nvps.add(new BasicNameValuePair("defType", "edismax"));
        nvps.add(new BasicNameValuePair("fl", "Name,Institution,Access,DataType,LayerDisplayName,Publisher,GeoReferenced,"
                + "Originator,Location,MinX,MaxX,MinY,MaxY,ContentDate,LayerId,score,WorkspaceName,"
                + "CollectionId,Availability")); // field list to be returned
        nvps.add(new BasicNameValuePair("sort", "score desc")); // sort results by score descendant
        // nvps.add(new BasicNameValuePair("fq"), "{!frange l=0 incl=false cache=false}$intx"));
        nvps.add(new BasicNameValuePair("start", "0")); // start retrieving results at index 0
        nvps.add(new BasicNameValuePair("rows", "50")); // retrieve 50 rows






    }

    private void buildRangeQueryString(List<NameValuePair> nvps, String fieldName, String fromValue, String toValue) {
        if (StringUtils.isNotBlank(fromValue)
                || StringUtils.isNotBlank(toValue)) {
            String fromString = StringUtils.defaultIfBlank(StringUtils.trim(fromValue), "*");
            String toString = StringUtils.defaultIfBlank(StringUtils.trim(toValue), "*");
            String parameterValue = String.format(RANGE_FORMAT, fieldName, fromString, toString);
            nvps.add(new BasicNameValuePair(FILTER_QUERY_KEY, parameterValue));
        }
    }

    private void buildSimpleFilterQuery(List<NameValuePair> nvps, String fieldName, String value) {
        if (StringUtils.isNotBlank(value)) {
            nvps.add(new BasicNameValuePair(FILTER_QUERY_KEY, String.format(SIMPLE_FILTER_QUERY, fieldName, value)));
        }
    }

    private void buildSimpleFilterQueryFromArray(List<NameValuePair> nvps, String fieldName, String[] values) {
        if (values.length > 0) {
            nvps.add(new BasicNameValuePair(FILTER_QUERY_KEY, generateConditionFromArray(fieldName, values, "OR")));
        }
    }

    private String generateConditionFromArray(String fieldName, String[] values, String operator) {
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < values.length; i++) {
            sb.append(fieldName).append(":").append(values[i]);
            if (i != values.length - 1 ) {
                sb.append(" ").append(operator).append(" ");
            }
        }

        return sb.toString();
    }


}
