<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:cit="http://www.isotc211.org/namespace/cit/1.0/2014-12-25"
                xmlns:gex="http://www.isotc211.org/namespace/gex/1.0/2014-12-25"
                xmlns:lan="http://www.isotc211.org/namespace/lan/1.0/2014-12-25"
                xmlns:mcc="http://www.isotc211.org/namespace/mcc/1.0/2014-12-25"
                xmlns:mco="http://www.isotc211.org/namespace/mco/1.0/2014-12-25"
                xmlns:mdb="http://www.isotc211.org/namespace/mdb/1.0/2014-12-25"
                xmlns:mmi="http://www.isotc211.org/namespace/mmi/1.0/2014-12-25"
                xmlns:mrd="http://www.isotc211.org/namespace/mrd/1.0/2014-12-25"
                xmlns:mri="http://www.isotc211.org/namespace/mri/1.0/2014-12-25"
                xmlns:mrl="http://www.isotc211.org/namespace/mrl/1.0/2014-12-25"
                xmlns:mrs="http://www.isotc211.org/namespace/mrs/1.0/2014-12-25"
                xmlns:mrc="http://www.isotc211.org/namespace/mrc/1.0/2014-12-25"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gml="http://www.opengis.net/gml/3.2">

  <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" version="1.0" indent="yes" />
  <xsl:template match="/">

    <mdb:MD_Metadata xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     xmlns:cit="http://www.isotc211.org/namespace/cit/1.0/2014-12-25"
                     xmlns:gex="http://www.isotc211.org/namespace/gex/1.0/2014-12-25"
                     xmlns:lan="http://www.isotc211.org/namespace/lan/1.0/2014-12-25"
                     xmlns:mcc="http://www.isotc211.org/namespace/mcc/1.0/2014-12-25"
                     xmlns:mco="http://www.isotc211.org/namespace/mco/1.0/2014-12-25"
                     xmlns:mdb="http://www.isotc211.org/namespace/mdb/1.0/2014-12-25"
                     xmlns:mmi="http://www.isotc211.org/namespace/mmi/1.0/2014-12-25"
                     xmlns:mrd="http://www.isotc211.org/namespace/mrd/1.0/2014-12-25"
                     xmlns:mri="http://www.isotc211.org/namespace/mri/1.0/2014-12-25"
                     xmlns:mrl="http://www.isotc211.org/namespace/mrl/1.0/2014-12-25"
                     xmlns:mrs="http://www.isotc211.org/namespace/mrs/1.0/2014-12-25"
                     xmlns:mrc="http://www.isotc211.org/namespace/mrc/1.0/2014-12-25"
                     xmlns:gco="http://www.isotc211.org/2005/gco"
                     xmlns:gml="http://www.opengis.net/gml/3.2"
                     xsi:schemaLocation="http://www.isotc211.org/namespace/mdb/1.0/2014-12-25 ../schema.xsd">

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
            <xsl:choose>
              <xsl:when test="metadata/mdLang/languageCode"><xsl:apply-templates select="metadata/mdLang/languageCode"/></xsl:when>
              <xsl:otherwise>
                <lan:LanguageCode codeList="codeListLocation#LanguageCode" codeListValue="eng" />
              </xsl:otherwise>
            </xsl:choose>
          </lan:language>

          <lan:characterEncoding>
            <xsl:choose>
              <xsl:when test="metadata/mdChar/CharSetCd"><xsl:apply-templates select="metadata/mdChar/CharSetCd"/></xsl:when>
              <xsl:otherwise>
                <lan:MD_CharacterSetCode codeList="codeListLocation#MD_CharacterSetCode" codeListValue="utf8" />
              </xsl:otherwise>
            </xsl:choose>
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

      <!-- Metadata contact -->
      <xsl:apply-templates select="metadata/metainfo/metc"/>

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

      <!-- Reference system info -->
      <xsl:for-each select="metadata/refSysInfo">
        <xsl:apply-templates select="."/>
      </xsl:for-each>

      <!-- Identification info -->
      <xsl:apply-templates select="metadata/idinfo"/>


      <!-- Distribution info -->
      <xsl:apply-templates select="metadata/distinfo"/>

      <!-- Data quality info -->
      <xsl:apply-templates select="metadata/dataqual"/>


      <!-- TODO -->
      <!--<mdb:resourceLineage />-->

      <!-- Feature catalogue attributes -->
      <xsl:apply-templates select="metadata/eainfo"/>
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
          <gco:DateTime>
          <xsl:call-template name="format-date">
            <xsl:with-param name="dateval" select="." />
            <xsl:with-param name="format" select="'datetime'" />
          </xsl:call-template>
          </gco:DateTime>
        </cit:date>
        <cit:dateType><cit:CI_DateTypeCode codeList="" codeListValue="creation" /></cit:dateType>
      </cit:CI_Date>
    </mdb:dateInfo>
  </xsl:template>

  <xsl:template match="languageCode">
<!--
      <languageCode Sync="TRUE" value="en"/>
-->
    <lan:LanguageCode codeList="codeListLocation#LanguageCode">
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

        <!-- Abstract -->
        <mri:abstract>
          <gco:CharacterString><xsl:value-of select="descript/abstract"/></gco:CharacterString>
        </mri:abstract>

        <!-- Purpose -->
        <mri:purpose>
          <gco:CharacterString><xsl:value-of select="descript/purpose"/></gco:CharacterString>
        </mri:purpose>

        <!-- Status -->
        <mri:status>
          <!-- TODO: CHeck if requires any translation -->
          <mcc:MD_ProgressCode codeList="codeListLocation#MD_ProgressCode" codeListValue="{status/progress}"><xsl:value-of select="status/progress"/></mcc:MD_ProgressCode>
        </mri:status>


        <!-- Point of contact -->
        <xsl:apply-templates select="ptcontac" />

        <!-- Spatial representation type -->
        <mri:spatialRepresentationType>
          <mcc:MD_SpatialRepresentationTypeCode codeList="codeListLocation#MD_SpatialRepresentationTypeCode"
                                                codeListValue="vector"/>
        </mri:spatialRepresentationType>
        <mri:spatialResolution />

        <!-- Topic category -->
        <xsl:for-each select="keywords/theme[themekt = 'ISO 19115 Topic Category']/themekey">
          <mri:topicCategory><mri:MD_TopicCategoryCode><xsl:value-of select="." /></mri:MD_TopicCategoryCode></mri:topicCategory>
        </xsl:for-each>

        <!-- Temporal extent -->
        <xsl:apply-templates select="timeperd/timeinfo/*" />

        <!-- Bounding box -->
        <xsl:for-each select="spdom/bounding">
          <xsl:apply-templates select="." />
        </xsl:for-each>


        <!-- TODO: Check is match status/update field? -->
        <mri:resourceMaintenance>
          <mmi:MD_MaintenanceInformation>
            <mmi:maintenanceAndUpdateFrequency>
              <mmi:MD_MaintenanceFrequencyCode codeListValue=""
                                               codeList="./resources/codeList.xml#MD_MaintenanceFrequencyCode"/>
            </mmi:maintenanceAndUpdateFrequency>
          </mmi:MD_MaintenanceInformation>
        </mri:resourceMaintenance>

        <!-- Keywords -->
        <xsl:for-each select="keywords">
            <xsl:for-each select="theme[not(themekt = 'ISO 19115 Topic Category')]">
              <mri:descriptiveKeywords>
                <mri:MD_Keywords>
                  <xsl:for-each select="themekey">
                    <mri:keyword><xsl:apply-templates select="."/></mri:keyword>
                  </xsl:for-each>

                  <mri:type>
                    <mri:MD_KeywordTypeCode codeListValue="theme"
                                            codeList="./resources/codeList.xml#MD_KeywordTypeCode"/>
                  </mri:type>

                  <mri:thesaurusName>
                    <cit:CI_Citation>
                      <cit:title>
                        <gco:CharacterString><xsl:value-of select="themekt" /></gco:CharacterString>
                      </cit:title>
                    </cit:CI_Citation>
                  </mri:thesaurusName>
                </mri:MD_Keywords>
              </mri:descriptiveKeywords>

            </xsl:for-each>

            <xsl:for-each select="place">
              <mri:descriptiveKeywords>
                <mri:MD_Keywords>
                  <xsl:for-each select="placekey">
                    <mri:keyword><xsl:apply-templates select="."/></mri:keyword>
                  </xsl:for-each>

                  <mri:type>
                    <mri:MD_KeywordTypeCode codeListValue="place"
                                            codeList="./resources/codeList.xml#MD_KeywordTypeCode"/>
                  </mri:type>

                  <mri:thesaurusName>
                    <cit:CI_Citation>
                      <cit:title>
                        <gco:CharacterString><xsl:value-of select="placekt" /></gco:CharacterString>
                      </cit:title>
                    </cit:CI_Citation>
                  </mri:thesaurusName>
                </mri:MD_Keywords>
              </mri:descriptiveKeywords>

            </xsl:for-each>

        </xsl:for-each>

        <!-- Resource constraints -->
        <mri:resourceConstraints>
          <mco:MD_LegalConstraints>
            <!-- TODO: Check if accconst can be match to codelist values -->
            <!--<mco:accessConstraints>
              <mco:MD_RestrictionCode codeListValue="copyright"
                                      codeList="./resources/codeList.xml#MD_RestrictionCode"/>
            </mco:accessConstraints>-->
            <mco:useConstraints>
              <mco:MD_RestrictionCode codeListValue="otherRestictions"
                                      codeList="./resources/codeList.xml#MD_RestrictionCode"/>
            </mco:useConstraints>
            <mco:otherConstraints>
              <gco:CharacterString><xsl:value-of select="useconst" /></gco:CharacterString>
            </mco:otherConstraints>
          </mco:MD_LegalConstraints>
        </mri:resourceConstraints>

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

        <!-- Supplemental info -->
        <xsl:apply-templates select="descript/supplinf" />

      </mri:MD_DataIdentification>
    </mdb:identificationInfo>
  </xsl:template>


  <xsl:template match="distinfo">
    <mdb:distributionInfo>
      <mrd:MD_Distribution>
        <!-- Distribution formats -->
        <xsl:for-each select="stdorder/digform/digtinfo">
          <xsl:if test="formname">
            <mrd:distributionFormat>
              <mrd:MD_Format>

                <mrd:formatSpecificationCitation>
                  <cit:CI_Citation>
                    <cit:title>
                      <gco:CharacterString><xsl:value-of select="formname" /></gco:CharacterString>
                    </cit:title>
                    <cit:date gco:nilReason="unknown"/>
                    <cit:edition>
                      <gco:CharacterString><xsl:value-of select="formvern" /></gco:CharacterString>
                    </cit:edition>
                    <cit:identifier>
                      <mcc:MD_Identifier>
                        <mcc:code>
                          <gco:CharacterString><xsl:value-of select="formname" /></gco:CharacterString>
                        </mcc:code>
                      </mcc:MD_Identifier>
                    </cit:identifier>
                  </cit:CI_Citation>
                </mrd:formatSpecificationCitation>
              </mrd:MD_Format>
            </mrd:distributionFormat>

          </xsl:if>
        </xsl:for-each>

        <!-- Distributor -->
        <mrd:distributor>
          <mrd:MD_Distributor>
            <!-- Distributor contact -->
            <xsl:apply-templates select="distrib" />

            <!-- Distribution order process -->
            <mrd:distributionOrderProcess>
              <mrd:MD_StandardOrderProcess>
                <mrd:fees>
                  <gco:CharacterString><xsl:value-of select="stdorder/fees" /></gco:CharacterString>
                </mrd:fees>
                <mrd:orderingInstructions>
                  <gco:CharacterString><xsl:value-of select="stdorder/ordering" /></gco:CharacterString>
                </mrd:orderingInstructions>
              </mrd:MD_StandardOrderProcess>
            </mrd:distributionOrderProcess>

          </mrd:MD_Distributor>
        </mrd:distributor>

        <!-- Distribution transfer options -->
        <mrd:transferOptions>
          <mrd:MD_DigitalTransferOptions>
            <xsl:if test="stdorder/digform/digtinfo/transize">
            <mrd:transferSize>
              <gco:Real><xsl:value-of select="stdorder/digform/digtinfo/transize" /></gco:Real>
            </mrd:transferSize>
            </xsl:if>

            <xsl:if test="stdorder/digform/digtopt/onlinopt/computer/networka">
                <xsl:for-each select="stdorder/digform/digtopt/onlinopt/computer/networka/networkr">
                  <mrd:onLine>
                    <cit:CI_OnlineResource>
                      <cit:linkage>
                        <gco:CharacterString><xsl:value-of select="." /></gco:CharacterString>
                      </cit:linkage>
                    </cit:CI_OnlineResource>
                  </mrd:onLine>
                </xsl:for-each>
            </xsl:if>

          </mrd:MD_DigitalTransferOptions>
        </mrd:transferOptions>


      </mrd:MD_Distribution>
    </mdb:distributionInfo>
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
              <gco:Date>
                <xsl:call-template name="format-date">
                  <xsl:with-param name="dateval" select="citeinfo/pubdate" />
                  <xsl:with-param name="format" select="'date'" />
                </xsl:call-template>
              </gco:Date>
            </cit:date>
            <cit:dateType>
              <cit:CI_DateTypeCode codeList="codeListLocation#CI_DateTypeCode" codeListValue="publication"/>
            </cit:dateType>
          </cit:CI_Date>
        </cit:date>

        <cit:edition>
          <gco:CharacterString><xsl:value-of select="citeinfo/edition"/></gco:CharacterString>
        </cit:edition>
        <cit:presentationForm>
          <xsl:apply-templates select="citeinfo/geoform" />
        </cit:presentationForm>
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


  <xsl:template match="geoform">
    <cit:CI_PresentationFormCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_PresentationFormCode">
      <xsl:if test=".='vector digital data'">
        <xsl:attribute name="codeListValue">
          <xsl:text>digitalMap</xsl:text>
        </xsl:attribute>
      </xsl:if>
    </cit:CI_PresentationFormCode>
  </xsl:template>


  <xsl:template match="eainfo">
    <xsl:if test="detailed">
    <mdb:contentInfo>
      <mrc:MD_FeatureCatalogue>
        <mrc:featureCatalogue>
          <gfc:FC_FeatureCatalogue xmlns:gfc="http://www.isotc211.org/namespace/gfc/1.1/2014-07-11">
            <gfc:producer>
              <cit:CI_Responsibility>
                <cit:role>
                  <cit:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode"
                                   codeListValue=""/>
                </cit:role>
              </cit:CI_Responsibility>
            </gfc:producer>
            <gfc:featureType>
              <gfc:FC_FeatureType>

                <gfc:typeName>
                  <gco:LocalName><xsl:value-of select="detailed/enttyp/enttypl" /></gco:LocalName>
                </gfc:typeName>
                <gfc:definition>
                  <gco:CharacterString><xsl:value-of select="detailed/enttyp/enttypl" /></gco:CharacterString>
                </gfc:definition>
                <gfc:isAbstract>
                  <gco:Boolean/>
                </gfc:isAbstract>

                <!-- ADD FOR EACH ATTRIBUTE A SECTION LIKE THIS, REPLACING THE NAME AND TYPE -->
                <xsl:for-each select="detailed/attr">
                  <gfc:carrierOfCharacteristics>
                    <gfc:FC_FeatureAttribute>
                      <gfc:featureType>
                        <gfc:FC_FeatureType>
                          <gfc:typeName/>
                          <gfc:definition>
                            <gco:CharacterString><xsl:value-of select="attrdef" /></gco:CharacterString>
                          </gfc:definition>
                          <gfc:isAbstract>
                            <gco:Boolean>false</gco:Boolean>
                          </gfc:isAbstract>
                          <gfc:featureCatalogue/>
                        </gfc:FC_FeatureType>
                      </gfc:featureType>
                      <gfc:constrainedBy>
                        <gfc:FC_Constraint>
                          <gfc:description gco:nilReason="missing">
                            <gco:CharacterString/>
                          </gfc:description>
                        </gfc:FC_Constraint>
                      </gfc:constrainedBy>
                      <gfc:memberName>
                        <gco:LocalName><xsl:value-of select="attrlabl" /></gco:LocalName>
                      </gfc:memberName>
                      <gfc:cardinality gco:nilReason="missing">
                        <gco:CharacterString/>
                      </gfc:cardinality>
                      <gfc:valueType>
                        <gco:TypeName>
                          <gco:aName>
                            <gco:CharacterString><xsl:value-of select="attrtype" /></gco:CharacterString>
                          </gco:aName>
                        </gco:TypeName>
                      </gfc:valueType>
                      <gfc:listedValue/>
                    </gfc:FC_FeatureAttribute>
                  </gfc:carrierOfCharacteristics>
                </xsl:for-each>


                <gfc:featureCatalogue/>
              </gfc:FC_FeatureType>
            </gfc:featureType>
          </gfc:FC_FeatureCatalogue>
        </mrc:featureCatalogue>
      </mrc:MD_FeatureCatalogue>
    </mdb:contentInfo>
    </xsl:if>
  </xsl:template>


  <xsl:template match="rngdates">
      <mri:extent>
        <gex:EX_Extent>
          <gex:temporalElement>
            <gex:EX_TemporalExtent>
              <gex:extent>
                <gml:TimePeriod>
                  <gml:beginPosition>
                    <xsl:call-template name="format-date">
                      <xsl:with-param name="dateval" select="begdate" />
                      <xsl:with-param name="format" select="'date'" />
                    </xsl:call-template>
                  </gml:beginPosition>
                  <gml:endPosition>
                    <xsl:call-template name="format-date">
                      <xsl:with-param name="dateval" select="enddate" />
                      <xsl:with-param name="format" select="'date'" />
                    </xsl:call-template>
                  </gml:endPosition>
                </gml:TimePeriod>
              </gex:extent>
            </gex:EX_TemporalExtent>
          </gex:temporalElement>
        </gex:EX_Extent>
      </mri:extent>
  </xsl:template>

  <xsl:template match="sngdate">
    <mri:extent>
      <gex:EX_Extent>
        <gex:temporalElement>
          <gex:EX_TemporalExtent>
            <gex:extent>
              <gml:TimeInstant>
                <gml:timePosition>
                  <xsl:call-template name="format-date">
                    <xsl:with-param name="dateval" select="caldate" />
                    <xsl:with-param name="format" select="'date'" />
                  </xsl:call-template>
                </gml:timePosition>
              </gml:TimeInstant>
            </gex:extent>
          </gex:EX_TemporalExtent>
        </gex:temporalElement>
      </gex:EX_Extent>
    </mri:extent>
  </xsl:template>


  <xsl:template match="ptcontac">
    <mri:pointOfContact>
      <cit:CI_Responsibility>
        <cit:role>
          <cit:CI_RoleCode codeList="codeListLocation#CI_RoleCode" codeListValue="pointOfContact">pointOfContact</cit:CI_RoleCode>
        </cit:role>

        <xsl:apply-templates select="cntinfo" />
      </cit:CI_Responsibility>
    </mri:pointOfContact>
  </xsl:template>


  <xsl:template match="distrib">
    <mrd:distributorContact>
      <cit:CI_Responsibility>
        <cit:role>
          <cit:CI_RoleCode codeList="codeListLocation#CI_RoleCode" codeListValue="distributor">distributor</cit:CI_RoleCode>
        </cit:role>

        <xsl:apply-templates select="cntinfo" />
      </cit:CI_Responsibility>
    </mrd:distributorContact>
  </xsl:template>

  <xsl:template match="metc">
    <mdb:contact>
      <cit:CI_Responsibility>
        <cit:role>
          <cit:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode"
                           codeListValue="pointOfContact"/>
        </cit:role>

        <xsl:apply-templates select="cntinfo" />
      </cit:CI_Responsibility>
    </mdb:contact>
  </xsl:template>

  <xsl:template match="dataqual">
    <!-- Lineage -->
    <mdb:resourceLineage>
      <mrl:LI_Lineage>
        <xsl:for-each select="lineage/procstep">
          <mrl:processStep>
            <mrl:LI_ProcessStep>
              <mrl:description>
                <gco:CharacterString><xsl:value-of select="procdesc" /></gco:CharacterString>
              </mrl:description>
              <mrl:stepDateTime>
                <gml:TimeInstant>
                  <xsl:attribute name="gml:id">
                    <xsl:value-of select="generate-id()"/>
                  </xsl:attribute>

                  <gml:timePosition>
                    <xsl:call-template name="format-date">
                      <xsl:with-param name="dateval" select="procdate" />
                      <xsl:with-param name="format" select="'date'" />
                    </xsl:call-template>
                  </gml:timePosition>
                </gml:TimeInstant>
              </mrl:stepDateTime>

              <xsl:apply-templates select="proccont" />

              <mrl:scope/>
            </mrl:LI_ProcessStep>
          </mrl:processStep>
        </xsl:for-each>
      </mrl:LI_Lineage>

    </mdb:resourceLineage>
  </xsl:template>


  <xsl:template match="proccont">
    <mrl:processor>
      <cit:CI_Responsibility>
        <cit:role>
          <cit:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode"
                           codeListValue="processor"/>
        </cit:role>

        <xsl:apply-templates select="cntinfo" />
      </cit:CI_Responsibility>
    </mrl:processor>
  </xsl:template>


  <xsl:template match="cntinfo">
    <cit:party>
      <cit:CI_Organisation>
        <cit:name>
          <gco:CharacterString><xsl:value-of select="cntorgp/cntorg" /></gco:CharacterString>
        </cit:name>
        <cit:contactInfo>
          <cit:CI_Contact>
            <xsl:if test="cntvoice">
              <cit:phone>
                <cit:CI_Telephone>
                  <cit:number>
                    <gco:CharacterString><xsl:value-of select="cntvoice" /></gco:CharacterString>
                  </cit:number>
                  <cit:numberType>
                    <cit:CI_TelephoneTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_TelephoneTypeCode"
                                              codeListValue="voice"/>
                  </cit:numberType>
                </cit:CI_Telephone>
              </cit:phone>
            </xsl:if>

            <xsl:if test="cntfax">
            <cit:phone>
              <cit:CI_Telephone>
                <cit:number>
                  <gco:CharacterString><xsl:value-of select="cntfax" /></gco:CharacterString>
                </cit:number>
                <cit:numberType>
                  <cit:CI_TelephoneTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_TelephoneTypeCode"
                                            codeListValue="facsimilie"/>
                </cit:numberType>
              </cit:CI_Telephone>
            </cit:phone>
            </xsl:if>

            <cit:address>
              <cit:CI_Address>
                <cit:deliveryPoint>
                  <gco:CharacterString><xsl:value-of select="cntaddr/address" /></gco:CharacterString>
                </cit:deliveryPoint>
                <cit:city>
                  <gco:CharacterString><xsl:value-of select="cntaddr/city" /></gco:CharacterString>
                </cit:city>
                <cit:administrativeArea>
                  <gco:CharacterString><xsl:value-of select="cntaddr/state" /></gco:CharacterString>
                </cit:administrativeArea>
                <cit:postalCode>
                  <gco:CharacterString><xsl:value-of select="cntaddr/postal" /></gco:CharacterString>
                </cit:postalCode>
                <cit:country>
                  <gco:CharacterString><xsl:value-of select="cntaddr/country" /></gco:CharacterString>
                </cit:country>
                <cit:electronicMailAddress>
                  <gco:CharacterString><xsl:value-of select="cntemail" /></gco:CharacterString>
                </cit:electronicMailAddress>
              </cit:CI_Address>
            </cit:address>
            <cit:hoursOfService>
              <gco:CharacterString><xsl:value-of select="hours" /></gco:CharacterString>
            </cit:hoursOfService>
            <cit:contactInstructions>
              <gco:CharacterString><xsl:value-of select="cntinst" /></gco:CharacterString>
            </cit:contactInstructions>
          </cit:CI_Contact>
        </cit:contactInfo>
        <cit:contactInfo/>
        <cit:individual>
          <cit:CI_Individual>
            <cit:name>
              <gco:CharacterString><xsl:value-of select="cntper" /></gco:CharacterString>
            </cit:name>
            <cit:positionName>
              <gco:CharacterString><xsl:value-of select="cntpos" /></gco:CharacterString>
            </cit:positionName>
          </cit:CI_Individual>
        </cit:individual>
      </cit:CI_Organisation>
    </cit:party>
  </xsl:template>

  <xsl:template match="supplinf">
    <mri:supplementalInformation>
      <gco:CharacterString><xsl:value-of select="." /></gco:CharacterString>
    </mri:supplementalInformation>
  </xsl:template>

  <!-- TODO: Review formats -->
  <xsl:template name="format-date">
    <xsl:param name="dateval" />
    <xsl:param name="format" select="'date'"/>

    <xsl:choose>
      <xsl:when test="string-length($dateval) = 8">
        <xsl:value-of select="concat(substring($dateval, 1, 4), '-', substring($dateval, 5, 2), '-', substring($dateval, 7, 2))" /><xsl:if test="$format = 'datetime'">T00:00:00</xsl:if>
        </xsl:when>
      <xsl:otherwise><xsl:value-of select="$dateval" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>