package org.fao.geonet.services.ogp.client;

/**
 * OGP record field names.
 * Created on 02/02/2015.
 *
 * @author <a href="mailto:juanluisrp@geocat.net">Juan Luis Rodriguez</a>.
 */
public interface OgpRecord {
    /** Name Theme Keywords field. */
    String THEME_KEYWORDS = "ThemeKeywords";

    /** Name of Place Keywords field. */
    String PLACE_KEYWORDS = "PlaceKeywords";

    /** Content date field name. */
    String CONTENT_DATE = "ContentDate";
    /** Originator field name. */
    String ORIGINATOR = "Originator";
    /** Data type field name. */
    String DATA_TYPE = "DataType";
    /** Institution field name. */
    String INSTITUTION = "Institution";
    /** Access field name. */
    String ACCESS = "Access";
    /** Solr timestamp field name. */
    String TIMESTAMP = "timestamp";

    String LAYER_ID = "LayerId";
    /** Topic Category field name. */
    String ISO_TOPIC_CATEGORY = "ThemeKeywordsSynonymsIso";
    /** MinX field name. */
    String MINX = "MinX";
    /** MinY field name. */
    String MINY = "MinY";
    /** MaxX field name. */
    String MAXX = "MaxX";
    /** MaxY field name. */
    String MAXY = "MaxY";

    String LAYER_DISPLAY_NAME = "LayerDisplayName";

    String LAYER_DISPLAY_NAME_SYNONYMS = "LayerDisplayNameSynonyms";
    String THEME_KEYWORDS_SYNONYMS_LCSH = "ThemeKeywordsSynonymsLcsh";
    String PLACE_KEYWORDS_SYNONYMS = "PlaceKeywordsSynonyms";
}
