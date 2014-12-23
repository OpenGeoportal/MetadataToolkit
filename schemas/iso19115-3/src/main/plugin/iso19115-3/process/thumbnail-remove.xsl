<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mcc="http://www.isotc211.org/namespace/mcc/1.0/2014-07-11"
  xmlns:mri="http://www.isotc211.org/namespace/mri/1.0/2014-07-11"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gn="http://www.fao.org/geonetwork" exclude-result-prefixes="#all" version="2.0">

  <!-- 
      Usage: 
        thumbnail-from-url-remove?thumbnail_url=http://geonetwork.org/thumbnails/image.png
    -->
  <xsl:param name="thumbnail_url"/>

  <!-- Remove the thumbnail define in thumbnail_url parameter -->
  <xsl:template
    match="mri:graphicOverview[mcc:MD_BrowseGraphic/mcc:fileName/gco:CharacterString= $thumbnail_url]"/>

  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Always remove geonet:* elements. -->
  <xsl:template match="gn:*" priority="2"/>

</xsl:stylesheet>
