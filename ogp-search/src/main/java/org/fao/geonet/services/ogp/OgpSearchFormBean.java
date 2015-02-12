package org.fao.geonet.services.ogp;

/**
 * Created on 30/01/2015.
 *
 * @author <a href="mailto:juanluisrp@geocat.net">Juan Luis Rodriguez</a>.
 */
public class OgpSearchFormBean {
    private String placeKeyword;
    private String themeKeyword;

    private String geographicExtent;
    private String originator;
    private String[] topic;
    private String[] dataType;
    private String dateRangeContentFrom;
    private String dateRangeContentTo;
    private String[] dataRepository;
    private String ogpLayerId;
    private boolean excludeRestrictedData;
    private String dateSolrTimestampFrom;
    private String dateSolrTimestampTo;
    private String solrQuery;
    private Float minx;
    private Float miny;
    private Float maxx;
    private Float maxy;
    private boolean useExtent;



    public OgpSearchFormBean() {
        topic = new String[]{};
        dataType = new String[]{};
        dataRepository = new String[]{};
    }

    public String getPlaceKeyword() {
        return placeKeyword;
    }

    public void setPlaceKeyword(String placeKeyword) {
        this.placeKeyword = placeKeyword;
    }

    public String getThemeKeyword() {
        return themeKeyword;
    }

    public void setThemeKeyword(String themeKeyword) {
        this.themeKeyword = themeKeyword;
    }

    public String getGeographicExtent() {
        return geographicExtent;
    }

    public void setGeographicExtent(String geographicExtent) {
        this.geographicExtent = geographicExtent;
    }

    public String getOriginator() {
        return originator;
    }

    public void setOriginator(String originator) {
        this.originator = originator;
    }

    public String[] getTopic() {
        return topic;
    }

    public void setTopic(String[] topic) {
        this.topic = topic;
    }

    public String[] getDataType() {
        return dataType;
    }

    public void setDataType(String[] dataType) {
        this.dataType = dataType;
    }

    public String getDateRangeContentFrom() {
        return dateRangeContentFrom;
    }

    public void setDateRangeContentFrom(String dateRangeContentFrom) {
        this.dateRangeContentFrom = dateRangeContentFrom;
    }

    public String getDateRangeContentTo() {
        return dateRangeContentTo;
    }

    public void setDateRangeContentTo(String dateRangeContentTo) {
        this.dateRangeContentTo = dateRangeContentTo;
    }

    public String[] getDataRepository() {
        return dataRepository;
    }

    public void setDataRepository(String[] dataRepository) {
        this.dataRepository = dataRepository;
    }

    public String getOgpLayerId() {
        return ogpLayerId;
    }

    public void setOgpLayerId(String ogpLayerId) {
        this.ogpLayerId = ogpLayerId;
    }

    public boolean isExcludeRestrictedData() {
        return excludeRestrictedData;
    }

    public void setExcludeRestrictedData(boolean excludeRestrictedData) {
        this.excludeRestrictedData = excludeRestrictedData;
    }

    public String getDateSolrTimestampFrom() {
        return dateSolrTimestampFrom;
    }

    public void setDateSolrTimestampFrom(String dateSolrTimestampFrom) {
        this.dateSolrTimestampFrom = dateSolrTimestampFrom;
    }

    public String getDateSolrTimestampTo() {
        return dateSolrTimestampTo;
    }

    public void setDateSolrTimestampTo(String dateSolrTimestampTo) {
        this.dateSolrTimestampTo = dateSolrTimestampTo;
    }

    public String getSolrQuery() {
        return solrQuery;
    }

    public void setSolrQuery(String solrQuery) {
        this.solrQuery = solrQuery;
    }

    public Float getMinx() {
        return minx;
    }

    public void setMinx(Float minx) {
        this.minx = minx;
    }

    public Float getMiny() {
        return miny;
    }

    public void setMiny(Float miny) {
        this.miny = miny;
    }

    public Float getMaxx() {
        return maxx;
    }

    public void setMaxx(Float maxx) {
        this.maxx = maxx;
    }

    public Float getMaxy() {
        return maxy;
    }

    public void setMaxy(Float maxy) {
        this.maxy = maxy;
    }

    public boolean isUseExtent() {
        return useExtent;
    }

    public void setUseExtent(boolean useExtent) {
        this.useExtent = useExtent;
    }
}
