<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:dc ="http://purl.org/dc/elements/1.1/"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:mdb="http://www.isotc211.org/namespace/mdb/1.0/2014-07-11"
  xmlns:mri="http://www.isotc211.org/namespace/mri/1.0/2014-07-11"
  xmlns:cit="http://www.isotc211.org/namespace/cit/1.0/2014-07-11"
  xmlns:mcc="http://www.isotc211.org/namespace/mcc/1.0/2014-07-11"
  xmlns:gex="http://www.isotc211.org/namespace/gex/1.0/2014-07-11"
  xmlns:srv="http://www.isotc211.org/namespace/srv/2.0/2014-07-11"
  xmlns:mco="http://www.isotc211.org/namespace/mco/1.0/2014-07-11"
  xmlns:mrd="http://www.isotc211.org/namespace/mrd/1.0/2014-07-11"
  xmlns:mrs="http://www.isotc211.org/namespace/mrs/1.0/2014-07-11"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:ows="http://www.opengis.net/ows"
  xmlns:geonet="http://www.fao.org/geonetwork"
  exclude-result-prefixes="#all">
  
  <xsl:param name="displayInfo"/>
  <xsl:param name="lang"/>
  
  <xsl:include href="../metadata-utils.xsl"/>
  
  <xsl:template match="mdb:MD_Metadata|*[contains(@gco:isoType,'MD_Metadata')]">
    <xsl:variable name="info" select="geonet:info"/>
    <xsl:variable name="langId">
      <xsl:call-template name="getLangId19115-1-2013">
        <xsl:with-param name="langGui" select="$lang"/>
        <xsl:with-param name="md" select="."/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="identification"
      select="mdb:identificationInfo/mri:MD_DataIdentification|
              mdb:identificationInfo/*[contains(@gco:isoType, 'MD_DataIdentification')]|
              mdb:identificationInfo/srv:SV_ServiceIdentification"
    />
    
    <csw:BriefRecord>
      <xsl:for-each select="mdb:metadataIdentifier">
        <dc:identifier><xsl:value-of select="mcc:MD_Identifier/mcc:code/gco:CharacterString"/></dc:identifier>
      </xsl:for-each>
      
      <!-- DataIdentification -->
      <xsl:for-each select="$identification/mri:citation/cit:CI_Citation">
        <xsl:for-each select="cit:title">
          <dc:title>
            <xsl:apply-templates mode="localised" select=".">
              <xsl:with-param name="langId" select="$langId"/>
            </xsl:apply-templates>
          </dc:title>
        </xsl:for-each>
      </xsl:for-each>
      
      
      <!-- Type -->
      <xsl:for-each select="mdb:metadataScope/mdb:MD_MetadataScope/
        mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue">
        <dc:type><xsl:value-of select="."/></dc:type>
      </xsl:for-each>
      
      <!-- bounding box -->
      <xsl:for-each
        select="$identification/mri:extent/gex:EX_Extent/gex:geographicElement/gex:EX_GeographicBoundingBox|
        $identification/srv:extent/gex:EX_Extent/gex:geographicElement/gex:EX_GeographicBoundingBox">
        <xsl:variable name="rsi"
          select="/mdb:MD_Metadata/mdb:referenceSystemInfo/mrs:MD_ReferenceSystem/
          mrs:referenceSystemIdentifier/mcc:MD_Identifier|/mdb:MD_Metadata/mdb:referenceSystemInfo/
          *[contains(@gco:isoType, 'MD_ReferenceSystem')]/mrs:referenceSystemIdentifier/mcc:MD_Identifier"/>
        <xsl:variable name="auth" select="$rsi/mcc:codeSpace/gco:CharacterString"/>
        <xsl:variable name="id" select="$rsi/mcc:code/gco:CharacterString"/>
        
        <ows:BoundingBox crs="{$auth}::{$id}">
          <ows:LowerCorner>
            <xsl:value-of
              select="concat(gex:eastBoundLongitude/gco:Decimal, ' ', gex:southBoundLatitude/gco:Decimal)"
            />
          </ows:LowerCorner>
          
          <ows:UpperCorner>
            <xsl:value-of
              select="concat(gex:westBoundLongitude/gco:Decimal, ' ', gex:northBoundLatitude/gco:Decimal)"
            />
          </ows:UpperCorner>
        </ows:BoundingBox>
      </xsl:for-each>
      
      <!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
      <xsl:if test="$displayInfo = 'true'">
        <xsl:copy-of select="$info"/>
      </xsl:if>
      
    </csw:BriefRecord>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:apply-templates select="*"/>
  </xsl:template>
</xsl:stylesheet>