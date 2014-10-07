<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:mdb="http://www.isotc211.org/namespace/mdb/1.0/2014-07-11"
  xmlns:mri="http://www.isotc211.org/namespace/mri/1.0/2014-07-11"
  xmlns:cit="http://www.isotc211.org/namespace/cit/1.0/2014-07-11"
  xmlns:mcc="http://www.isotc211.org/namespace/mcc/1.0/2014-07-11"
  xmlns:gex="http://www.isotc211.org/namespace/gex/1.0/2014-07-11"
  xmlns:srv="http://www.isotc211.org/namespace/srv/2.0/2014-07-11"
  xmlns:mco="http://www.isotc211.org/namespace/mco/1.0/2014-07-11"
  xmlns:mrd="http://www.isotc211.org/namespace/mrd/1.0/2014-07-11"
  xmlns:lan="http://www.isotc211.org/namespace/lan/1.0/2014-07-11"
  xmlns:mrl="http://www.isotc211.org/namespace/mrl/1.0/2014-07-11"
  xmlns:mrs="http://www.isotc211.org/namespace/mrs/1.0/2014-07-11"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:ows="http://www.opengis.net/ows"
  xmlns:gn="http://www.fao.org/geonetwork"
  exclude-result-prefixes="#all">
  
  <xsl:param name="displayInfo"/>
  
  <xsl:template match="mdb:MD_Metadata|*[contains(@gco:isoType,'MD_Metadata')]">
    <xsl:variable name="info" select="gn:info"/>
    <xsl:copy>
      <xsl:apply-templates select="mdb:metadataIdentifier"/>
      <xsl:apply-templates select="mdb:metadataScope"/>
      <xsl:apply-templates select="mdb:identificationInfo"/>
      
      <!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
      <xsl:if test="$displayInfo = 'true'">
        <xsl:copy-of select="$info"/>
      </xsl:if>
      
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="mri:MD_DataIdentification|
    *[contains(@gco:isoType, 'MD_DataIdentification')]|
    srv:SV_ServiceIdentification|
    *[contains(@gco:isoType, 'SV_ServiceIdentification')]
    ">
    <xsl:copy>
      <xsl:apply-templates select="mri:citation"/>
      <xsl:apply-templates select="mri:graphicOverview"/>
      <xsl:apply-templates select="mri:extent[child::gex:EX_Extent[child::gex:geographicElement]]|
        srv:extent[child::gex:EX_Extent[child::gex:geographicElement]]"/>
      <xsl:apply-templates select="srv:serviceType"/>
      <xsl:apply-templates select="srv:serviceTypeVersion"/>
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template match="mcc:MD_BrowseGraphic">
    <xsl:copy>
      <xsl:apply-templates select="mcc:fileName"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="gex:EX_Extent">
    <xsl:copy>
      <xsl:apply-templates select="gex:geographicElement[child::gex:EX_GeographicBoundingBox]"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="gex:EX_GeographicBoundingBox">
    <xsl:copy>
      <xsl:apply-templates select="gex:westBoundLongitude"/>
      <xsl:apply-templates select="gex:southBoundLatitude"/>
      <xsl:apply-templates select="gex:eastBoundLongitude"/>
      <xsl:apply-templates select="gex:northBoundLatitude"/>
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template match="cit:CI_Citation">
    <xsl:copy>
      <xsl:apply-templates select="cit:title"/>
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>