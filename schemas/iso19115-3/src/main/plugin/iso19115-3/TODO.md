# On going

## Translations

* Translate codelists at least in French and English
* Translate labels at least in French and English
* See https://github.com/geonetwork/schema-plugins/tree/master/iso19115-3/loc

## Associated resources

* Rework set/Unset thumbnail to work only on URL or filename and not on type. This will allow to have more than 2 thumbnails.

## Editor

* Configure multilingual element exlcusion list https://github.com/geonetwork/schema-plugins/blob/master/iso19115-3/layout/config-editor.xml#L121
* Check element type for form field https://github.com/geonetwork/schema-plugins/blob/master/iso19115-3/layout/config-editor.xml#L22

## Templates

* Template general en vector, raster, map
* See https://github.com/geonetwork/schema-plugins/tree/master/iso19115-3/templates

## Conversions

* ISO19139 to ISO19115-3
 * metadataStandard force to ISO19115-3 ?
 * codeList anyUriRef ?
* ISO19115-3 to ISO19139


# Nice to have

## CSW support

* A schema plugin should define what outputSchema could be used and define the conversion to apply. http://www.isotc211.org/namespace/mdb/1.0/2014-07-11 should be added to the list.

