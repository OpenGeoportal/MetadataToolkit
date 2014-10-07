<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:srv="http://www.isotc211.org/namespace/srv/2.0/2014-07-11"
                xmlns:mds="http://www.isotc211.org/namespace/mds/1.0/2014-07-11"
                xmlns:mcc="http://www.isotc211.org/namespace/mcc/1.0/2014-07-11"
                xmlns:mri="http://www.isotc211.org/namespace/mri/1.0/2014-07-11"
                xmlns:mrs="http://www.isotc211.org/namespace/mrs/1.0/2014-07-11"
                xmlns:mrd="http://www.isotc211.org/namespace/mrd/1.0/2014-07-11"
                xmlns:mco="http://www.isotc211.org/namespace/mco/1.0/2014-07-11"
                xmlns:msr="http://www.isotc211.org/namespace/msr/1.0/2014-07-11"
                xmlns:lan="http://www.isotc211.org/namespace/lan/1.0/2014-07-11"
                xmlns:gcx="http://www.isotc211.org/namespace/gcx/1.0/2014-07-11"
                xmlns:gex="http://www.isotc211.org/namespace/gex/1.0/2014-07-11"
                xmlns:dqm="http://www.isotc211.org/namespace/dqm/1.0/2014-07-11"
                xmlns:cit="http://www.isotc211.org/namespace/cit/1.0/2014-07-11"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="#all">
  <xsl:import href="metadata-view.xsl"/>

  <xsl:template name="iso19115-3CompleteTab"/>

  <!-- main template - the way into processing iso19139 -->
  <xsl:template name="metadata-iso19115-3">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>

    <xsl:apply-templates mode="iso19115-3" select="." >
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
      <xsl:with-param name="embedded" select="$embedded" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="iso19115-3GetIsoLanguage" mode="iso19115-3GetIsoLanguage" match="*">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
    <xsl:param name="value"/>
    <xsl:param name="ref"/>

    <xsl:variable name="lang" select="/root/gui/language"/>

    <xsl:choose>
      <xsl:when test="$edit=true()">
        <select class="md" name="{$ref}" size="1">
          <option name=""/>

          <xsl:for-each select="/root/gui/isoLang/record">
            <xsl:sort select="label/child::*[name() = $lang]"/>
            <option value="{code}">
              <xsl:if test="code = $value">
                <xsl:attribute name="selected"/>
              </xsl:if>
              <xsl:value-of select="label/child::*[name() = $lang]"/>
            </option>
          </xsl:for-each>
        </select>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="/root/gui/isoLang/record[code=$value]/label/child::*[name() = $lang]"/>

        <!-- In view mode display other languages from gmd:locale of gmd:MD_Metadata element
        FIXME
        <xsl:if test="../gmd:locale or ../../gmd:locale">
          <xsl:text> (</xsl:text><xsl:value-of
            select="string(/root/gui/schemas/iso19139/labels/element[@name='gmd:locale' and not(@context)]/label)"/>
          <xsl:text>:</xsl:text>
          <xsl:for-each select="../gmd:locale|../../gmd:locale">
            <xsl:variable name="c" select="gmd:PT_Locale/gmd:languageCode/gmd:LanguageCode/@codeListValue"/>
            <xsl:value-of select="/root/gui/isoLang/record[code=$c]/label/child::*[name() = $lang]"/>
            <xsl:if test="position()!=last()">,</xsl:if>
          </xsl:for-each>
          <xsl:text>)</xsl:text>
        </xsl:if>-->

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>