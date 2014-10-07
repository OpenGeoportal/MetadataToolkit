<xsl:stylesheet version="2.0" 
    xmlns:mds="http://www.isotc211.org/namespace/mds/1.0/2014-07-11"
    xmlns:srv="http://www.isotc211.org/namespace/srv/2.0/2014-07-11"
    xmlns:gex="http://www.isotc211.org/namespace/gex/1.0/2014-07-11"
    xmlns:lan="http://www.isotc211.org/namespace/lan/1.0/2014-07-11"
    xmlns:cit="http://www.isotc211.org/namespace/cit/1.0/2014-07-11"
    xmlns:mri="http://www.isotc211.org/namespace/mri/1.0/2014-07-11"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:java="java:org.fao.geonet.util.XslUtil"
    xmlns:joda="java:org.fao.geonet.util.JODAISODate"
    xmlns:mime="java:org.fao.geonet.util.MimeTypeFinder"
    exclude-result-prefixes="#all">
    
    <!-- ========================================================================================= -->
    <!-- latlon coordinates indexed as numeric. -->
    
    <xsl:template match="*" mode="latLon19115-1-2013">
        <xsl:variable name="format" select="'##.00'"></xsl:variable>
        
        <xsl:if test="number(gex:westBoundLongitude/gco:Decimal)
            and number(gex:southBoundLatitude/gco:Decimal)
            and number(gex:eastBoundLongitude/gco:Decimal)
            and number(gex:northBoundLatitude/gco:Decimal)
            ">
            <Field name="westBL" string="{format-number(gex:westBoundLongitude/gco:Decimal, $format)}" store="false" index="true"/>
            <Field name="southBL" string="{format-number(gex:southBoundLatitude/gco:Decimal, $format)}" store="false" index="true"/>
            
            <Field name="eastBL" string="{format-number(gex:eastBoundLongitude/gco:Decimal, $format)}" store="false" index="true"/>
            <Field name="northBL" string="{format-number(gex:northBoundLatitude/gco:Decimal, $format)}" store="false" index="true"/>
            
            <Field name="geoBox" string="{concat(gex:westBoundLongitude/gco:Decimal, '|', 
                gex:southBoundLatitude/gco:Decimal, '|', 
                gex:eastBoundLongitude/gco:Decimal, '|', 
                gex:northBoundLatitude/gco:Decimal
                )}" store="true" index="false"/>
        </xsl:if>
        
    </xsl:template>
	<!-- ================================================================== -->

  <!-- ================================================================== -->
  <!-- iso3code of default index language -->
    
    <xsl:template name="langId19115-1-2013">
        <xsl:variable name="tmp">
            <xsl:choose>
                <xsl:when test="/*[name(.)='mds:MD_Metadata' or @gco:isoType='mds:MD_Metadata']/mds:defaultLocale/lan:PT_Locale/lan:language/lan:LanguageCode/@codeListValue">
                    <xsl:value-of select="/*[name(.)='mds:MD_Metadata' or @gco:isoType='mds:MD_Metadata']/mds:defaultLocale/lan:PT_Locale/lan:language/lan:LanguageCode/@codeListValue"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$defaultLang"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="normalize-space(string($tmp))"></xsl:value-of>
    </xsl:template>


    <xsl:template name="defaultTitle19115-1-2013">
        <xsl:param name="isoDocLangId"/>
        
        <xsl:variable name="poundLangId" select="concat('#',upper-case(java:twoCharLangCode($isoDocLangId)))" />

        <xsl:variable name="identification" select="/*[name(.)='mds:MD_Metadata' or @gco:isoType='mds:MD_Metadata']/mds:identificationInfo/*"></xsl:variable>
        <xsl:variable name="docLangTitle" select="$identification/mri:citation/*/cit:title//lan:LocalisedCharacterString[@locale=$poundLangId]"/>
        <xsl:variable name="charStringTitle" select="$identification/mri:citation/*/cit:title/gco:CharacterString"/>
        <xsl:variable name="locStringTitles" select="$identification/mri:citation/*/cit:title//lan:LocalisedCharacterString"/>
        <xsl:choose>
        <xsl:when    test="string-length(string($docLangTitle)) != 0">
            <xsl:value-of select="$docLangTitle[1]"/>
        </xsl:when>
        <xsl:when    test="string-length(string($charStringTitle[1])) != 0">
            <xsl:value-of select="string($charStringTitle[1])"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="string($locStringTitles[1])"/>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ================================================================== -->

</xsl:stylesheet>
