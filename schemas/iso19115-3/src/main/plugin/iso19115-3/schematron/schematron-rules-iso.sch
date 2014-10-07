<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--

Schematron rules implementing Constraints described in ISO 19115-1:2013 
Chapter 6

Adapted from previous script included in GeoNetwork iso19139 schema 
Simon Pigot, 2013

This work is licensed under the Creative Commons Attribution 2.5 License. 
To view a copy of this license, visit 
    http://creativecommons.org/licenses/by/2.5/au/ 

or send a letter to:

Creative Commons, 
543 Howard Street, 5th Floor, 
San Francisco, California, 94105, 
USA.

-->

	<sch:title xmlns="http://www.w3.org/2001/XMLSchema">Schematron validation for ISO/FDIS 19115-1:2013</sch:title>
	<sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
  <sch:ns prefix="srv" uri="http://www.isotc211.org/namespace/srv/2.0/2013-03-28"/>
  <sch:ns prefix="mds" uri="http://www.isotc211.org/namespace/mds/1.0/2013-03-28"/>
  <sch:ns prefix="mcc" uri="http://www.isotc211.org/namespace/mcc/1.0/2013-03-28"/>
  <sch:ns prefix="mri" uri="http://www.isotc211.org/namespace/mri/1.0/2013-03-28"/>
  <sch:ns prefix="mrs" uri="http://www.isotc211.org/namespace/mrs/1.0/2013-03-28"/>
  <sch:ns prefix="mrd" uri="http://www.isotc211.org/namespace/mrd/1.0/2013-03-28"/>
  <sch:ns prefix="mco" uri="http://www.isotc211.org/namespace/mco/1.0/2013-03-28"/>
  <sch:ns prefix="msr" uri="http://www.isotc211.org/namespace/msr/1.0/2013-03-28"/>
  <sch:ns prefix="mrc" uri="http://www.isotc211.org/namespace/mrc/1.0/2013-03-28"/>
  <sch:ns prefix="mrl" uri="http://www.isotc211.org/namespace/mrl/1.0/2013-03-28"/>
  <sch:ns prefix="lan" uri="http://www.isotc211.org/namespace/lan/1.0/2013-03-28"/>
  <sch:ns prefix="gcx" uri="http://www.isotc211.org/namespace/gcx/1.0/2013-03-28"/>
  <sch:ns prefix="gex" uri="http://www.isotc211.org/namespace/gex/1.0/2013-03-28"/>
  <sch:ns prefix="mex" uri="http://www.isotc211.org/namespace/mex/1.0/2013-03-28"/>
  <sch:ns prefix="dqm" uri="http://www.isotc211.org/namespace/dqm/1.0/2013-03-28"/>
  <sch:ns prefix="cit" uri="http://www.isotc211.org/namespace/cit/1.0/2013-03-28"/>
	<sch:ns prefix="gco" uri="http://www.isotc211.org/2005/gco"/>
	<sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>

	<!-- Test that every CharacterString element has content or it's parent has a
   		 valid nilReason attribute value - this is not necessary for geonetwork 
			 because update-fixed-info.xsl supplies a gco:nilReason of missing for 
			 all gco:CharacterString elements with no content and removes it if the
			 user fills in a value - this is the same for all gco:nilReason tests 
			 used below - the test for gco:nilReason in 'inapplicable....' etc is
			 "mickey mouse" for that reason. -->
	<sch:pattern>
		<sch:title>$loc/strings/M6</sch:title>
		<sch:rule context="*[gco:CharacterString]">
			<sch:report
				test="(normalize-space(gco:CharacterString) = '') and (not(@gco:nilReason) or not(contains('inapplicable missing template unknown withheld',@gco:nilReason)))"
				>$loc/strings/alert.M6.characterString</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern>
		<sch:title>$loc/strings/M7</sch:title>
		<!-- UNVERIFIED -->
		<sch:rule id="CRSLabelsPosType" context="//gml:DirectPositionType">
			<sch:report test="not(@srsDimension) or @srsName"
				>$loc/strings/alert.M7.directPosition</sch:report>
			<sch:report test="not(@axisLabels) or @srsName"
				>$loc/strings/alert.M7.axisAndSrs</sch:report>
			<sch:report test="not(@uomLabels) or @srsName"
				>$loc/strings/alert.M7.uomAndSrs</sch:report>
			<sch:report
				test="(not(@uomLabels) and not(@axisLabels)) or (@uomLabels and @axisLabels)"
				>$loc/strings/alert.M7.uomAndAxis</sch:report>
		</sch:rule>
	</sch:pattern>

  <!-- cit:CI_Individual must have cit:name or cit:positionName -->
	<sch:pattern>
		<sch:title>$loc/strings/M8</sch:title>
		<sch:rule context="//*[cit:CI_Individual]">
			<sch:let name="count" value="(count(cit:CI_Individual/cit:name[@gco:nilReason!='missing' or not(@gco:nilReason)]) 
				+ count(cit:CI_Individual/cit:positionName[@gco:nilReason!='missing' or not(@gco:nilReason)]))"/>
			<sch:assert test="$count > 0">$loc/strings/alert.M8</sch:assert>
			<sch:report test="$count > 0"><sch:value-of select="$loc/strings/report.M8"/> <sch:value-of select="cit:CI_Individual/cit:positionName"/>- <sch:value-of select="cit:CI_Individual/cit:name"/></sch:report>
		</sch:rule>
	</sch:pattern>

  <!-- cit:CI_Organisation must have cit:name or cit:logo -->
	<sch:pattern>
		<sch:title>$loc/strings/M31</sch:title>
		<sch:rule context="//*[cit:CI_Organisation]">
			<sch:let name="count" value="(count(cit:CI_Organisation/cit:name[@gco:nilReason!='missing' or not(@gco:nilReason)]) 
				+ count(cit:CI_Organisation/cit:logo[@gco:nilReason!='missing' or not(@gco:nilReason)]))"/>
			<sch:assert test="$count > 0">$loc/strings/alert.M31</sch:assert>
			<sch:report test="$count > 0"><sch:value-of select="$loc/strings/report.M31"/> <sch:value-of select="cit:CI_Organisation/cit:name"/>- <sch:value-of select="cit:CI_Individual/cit:name"/></sch:report>
		</sch:rule>
	</sch:pattern>

	<!-- mco:MD_LegalConstraints ISO/FDIS 19115-1:2013 pg 14 - 1st condition -->
	<sch:pattern>
		<sch:title>$loc/strings/M9</sch:title>
		<sch:rule context="//mco:MD_LegalConstraints[mco:accessConstraints/mco:MD_RestrictionCode/@codeListValue='otherRestrictions']
			|//*[@gco:isoType='mco:MD_LegalConstraints' and mco:accessConstraints/mco:MD_RestrictionCode/@codeListValue='otherRestrictions']">
			<sch:let name="access" value="not(mco:otherConstraints) 
				or count(mco:otherConstraints[gco:CharacterString = '']) > 0 
				or mco:otherConstraints/@gco:nilReason='missing'"/>
			<sch:assert test="$access = false()">
				<sch:value-of select="$loc/strings/alert.M9.access"/>
			</sch:assert>
			<sch:report test="$access = false()"
				><sch:value-of select="$loc/strings/report.M9"/>
				<sch:value-of select="mco:otherConstraints/gco:CharacterString"/>
			</sch:report>
		</sch:rule>
		<sch:rule context="//mco:MD_LegalConstraints[mco:useConstraints/mco:MD_RestrictionCode/@codeListValue='otherRestrictions']
			|//*[@gco:isoType='mco:MD_LegalConstraints' and mco:accessConstraints/mco:MD_RestrictionCode/@codeListValue='otherRestrictions']">
			<sch:let name="use" value="(not(mco:otherConstraints) or not(string(mco:otherConstraints/gco:CharacterString)) or mco:otherConstraints/@gco:nilReason='missing')"/>
			<sch:assert
				test="$use = false()"
				><sch:value-of select="$loc/strings/alert.M9.use"/>
			</sch:assert>
			<sch:report
				test="$use = false()"
				><sch:value-of select="$loc/strings/report.M9"/>
				<sch:value-of select="mco:otherConstraints/gco:CharacterString"/>
			</sch:report>
		</sch:rule>
	</sch:pattern>

  <!-- mco:MD_LegalConstraints ISO/FDIS 19115-1:2013 pg 14 - 2nd condition -->
	<sch:pattern>
		<sch:title>$loc/strings/M32</sch:title>
		<sch:rule context="//*[mco:MD_LegalConstraints]">
			<sch:let name="count" value="(
          count(mco:accessConstraints[@gco:nilReason!='missing' or not(@gco:nilReason)]) 
				+ count(mco:useConstraints[@gco:nilReason!='missing' or not(@gco:nilReason)])
				+ count(mco:useLimitation[@gco:nilReason!='missing' or not(@gco:nilReason)])
				+ count(mco:releaseability[@gco:nilReason!='missing' or not(@gco:nilReason)])
        )"/>
			<sch:assert test="$count > 0">$loc/strings/alert.M32</sch:assert>
			<sch:report test="$count > 0"><sch:value-of select="$loc/strings/report.M32"/></sch:report>
		</sch:rule>
	</sch:pattern>

  <!-- mrc:MD_Band ISO/FDIS 19115-1:2013 pg 19 -->
  <!-- FIXME: Implement other conditions shown on pg 19 -->
	<sch:pattern>
		<sch:title>$loc/strings/M10</sch:title>
		<sch:rule context="//mrc:MD_Band[mrc:maxValue or mrc:minValue]">
			<sch:let name="values" value="(mrc:maxValue[@gco:nilReason!='missing' or not(@gco:nilReason)]
				or mrc:minValue[@gco:nilReason!='missing' or not(@gco:nilReason)]) 
				and not(mrc:units)"/>
			<sch:assert test="$values = false()"
				><sch:value-of select="$loc/strings/alert.M9"/>
			</sch:assert>
			<sch:report test="$values = false()"
				>
				<sch:value-of select="$loc/strings/report.M9.min"/>
				<sch:value-of select="mrc:minValue"/> / 
				<sch:value-of select="$loc/strings/report.M9.max"/>
				<sch:value-of select="mrc:maxValue"/> [
				<sch:value-of select="$loc/strings/report.M9.units"/>
				<sch:value-of select="mrc:units"/>]
			</sch:report>
			<!-- FIXME : Rename to alert M10 -->
		</sch:rule>
	</sch:pattern>

	<!-- mrl:LI_Source ISO/FDIS 19115-1:2013 pg 15 -->
	<sch:pattern>
		<sch:title>$loc/strings/M11</sch:title>
		<sch:rule context="//mrl:LI_Source">
			<sch:let name="scopeordescription" value="mrl:description[@gco:nilReason!='missing' or not(@gco:nilReason)] and mrl:scope[@gco:nilReason!='missing' or not(@gco:nilReason) or mcc:MD_ScopeCode/@codeListValue='']"/>
			<sch:assert test="$scopeordescription"
				>$loc/strings/alert.M11</sch:assert>
			<sch:report test="$scopeordescription"
				>$loc/strings/report.M11</sch:report>
		</sch:rule>
	</sch:pattern>

	<!-- mrl:LI_Lineage ISO/FDIS 19115-1:2013 pg 15 -->
	<sch:pattern>
		<sch:title>$loc/strings/M14</sch:title>
		<sch:rule context="//mrl:LI_Lineage">
			<sch:let name="emptySource" value="not(mrl:source) 
				and not(mrl:statement[@gco:nilReason!='missing' or not(@gco:nilReason)]) 
				and not(mrl:processStep)"/>
			<sch:assert test="$emptySource = false()"
				>$loc/strings/alert.M14</sch:assert>
			<sch:report test="$emptySource = false()"
				>$loc/strings/report.M14</sch:report>

			<sch:let name="emptyProcessStep" value="not(mrl:processStep) 
				and not(mrl:statement[@gco:nilReason!='missing' or not(@gco:nilReason)])
				and not(mrl:source)"/>
			<sch:assert test="$emptyProcessStep = false()"
				>$loc/strings/alert.M15</sch:assert>
			<sch:report test="$emptyProcessStep = false()"
				>$loc/strings/report.M15</sch:report>
		</sch:rule>
	</sch:pattern>

  <!-- Not part of ISO/FDIS 19115-1:2013, DQ is ISO 19157 now, does this still 
       apply? -->
	<sch:pattern>
		<sch:title>$loc/strings/M17</sch:title>
		<sch:rule context="//dqm:DQ_Scope">
			<sch:let name="levelDesc" value="dqm:level/dqm:MD_ScopeCode/@codeListValue='dataset' 
				or dqm:level/dqm:MD_ScopeCode/@codeListValue='series' 
				or (dqm:levelDescription and ((normalize-space(dqm:levelDescription) != '') 
				or (dqm:levelDescription/dqm:MD_ScopeDescription) 
				or (dqm:levelDescription/@gco:nilReason 
				and contains('inapplicable missing template unknown withheld',dqm:levelDescription/@gco:nilReason))))"/>
			<sch:assert
				test="$levelDesc"
				>$loc/strings/alert.M17</sch:assert>
			<sch:report
				test="$levelDesc"
				><sch:value-of select="$loc/strings/report.M17"/> <sch:value-of select="dqm:levelDescription"/></sch:report>
		</sch:rule>
	</sch:pattern>

	<!-- mrd:MD_Medium from ISO/FDIS 19115-1:2013 pg 21 -->
	<sch:pattern>
		<sch:title>$loc/strings/M18</sch:title>
		<sch:rule context="//mrd:MD_Medium">
			<sch:let name="density" value="mrd:density and not(mrd:densityUnits[@gco:nilReason!='missing' or not(@gco:nilReason)])"/>
			<sch:assert test="$density = false()"
				>$loc/strings/alert.M18</sch:assert>
			<sch:report test="$density = false()"
				><sch:value-of select="$loc/strings/report.M18"/> <sch:value-of select="mrd:density"/> 
				<sch:value-of select="mrd:densityUnits/gco:CharacterString"/></sch:report>
		</sch:rule>
	</sch:pattern>

  <!-- gex:EX_Extent from ISO/FDIS 19115-1:2013 pg 25 -->
	<sch:pattern>
		<sch:title>$loc/strings/M20</sch:title>
		<sch:rule context="//gex:EX_Extent">
			<sch:let name="count" value="count(gex:description[@gco:nilReason!='missing' or not(@gco:nilReason)])>0 
				or count(gex:geographicElement)>0 
				or count(gex:temporalElement)>0 
				or count(gex:verticalElement)>0"/>
			<sch:assert
				test="$count"
				>$loc/strings/alert.M20</sch:assert>
			<sch:report
				test="$count"
				>$loc/strings/report.M20</sch:report>
		</sch:rule>
	</sch:pattern>

	<!-- mri:MD_Identification from ISO/FDIS 19115-1:2013 pg 12 -->
	<sch:pattern>
		<sch:title>$loc/strings/M21</sch:title>
		<sch:rule context="//mri:MD_DataIdentification|//*[contains(@gco:isoType, 'MD_DataIdentification')]">
			<sch:let name="extent" value="(not(../../mds:metadataScope) 
				or ../../mds:metadataScope/mds:MD_MetadataScope/mds:resourceScope/mcc:MD_ScopeCode/@codeListValue='dataset' 
				or ../../mds:metadataScope/mds:MD_MetadataScope/mds:resourceScope/mcc:MD_ScopeCode/@codeListValue='') 
				and (count(mri:extent/*/gex:geographicElement/gex:EX_GeographicBoundingBox) 
				+ count (mri:extent/*/gex:geographicElement/gex:EX_GeographicDescription))=0"/>
			<sch:assert
				test="$extent = false()"
				>$loc/strings/alert.M21</sch:assert>
			<sch:report
				test="$extent = false()"
				>$loc/strings/report.M21</sch:report>
		</sch:rule>
	</sch:pattern>

	<!-- mri:MD_Identification from ISO/FDIS 19115-1:2013 pg 12 -->
	<sch:pattern>
		<sch:title>$loc/strings/M22</sch:title>
		<sch:rule context="//mri:MD_DataIdentification|//*[contains(@gco:isoType, 'MD_DataIdentification')]">
			<sch:let name="topic" value="(not(../../mds:metadataScope) 
				or ../../mds:metadataScope/mds:MD_MetadataScope/mds:resourceScope/mcc:MD_ScopeCode/@codeListValue='dataset' 
				or ../../mds:metadataScope/mds:MD_MetadataScope/mds:resourceScope/mcc:MD_ScopeCode/@codeListValue='series'  
				or ../../mds:metadataScope/mds:MD_MetadataScope/mds:resourceScope/mcc:MD_ScopeCode/@codeListValue='' )
				and not(mri:topicCategory)"/>
			<sch:assert
				test="$topic = false()"
				>$loc/strings/alert.M22</sch:assert>
			<sch:report
				test="$topic = false()"
			  ><sch:value-of select="$loc/strings/report.M22"/> "<sch:value-of select="mri:topicCategory/mri:MD_TopicCategoryCode/text()"/>"</sch:report>
		</sch:rule>
	</sch:pattern>

	<!-- mri:MD_AssociatedResources from ISO/FDIS 19115-1:2013 pg 12 -->
	<sch:pattern>
		<sch:title>$loc/strings/M23</sch:title>
		<sch:rule context="//mri:MD_AssociatedResources">
      <sch:let name="count" value="(count(mri:name) + count(mri:metadataReference))"/>
      
			<sch:assert test="$count > 0"
				>$loc/strings/alert.M23</sch:assert>
			<sch:report test="$count > 0"
				>$loc/strings/report.M23</sch:report>
		</sch:rule>
	</sch:pattern>

  <!-- FIXME: Add other constraints defined in ISO/FDIS 19115-1:2013 pg 12 -->

	<sch:pattern>
		<sch:title>$loc/strings/M25</sch:title>
		<!-- UNVERIFIED -->
		<sch:rule context="//mds:MD_Metadata|//*[@gco:isoType='mds:MD_Metadata']">
			<!-- characterSet: documented if ISO/IEC 10646 not used and not defined by
        the encoding standard. Can't tell if XML declaration has an encoding
        attribute. -->
		</sch:rule>
	</sch:pattern>

	<!-- mex:MD_ExtendedElementInformation from ISO/FDIS 19115-1:2013 pg 22 -->
	<sch:pattern>
		<sch:title>$loc/strings/M26</sch:title>
		<sch:rule context="//mex:MD_ExtendedElementInformation">
			<sch:assert
				test="(mex:dataType/mex:MD_DatatypeCode/@codeListValue='codelist' 
				or mex:dataType/mex:MD_DatatypeCode/@codeListValue='enumeration' 
				or mex:dataType/mex:MD_DatatypeCode/@codeListValue='codelistElement') 
				or (mex:obligation and ((normalize-space(mex:obligation) != '')  
				or (mex:obligation/mex:MD_ObligationCode) 
				or (mex:obligation/@gco:nilReason and contains('inapplicable missing template unknown withheld',mex:obligation/@gco:nilReason))))"
				>$loc/strings/alert.M26.obligation</sch:assert>
			<sch:assert
				test="(mex:dataType/mex:MD_DatatypeCode/@codeListValue='codelist' 
				or mex:dataType/mex:MD_DatatypeCode/@codeListValue='enumeration' 
				or mex:dataType/mex:MD_DatatypeCode/@codeListValue='codelistElement') 
				or (mex:maximumOccurrence and ((normalize-space(mex:maximumOccurrence) != '')  
				or (normalize-space(mex:maximumOccurrence/gco:CharacterString) != '') 
				or (mex:maximumOccurrence/@gco:nilReason and contains('inapplicable missing template unknown withheld',mex:maximumOccurrence/@gco:nilReason))))"
				>$loc/strings/alert.M26.maximumOccurence</sch:assert>
			<sch:assert
				test="(mex:dataType/mex:MD_DatatypeCode/@codeListValue='codelist' 
				or mex:dataType/mex:MD_DatatypeCode/@codeListValue='enumeration' 
				or mex:dataType/mex:MD_DatatypeCode/@codeListValue='codelistElement') 
				or (mex:domainValue and ((normalize-space(mex:domainValue) != '')  
				or (normalize-space(mex:domainValue/gco:CharacterString) != '') 
				or (mex:domainValue/@gco:nilReason and contains('inapplicable missing template unknown withheld',mex:domainValue/@gco:nilReason))))"
				>$loc/strings/alert.M26.domainValue</sch:assert>
		</sch:rule>
	</sch:pattern>

  <!-- mex:MD_ExtendedElementInformation from ISO/FDIS 19115-1:2013 pg 22 -->
	<sch:pattern>
		<sch:title>$loc/strings/M27</sch:title>
		<sch:rule context="//mex:MD_ExtendedElementInformation">
			<sch:let name="condition" value="mex:obligation/mex:MD_ObligationCode='conditional'
				and (not(mex:condition) or count(mex:condition[@gco:nilReason='missing'])>0)"/>
			<sch:assert
				test="$condition = false()"
				>
				<sch:value-of select="$loc/strings/alert.M27"/>
			</sch:assert>
			<sch:report
				test="$condition = false()"
				>
				<sch:value-of select="$loc/strings/report.M27"/>
			</sch:report>
		</sch:rule>
	</sch:pattern>

  <!-- mex:MD_ExtendedElementInformation from ISO/FDIS 19115-1:2013 pg 22 -->
	<sch:pattern>
		<sch:title>$loc/strings/M28</sch:title>
		<sch:rule context="//mex:MD_ExtendedElementInformation">
			<sch:let name="domain" value="mex:dataType/mex:MD_DatatypeCode/@codeListValue='codelistElement' and not(mex:domainCode)"/>
			<sch:assert
				test="$domain = false()"
				>$loc/strings/alert.M28</sch:assert>
			<sch:report
				test="$domain = false()"
				>$loc/strings/report.M28</sch:report>
		</sch:rule>
	</sch:pattern>

  <!-- mex:MD_ExtendedElementInformation from ISO/FDIS 19115-1:2013 pg 22 -->
	<sch:pattern>
		<sch:title>$loc/strings/M29</sch:title>
		<sch:rule context="//mex:MD_ExtendedElementInformation">
			<sch:let name="code" value="(mex:dataType/mex:MD_DatatypeCode/@codeListValue='codelistElement' or mex:dataType/mex:MD_DatatypeCode/@codeListValue='enumeration' or mex:dataType/mex:MD_DatatypeCode/@codeListValue='codelist') and not(mex:code)"/>
			<sch:assert
				test="$code = false()"
				>$loc/strings/alert.M29</sch:assert>
			<sch:report
				test="$code = false()"
				>$loc/strings/report.M29</sch:report>
		</sch:rule>
	</sch:pattern>

  <!-- FIXME: Add remaining conditional for mex:MD_ExtendedElementInformation from ISO/FDIS 19115-1:2013 pg 22 -->

  <!-- msr:MD_Georectified doesn't appear to have the following conditional 
       any more - see msr:MD_Georectified from ISO/FDIS 19115-1:2013 pg 17 --> 
	<sch:pattern>
		<sch:title>$loc/strings/M30</sch:title>
		<sch:rule context="//msr:MD_Georectified">
			<sch:let name="cpd" value="(msr:checkPointAvailability/gco:Boolean='1' or msr:checkPointAvailability/gco:Boolean='true') and 
				(not(msr:checkPointDescription) or count(msr:checkPointDescription[@gco:nilReason='missing'])>0)"/>
			<sch:assert
				test="$cpd = false()"
				>$loc/strings/alert.M30</sch:assert>
			<sch:report
				test="$cpd = false()"
				>$loc/strings/report.M30</sch:report>
		</sch:rule>
	</sch:pattern>

</sch:schema>
