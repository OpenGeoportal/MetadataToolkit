<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mdb="http://standards.iso.org/19115/-3/mdb/1.0/2014-12-25"
  xmlns:lan="http://standards.iso.org/19115/-3/lan/1.0/2014-12-25"
  xmlns:gco="http://standards.iso.org/19139/gco/1.0/2014-12-25"
  exclude-result-prefixes="#all">

  <!-- Get the main metadata languages -->
  <xsl:template name="get-iso19115-3-language">
    <xsl:value-of select="$metadata/mdb:defaultLocale/
    lan:PT_Locale/lan:language/lan:LanguageCode/@codeListValue"/>
  </xsl:template>

  <!-- Get the list of other languages in JSON -->
  <xsl:template name="get-iso19115-3-other-languages-as-json">
    <xsl:variable name="langs">
      <xsl:for-each select="$metadata/mdb:otherLocale/lan:PT_Locale">
        <lang><xsl:value-of select="concat('&quot;', lan:language/lan:LanguageCode/@codeListValue, '&quot;:&quot;#', @id, '&quot;')"/></lang>
      </xsl:for-each>
    </xsl:variable>
    <xsl:text>{</xsl:text><xsl:value-of select="string-join($langs/lang, ',')"/><xsl:text>}</xsl:text>
  </xsl:template>

  <!-- Get the list of other languages -->
  <xsl:template name="get-iso19115-3-other-languages">
    <xsl:for-each select="$metadata/mdb:otherLocale/lan:PT_Locale">
      <lang id="{@id}" code="{lan:language/lan:languageCode/lan:LanguageCode/@codeListValue}"/>
    </xsl:for-each>
  </xsl:template>


  <!-- Template used to return a gco:CharacterString element
        in default metadata language or in a specific locale
        if exist.
        FIXME : lan:PT_FreeText should not be in the match clause as gco:CharacterString
        is mandatory and PT_FreeText optional. Added for testing GM03 import.
    -->
  <xsl:template mode="localised" match="*[lan:PT_FreeText]">
    <xsl:param name="langId"/>

    <xsl:choose>
      <xsl:when
          test="lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale=$langId] and
          lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale=$langId] != ''">
        <xsl:value-of
            select="lan:PT_FreeText/lan:textGroup/lan:LocalisedCharacterString[@locale=$langId]"/>
      </xsl:when>
      <xsl:when test="not(gco:CharacterString)">
        <!-- If no CharacterString, try to use the first textGroup available -->
        <xsl:value-of
            select="lan:PT_FreeText/lan:textGroup[position()=1]/lan:LocalisedCharacterString"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="gco:CharacterString"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
