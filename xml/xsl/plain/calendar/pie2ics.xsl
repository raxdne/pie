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
    <xsl:apply-templates select="descendant::date"/>
<xsl:text>END:VCALENDAR</xsl:text>
  </xsl:template>
  
  <xsl:template match="date">
    <xsl:variable name="str_summary">
      <xsl:choose>
	<xsl:when test="name(parent::*) = 'td' or name(parent::*) = 'th'">
	  <xsl:for-each select="parent::*/parent::*/child::node()|parent::*/parent::*/child::text()">
	    <xsl:choose>
	      <xsl:when test="name() = 't'"/>
	      <xsl:when test="name() = 'date'"/>
	      <xsl:otherwise>
		<xsl:value-of select="concat(normalize-space(.),' ')"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:for-each>	  
	</xsl:when>
	<xsl:otherwise>
	  <xsl:for-each select="parent::*/child::node()|parent::*/child::text()">
	    <xsl:if test="position() = 1">
	      <xsl:value-of select="concat(parent::*/parent::*/attribute::class,': ')" />
	    </xsl:if>
	    <xsl:choose>
	      <xsl:when test="name() = 't'"/>
	      <xsl:when test="name() = 'date'"/>
	      <xsl:otherwise>
		<xsl:value-of select="concat(normalize-space(.),' ')"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:for-each>	  
	</xsl:otherwise>
      </xsl:choose>

    </xsl:variable>
    <xsl:variable name="str_category">
      <xsl:for-each select="ancestor::*[attribute::impact][1]">
	<xsl:value-of select="concat('CATEGORIES:',name(.),attribute::impact,'&#10;')" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$flag_interval and not(attribute::interval) and not(ancestor-or-self::*[attribute::impact] = 1)"/>
      
   <!-- <xsl:when test="not(ancestor-or-self::*/attribute::impact)"/> -->
      
      <xsl:when test="ancestor-or-self::*/attribute::done"/>
      
      <xsl:when test="not(@DTSTART)"/>
      
      <xsl:when test="not(@DTEND)"/>
      
      <xsl:when test="$str_summary = ''"/>
      
      <xsl:when test="parent::h/parent::task and $flag_todo">
    <xsl:text>BEGIN:VTODO
CREATED:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
LAST-MODIFIED:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
DTSTAMP:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
SUMMARY:TODO: </xsl:text><xsl:value-of select="substring($str_summary,1,60)" /><xsl:text>
DTSTART:</xsl:text><xsl:value-of select="@DTSTART" /><xsl:text>
DTEND:</xsl:text><xsl:value-of select="@DTEND" /><xsl:text>
UID:</xsl:text><xsl:value-of select="generate-id(.)" /><xsl:text>
</xsl:text>
<xsl:value-of select="$str_category" />
<xsl:if test="parent::h/parent::task[@done]">
<xsl:text>STATUS:COMPLETED
PERCENT-COMPLETE:100
</xsl:text>
</xsl:if>
<xsl:text>TRANSP:OPAQUE
END:VTODO
</xsl:text>
      </xsl:when>

      <xsl:otherwise>
    <xsl:text>BEGIN:VEVENT
CREATED:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
LAST-MODIFIED:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
DTSTAMP:</xsl:text><xsl:value-of select="$str_ctime" /><xsl:text>
SUMMARY:</xsl:text><xsl:value-of select="substring($str_summary,1,70)" /><xsl:text>
DTSTART:</xsl:text><xsl:value-of select="@DTSTART" /><xsl:text>
DTEND:</xsl:text><xsl:value-of select="@DTEND" /><xsl:text>
UID:</xsl:text><xsl:value-of select="generate-id(.)" /><xsl:text>
</xsl:text>
<xsl:value-of select="$str_category" />
<xsl:text>TRANSP:OPAQUE
END:VEVENT
</xsl:text>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*"/>

</xsl:stylesheet>
