package org.fao.geonet.services.ogp.client;

import org.apache.commons.lang.StringUtils;
import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.message.BasicNameValuePair;
import org.fao.geonet.services.ogp.OgpSearchFormBean;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

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
        buildSimpleFilterQuery(nvps, OgpRecord.PLACE_KEYWORDS, searchParameters.getPlaceKeyword());

        if (StringUtils.isNotBlank(searchParameters.getThemeKeyword())) {
            nvps.add(new BasicNameValuePair(Q, searchParameters.getThemeKeyword()));
        } else {
            nvps.add(new BasicNameValuePair(Q, "*"));
        }

        // TODO add include restricted data to query
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

        if (searchParameters.isUseExtent()) {
            buildGeographicQuery(nvps, searchParameters.getMinx(), searchParameters.getMiny(),
                    searchParameters.getMaxx(), searchParameters.getMaxy());
        }
    }



    public List<NameValuePair> getParametersUsingQueryString() {
        List<NameValuePair> nvps = URLEncodedUtils.parse(searchParameters.getSolrQuery(), Charset.defaultCharset());
        // remove "dangerous" parameters
        for(Iterator<NameValuePair> iterator = nvps.iterator(); iterator.hasNext();) {
            NameValuePair nvp = iterator.next();
            String name = nvp.getName();
            if ("wt".equals(name) || "fl".equals(name) || "start".equals(name) || "rows".equals(name)
                    || "sort".equals(name)) {
                iterator.remove();
            }
        }

        // System parameters
        nvps.add(new BasicNameValuePair("wt", "json")); // JSON output
        nvps.add(new BasicNameValuePair("fl", "Name,Institution,Access,DataType,LayerDisplayName,Publisher,GeoReferenced,"
                + "Originator,Location,MinX,MaxX,MinY,MaxY,ContentDate,LayerId,score,WorkspaceName,"
                + "CollectionId,Availability")); // field list to be returned
        nvps.add(new BasicNameValuePair("sort", "score desc")); // sort results by score descendant
        nvps.add(new BasicNameValuePair("start", "0")); // start retrieving results at index 0
        nvps.add(new BasicNameValuePair("rows", "50")); // retrieve 50 rows

        return nvps;
    }

    private void buildGeographicQuery(List<NameValuePair> nvps, Float minx, Float miny, Float maxx, Float maxy) {
        // If the result layer has bounds that cross the dateline, use the 'dintx' clause.
        // Otherwise, use the 'intx' clause
        nvps.add(new BasicNameValuePair(FILTER_QUERY_KEY, "{!frange l=0 incl=false cache=false}if($dl,$dintx,$intx)"));
        // this clause determines if the result layer has bounds that cross the dateline.
        nvps.add(new BasicNameValuePair("dl", "{!frange u=0 incu=false}sub(MaxX,MinX)"));
        nvps.add(new BasicNameValuePair("dintx", getDLIntersection(minx, miny, maxx, maxy)));
        nvps.add(new BasicNameValuePair("intx", getIntersection(minx, miny, maxx, maxy)));
        nvps.add(new BasicNameValuePair("y", getYRange(miny, maxy)));
        nvps.add(new BasicNameValuePair("bf", getClassicLayerMatcherArea(minx, miny, maxx, maxy)));
        nvps.add(new BasicNameValuePair("bf", getClassiclayerWithinMap(minx, miny, maxx, maxy)));

    }

    /**
     * Compute a score for layers within the current map the layer's MinX and MaxX must be within the map extent in X
     * and the layer's MinY and MaxY must be within the map extent in Y. I had trouble using a range based test
     * (e.g., MinX:[mapMinX+TO+mapMapX]) along with other scoring functions based on _val_. So, this function is like
     * the other scoring functions and uses _val_. The Solr "sum" function returns 4 if the layer is contained within
     * the map. The outer "map" converts 4 to 1 and anything else to 0. Finally, the product converts the 1 to
     * LayerWithinMapBoost
     * @param minx
     * @param miny
     * @param maxx
     * @param maxy
     * @return
     */
    private String getClassiclayerWithinMap(Float minx, Float miny, Float maxx, Float maxy) {
        //needs to account for dl cross, both for query bounds and result bounds
        //one check would be to see if the center x is within
        float margin = 0.2f;
        float xDelta = getDelta(minx, maxx);
        float yDelta = getDelta(miny, maxy);
        boolean bufferX = false;
        if (yDelta > xDelta) {
            bufferX = true;
        }
        float mapMinX = minx;
        float mapMaxX = minx + xDelta;
        float mapMinY = miny;
        float mapMaxY = maxy;
        if (bufferX) {
            mapMinX = trim(mapMinX - xDelta*margin, -180.0f);
            mapMaxX = trim (mapMaxX + xDelta*margin, 180.0f);
        } else {
            mapMinY = trim(mapMinY - yDelta * margin, -90.0f);
            mapMaxY = trim(mapMaxX + yDelta * margin, 90.0f);
        }

        // add a buffer to the short side, because of the way zoom to extent works
        StringBuilder layerWithinMap = new StringBuilder("if(and(exists(MinX),exists(MaxX),exists(MinY),exists(MaxY)),")
                .append( "map(sum(")
                .append("map(MinX,").append(mapMinX).append(",").append(mapMaxX).append(",1,0),");
        layerWithinMap.append("map(MaxX,").append(mapMinX).append(",").append(mapMaxX).append(",1,0),");
        layerWithinMap.append("map(MinY,").append(mapMinY).append(",").append(mapMaxY).append(",1,0),");
        layerWithinMap.append( "map(MaxY,").append(mapMinY).append(",").append(mapMaxY).append(",1,0))");
        layerWithinMap.append(",4,4,1,0),0)");

        return layerWithinMap.toString();
    }

    private float trim(float toBeTrimmed, float cutValue) {
        if (Math.signum(cutValue) >= 0) {
            if (toBeTrimmed >= cutValue) {
                return cutValue;
            } else {
                return toBeTrimmed;
            }
        } else {
            if (toBeTrimmed <= cutValue) {
                return cutValue;
            } else {
                return  toBeTrimmed;
            }
        }
    }

    private float getDelta(float min, float max) {
        float delta = Math.abs(max -min);
        if (min > max) {
            delta = 360.0f - delta;
        }
        return delta;
    }

    /**
     *
     * @param minx
     * @param miny
     * @param maxx
     * @param maxy
     * @return a search element to boost the scores of layers whose scale matches the displayed map scale. Specifically,
     * it compares their area.
     */
    private String getClassicLayerMatcherArea(Float minx, Float miny, Float maxx, Float maxy) {
        float mapDeltaX = getDelta(minx, maxx);

        float mapDeltaY = Math.abs(maxy - miny);
        float mapArea = mapDeltaX * mapDeltaY;
        float smoothingFactor = mapArea * 10.0f;
        String layerMatchesArea = "recip(sum(abs(sub(Area," + String.format(Locale.ENGLISH, "%f", mapArea)
                + ")),.01),1," + String.format(Locale.ENGLISH, "%f", smoothingFactor) + "," + String.format(Locale.ENGLISH, "%f", smoothingFactor) + ")";
        return layerMatchesArea;
    }

    private String getYRange(Float miny, Float maxy) {
        return getRangeClause(String.format(Locale.ENGLISH, "%f", miny), "MinY", String.format(Locale.ENGLISH, "%f", maxy), "MaxY");
    }

    /**
     * Returns the intersection area of the layer and map.
     *
     * @param minx
     * @param miny
     * @param maxx
     * @param maxy
     * @return Query string to calculate intersection.
     */
    private String getIntersection(Float minx, Float miny, Float maxx, Float maxy) {

        String yRange = "$y";
        String intersection;

        // this is the case where bounds passed from the onscreen map cross the dateline
        if (minx > maxx) {
            String xRange1 = this.getRangeClause(String.format(Locale.ENGLISH, "%f", minx), "MinX", "180", "MaxX");
            String xRange2 = this.getRangeClause("-180", "MinX", String.format(Locale.ENGLISH, "%f", maxx), "MaxX");
            intersection = "product(sum(" + xRange1 + "," + xRange2 + ")," + yRange + ")";
        } else {
            String xRange = this.getRangeClause(minx.toString(), "MinX", maxx.toString(), "MaxX");
            intersection = "product(" + xRange + "," + yRange + ")";
        }

        return intersection;
    }

    private String getRangeClause(String minVal, String minTerm, String maxVal, String maxTerm) {
        String rangeClause =  "max(sub(min(" + maxVal + "," + maxTerm
                + "),max(" + minVal + "," + minTerm + ")),0)";
        return rangeClause;
    }

    /**
     * Returns the intersection area of the layer and map if the dateline is crossed (indexed bounds)
     * @param minx
     * @param miny
     * @param maxx
     * @param maxy
     * @return Query string to calculate intersection.
     */
    private String getDLIntersection(Float minx, Float miny, Float maxx, Float maxy) {
        // This filter gets all results where MinX is greater than MaxX {!frange u= uncu=false}sub(MaxX,MinX),
        // which indicates crosing the dateline
        String yRange ="$y";
        String intersection;

        // this is the case where bounds passed from the onscreen map cross the dateline
        if (minx > maxx) {
            // client extent crosses the dateline
            String xRangeA1 = this.getRangeClause(String.format(Locale.ENGLISH, "%f", minx), "MinX", "180", "180");
            String xRangeB1 = this.getRangeClause("-180", "-180", String.format(Locale.ENGLISH, "%f", maxx), "MaxX");
            intersection = "product(sum(" + xRangeA1 + "," + xRangeB1 + ")," + yRange + ")";
        } else {
            String xRangeA = this.getRangeClause(String.format(Locale.ENGLISH, "%f", minx), "MinX", String.format(Locale.ENGLISH, "%f", maxx), "180");
            String xRangeB = this.getRangeClause(String.format(Locale.ENGLISH, "%f", minx), "-180", String.format(Locale.ENGLISH, "%f", maxx), "MaxX");
            intersection = "product(sum(" + xRangeA + "," + xRangeB + ")," + yRange + ")";
        }

        return intersection;
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
