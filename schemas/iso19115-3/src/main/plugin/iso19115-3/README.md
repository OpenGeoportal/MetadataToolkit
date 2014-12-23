# ISO 19115-3 schema plugin

This is the ISO19115-3 schema plugin for GeoNetwork 2.11.x or greater version.

## Warning:

The XML schema is not the final version.

## Reference documents:

* http://www.iso.org/iso/catalogue_detail.htm?csnumber=53798
* http://www.iso.org/iso/catalogue_detail.htm?csnumber=32579
* https://github.com/ISO-TC211/XML/
 

## Description:

This plugin supports:

* indexing
* editing (Angular editor)
* viewing
* CSW
* from/to ISO19139 conversion
* editor associated resources
* multilingual metadata


This plugin does not support:
* ... still lots of features to be checked


## Metadata rules:

### Metadata identifier

The metadata identifier is stored in the element mdb:MD_Metadata/mdb:metadataIdentifier.
Only the code is set by default but more complete description may be defined (see authority,
codeSpace, version, description).

```
<mdb:metadataIdentifier>
  <mcc:MD_Identifier>
    <mcc:code>
      <gco:CharacterString>{{MetadataUUID}}</gco:CharacterString>
    </mcc:code>
  </mcc:MD_Identifier>
</mdb:metadataIdentifier>
```

### Metadata linkage ("point of truth")

The metadata linkage is updated when saving the record. The link added points
to the catalog the metadata was created. If the metadata is harvested by another
catalog, then this link will provide a way to retrieve the original record in the
source catalog.

```
<mdb:metadataLinkage>
  <cit:CI_OnlineResource>
    <cit:linkage>
      <gco:CharacterString>http://localhost/geonetwork/srv/eng/home?uuid={{MetadataUUID}}</gco:CharacterString>
    </cit:linkage>
    <cit:function>
      <cit:CI_OnLineFunctionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_OnLineFunctionCode"
                                 codeListValue="completeMetadata"/>
    </cit:function>
  </cit:CI_OnlineResource>
</mdb:metadataLinkage>
```


### Parent metadata

The parent metadata records is referenced using the following form from the editor:

```
<mdb:parentMetadata uuidref="{{ParentMetadataUUID}}}"/>
```

Nevertheless, the citation code is also indexed.



## CSW requests:

If requesting an ISO record using the gmd namespace, metadata are converted to ISO19139.
```
<?xml version="1.0"?>
<csw:GetRecordById xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
  service="CSW"
  version="2.0.2"
  outputSchema="http://www.isotc211.org/namespace/gmd">
    <csw:Id>cecd1ebf-719e-4b1f-b6a7-86c17ed02c62</csw:Id>
    <csw:ElementSetName>brief</csw:ElementSetName>
</csw:GetRecordById>
```

To retrieve the record in ISO19115-3, use outputSchema = own to not to apply conversion.




## GeoNetwork version to use with this plugin

This is a draft implementation for testing mainly. It'll not be supported in 2.10.x series
so don't plug it into it! develop branch should support it.

In 2.11+ version, in catalog settings, add to metadata/editor/schemaConfig the editor configuration
for the schema:

```
"iso19115-3":{
  "defaultTab":"default",
  "displayToolTip":false,
  "related":{
    "display":true,
    "categories":[]},
  "suggestion":{"display":true},
  "validation":{"display":true}}
```

## Community

Comments and questions to geonetwork-developers or geonetwork-users mailing lists.


## Contributors

* Simon Pigot (CSIRO)
* François Prunayre (titellus)
* Ted Habermann (hdfgroup)

