<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:mdb="http://standards.iso.org/19115/-3/mdb/1.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:cat="http://standards.iso.org/19115/-3/cat/1.0"
                xmlns:cit="http://standards.iso.org/19115/-3/cit/1.0"
                xmlns:gcx="http://standards.iso.org/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/19115/-3/gex/1.0"
                xmlns:lan="http://standards.iso.org/19115/-3/lan/1.0"
                xmlns:srv="http://standards.iso.org/19115/-3/srv/2.0"
                xmlns:mas="http://standards.iso.org/19115/-3/mas/1.0"
                xmlns:mcc="http://standards.iso.org/19115/-3/mcc/1.0"
                xmlns:mco="http://standards.iso.org/19115/-3/mco/1.0"
                xmlns:mda="http://standards.iso.org/19115/-3/mda/1.0"
                xmlns:mds="http://standards.iso.org/19115/-3/mds/1.0"
                xmlns:mdt="http://standards.iso.org/19115/-3/mdt/1.0"
                xmlns:mex="http://standards.iso.org/19115/-3/mex/1.0"
                xmlns:mmi="http://standards.iso.org/19115/-3/mmi/1.0"
                xmlns:mpc="http://standards.iso.org/19115/-3/mpc/1.0"
                xmlns:mrc="http://standards.iso.org/19115/-3/mrc/1.0"
                xmlns:mrd="http://standards.iso.org/19115/-3/mrd/1.0"
                xmlns:mri="http://standards.iso.org/19115/-3/mri/1.0"
                xmlns:mrl="http://standards.iso.org/19115/-3/mrl/1.0"
                xmlns:mrs="http://standards.iso.org/19115/-3/mrs/1.0"
                xmlns:msr="http://standards.iso.org/19115/-3/msr/1.0"
                xmlns:mdq="http://standards.iso.org/19157/-2/mdq/1.0"
                xmlns:mac="http://standards.iso.org/19115/-3/mac/1.0"
                xmlns:gco="http://standards.iso.org/19115/-3/gco/1.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:geonet="http://www.fao.org/geonetwork"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:param name="etlXml" />

  <!--<xsl:variable name="etlXml"
                select="document('file:///pathto/etl.xml')"/> -->

  <xsl:template match="mdb:MD_Metadata">
    <xsl:copy>
      <!-- Copy attributes -->
      <xsl:copy-of select="@*" />

      <xsl:apply-templates select="mdb:metadataIdentifier" />
      <xsl:apply-templates select="mdb:defaultLocale" />
      <xsl:apply-templates select="mdb:parentMetadata" />
      <xsl:apply-templates select="mdb:metadataScope" />
      <xsl:apply-templates select="mdb:contact" />
      <xsl:apply-templates select="mdb:dateInfo" />
      <xsl:apply-templates select="mdb:metadataStandard" />
      <xsl:apply-templates select="mdb:metadataProfile" />
      <xsl:apply-templates select="mdb:alternativeMetadataReference" />
      <xsl:apply-templates select="mdb:otherLocale" />
      <xsl:apply-templates select="mdb:metadataLinkage" />
      <xsl:apply-templates select="mdb:spatialRepresentationInfo" />

      <!-- ReferenceSystemInfo from the ETL template -->
      <xsl:choose>
        <xsl:when test="$etlXml/mdb:MD_Metadata/mdb:referenceSystemInfo">
          <xsl:copy-of select="$etlXml/mdb:MD_Metadata/mdb:referenceSystemInfo" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="mdb:referenceSystemInfo" />
        </xsl:otherwise>
      </xsl:choose>


      <xsl:apply-templates select="mdb:metadataExtensionInfo" />
      <xsl:apply-templates select="mdb:identificationInfo" />

      <!-- Feature Catalogue information from the ETL template -->
      <xsl:choose>
        <xsl:when test="$etlXml/mdb:MD_Metadata/mdb:contentInfo">
          <xsl:copy-of select="$etlXml/mdb:MD_Metadata/mdb:contentInfo" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="mdb:contentInfo" />
        </xsl:otherwise>
      </xsl:choose>


      <xsl:apply-templates select="mdb:distributionInfo" />
      <xsl:apply-templates select="mdb:dataQualityInfo" />
      <xsl:apply-templates select="mdb:resourceLineage" />

      <xsl:apply-templates select="mdb:portrayalCatalogueInfo" />
      <xsl:apply-templates select="mdb:metadataConstraints" />
      <xsl:apply-templates select="mdb:applicationSchemaInfo" />
      <xsl:apply-templates select="mdb:metadataMaintenance" />
      <xsl:apply-templates select="mdb:acquisitionInformation" />
    </xsl:copy>
  </xsl:template>


  <xsl:template match="mri:MD_DataIdentification">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:for-each select="mri:citation">
        <xsl:copy>
          <xsl:copy-of select="@*" />
          <xsl:for-each select="cit:CI_Citation">
            <xsl:copy>
              <xsl:copy-of select="@*" />

              <!-- Metadata title from the ETL template -->
              <xsl:choose>
                <xsl:when test="string($etlXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:citation/cit:CI_Citation/cit:title/gco:CharacterString)">
                  <xsl:copy-of select="$etlXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:citation/cit:CI_Citation/cit:title" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="cit:title" />
                </xsl:otherwise>
              </xsl:choose>

              <xsl:apply-templates select="*[name () != 'cit:title']" />
            </xsl:copy>
          </xsl:for-each>
        </xsl:copy>
      </xsl:for-each>

      <xsl:apply-templates select="mri:abstract" />
      <xsl:apply-templates select="mri:purpose" />
      <xsl:apply-templates select="mri:credit" />
      <xsl:apply-templates select="mri:status" />
      <xsl:apply-templates select="mri:pointOfContact" />

      <!-- spatialRepresentationType from the ETL template -->
      <xsl:choose>
        <xsl:when test="$etlXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:spatialRepresentationType">
          <xsl:copy-of select="$etlXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:spatialRepresentationType" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="spatialRepresentationType" />
        </xsl:otherwise>
      </xsl:choose>

      <!-- spatialResolution. TODO: Check if filled in ETL? -->
      <xsl:apply-templates select="mri:spatialResolution" />

      <xsl:apply-templates select="mri:temporalResolution" />
      <xsl:apply-templates select="mri:topicCategory" />

      <xsl:apply-templates select="mri:extent[not(gex:EX_Extent/gex:geographicElement)]" />

      <!-- Geographic extent from the ETL template -->
      <xsl:choose>
        <xsl:when test="$etlXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:extent[gex:EX_Extent/gex:geographicElement]">
          <xsl:copy-of select="$etlXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:extent[gex:EX_Extent/gex:geographicElement]" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="mri:extent[gex:EX_Extent/gex:geographicElement]" />
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="mri:additionalDocumentation" />
      <xsl:apply-templates select="mri:processingLevel" />
      <xsl:apply-templates select="mri:resourceMaintenance" />
      <xsl:apply-templates select="mri:graphicOverview" />
      <xsl:apply-templates select="mri:resourceFormat" />
      <xsl:apply-templates select="mri:descriptiveKeywords" />
      <xsl:apply-templates select="mri:resourceSpecificUsage" />
      <xsl:apply-templates select="mri:resourceConstraints" />
      <xsl:apply-templates select="mri:associatedResource" />
      <xsl:apply-templates select="mri:defaultLocale" />
      <xsl:apply-templates select="mri:otherLocale" />
      <xsl:apply-templates select="mri:environmentDescription" />
      <xsl:apply-templates select="mri:supplementalInformation" />
    </xsl:copy>
  </xsl:template>

  <!-- ================================================================= -->
  <!-- copy everything else as is -->

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>