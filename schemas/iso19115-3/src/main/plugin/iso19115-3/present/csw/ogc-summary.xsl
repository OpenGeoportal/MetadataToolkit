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
    
    <csw:SummaryRecord>
      
      <xsl:for-each select="mdb:metadataIdentifier">
        <dc:identifier><xsl:value-of select="mcc:MD_Identifier/mcc:code/gco:CharacterString"/></dc:identifier>
      </xsl:for-each>
      
      <!-- Identification -->
      <xsl:for-each select="mdb:identificationInfo/mri:MD_DataIdentification|
        mdb:identificationInfo/*[contains(@gco:isoType, 'MD_DataIdentification')]|
        mdb:identificationInfo/srv:SV_ServiceIdentification|
        mdb:identificationInfo/*[contains(@gco:isoType, 'SV_ServiceIdentification')]">
        
        <xsl:for-each select="mri:citation/cit:CI_Citation/cit:title">
          <dc:title>
            <xsl:apply-templates mode="localised" select=".">
              <xsl:with-param name="langId" select="$langId"/>
            </xsl:apply-templates>
          </dc:title>
        </xsl:for-each>
        
        <!-- Type -->
        <xsl:for-each select="../../mdb:metadataScope/mdb:MD_MetadataScope/
          mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue">
          <dc:type><xsl:value-of select="."/></dc:type>
        </xsl:for-each>
        
        
        <xsl:for-each select="mri:descriptiveKeywords/mri:MD_Keywords/mri:keyword[not(@gco:nilReason)]">
          <dc:subject>
            <xsl:apply-templates mode="localised" select=".">
              <xsl:with-param name="langId" select="$langId"/>
            </xsl:apply-templates>
          </dc:subject>
        </xsl:for-each>
        <xsl:for-each select="mri:topicCategory/mri:MD_TopicCategoryCode">
          <dc:subject><xsl:value-of select="."/></dc:subject><!-- TODO : translate ? -->
        </xsl:for-each>
        
        
        <!-- Distribution -->
        <xsl:for-each select="../../mdb:distributionInfo/mrd:MD_Distribution">
          <xsl:for-each select="mrd:distributionFormat/
            mrd:MD_Format/mrd:formatSpecificationCitation/
            cit:CI_Citation/cit:title/gco:CharacterString">
            <dc:format>
              <xsl:apply-templates mode="localised" select=".">
                <xsl:with-param name="langId" select="$langId"/>
              </xsl:apply-templates>
            </dc:format>
          </xsl:for-each>
        </xsl:for-each>
        
        
        <!-- Parent Identifier -->
        <xsl:for-each select="../../mdb:parentMetadata">
          <dc:relation><xsl:value-of select="cit:CI_Citation/
            cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString|@uuidref"/></dc:relation>
        </xsl:for-each>
        
        
        <!-- Resource modification date (metadata modification date is in 
          mdb:MD_Metadata/mdb:dateInfo  -->
        <xsl:for-each select="mri:citation/cit:CI_Citation/
          cit:date/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='revision']/
          cit:date/*">
          <dct:modified><xsl:value-of select="."/></dct:modified>
        </xsl:for-each>
        
        
        <xsl:for-each select="mri:abstract">
          <dct:abstract>
            <xsl:apply-templates mode="localised" select=".">
              <xsl:with-param name="langId" select="$langId"/>
            </xsl:apply-templates>
          </dct:abstract>
        </xsl:for-each>
        
      </xsl:for-each>
      
      <!-- Lineage 
        
        <xsl:for-each select="../../mdb:dataQualityInfo/dqm:DQ_DataQuality/dqm:lineage/dqm:LI_Lineage/dqm:statement/gco:CharacterString">
        <dc:source><xsl:value-of select="."/></dc:source>
        </xsl:for-each>-->
      
      
      <!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
      <xsl:if test="$displayInfo = 'true'">
        <xsl:copy-of select="$info"/>
      </xsl:if>
      
    </csw:SummaryRecord>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:apply-templates select="*"/>
  </xsl:template>
</xsl:stylesheet>