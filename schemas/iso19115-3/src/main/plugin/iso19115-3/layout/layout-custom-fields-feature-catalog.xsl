<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mdb="http://standards.iso.org/19115/-3/mdb/1.0"
                xmlns:mcc="http://standards.iso.org/19115/-3/mcc/1.0"
                xmlns:mri="http://standards.iso.org/19115/-3/mri/1.0"
                xmlns:cit="http://standards.iso.org/19115/-3/cit/1.0"
                xmlns:gex="http://standards.iso.org/19115/-3/gex/1.0"
                xmlns:gfc="http://standards.iso.org/19110/gfc/1.1"
                xmlns:mrc="http://standards.iso.org/19115/-3/mrc/1.0"
                xmlns:gco="http://standards.iso.org/19115/-3/gco/1.0"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                exclude-result-prefixes="#all">

  <!-- Custom rendering of feature catalog section   -->
  
  
  <xsl:template mode="mode-iso19115-3" priority="2000" match="mrc:featureCatalogue">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>

    <xsl:choose>
        <xsl:when test="starts-with(string($tab), 'tufts') or string($tab) = 'featureCatalogTab'">
	        <xsl:call-template name="render-boxed-element">
		      <xsl:with-param name="label"
		        select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
		      <xsl:with-param name="editInfo" select="gn:element"/>
		      <xsl:with-param name="cls" select="local-name()"/>
		      <xsl:with-param name="xpath" select="$xpath"/>
		      <xsl:with-param name="subTreeSnippet">
		        <xsl:apply-templates mode="mode-tufts" select="gfc:FC_FeatureCatalogue">
		          <xsl:with-param name="schema" select="$schema"/>
		          <xsl:with-param name="labels" select="$labels"/>
		        </xsl:apply-templates>
		      </xsl:with-param>
	        </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
	        <xsl:call-template name="render-boxed-element">
	              <xsl:with-param name="label"
	                select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
	              <xsl:with-param name="editInfo" select="gn:element"/>
	              <xsl:with-param name="cls" select="local-name()"/>
	              <xsl:with-param name="xpath" select="$xpath"/>
	              <xsl:with-param name="subTreeSnippet">
	                <xsl:apply-templates mode="mode-iso19115-3" select="*">
	                  <xsl:with-param name="schema" select="$schema"/>
	                  <xsl:with-param name="labels" select="$labels"/>
	                </xsl:apply-templates>
	              </xsl:with-param>
	        </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>

    
  </xsl:template>

  <xsl:template mode="mode-tufts" match="gfc:FC_FeatureCatalogue" priority="2000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    
    <xsl:apply-templates mode="mode-iso19115-3" select="gfc:definitionSource">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="labels" select="$labels"/>
    </xsl:apply-templates>
    
     <xsl:if test="$isEditing and not(gfc:definitionSource)">
         <xsl:for-each select="geonet:child[@name='definitionSource']">
         
           <xsl:variable name="name" select="concat(@prefix, ':', @name)"/>
           <xsl:variable name="directive" select="gn-fn-metadata:getFieldAddDirective($editorConfig, $name)"/>
      
           <xsl:call-template name="render-element-to-add">
             <!-- TODO: add xpath and isoType to get label ? -->
             <xsl:with-param name="label"
                             select="gn-fn-metadata:getLabel($schema, $name, $labels, name(..), '', '')/label"/>
             <xsl:with-param name="directive" select="$directive"/>
             <xsl:with-param name="childEditInfo" select="."/>
             <xsl:with-param name="parentEditInfo" select="../gn:element"/>
           <xsl:with-param name="isFirst" select="count(preceding-sibling::*[name() = $name]) = 0"/>
           </xsl:call-template>
         </xsl:for-each>
     </xsl:if>
     
    <xsl:apply-templates mode="mode-tufts" select="gfc:featureType">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="labels" select="$labels"/>
    </xsl:apply-templates>
    
    
     <xsl:if test="$isEditing">
         <xsl:for-each select="geonet:child[@name='featureType']">
         
           <xsl:variable name="name" select="concat(@prefix, ':', @name)"/>
           <xsl:variable name="directive" select="gn-fn-metadata:getFieldAddDirective($editorConfig, $name)"/>
      
           <xsl:call-template name="render-element-to-add">
             <!-- TODO: add xpath and isoType to get label ? -->
             <xsl:with-param name="label"
                             select="gn-fn-metadata:getLabel($schema, $name, $labels, name(..), '', '')/label"/>
             <xsl:with-param name="directive" select="$directive"/>
             <xsl:with-param name="childEditInfo" select="."/>
             <xsl:with-param name="parentEditInfo" select="../gn:element"/>
           <xsl:with-param name="isFirst" select="count(preceding-sibling::*[name() = $name]) = 0"/>
           <!-- Display only the 5th choice: Attribute -->
           <xsl:with-param name="choicePosition" select="2"/>
           </xsl:call-template>
         </xsl:for-each>
     </xsl:if>
     
   </xsl:template>
    
  <xsl:template mode="mode-tufts" match="gfc:featureType" priority="2000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    
    <xsl:for-each select="gfc:FC_FeatureType">
    
	    <xsl:apply-templates mode="mode-iso19115-3" select="gfc:typeName">
	          <xsl:with-param name="schema" select="$schema"/>
	          <xsl:with-param name="labels" select="$labels"/>
	    </xsl:apply-templates>
	    
	    <xsl:apply-templates mode="mode-iso19115-3" select="gfc:definition">
	          <xsl:with-param name="schema" select="$schema"/>
	          <xsl:with-param name="labels" select="$labels"/>
	    </xsl:apply-templates>
	    
	     <xsl:if test="$isEditing">
	         <xsl:for-each select="geonet:child[@name='definition']">
	         
	           <xsl:variable name="name" select="concat(@prefix, ':', @name)"/>
	           <xsl:variable name="directive" select="gn-fn-metadata:getFieldAddDirective($editorConfig, $name)"/>
	      
	           <xsl:call-template name="render-element-to-add">
	             <!-- TODO: add xpath and isoType to get label ? -->
	             <xsl:with-param name="label"
	                             select="gn-fn-metadata:getLabel($schema, $name, $labels, name(..), '', '')/label"/>
	             <xsl:with-param name="directive" select="$directive"/>
	             <xsl:with-param name="childEditInfo" select="."/>
	             <xsl:with-param name="parentEditInfo" select="../gn:element"/>
	           <xsl:with-param name="isFirst" select="count(preceding-sibling::*[name() = $name]) = 0"/>
	           </xsl:call-template>
	         </xsl:for-each>
	     </xsl:if>
	    
	    <xsl:for-each select="gfc:carrierOfCharacteristics">

		    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
		    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
            <xsl:call-template name="render-boxed-element">
                  <xsl:with-param name="label"
                    select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
                  <xsl:with-param name="editInfo" select="gn:element"/>
                  <xsl:with-param name="cls" select="local-name()"/>
                  <xsl:with-param name="xpath" select="$xpath"/>
                  <xsl:with-param name="subTreeSnippet">
		            <xsl:apply-templates mode="mode-iso19115-3" select="gfc:FC_FeatureAttribute/gfc:memberName">
		                  <xsl:with-param name="schema" select="$schema"/>
		                  <xsl:with-param name="labels" select="$labels"/>
		            </xsl:apply-templates>
		            <xsl:apply-templates mode="mode-iso19115-3" select="gfc:FC_FeatureAttribute/gfc:featureType/gfc:FC_FeatureType/gfc:definition">
		                  <xsl:with-param name="schema" select="$schema"/>
		                  <xsl:with-param name="labels" select="$labels"/>
		            </xsl:apply-templates> 
                    <xsl:choose>
	                    <xsl:when test="$isEditing and not(gfc:FC_FeatureAttribute/gfc:featureType)">
		                     <xsl:for-each select="gfc:FC_FeatureAttribute/geonet:child[@name='featureType']">

					             <xsl:variable name="name" select="concat(@prefix, ':', @name)"/>
					             <xsl:variable name="directive" select="gn-fn-metadata:getFieldAddDirective($editorConfig, $name)"/>

					             <xsl:call-template name="render-element-to-add">
						               <xsl:with-param name="label"
		                                    select="gn-fn-metadata:getLabel($schema, $name, $labels, name(..), '', '')/label"/>
		                               <xsl:with-param name="directive" select="$directive"/>
						               <xsl:with-param name="childEditInfo" select="."/>
						               <xsl:with-param name="parentEditInfo" select="../gn:element"/>
						               <xsl:with-param name="isFirst" select="count(preceding-sibling::*[name() = $name]) = 0"/>
		    				           <xsl:with-param name="choicePosition" select="2"/>
					             </xsl:call-template>
				           </xsl:for-each>
	                   </xsl:when>
	                   <xsl:when test="$isEditing and not(gfc:FC_FeatureAttribute/gfc:featureType/gfc:FC_FeatureType/gfc:definition)">
	                       <xsl:for-each select="gfc:FC_FeatureAttribute/gfc:featureType/gfc:FC_FeatureType/geonet:child[@name='definition']">

                                 <xsl:variable name="name" select="concat(@prefix, ':', @name)"/>
                                 <xsl:variable name="directive" select="gn-fn-metadata:getFieldAddDirective($editorConfig, $name)"/>

                                 <xsl:call-template name="render-element-to-add">
                                       <xsl:with-param name="label"
                                            select="gn-fn-metadata:getLabel($schema, $name, $labels, name(..), '', '')/label"/>
                                       <xsl:with-param name="directive" select="$directive"/>
                                       <xsl:with-param name="childEditInfo" select="."/>
                                       <xsl:with-param name="parentEditInfo" select="../gn:element"/>
                                       <xsl:with-param name="isFirst" select="count(preceding-sibling::*[name() = $name]) = 0"/>
                                       <xsl:with-param name="choicePosition" select="2"/>
                                 </xsl:call-template>
                           </xsl:for-each>
	                   </xsl:when>
	                   <xsl:otherwise></xsl:otherwise>
                   </xsl:choose>
                  </xsl:with-param>
            </xsl:call-template>

	    </xsl:for-each>

       <xsl:if test="$isEditing">
		   <xsl:for-each select="geonet:child[@name='carrierOfCharacteristics']">
		   
		     <xsl:variable name="name" select="concat(@prefix, ':', @name)"/>
		     <xsl:variable name="directive" select="gn-fn-metadata:getFieldAddDirective($editorConfig, $name)"/>


         <!-- Instead of the default + button with choices, select the choice required (position 5 = Attribute)
              TODO: To improve in render-element-to-add sending an optional choice position parameter, if specified
              instead of displaying the full choice, just the selection
         -->
		     <xsl:call-template name="render-element-to-add">
		       <xsl:with-param name="label"
		                       select="gn-fn-metadata:getLabel($schema, $name, $labels, 'carrierOfCharacteristics', '', '')/label"/>
		       <xsl:with-param name="directive" select="$directive"/>
		       <xsl:with-param name="childEditInfo" select="."/>
		       <xsl:with-param name="parentEditInfo" select="../gn:element"/>
		       <xsl:with-param name="isFirst" select="count(preceding-sibling::*[name() = $name]) = 0"/>
           <!-- Display only the 5th choice: Attribute -->
           <xsl:with-param name="choicePosition" select="5"/>
		     </xsl:call-template>
	       </xsl:for-each>
	   </xsl:if>
	 
    </xsl:for-each>
    
  </xsl:template>

</xsl:stylesheet>
