<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="PieFo.xsl"/>
  <xsl:variable name="level_hidden" select="1"/>
  <xsl:variable name="length_link" select="30"/>
  <xsl:output method="xml"/>
  <xsl:template match="/">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <xsl:call-template name="HEADER"/>
      <!-- end: defines page layout -->
      <!-- actual layout -->
      <fo:page-sequence master-reference="basicPSM">
        <fo:static-content flow-name="xsl-region-before">
          <fo:block text-align="end" font-size="10pt" font-family="serif" line-height="14pt">
            <xsl:value-of select="/pie/section[1]/h"/>
          </fo:block>
        </fo:static-content>
        <fo:flow flow-name="xsl-region-body">
            <xsl:apply-templates select="/pie/*"/>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>
