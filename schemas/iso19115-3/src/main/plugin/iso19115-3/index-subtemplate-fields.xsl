<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
                xmlns:cit="http://www.isotc211.org/namespace/cit/1.0/2014-07-11"
                xmlns:dqm="http://www.isotc211.org/namespace/dqm/1.0/2014-07-11"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:lan="http://www.isotc211.org/namespace/lan/1.0/2014-07-11"
                xmlns:mcc="http://www.isotc211.org/namespace/mcc/1.0/2014-07-11"
                xmlns:mrc="http://www.isotc211.org/namespace/mrc/1.0/2014-07-11"
                xmlns:mco="http://www.isotc211.org/namespace/mco/1.0/2014-07-11"
                xmlns:mdb="http://www.isotc211.org/namespace/mdb/1.0/2014-07-11"
                xmlns:mri="http://www.isotc211.org/namespace/mri/1.0/2014-07-11"
                xmlns:mrs="http://www.isotc211.org/namespace/mrs/1.0/2014-07-11"
                xmlns:mrl="http://www.isotc211.org/namespace/mrl/1.0/2014-07-11"
                xmlns:mrd="http://www.isotc211.org/namespace/mrd/1.0/2014-07-11"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:srv="http://www.isotc211.org/namespace/srv/2.0/2014-07-11"
                xmlns:gcx="http://www.isotc211.org/namespace/gcx/1.0/2014-07-11"
                xmlns:gex="http://www.isotc211.org/namespace/gex/1.0/2014-07-11"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#">

  <!-- Subtemplate indexing

  Add the [count(ancestor::node()) =  1] to only match element at the root of the document.
  This is the method to identify a subtemplate.
  -->
  <xsl:template mode="index" match="cit:CI_Responsibility[count(ancestor::node()) =  1]">
    <Field name="_title"
           string="{normalize-space(cit:party/cit:CI_Organisation/cit:name/gco:CharacterString)}:
      {string-join(.//cit:individual/cit:CI_Individual/cit:name/gco:CharacterString, ', ')}"
           store="true" index="true"/>
    <xsl:call-template name="subtemplate-common-fields"/>
  </xsl:template>

  <xsl:template name="subtemplate-common-fields">
    <Field name="any" string="{normalize-space(string(.))}" store="false" index="true"/>
    <Field name="_root" string="{name(.)}" store="true" index="true"/>
  </xsl:template>

</xsl:stylesheet>