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

  <!-- Template information has priority over the metadata processed -->
  <!--<xsl:variable name="templateXml"
                select="document('file:///pathto/template.xml')"/>-->

  <xsl:param name="templateXml" />

  <xsl:template match="mdb:MD_Metadata">
    <xsl:copy>
      <!-- Copy attributes -->
      <xsl:copy-of select="@*" />

      <xsl:apply-templates select="mdb:metadataIdentifier" />

      <!-- Metadata language from the template -->
      <xsl:choose>
        <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:defaultLocale">
          <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:defaultLocale" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="mdb:defaultLocale" />
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="mdb:parentMetadata" />

      <!-- hierarchyLevel from the template -->
      <xsl:choose>
        <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:metadataScope">
          <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:metadataScope" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="mdb:metadataScope" />
        </xsl:otherwise>
      </xsl:choose>

      <!-- contact from the template -->
      <xsl:choose>
        <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:contact">
          <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:contact" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="mdb:contact" />
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="mdb:dateInfo" />
      <xsl:apply-templates select="mdb:metadataStandard" />
      <xsl:apply-templates select="mdb:metadataProfile" />
      <xsl:apply-templates select="mdb:alternativeMetadataReference" />
      <xsl:apply-templates select="mdb:otherLocale" />
      <xsl:apply-templates select="mdb:metadataLinkage" />
      <xsl:apply-templates select="mdb:spatialRepresentationInfo" />

      <!-- ReferenceSystemInfo from the template -->
      <xsl:choose>
        <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:referenceSystemInfo">
          <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:referenceSystemInfo" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="mdb:referenceSystemInfo" />
        </xsl:otherwise>
      </xsl:choose>


      <xsl:apply-templates select="mdb:metadataExtensionInfo" />
      <xsl:apply-templates select="mdb:identificationInfo" />

      <!-- Feature Catalogue information from the template -->
      <xsl:choose>
        <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:contentInfo">
          <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:contentInfo" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="mdb:contentInfo" />
        </xsl:otherwise>
      </xsl:choose>


      <!-- Format, Distributor, Transfer options from template -->
      <xsl:choose>
        <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:distributionFormat or
                    $templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:distributor or
                    $templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:transferOptions">
          <!-- mdb:distributionInfo is optional, check if required to be added or reuse it if exists -->
          <xsl:choose>
            <xsl:when test="mdb:distributionInfo">
              <xsl:for-each select="mdb:distributionInfo">
                <xsl:copy-of select="@*" />

                <!-- mrd:MD_Distribution is optional, check if required to add -->
                <xsl:choose>
                  <xsl:when test="mrd:MD_Distribution">
                    <xsl:for-each select="mdb:MD_Distribution">
                      <xsl:copy-of select="@*" />

                      <xsl:apply-templates select="mrd:description" />

                      <xsl:choose>
                        <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:distributionFormat">
                          <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:distributionFormat" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="mrd:distributionFormat" />
                        </xsl:otherwise>
                      </xsl:choose>

                      <xsl:choose>
                        <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:distributor">
                          <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:distributor" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="mrd:distributor" />
                        </xsl:otherwise>
                      </xsl:choose>

                      <xsl:choose>
                        <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:transferOptions">
                          <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:transferOptions" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="mrd:transferOptions" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>

                  </xsl:when>

                  <xsl:otherwise>
                    <mrd:MD_Distribution>
                      <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:distributionFormat" />
                      <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:distributor" />
                      <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:transferOptions" />
                    </mrd:MD_Distribution>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:for-each>
            </xsl:when>
            <!-- Add mdb:distributionInfo -->
            <xsl:otherwise>
              <mdb:distributionInfo>
                <mrd:MD_Distribution>
                  <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:distributionFormat" />
                  <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:distributor" />
                  <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:transferOptions" />
                </mrd:MD_Distribution>
              </mdb:distributionInfo>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:otherwise>
          <xsl:apply-templates select="mdb:distributionInfo" />
        </xsl:otherwise>
      </xsl:choose>



      <xsl:apply-templates select="mdb:dataQualityInfo" />

      <!-- resource lineage (for process step) information from the template -->
      <xsl:choose>
        <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:resourceLineage">
          <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:resourceLineage" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="mdb:resourceLineage" />
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="mdb:portrayalCatalogueInfo" />
      <xsl:apply-templates select="mdb:metadataConstraints" />
      <xsl:apply-templates select="mdb:applicationSchemaInfo" />
      <xsl:apply-templates select="mdb:metadataMaintenance" />
      <xsl:apply-templates select="mdb:acquisitionInformation" />
    </xsl:copy>
  </xsl:template>


  <xsl:template match="mri:MD_DataIdentification">
    <xsl:for-each select="mri:citation">
      <xsl:copy>
        <xsl:copy-of select="@*" />
        <xsl:for-each select="cit:CI_Citation">
          <xsl:copy>
            <xsl:copy-of select="@*" />

            <!-- Metadata title from the template -->
            <xsl:choose>
              <xsl:when test="string($templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:citation/cit:CI_Citation/cit:title/gco:CharacterString)">
                <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:citation/cit:CI_Citation/cit:title" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="cit:title" />
              </xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates select="alternateTitle" />

            <!-- Publication date from the template -->
            <xsl:choose>
              <xsl:when test="count($templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:citation/cit:CI_Citation/cit:date/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='publication']/cit:date[normalize-space(*) != '']) > 0">
                <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:citation/cit:CI_Citation/cit:date[cit:CI_Date/cit:dateType/cit:CI_DateTypeCode/@codeListValue='publication']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="cit:date[cit:CI_Date/cit:dateType/cit:CI_DateTypeCode/@codeListValue='publication']" />
              </xsl:otherwise>
            </xsl:choose>

            <!-- Copy the rest of dates -->
            <xsl:apply-templates select="cit:date[cit:CI_Date/cit:dateType/cit:CI_DateTypeCode/@codeListValue!='publication']" />

            <xsl:apply-templates select="cit:edition" />
            <xsl:apply-templates select="cit:editionDate" />
            <xsl:apply-templates select="cit:identifier" />

            <!-- Copy the contacts with other roles than originator, publisher -->
            <xsl:apply-templates select="cit:citedResponsibleParty[cit:CI_Responsibility/cit:role/cit:CI_RoleCode/@codeListValue != 'originator' and
                            cit:CI_Responsibility/cit:role/cit:CI_RoleCode/@codeListValue != 'publisher']
                            " />

            <!-- Originator from template -->
            <xsl:choose>
              <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:citation/cit:CI_Citation/cit:citedResponsibleParty[cit:CI_Responsibility/cit:role/cit:CI_RoleCode/@codeListValue = 'originator']">
                <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:citation/cit:CI_Citation/cit:citedResponsibleParty[cit:CI_Responsibility/cit:role/cit:CI_RoleCode/@codeListValue = 'originator']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="cit:citedResponsibleParty[cit:CI_Responsibility/cit:role/cit:CI_RoleCode/@codeListValue = 'originator']" />
              </xsl:otherwise>
            </xsl:choose>

            <!-- Publisher from template -->
            <xsl:choose>
              <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:citation/cit:CI_Citation/cit:citedResponsibleParty[cit:CI_Responsibility/cit:role/cit:CI_RoleCode/@codeListValue = 'publisher']">
                <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:citation/cit:CI_Citation/cit:citedResponsibleParty[cit:CI_Responsibility/cit:role/cit:CI_RoleCode/@codeListValue = 'publisher']" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="cit:citedResponsibleParty[cit:CI_Responsibility/cit:role/cit:CI_RoleCode/@codeListValue = 'originator']" />
              </xsl:otherwise>
            </xsl:choose>

            <!-- presentationForm from the template -->
            <xsl:choose>
              <xsl:when test="count($templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:citation/cit:CI_Citation/cit:presentationForm[normalize-space(cit:CI_PresentationFormCode/@codeListValue) != '']) > 0">
                <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:citation/cit:CI_Citation/cit:presentationForm" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="cit:presentationForm" />
              </xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates select="cit:series" />
            <xsl:apply-templates select="cit:ISBN" />
            <xsl:apply-templates select="cit:ISSN" />
            <xsl:apply-templates select="cit:onlineResource" />
            <xsl:apply-templates select="cit:graphic" />
            <xsl:apply-templates select="cit:onlineResource" />

          </xsl:copy>
        </xsl:for-each>
      </xsl:copy>
    </xsl:for-each>

    <!-- abstract from the template -->
    <xsl:choose>
      <xsl:when test="string($templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:abstract/gco:CharacterString)">
        <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:abstract" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="mri:abstract" />
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="mri:abstract" />
    <xsl:apply-templates select="mri:purpose" />
    <xsl:apply-templates select="mri:credit" />
    <xsl:apply-templates select="mri:status" />
    <xsl:apply-templates select="mri:pointOfContact" />

    <!-- spatialRepresentationType from the template -->
    <xsl:choose>
      <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:spatialRepresentationType">
        <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:spatialRepresentationType" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="spatialRepresentationType" />
      </xsl:otherwise>
    </xsl:choose>

    <!-- spatialResolution from the template -->
    <xsl:choose>
      <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:spatialResolution">
        <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:spatialResolution" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="spatialResolution" />
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="mri:temporalResolution" />

    <!-- Topic Category from the template -->
    <xsl:choose>
      <xsl:when test="count($templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:topicCategory[normalize-space(mri:MD_TopicCategoryCode) != '']) > 0">
        <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:topicCategory" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="mri:topicCategory" />
      </xsl:otherwise>
    </xsl:choose>

    <!-- Copy non temporal/geographic extents -->
    <xsl:apply-templates select="mri:extent[not(gex:EX_Extent/gex:geographicElement) and not(gex:EX_Extent/gex:temporalElement)]" />

    <!-- Temporal extent from the template -->
    <xsl:choose>
      <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:extent[gex:EX_Extent/gex:temporalElement]">
        <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:extent[gex:EX_Extent/gex:temporalElement]" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="mri:extent[gex:EX_Extent/gex:temporalElement]" />
      </xsl:otherwise>
    </xsl:choose>

    <!-- Geographic extent from the template -->
    <xsl:choose>
      <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:extent[gex:EX_Extent/gex:geographicElement]">
        <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:extent[gex:EX_Extent/gex:geographicElement]" />
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

    <!-- Copy keywords non related to theme, place -->
    <xsl:apply-templates select="mri:descriptiveKeywords[mri:MD_Keywords/mri:type/mri:MD_KeywordTypeCode/@codeListValue != 'theme' and
            mri:MD_Keywords/mri:type/mri:MD_KeywordTypeCode/@codeListValue != 'place']" />

    <!-- Theme keywords from the template. TODO: Check if both should be integrated?? -->
    <xsl:choose>
      <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:descriptiveKeywords[mri:MD_Keywords/mri:type/mri:MD_KeywordTypeCode/@codeListValue = 'theme']">
        <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:descriptiveKeywords[mri:MD_Keywords/mri:type/mri:MD_KeywordTypeCode/@codeListValue = 'theme']" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="mri:descriptiveKeywords[mri:MD_Keywords/mri:type/mri:MD_KeywordTypeCode/@codeListValue = 'theme']" />
      </xsl:otherwise>
    </xsl:choose>


    <!-- Place keywords from the template. TODO: Check if both should be integrated?? -->
    <xsl:choose>
      <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:descriptiveKeywords[mri:MD_Keywords/mri:type/mri:MD_KeywordTypeCode/@codeListValue = 'place']">
        <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:descriptiveKeywords[mri:MD_Keywords/mri:type/mri:MD_KeywordTypeCode/@codeListValue = 'place']" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="mri:descriptiveKeywords[mri:MD_Keywords/mri:type/mri:MD_KeywordTypeCode/@codeListValue = 'place']" />
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="mri:resourceSpecificUsage" />

    <!-- Access, user constraints from the template -->
    <xsl:choose>
      <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:resourceConstraints/mco:MD_LegalConstraints/mco:accessConstraints or
                $templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:resourceConstraints/mco:MD_LegalConstraints/mco:useConstraints">

        <!-- Copy the legal contraints content from the template -->
        <!-- Note that in the md can be several sections with mri:resourceConstraints[mco:MD_LegalConstraint], all are replaced with the ones in the template -->
        <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:resourceConstraints[mco:MD_LegalConstraint]"></xsl:copy-of>

      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates select="mri:resourceConstraints[mco:MD_LegalConstraints]" />
      </xsl:otherwise>
    </xsl:choose>

    <!-- Copy non legal constraints -->
    <xsl:apply-templates select="mri:resourceConstraints[mco:MD_Constraints]" />
    <xsl:apply-templates select="mri:resourceConstraints[mco:MD_SecurityConstraints]" />

    <xsl:apply-templates select="mri:associatedResource" />

    <!-- Dataset language from the template -->
    <xsl:choose>
      <xsl:when test="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:defaultLocale">
        <xsl:copy-of select="$templateXml/mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification/mri:defaultLocale" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="mri:defaultLocale" />
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="mri:otherLocale" />
    <xsl:apply-templates select="mri:environmentDescription" />
    <xsl:apply-templates select="mri:supplementalInformation" />
  </xsl:template>

  <!-- ================================================================= -->
  <!-- copy everything else as is -->

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>