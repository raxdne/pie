<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- https://www.rfc-editor.org/rfc/rfc5545.txt -->

  <!-- BUG: dtend/date values are one day too late -->

  <xsl:output method="xml" version="1.0"/>

  <xsl:variable name="int_offset" select="number(1)"/> <!-- TODO: handle different UTC timezones and DST 'iCalendar/vcalendar/properties/x-wr-timezone' -->

  <xsl:template match="/">
    <xsl:element name="pie">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="icalendar">
    <xsl:element name="section">
      <xsl:element name="h">
	<xsl:value-of select="parent::file/@name"/>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="vevent[properties/dtstart]">
    <xsl:element name="p">
      <xsl:element name="date">
	<xsl:if test="properties/dtstart">
	  <xsl:attribute name="DTSTART">
	    <xsl:value-of select="properties/dtstart/date-time"/>
	  </xsl:attribute>
	</xsl:if>
	<xsl:if test="properties/dtend">
	  <xsl:attribute name="DTEND">
	    <xsl:value-of select="properties/dtend/date-time"/>
	  </xsl:attribute>
	</xsl:if>
        <xsl:choose>
	  <xsl:when test="properties/dtend[@iso = ../dtstart/date-time]">
	    <xsl:value-of select="properties/dtstart/date-time"/>
	  </xsl:when>
	  <xsl:when test="properties/dtend/@iso">
	    <xsl:value-of select="concat(properties/dtstart/date-time,'/',properties/dtend/@iso)"/>
	  </xsl:when>
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

  <xsl:template match="vtodo[properties]">
    <xsl:element name="task">
      <xsl:attribute name="class">todo</xsl:attribute>
      <xsl:if test="properties/priority">
	<xsl:attribute name="impact">
          <xsl:value-of select="properties/priority/text"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:if test="properties/status[text = 'COMPLETED']">
	<xsl:attribute name="done">yes</xsl:attribute>
      </xsl:if>
      <xsl:element name="h">
	<xsl:element name="date">
	  <xsl:if test="properties/sequence/text">
	    <xsl:attribute name="i">
	      <xsl:value-of select="properties/sequence/text"/>
	    </xsl:attribute>
	  </xsl:if>
	  <xsl:if test="properties/due">
	    <xsl:attribute name="DUE">
	      <xsl:value-of select="properties/due/date-time"/>
	    </xsl:attribute>
	  </xsl:if>
	  <xsl:if test="properties/dtstart">
	    <xsl:attribute name="DTSTART">
	      <xsl:value-of select="properties/dtstart/date-time"/>
	    </xsl:attribute>
	  </xsl:if>
	  <xsl:if test="properties/dtend">
	    <xsl:attribute name="DTEND">
	      <xsl:value-of select="properties/dtend/date-time"/>
	    </xsl:attribute>
	  </xsl:if>
          <xsl:choose>
	    <xsl:when test="properties/due/date-time">
	      <xsl:value-of select="properties/due/date-time"/>
	    </xsl:when>
	    <xsl:when test="properties/dtend[@iso = ../dtstart/date-time]">
	      <xsl:value-of select="properties/dtstart/date-time"/>
	    </xsl:when>
	    <xsl:when test="properties/dtend/@iso">
	      <xsl:value-of select="concat(properties/dtstart/date-time,'/',properties/dtend/@iso)"/>
	    </xsl:when>
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
	<xsl:if test="properties/organizer/text">
          <xsl:value-of select="concat(' ',properties/organizer/text)"/>
	</xsl:if>
      </xsl:element>
      <xsl:for-each select="properties/attendee">
	<xsl:value-of select="concat(' ',text)"/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="vjournal[properties]">
    <xsl:element name="p">
      <xsl:attribute name="class">journal</xsl:attribute>
      <xsl:if test="properties/priority">
	<xsl:attribute name="impact">
          <xsl:value-of select="properties/priority/text"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:if test="properties/status[text = 'COMPLETED']">
	<xsl:attribute name="done">yes</xsl:attribute>
      </xsl:if>
      <xsl:element name="h">
	<xsl:element name="date">
	  <xsl:if test="properties/dtstamp">
	    <xsl:attribute name="DTSTAMP">
	      <xsl:value-of select="properties/dtstamp/date-time"/>
	    </xsl:attribute>
	  </xsl:if>
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
	<xsl:if test="properties/organizer/text">
          <xsl:value-of select="concat(' ',properties/organizer/text)"/>
	</xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="comment()|text()|@*"/>

</xsl:stylesheet>
