<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" version="1.0"/>
  <xsl:template match="iCalendar">
    <xsl:element name="pie">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="vevent">
    <xsl:element name="p">
      <xsl:variable name="str_date" select="substring-before(properties/dtstart/date-time,'T')"/>
      <xsl:variable name="str_time" select="substring-after(properties/dtstart/date-time,'T')"/>
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
          <xsl:choose>
            <xsl:when test="contains($str_time,'Z')">
              <!-- date with UTC time, or absolute time -->
              <xsl:value-of select="concat(substring($str_time,1,2)+2,'.',substring($str_time,3,2),'-',substring(substring-after(properties/dtend/date-time,'T'),1,2)+2,'.',substring(substring-after(properties/dtend/date-time,'T'),3,2))"/>
            </xsl:when>
            <xsl:when test="contains(properties/dtend/parameters/tzid,'W. Europe Standard Time')">
              <!--  -->
              <xsl:value-of select="concat(substring($str_time,1,2),'.',substring($str_time,3,2),'-',substring(substring-after(properties/dtend/date-time,'T'),1,2),'.',substring(substring-after(properties/dtend/date-time,'T'),3,2))"/>
            </xsl:when>
            <!-- TODO: handling of other time zones, s. @tzid -->
            <xsl:otherwise>
              <xsl:value-of select="concat(substring($str_time,1,2),'.',substring($str_time,3,2),'-',substring(substring-after(properties/dtend/date-time,'T'),1,2),'.',substring(substring-after(properties/dtend/date-time,'T'),3,2))"/>
            </xsl:otherwise>
          </xsl:choose>
          <!-- text value -->
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
