<?xml version="1.0" encoding="UTF-8"?>
<!--  
Stylesheet used to remove a reference to a parent record.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:srv="http://www.isotc211.org/namespace/srv/2.0/2014-07-11"
                xmlns:mcc="http://www.isotc211.org/namespace/mcc/1.0/2014-07-11"
                xmlns:mri="http://www.isotc211.org/namespace/mri/1.0/2014-07-11"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gn="http://www.fao.org/geonetwork"
                exclude-result-prefixes="#all" version="2.0">

	
	<xsl:param name="uuidref"/>
	
	<!-- Do a copy of every nodes and attributes -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- Remove geonet:* elements. -->
	<xsl:template match="gn:*|mri:associatedResource/mri:MD_AssociatedResource[mri:metadataReference/@uuidref = $uuidref]" priority="2"/>
</xsl:stylesheet>
