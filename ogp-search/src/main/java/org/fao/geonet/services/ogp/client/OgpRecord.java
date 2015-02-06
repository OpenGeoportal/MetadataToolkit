package org.fao.geonet.services.ogp.client;

/**
 * OGP record field names.
 * Created on 02/02/2015.
 *
 * @author <a href="mailto:juanluisrp@geocat.net">Juan Luis Rodriguez</a>.
 */
public interface OgpRecord {
    /** Name Theme Keywords field. */
    public static final String THEME_KEYWORDS = "ThemeKeywords";

    /** Name of Place Keywords field. */
    public static final String PLACE_KEYWORDS = "PlaceKeywords";

    /** Content date field name. */
    public static final String CONTENT_DATE = "ContentDate";
    /** Originator field name. */
    public static final String ORIGINATOR = "Originator";
    /** Data type field name. */
    public static final String DATA_TYPE = "DataType";
    /** Institution field name. */
    public static final String INSTITUTION = "Institution";
    /** Access field name. */
    public static final String ACCESS = "Access";
    /** Solr timestamp field name. */
    public static final String TIMESTAMP = "timestamp";

    public static final String LAYER_ID = "LayerId";
    /** Topic Category field name. */
    public static final String ISO_TOPIC_CATEGORY = "ThemeKeywordsSynonymsIso";
    /** MinX field name. */
    public static final String MINX = "MinX";
    /** MinY field name. */
    public static final String MINY = "MinY";
    /** MaxX field name. */
    public static final String MAXX = "MaxX";
    /** MaxY field name. */
    public static final String MAXY = "MaxY";

    public static final String LAYER_DISPLAY_NAME = "LayerDisplayName";

    public static final String LAYER_DISPLAY_NAME_SYNONYMS = "LayerDisplayNameSynonyms";
    public static final String THEME_KEYWORDS_SYNONYMS_LCSH = "ThemeKeywordsSynonymsLcsh";
    public static final String PLACE_KEYWORDS_SYNONYMS = "PlaceKeywordsSynonyms";
}
