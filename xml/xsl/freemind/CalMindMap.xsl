<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="US-ASCII"/>
  <xsl:template match="/calendar">
    <xsl:element name="map">
      <xsl:element name="node">
        <xsl:attribute name="TEXT">
          <xsl:text>Kalender</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates select="year"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="year">
    <xsl:element name="node">
      <xsl:attribute name="TEXT">
        <xsl:value-of select="@ad"/>
      </xsl:attribute>
      <xsl:apply-templates select="month"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="month">
    <xsl:element name="node">
      <xsl:attribute name="FOLDED">
        <xsl:text>true</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TEXT">
        <xsl:value-of select="@nr"/>
      </xsl:attribute>
      <xsl:apply-templates select="day"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="day">
    <xsl:element name="node">
      <xsl:attribute name="TEXT">
        <xsl:value-of select="concat(@om,' ',@own)"/>
      </xsl:attribute>
      <xsl:apply-templates select="descendant::*[name()='p' or name()='h']"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="p|h">
    <xsl:element name="node">
      <xsl:attribute name="TEXT">
        <xsl:apply-templates/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
