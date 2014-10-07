<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:srv="http://www.isotc211.org/namespace/srv/2.0/2014-07-11"
  xmlns:mdb="http://www.isotc211.org/namespace/mdb/1.0/2014-07-11"
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
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon"
  exclude-result-prefixes="#all">
  
  <xsl:include href="layout.xsl"/>

  <!-- 
    Load the schema configuration for the editor.
    Same configuration as ISO19139 here.
      -->
  <xsl:template name="get-iso19115-3-configuration">
    <xsl:copy-of select="document('config-editor.xml')"/>
  </xsl:template>


  <!-- Dispatch to the current profile mode -->
  <xsl:template name="dispatch-iso19115-3">
    <xsl:param name="base" as="node()"/>
    <xsl:apply-templates mode="mode-iso19115-3" select="$base"/>
  </xsl:template>


  <!-- The following templates usually delegates all to iso19139. -->
  <xsl:template name="evaluate-iso19115-3">
    <xsl:param name="base" as="node()"/>
    <xsl:param name="in"/>
    <!-- <xsl:message>in xml <xsl:copy-of select="$base"></xsl:copy-of></xsl:message>
     <xsl:message>search for <xsl:copy-of select="$in"></xsl:copy-of></xsl:message>-->
    <xsl:variable name="nodeOrAttribute" select="saxon:evaluate(concat('$p1', $in), $base)"/>
    <xsl:choose>
      <xsl:when test="$nodeOrAttribute/*">
        <xsl:copy-of select="$nodeOrAttribute"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nodeOrAttribute"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Evaluate XPath returning a boolean value. -->
  <xsl:template name="evaluate-iso19115-3-boolean">
    <xsl:param name="base" as="node()"/>
    <xsl:param name="in"/>

    <xsl:value-of select="saxon:evaluate(concat('$p1', $in), $base)"/>
  </xsl:template>


</xsl:stylesheet>
