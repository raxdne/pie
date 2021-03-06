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
      <xsl:variable name="str_date" select="substring-before(properties/dtstart/date-time,'T')"/>
      <xsl:variable name="str_time_start" select="substring-after(properties/dtstart/date-time,'T')"/>
      <xsl:variable name="str_time_end" select="substring-after(properties/dtend/date-time,'T')"/>
      <xsl:variable name="int_offset_local">
	<xsl:choose>
          <xsl:when test="contains(properties/dtstart/parameters/tzid,'Eastern Standard Time')">
            <xsl:value-of select="5"/>
          </xsl:when>
          <xsl:when test="contains(properties/dtend/parameters/tzid,'W. Europe Standard Time')">
            <xsl:value-of select="0"/>
          </xsl:when>
          <xsl:when test="contains($str_time_start,'Z')"> <!-- date with UTC time, or absolute time -->
            <xsl:value-of select="$int_offset"/>
          </xsl:when>
          <!-- TODO: handling of other time zones, s. @tzid -->
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="string-length($str_date) &gt; 0">
          <!-- there is a time value -->
          <xsl:choose>
            <xsl:when test="starts-with(properties/dtend/date-time,$str_date) or contains(properties/dtend/date-time,'T000000')">
              <xsl:attribute name="date">
                <xsl:value-of select="$str_date"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="date">
                <xsl:value-of select="concat($str_date,'#',substring-before(properties/dtend/date-time,'T'))"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <!-- time value without zone -->
          <xsl:value-of select="concat(number(substring($str_time_start,1,2)) + $int_offset_local,'.',substring($str_time_start,3,2),'-',number(substring($str_time_end,1,2)) + $int_offset_local,'.',substring($str_time_end,3,2))"/>
          <!-- text value -->
          <xsl:if test="properties/url/text">
            <xsl:attribute name="href">
              <xsl:value-of select="concat(' ',properties/url/text)"/>
            </xsl:attribute>
          </xsl:if>
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
	</xsl:when>
        <xsl:otherwise>
          <!-- there is no time value -->
          <xsl:choose>
            <xsl:when test="properties/dtend/date-time">
              <xsl:attribute name="date">
		<xsl:choose>
		  <xsl:when test="(properties/dtend/date-time - properties/dtstart/date-time) &lt; 2">
		    <xsl:value-of select="properties/dtstart/date-time"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:value-of select="concat(properties/dtstart/date-time,'#',properties/dtend/date-time)"/>
		  </xsl:otherwise>
		</xsl:choose>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="date">
                <xsl:value-of select="properties/dtstart/date-time"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
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
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="properties/location/text">
        <xsl:value-of select="concat(' (',properties/location/text,')')"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  <xsl:template match="comment()|text()|@*"/>
</xsl:stylesheet>
