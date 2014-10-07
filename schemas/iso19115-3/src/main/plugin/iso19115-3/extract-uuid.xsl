<?xml version="1.0" encoding="UTF-8"?>
<!-- FIXME: Which MD_Identifier do we select under mds:metadataIdentifier
  probably should use some form of match on a particular codeSpace?
-->
<xsl:stylesheet version="2.0" xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:mcc="http://www.isotc211.org/namespace/mcc/1.0/2014-07-11"
  xmlns:mdb="http://www.isotc211.org/namespace/mdb/1.0/2014-07-11"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="mdb:MD_Metadata">
    <uuid>
      <xsl:value-of
        select="mdb:metadataIdentifier/mcc:MD_Identifier
              [mcc:codeSpace/gco:CharacterString='urn:uuid']
              /mcc:code/gco:CharacterString"
      />
    </uuid>
  </xsl:template>
</xsl:stylesheet>
