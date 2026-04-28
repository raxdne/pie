<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">
  <xsl:import href="PieFo.xsl"/>
  <xsl:variable name="level_hidden" select="1"/>
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
  <xsl:template match="pkg:transition|pkg:state">
    <xsl:element name="fo:block" xsl:use-attribute-sets="paragraph header">
      <xsl:attribute name="font-size">
        <xsl:choose>
          <xsl:when test="count(ancestor::section) &lt; 1">
            <!-- -->
            <xsl:text>14pt</xsl:text>
          </xsl:when>
          <xsl:when test="count(ancestor::section) &lt; 2">
            <!-- -->
            <xsl:text>12pt</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <!--  -->
            <xsl:text>10pt</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="h"/>
    </xsl:element>

    <xsl:element name="fo:block">
      <xsl:attribute name="margin">10pt</xsl:attribute>
      <xsl:attribute name="text-align">center</xsl:attribute>
      <xsl:element name="fo:external-graphic">
      <xsl:attribute name="src">
        <xsl:value-of select="concat('tmp/',@id,'.png')"/>
      </xsl:attribute>
      </xsl:element>
    </xsl:element>

    <xsl:apply-templates select="*[not(name(.) = 'h')]"/>
  </xsl:template>
</xsl:stylesheet>
