<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
						xmlns:gco="http://www.isotc211.org/2005/gco"
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
						>

	<!-- ============================================================================================ -->

	<xsl:output indent="yes"/>
	
	<!-- ============================================================================================ -->
	
	<xsl:template match="mds:MD_Metadata">
		<oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
						xmlns:dc   ="http://purl.org/dc/elements/1.1/"
						xmlns:xsi  ="http://www.w3.org/2001/XMLSchema-instance"
						xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">

			<xsl:for-each select="mds:metadataIdentifier/mcc:MD_Identifier[mcc:codeSpace='urn:uuid']/mcc:code">
				<dc:identifier><xsl:value-of select="gco:CharacterString"/></dc:identifier>
			</xsl:for-each>

			<dc:date><xsl:value-of select="/root/env/changeDate"/></dc:date>
			
			<!-- DataIdentification - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="mds:identificationInfo/mri:MD_DataIdentification">

				<xsl:for-each select="mri:citation/cit:CI_Citation">	
					<xsl:for-each select="cit:title/gco:CharacterString">
						<dc:title><xsl:value-of select="."/></dc:title>
					</xsl:for-each>

					<xsl:for-each select="cit:citedResponsibleParty/cit:CI_Responsibility[cit:role/cit:CI_RoleCode/@codeListValue='originator']/cit:party/cit:CI_Organisation/cit:name/gco:CharacterString">
						<dc:creator><xsl:value-of select="."/></dc:creator>
					</xsl:for-each>

					<xsl:for-each select="cit:citedResponsibleParty/cit:CI_Responsibility[cit:role/cit:CI_RoleCode/@codeListValue='publisher']/cit:party/cit:CI_Organisation/cit:name/gco:CharacterString">
						<dc:publisher><xsl:value-of select="."/></dc:publisher>
					</xsl:for-each>

					<xsl:for-each select="cit:citedResponsibleParty/cit:CI_Responsibility[cit:role/cit:CI_RoleCode/@codeListValue='author']/cit:party/cit:CI_Organisation/cit:name/gco:CharacterString">
						<dc:contributor><xsl:value-of select="."/></dc:contributor>
					</xsl:for-each>
				</xsl:for-each>

				<!-- subject -->

				<xsl:for-each select="mri:descriptiveKeywords/mri:MD_Keywords/mri:keyword/gco:CharacterString">
					<dc:subject><xsl:value-of select="."/></dc:subject>
				</xsl:for-each>

				<!-- description -->

				<xsl:for-each select="mri:abstract/gco:CharacterString">
					<dc:description><xsl:value-of select="."/></dc:description>
				</xsl:for-each>

				<!-- rights -->

				<xsl:for-each select="mri:resourceConstraints/mco:MD_LegalConstraints">
					<xsl:for-each select="*/mco:MD_RestrictionCode/@codeListValue">
						<dc:rights><xsl:value-of select="."/></dc:rights>
					</xsl:for-each>

					<xsl:for-each select="mco:otherConstraints/gco:CharacterString">
						<dc:rights><xsl:value-of select="."/></dc:rights>
					</xsl:for-each>
				</xsl:for-each>

				<!-- language -->

				<xsl:for-each select="mri:defaultLocale/lan:PT_Locale/lan:language/lan:languageCode">
					<dc:language><xsl:value-of select="."/></dc:language>
				</xsl:for-each>

				<!-- bounding box -->

				<xsl:for-each select="mri:extent/gex:EX_Extent/gex:geographicElement/gex:EX_GeographicBoundingBox">	
					<dc:coverage>
						<xsl:value-of select="concat('North ', gex:northBoundLatitude/gco:Decimal, ', ')"/>
						<xsl:value-of select="concat('South ', gex:southBoundLatitude/gco:Decimal, ', ')"/>
						<xsl:value-of select="concat('East ' , gex:eastBoundLongitude/gco:Decimal, ', ')"/>
						<xsl:value-of select="concat('West ' , gex:westBoundLongitude/gco:Decimal, '.')"/>
					</dc:coverage>
				</xsl:for-each>
			</xsl:for-each>

			<!-- Type - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="mds:metadataScope/mds:MD_MetadataScope/mds:resourceScope/mcc:MD_ScopeCode/@codeListValue">
				<dc:type><xsl:value-of select="."/></dc:type>
			</xsl:for-each>

			<!-- Distribution - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="mds:distributionInfo/mrd:MD_Distribution">
				<xsl:for-each select="mrd:distributionFormat/mrd:MD_Format/mrd:name/gco:CharacterString">
					<dc:format><xsl:value-of select="."/></dc:format>
				</xsl:for-each>
			</xsl:for-each>

		</oai_dc:dc>
	</xsl:template>

	<!-- ============================================================================================ -->

	<xsl:template match="*">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	
	<!-- ============================================================================================ -->

</xsl:stylesheet>
