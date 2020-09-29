<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:template match="/">
<xsl:text>BEGIN:VCALENDAR
METHOD:PUBLISH
VERSION:2.0
PRODID:-//CXPROC PIE Calendar//DE
</xsl:text>
    <xsl:apply-templates select="//*[@date and not(@date='') and not(@date='m') and not(@date='y') and not(@done)]"/>
<xsl:text>END:VCALENDAR</xsl:text>
  </xsl:template>
  <xsl:template match="*[@date]">
    <xsl:value-of select="@date"/>
    <xsl:text> </xsl:text>
    <xsl:for-each select="ancestor::section">
      <xsl:if test="h">
        <xsl:value-of select="normalize-space(h)"/>
        <xsl:text> :: </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:text>
</xsl:text>
  </xsl:template>
</xsl:stylesheet>
