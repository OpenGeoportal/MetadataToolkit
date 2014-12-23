<?xml version="1.0" encoding="UTF-8"?>
<!--  
Stylesheet used to update metadata adding a reference to a source record.
-->
<xsl:stylesheet version="2.0" xmlns:gmd="http://www.isotc211.org/namespace/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:mrl="http://www.isotc211.org/namespace/mrl/1.0/2014-07-11"
                xmlns:mdb="http://www.isotc211.org/namespace/mdb/1.0/2014-07-11"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:xlink="http://www.w3.org/1999/xlink">

  <!-- Source metadata record UUID -->
  <xsl:param name="sourceUuid"/>
  <xsl:param name="siteUrl"/>

  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/mdb:MD_Metadata|*[@gco:isoType='mdb:MD_Metadata']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:apply-templates select="mdb:metadataIdentifier"/>
      <xsl:apply-templates select="mdb:defaultLocale"/>
      <xsl:apply-templates select="mdb:parentMetadata"/>
      <xsl:apply-templates select="mdb:metadataScope"/>
      <xsl:apply-templates select="mdb:contact"/>
      <xsl:apply-templates select="mdb:dateInfo"/>
      <xsl:apply-templates select="mdb:metadataStandard"/>
      <xsl:apply-templates select="mdb:metadataProfile"/>
      <xsl:apply-templates select="mdb:alternativeMetadataReference"/>
      <xsl:apply-templates select="mdb:otherLocale"/>
      <xsl:apply-templates select="mdb:metadataLinkage"/>
      <xsl:apply-templates select="mdb:spatialRepresentationInfo"/>
      <xsl:apply-templates select="mdb:referenceSystemInfo"/>
      <xsl:apply-templates select="mdb:metadataExtensionInfo"/>
      <xsl:apply-templates select="mdb:identificationInfo"/>
      <xsl:apply-templates select="mdb:contentInfo"/>
      <xsl:apply-templates select="mdb:distributionInfo"/>
      <xsl:apply-templates select="gmd:dataQualityInfo"/>

      <xsl:choose>
        <!-- Add to existing resourceLineage section or create a new one -->
        <xsl:when
            test="mdb:resourceLineage">
          <mdb:resourceLineage>
            <xsl:apply-templates select="mrl:statement"/>
            <xsl:apply-templates select="mrl:scope"/>
            <xsl:apply-templates select="mrl:additionalDocumentation"/>
            <xsl:apply-templates select="mrl:source"/>
            <mrl:source uuidref="{$sourceUuid}"
                        xlink:href="{$siteUrl}/csw?service=CSW&amp;request=GetRecordById&amp;version=2.0.2&amp;outputSchema=http://www.isotc211.org/namespace/gmd&amp;elementSetName=full&amp;id={$sourceUuid}"/>
            <xsl:apply-templates select="mrl:processStep"/>
          </mdb:resourceLineage>
        </xsl:when>

        <xsl:otherwise>
          <mdb:resourceLineage>
            <mrl:LI_Lineage>
              <mrl:source uuidref="{$sourceUuid}"
                          xlink:href="{$siteUrl}/csw?service=CSW&amp;request=GetRecordById&amp;version=2.0.2&amp;outputSchema=http://www.isotc211.org/namespace/gmd&amp;elementSetName=full&amp;id={$sourceUuid}"/>
            </mrl:LI_Lineage>
          </mdb:resourceLineage>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="mdb:portrayalCatalogueInfo"/>
      <xsl:apply-templates select="mdb:metadataConstraints"/>
      <xsl:apply-templates select="mdb:applicationSchemaInfo"/>
      <xsl:apply-templates select="mdb:metadataMaintenance"/>
      <xsl:apply-templates select="mdb:acquisitionInformation"/>
    </xsl:copy>

  </xsl:template>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="gn:*" priority="2"/>
</xsl:stylesheet>