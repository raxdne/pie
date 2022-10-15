<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="text"/>

  <xsl:variable name="flag_todo" select="false()" /> <!-- default: false() handle task elements as ordinary VEVENT -->

  <xsl:variable name="flag_interval" select="true()" /> <!-- default: true() only dates with an interval/period -->

  <xsl:variable name="str_ctime" select="translate(/pie/meta/@ctime2,'-:','')" />

  <xsl:template match="/">
<xsl:text>BEGIN:VCALENDAR
PRODID:-//CXPROC PIE Calendar//DE
VERSION:2.0
METHOD:PUBLISH
</xsl:text>
    <xsl:apply-templates select="descendant::date"/>
<xsl:text>END:VCALENDAR</xsl:text>
  </xsl:template>
  
  <xsl:template match="date">
    <xsl:choose>
       <xsl:when test="$flag_interval and not(@interval)"/>
     
       <xsl:when test="not(@DTSTART)"/>
     
       <xsl:when test="not(@DTEND)"/>
     
      <xsl:when test="parent::h/parent::task and $flag_todo">
    <xsl:text>BEGIN:VTODO
CREATED:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
LAST-MODIFIED:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
DTSTAMP:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
SUMMARY:TODO: </xsl:text><xsl:value-of select="normalize-space(string(parent::*))" /><xsl:text>
DTSTART:</xsl:text><xsl:value-of select="@DTSTART" /><xsl:text>
DTEND:</xsl:text><xsl:value-of select="@DTEND" /><xsl:text>
</xsl:text>
<xsl:if test="parent::h/parent::task[@done]">
<xsl:text>STATUS:COMPLETED
PERCENT-COMPLETE:100
</xsl:text>
</xsl:if>
<xsl:text>TRANSP:OPAQUE
END:VTODO
</xsl:text>
      </xsl:when>

      <xsl:when test="date[parent::p]">
    <xsl:text>BEGIN:VEVENT
CREATED:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
LAST-MODIFIED:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
DTSTAMP:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
SUMMARY:</xsl:text><xsl:value-of select="normalize-space(string(parent::*))" /><xsl:text>
DTSTART:</xsl:text><xsl:value-of select="@DTSTART" /><xsl:text>
DTEND:</xsl:text><xsl:value-of select="@DTEND" /><xsl:text>
TRANSP:OPAQUE
END:VEVENT
</xsl:text>
      </xsl:when>

      <xsl:otherwise>
    <xsl:text>BEGIN:VEVENT
CREATED:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
LAST-MODIFIED:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
DTSTAMP:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
SUMMARY:</xsl:text><xsl:value-of select="normalize-space(string(parent::*))" /> <!-- [not(name()='date') and not(name()='t')] --> <xsl:text>
DTSTART:</xsl:text><xsl:value-of select="@DTSTART" /><xsl:text>
DTEND:</xsl:text><xsl:value-of select="@DTEND" /><xsl:text>
TRANSP:OPAQUE
END:VEVENT
</xsl:text>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*"/>

</xsl:stylesheet>
