<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:mdb="http://www.isotc211.org/namespace/mdb/1.0/2014-07-11"
  exclude-result-prefixes="#all" >
  
  <!-- Remove geonet:* elements and parentMetadata. -->
  <xsl:template match="gn:*|mdb:parentMetadata" priority="2"/>
  
  <!-- Copy everything -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>