<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" encoding="US-ASCII"/>
  <xsl:variable name="str_ctime" select="translate(/pie/meta/@ctime2,'-:','')" />
  <xsl:template match="/">
<xsl:text>BEGIN:VCALENDAR
PRODID:-//CXPROC PIE Calendar//DE
VERSION:2.0
METHOD:PUBLISH
X-WR-CALNAME:cxproc
X-WR-TIMEZONE:Europe/Berlin
BEGIN:VTIMEZONE
TZID:Europe/Berlin
BEGIN:DAYLIGHT
TZOFFSETFROM:+0100
TZOFFSETTO:+0200
TZNAME:CEST
DTSTART:19700329T020000
RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=3
END:DAYLIGHT
BEGIN:STANDARD
TZOFFSETFROM:+0200
TZOFFSETTO:+0100
TZNAME:CET
DTSTART:19701025T030000
RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=10
END:STANDARD
END:VTIMEZONE
</xsl:text>
    <xsl:apply-templates select="descendant::date[@iso]"/>
<xsl:text>END:VCALENDAR</xsl:text>
  </xsl:template>
  <xsl:template match="date">
    <xsl:text>BEGIN:VEVENT
CREATED:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
LAST-MODIFIED:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
DTSTAMP:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
SUMMARY:</xsl:text><xsl:value-of select="normalize-space(following-sibling::text())" /><xsl:text>
DTSTART;TZID=Europe/Berlin:</xsl:text><xsl:value-of select="@iso" /><xsl:text>
DTEND;TZID=Europe/Berlin:</xsl:text><xsl:value-of select="@iso" /><xsl:text>
TRANSP:OPAQUE
END:VEVENT
</xsl:text>
  </xsl:template>
  <xsl:template match="*"/>
</xsl:stylesheet>
