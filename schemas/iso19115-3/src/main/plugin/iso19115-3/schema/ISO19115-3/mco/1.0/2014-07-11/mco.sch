<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:ns prefix="gco" uri="http://www.isotc211.org/2005/gco"/>
  <sch:ns prefix="mco" uri="http://www.isotc211.org/namespace/mco/1.0/2013-06-24"/>
  <sch:ns prefix="mcc" uri="http://www.isotc211.org/namespace/mcc/1.0/2013-06-24"/>
  <!--
    ISO 19115-1 mco namespace schematron rules
    Created by thabermann@hdfgroup.org 20140308
  -->
  <sch:pattern id="conf.constraints-xml.schematron-rules">
    <sch:title>Constraint Requirements</sch:title>
    <sch:p>Constraints for elements in the mco namespace</sch:p>
    <sch:rule context="//mco:MD_LegalConstraints">
      <sch:assert test="(count(./mco:accessConstraints) + 
        count(./mco:useConstraints) +
        count(./mco:otherConstraints) +
        count(./mco:useLimitation) + 
        count(./mco:releasability)) &gt; 0">Specify either mco:accessConstraints, mco:useConstraints, mco:otherConstraint, mco:useLimitation or mco:releasability for each mco:MD_LegalConstraints.</sch:assert>
    </sch:rule>
     <sch:rule context="//mco:otherConstraints/gco:CharacterString">
      <sch:assert test="(count(../../mco:accessConstraints[mco:MD_RestrictionCode='otherRestrictions']) +
        count(../../mco:accessConstraints[mco:MD_RestrictionCode/@codeListValue='otherRestrictions']) +
        count(../../mco:useConstraints[mco:MD_RestrictionCode='otherRestrictions']) +
        count(../../mco:useConstraints[mco:MD_RestrictionCode/@codeListValue='otherRestrictions'])) &gt; 0">Specify mco:otherConstraints only if accessConstraints or useConstraints = 'otherRestrictions'.</sch:assert>
    </sch:rule>
    <sch:rule context="//mco:MD_Releasability">
      <sch:assert test="(count(./mco:addressee) + 
        count(./mco:statement/gco:CharacterString)) &gt; 0">Specify either mco:addressee or mco:statement for each mco:MD_MD_Releasability.</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
