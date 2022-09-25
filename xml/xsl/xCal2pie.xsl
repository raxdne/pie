<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" version="1.0"/>
  <xsl:variable name="int_offset" select="number(1)"/> <!-- TODO: handle different UTC timezones and DST 'iCalendar/vcalendar/properties/x-wr-timezone' -->
  <xsl:template match="/">
    <xsl:element name="pie">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="iCalendar">
    <xsl:element name="block">
      <xsl:comment>
        <xsl:value-of select="parent::file/@name"/>
      </xsl:comment>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="vevent">
    <xsl:element name="p">
      <xsl:element name="date">
        <xsl:choose>
	  <xsl:when test="properties/dtend/date-time">
	    <xsl:value-of select="concat(properties/dtstart/date-time,'/',properties/dtend/date-time)"/>
	  </xsl:when>
	  <xsl:otherwise>
            <xsl:value-of select="properties/dtstart/date-time"/>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <xsl:choose>
        <xsl:when test="properties/summary/text">
          <xsl:value-of select="concat(' ',properties/summary/text)"/>
        </xsl:when>
        <xsl:when test="properties/description/text">
          <xsl:value-of select="concat(' ',properties/description/text)"/>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="properties/location/text">
        <xsl:value-of select="concat(' (',properties/location/text,')')"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  <xsl:template match="comment()|text()|@*"/>
</xsl:stylesheet>
