<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:cit="http://www.isotc211.org/namespace/cit/1.0/2014-07-11"
                xmlns:gex="http://www.isotc211.org/namespace/gex/1.0/2014-07-11"
                xmlns:lan="http://www.isotc211.org/namespace/lan/1.0/2014-07-11"
                xmlns:mcc="http://www.isotc211.org/namespace/mcc/1.0/2014-07-11"
                xmlns:mco="http://www.isotc211.org/namespace/mco/1.0/2014-07-11"
                xmlns:mdb="http://www.isotc211.org/namespace/mdb/1.0/2014-07-11"
                xmlns:mmi="http://www.isotc211.org/namespace/mmi/1.0/2014-07-11"
                xmlns:mrd="http://www.isotc211.org/namespace/mrd/1.0/2014-07-11"
                xmlns:mri="http://www.isotc211.org/namespace/mri/1.0/2014-07-11"
                xmlns:mrl="http://www.isotc211.org/namespace/mrl/1.0/2014-07-11"
                xmlns:mrs="http://www.isotc211.org/namespace/mrs/1.0/2014-07-11"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gml="http://www.opengis.net/gml/3.2">

  <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" version="1.0" indent="yes" />
  <xsl:template match="/">

    <mdb:MD_Metadata xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     xmlns:cit="http://www.isotc211.org/namespace/cit/1.0/2014-07-11"
                     xmlns:gex="http://www.isotc211.org/namespace/gex/1.0/2014-07-11"
                     xmlns:lan="http://www.isotc211.org/namespace/lan/1.0/2014-07-11"
                     xmlns:mcc="http://www.isotc211.org/namespace/mcc/1.0/2014-07-11"
                     xmlns:mco="http://www.isotc211.org/namespace/mco/1.0/2014-07-11"
                     xmlns:mdb="http://www.isotc211.org/namespace/mdb/1.0/2014-07-11"
                     xmlns:mmi="http://www.isotc211.org/namespace/mmi/1.0/2014-07-11"
                     xmlns:mrd="http://www.isotc211.org/namespace/mrd/1.0/2014-07-11"
                     xmlns:mri="http://www.isotc211.org/namespace/mri/1.0/2014-07-11"
                     xmlns:mrl="http://www.isotc211.org/namespace/mrl/1.0/2014-07-11"
                     xmlns:mrs="http://www.isotc211.org/namespace/mrs/1.0/2014-07-11"
                     xmlns:gco="http://www.isotc211.org/2005/gco"
                     xmlns:gml="http://www.opengis.net/gml/3.2"
                     xsi:schemaLocation="http://www.isotc211.org/namespace/mdb/1.0/2014-07-11 ../schema.xsd">

      <!-- Metadata identifier -->
      <xsl:choose>
        <xsl:when test="mdFileID">
          <xsl:apply-templates select="metadata/mdFileID"/>
        </xsl:when>

        <xsl:otherwise>
          <!-- TODO: create a uuid -->
          <mdb:metadataIdentifier>
            <mcc:MD_Identifier>
              <mcc:code>
                <gco:CharacterString/>
              </mcc:code>
            </mcc:MD_Identifier>
          </mdb:metadataIdentifier>
        </xsl:otherwise>
      </xsl:choose>

      <!-- Metadata language/charset -->
      <mdb:defaultLocale>
        <lan:PT_Locale>
          <lan:language>
            <!-- TODO: Translate to ISO 3 code -->
            <xsl:apply-templates select="metadata/mdLang/languageCode"/>

          </lan:language>
          <lan:characterEncoding>
            <xsl:apply-templates select="metadata/mdChar/CharSetCd"/>
          </lan:characterEncoding>
        </lan:PT_Locale>
      </mdb:defaultLocale>

      <!-- Metadata scope -->
      <mdb:metadataScope>
        <mdb:MD_MetadataScope>
          <mdb:resourceScope> <xsl:apply-templates select="metadata/mdHrLv/ScopeCd"/></mdb:resourceScope>
          <xsl:if test="metadata/mdHrLvName">
            <mdb:name>
              <gco:CharacterString>
                <xsl:value-of select="metadata/mdHrLvName"/>
              </gco:CharacterString>
            </mdb:name>
          </xsl:if>
        </mdb:MD_MetadataScope>
      </mdb:metadataScope>

      <!-- TODO: Check -->
      <!--<mdb:contact />

      <!-- Metadata date stamp -->
      <xsl:apply-templates select="metadata/mdDateSt"/>

      <!-- Metadata standard name -->
      <mdb:metadataStandard>
        <cit:CI_Citation>
          <cit:title>
            <gco:CharacterString>ISO 19115-3</gco:CharacterString>
          </cit:title>
        </cit:CI_Citation>
      </mdb:metadataStandard>

      <!-- TODO: Check -->
      <!--
        <xsl:apply-templates select="mdb:metadataProfile"/>
        <xsl:apply-templates select="mdb:alternativeMetadataReference"/>
        <xsl:apply-templates select="mdb:otherLocale"/>
        <xsl:apply-templates select="mdb:metadataLinkage"/>
        <xsl:apply-templates select="mdb:spatialRepresentationInfo"/>
      -->

      <xsl:for-each select="metadata/refSysInfo">
        <xsl:apply-templates select="."/>
      </xsl:for-each>

      <xsl:apply-templates select="metadata/idinfo"/>


      <!-- TODO -->
      <!--<mdb:distributionInfo />
      <mdb:resourceLineage />-->
    </mdb:MD_Metadata>
  </xsl:template>

  <xsl:template match="mdFileID">
    <mdb:metadataIdentifier>
      <mcc:MD_Identifier>
        <mcc:code>
          <gco:CharacterString><xsl:value-of select="." /></gco:CharacterString>
        </mcc:code>
      </mcc:MD_Identifier>
    </mdb:metadataIdentifier>
  </xsl:template>

  <xsl:template match="mdDateSt">
    <mdb:dateInfo>
      <cit:CI_Date>
        <cit:date>
          <!-- TODO: Review format -->
          <xsl:value-of select="." />
        </cit:date>
        <cit:dateType><cit:CI_DateTypeCode codeList="" codeListValue="creation" /></cit:dateType>
      </cit:CI_Date>
    </mdb:dateInfo>
  </xsl:template>

  <xsl:template match="languageCode">
<!--
      <languageCode Sync="TRUE" value="en"/>
-->
    <lan:LanguageCode codeList="codeListLocation#LanguageCode" codeListValue="{languageCode/@value}">
      <!-- TODO: Add more language mappings -->
      <xsl:if test="@value=en">
        <xsl:attribute name="codeListValue">
          <xsl:text>eng</xsl:text>
        </xsl:attribute>
      </xsl:if>
    </lan:LanguageCode>
  </xsl:template>

  <xsl:template match="CharSetCd">
    <lan:MD_CharacterSetCode codeList="codeListLocation#MD_CharacterSetCode">
      <xsl:if test="@value=001">
        <xsl:attribute name="codeListValue">
          <xsl:text>ucs2</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=002">
        <xsl:attribute name="codeListValue">
          <xsl:text>ucs4</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=003">
        <xsl:attribute name="codeListValue">
          <xsl:text>utf7</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=004">
        <xsl:attribute name="codeListValue">
          <xsl:text>utf8</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=005">
        <xsl:attribute name="codeListValue">
          <xsl:text>utf16</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=006">
        <xsl:attribute name="codeListValue">
          <xsl:text>8859part1</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=007">
        <xsl:attribute name="codeListValue">
          <xsl:text>8859part2</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=008">
        <xsl:attribute name="codeListValue">
          <xsl:text>8859part3</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=009">
        <xsl:attribute name="codeListValue">
          <xsl:text>8859part4</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=010">
        <xsl:attribute name="codeListValue">
          <xsl:text>8859part5</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=011">
        <xsl:attribute name="codeListValue">
          <xsl:text>8859part6</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=012">
        <xsl:attribute name="codeListValue">
          <xsl:text>8859part7</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=013">
        <xsl:attribute name="codeListValue">
          <xsl:text>8859part8</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=014">
        <xsl:attribute name="codeListValue">
          <xsl:text>8859part9</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=015">
        <xsl:attribute name="codeListValue">
          <xsl:text>8859part11</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=016">
        <xsl:attribute name="codeListValue">
          <xsl:text>8859part14</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=017">
        <xsl:attribute name="codeListValue">
          <xsl:text>8859part15</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=018">
        <xsl:attribute name="codeListValue">
          <xsl:text>jis</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=019">
        <xsl:attribute name="codeListValue">
          <xsl:text>shiftJIS</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=020">
        <xsl:attribute name="codeListValue">
          <xsl:text>eucJP</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=021">
        <xsl:attribute name="codeListValue">
          <xsl:text>usAscii</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=022">
        <xsl:attribute name="codeListValue">
          <xsl:text>ebcdic</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=023">
        <xsl:attribute name="codeListValue">
          <xsl:text>eucKR</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=024">
        <xsl:attribute name="codeListValue">
          <xsl:text>big5</xsl:text>
        </xsl:attribute>
      </xsl:if>
    </lan:MD_CharacterSetCode>
  </xsl:template>

  <xsl:template match="refSysInfo">
<!--
    <refSysInfo>
      <RefSystem>
        <refSysID>
          <identCode Sync="TRUE">NAD_1983_StatePlane_New_York_Long_Island_FIPS_3104_Feet</identCode>
        </refSysID>
      </RefSystem>
    </refSysInfo>
-->
    <mdb:referenceSystemInfo>
      <mrs:MD_ReferenceSystem>
        <mrs:referenceSystemIdentifier>
          <mcc:MD_Identifier>
            <mcc:code>
              <gco:CharacterString><xsl:value-of select="RefSystem/refSysID/identCode" /></gco:CharacterString>
            </mcc:code>
          </mcc:MD_Identifier>
        </mrs:referenceSystemIdentifier>
      </mrs:MD_ReferenceSystem>
    </mdb:referenceSystemInfo>
  </xsl:template>

  <xsl:template match="idinfo">
    <mdb:identificationInfo>
      <mri:MD_DataIdentification>
        <xsl:apply-templates select="citation"/>

        <mri:abstract>
          <gco:CharacterString><xsl:value-of select="descript/abstract"/></gco:CharacterString>
        </mri:abstract>
        <mri:purpose>
          <gco:CharacterString><xsl:value-of select="descript/purpose"/></gco:CharacterString>
        </mri:purpose>
        <mri:status>
          <!-- TODO: CHeck if requires any translation -->
          <mcc:MD_ProgressCode codeList="codeListLocation#MD_ProgressCode" codeListValue="{status/progress}"><xsl:value-of select="status/progress"/></mcc:MD_ProgressCode>
        </mri:status>


        <!-- TODO -->
        <mri:pointOfContact />
        <mri:spatialRepresentationType>
          <mcc:MD_SpatialRepresentationTypeCode codeList="codeListLocation#MD_SpatialRepresentationTypeCode"
                                                codeListValue="vector"/>
        </mri:spatialRepresentationType>
        <mri:spatialResolution />
        <mri:topicCategory />

        <mri:extent>
          <gex:EX_Extent>
            <gex:temporalElement>
              <gex:EX_TemporalExtent>

              </gex:EX_TemporalExtent>
            </gex:temporalElement>
          </gex:EX_Extent>
        </mri:extent>

        <xsl:for-each select="spdom/bounding">
          <xsl:apply-templates select="." />
        </xsl:for-each>


        <!-- TODO -->
        <mri:resourceMaintenance />


        <xsl:for-each select="keywords">
          <mri:descriptiveKeywords>
            <mri:MD_Keywords>
            <xsl:for-each select="theme">
              <xsl:for-each select="themekey">
                <mri:keyword><xsl:apply-templates select="."/></mri:keyword>
              </xsl:for-each>

              <mri:type>
                <mri:MD_KeywordTypeCode codeListValue="theme"
                                        codeList="./resources/codeList.xml#MD_KeywordTypeCode"/>
              </mri:type>

              <!-- TODO: Thesaurus -->
              <!--<xsl:apply-templates select="themekt"/>-->

            </xsl:for-each>
            </mri:MD_Keywords>
          </mri:descriptiveKeywords>

          <mri:descriptiveKeywords>
            <mri:MD_Keywords>
            <xsl:for-each select="place">
              <xsl:for-each select="placekey">
                <mri:keyword><xsl:apply-templates select="."/></mri:keyword>
              </xsl:for-each>

              <mri:type>
                <mri:MD_KeywordTypeCode codeListValue="place"
                                        codeList="./resources/codeList.xml#MD_KeywordTypeCode"/>
              </mri:type>

              <!-- TODO: Thesaurus -->
              <!--<xsl:apply-templates select="placekt"/>-->
            </xsl:for-each>
            </mri:MD_Keywords>
          </mri:descriptiveKeywords>

        </xsl:for-each>


        <!-- TODO -->
        <!--<mri:resourceConstraints />-->
        <!--<xsl:for-each select="/metadata/dataIdInfo/resConst">
          <xsl:apply-templates select="."/>
        </xsl:for-each>-->

        <mri:defaultLocale>
          <lan:PT_Locale>
            <lan:language>
              <lan:LanguageCode codeList="codeListLocation#LanguageCode" codeListValue="eng"/>
            </lan:language>
            <lan:characterEncoding>
              <lan:MD_CharacterSetCode codeList="codeListLocation#MD_CharacterSetCode"
                                       codeListValue="utf8"/>
            </lan:characterEncoding>
          </lan:PT_Locale>
        </mri:defaultLocale>

        <!-- TODO -->
        <!--<mri:supplementalInformation />-->

      </mri:MD_DataIdentification>
    </mdb:identificationInfo>

  </xsl:template>

  <xsl:template match="citation">
    <mri:citation>
      <cit:CI_Citation>
        <cit:title>
          <gco:CharacterString><xsl:value-of select="citeinfo/title"/></gco:CharacterString>
        </cit:title>
        <cit:date>
          <cit:CI_Date>
            <cit:date>
              <gco:DateTime><xsl:value-of select="citeinfo/pubdate"/></gco:DateTime>
            </cit:date>
            <cit:dateType>
              <cit:CI_DateTypeCode codeList="codeListLocation#CI_DateTypeCode" codeListValue="publication"/>
            </cit:dateType>
          </cit:CI_Date>
        </cit:date>
      </cit:CI_Citation>
    </mri:citation>
  </xsl:template>

  <xsl:template match="bounding">
    <mri:extent>
      <gex:EX_Extent>
        <gex:geographicElement>
          <gex:EX_GeographicBoundingBox>
            <gex:westBoundLongitude><gco:Decimal><xsl:value-of select="westbc"/></gco:Decimal></gex:westBoundLongitude>
            <gex:eastBoundLongitude><gco:Decimal><xsl:value-of select="eastbc"/></gco:Decimal></gex:eastBoundLongitude>
            <gex:southBoundLatitude><gco:Decimal><xsl:value-of select="southbc"/></gco:Decimal></gex:southBoundLatitude>
            <gex:northBoundLatitude><gco:Decimal><xsl:value-of select="northbc"/></gco:Decimal></gex:northBoundLatitude>
          </gex:EX_GeographicBoundingBox>
        </gex:geographicElement>
      </gex:EX_Extent>
    </mri:extent>
  </xsl:template>



  <xsl:template match="ScopeCd">
    <mcc:MD_ScopeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ScopeCode">
      <xsl:if test="@value=001">
        <xsl:attribute name="codeListValue">
          <xsl:text>attribute</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=002">
        <xsl:attribute name="codeListValue">
          <xsl:text>attributeType</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=003">
        <xsl:attribute name="codeListValue">
          <xsl:text>collectionHardware</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=004">
        <xsl:attribute name="codeListValue">
          <xsl:text>collectionSession</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=005">
        <xsl:attribute name="codeListValue">
          <xsl:text>dataset</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=006">
        <xsl:attribute name="codeListValue">
          <xsl:text>series</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=007">
        <xsl:attribute name="codeListValue">
          <xsl:text>nonGeographicDataset</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=008">
        <xsl:attribute name="codeListValue">
          <xsl:text>dimensionGroup</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=009">
        <xsl:attribute name="codeListValue">
          <xsl:text>feature</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=010">
        <xsl:attribute name="codeListValue">
          <xsl:text>featureType</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=011">
        <xsl:attribute name="codeListValue">
          <xsl:text>propertyType</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=012">
        <xsl:attribute name="codeListValue">
          <xsl:text>fieldSession</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=013">
        <xsl:attribute name="codeListValue">
          <xsl:text>software</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=014">
        <xsl:attribute name="codeListValue">
          <xsl:text>service</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@value=015">
        <xsl:attribute name="codeListValue">
          <xsl:text>model</xsl:text>
        </xsl:attribute>
      </xsl:if>
    </mcc:MD_ScopeCode>
  </xsl:template>
</xsl:stylesheet>