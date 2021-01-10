<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" encoding="US-ASCII"/>
  <xsl:template match="/">
<xsl:text>BEGIN:VCALENDAR
METHOD:PUBLISH
VERSION:2.0
PRODID:-//CXPROC PIE Calendar//DE
</xsl:text>
    <xsl:apply-templates select="descendant::date[@iso]"/>
<xsl:text>END:VCALENDAR</xsl:text>
  </xsl:template>
  <xsl:template match="date">
    <xsl:text>BEGIN:VEVENT
SUMMARY:</xsl:text><xsl:value-of select="normalize-space(following-sibling::text())" /><xsl:text>
TRANSP:TRANSPARENT
DTSTAMP:20200101T000000Z
CREATED:20200101T000000Z
DTSTART;VALUE=DATE:</xsl:text><xsl:value-of select="@iso" /><xsl:text>
DTEND;VALUE=DATE:</xsl:text><xsl:value-of select="@iso" /><xsl:text>
END:VEVENT
</xsl:text>
  </xsl:template>
  <xsl:template match="*"/>
</xsl:stylesheet>
