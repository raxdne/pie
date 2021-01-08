<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" version="1.0"/>
  <xsl:variable name="int_offset" select="number(1)"/> <!-- TODO: handle different UTC timezones and DST 'iCalendar/vcalendar/properties/x-wr-timezone' -->

  <xsl:template match="iCalendar">
    <xsl:text>* Journal

</xsl:text>
<xsl:apply-templates select="//vevent">
  <xsl:sort select="properties/dtstart/date-time"/>
</xsl:apply-templates>
  </xsl:template>

  <xsl:template match="vevent">
    <xsl:variable name="str_date">
      <xsl:choose>
	<xsl:when test="contains(properties/dtstart/date-time,'T')">
	  <xsl:value-of select="substring-before(properties/dtstart/date-time,'T')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="properties/dtstart/date-time"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="str_date_iso">
      <xsl:value-of select="concat(substring($str_date,1,4),'-',substring($str_date,5,2),'-',substring($str_date,7))"/>
    </xsl:variable>

    <xsl:if test="string-length(properties/summary/text) &gt; 0">
      <xsl:value-of select="concat('** ',$str_date_iso,' “',properties/summary/text,'”')"/>
      <xsl:text>
      

</xsl:text>
      </xsl:if>
  </xsl:template>
  <xsl:template match="comment()|text()|@*"/>
</xsl:stylesheet>
