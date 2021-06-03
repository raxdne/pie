<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!--  -->

  <xsl:output method="html" encoding="utf-8"/>

  <!-- diagram height -->
  <xsl:variable name="int_height" select="200"/>
  <xsl:variable name="int_width" select="60 * 100"/>

  <!-- heart rate ranges -->
  <xsl:variable name="int_hr_1" select="125"/>
  <xsl:variable name="int_hr_2" select="150"/>
  <xsl:variable name="int_hr_3" select="190"/>

  <!-- speed levels -->
  <xsl:variable name="int_speed_1" select="25"/>
  <xsl:variable name="int_speed_2" select="50"/>

  <xsl:decimal-format name="f1" grouping-separator="." decimal-separator=","/>
  
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="body">
	<xsl:call-template name="COMPARE_DIAGRAM"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="pie|file|dir">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="COMPARE_DIAGRAM">

    <xsl:element name="svg" xmlns="http://www.w3.org/2000/svg">
      <xsl:attribute name="version">1.1</xsl:attribute>
      <xsl:attribute name="baseProfile">full</xsl:attribute>
      <xsl:attribute name="height"><xsl:value-of select="$int_height"/></xsl:attribute>
      <xsl:attribute name="width"><xsl:value-of select="$int_width"/></xsl:attribute>
      <xsl:attribute name="id">diagram</xsl:attribute>

      <xsl:element name="style">
	<xsl:attribute name="type">text/css</xsl:attribute>
	<xsl:text>svg { font-family: Arial; font-size: 8pt;}</xsl:text>
      </xsl:element>

      <xsl:element name="rect">
	<xsl:attribute name="fill">#ffcccc</xsl:attribute>
	<xsl:attribute name="x"><xsl:value-of select="0"/></xsl:attribute>
	<xsl:attribute name="y"><xsl:value-of select="$int_height - $int_hr_3"/></xsl:attribute>
	<xsl:attribute name="height"><xsl:value-of select="$int_hr_3 - $int_hr_2"/></xsl:attribute>
	<xsl:attribute name="width"><xsl:value-of select="$int_width"/></xsl:attribute>
	<xsl:element name="title">
	  <xsl:value-of select="concat('Red zone: ', $int_hr_2, ' .. ', $int_hr_3)"/>
	</xsl:element>
      </xsl:element>

      <xsl:element name="rect">
	<xsl:attribute name="fill">#ccffcc</xsl:attribute>
	<xsl:attribute name="x"><xsl:value-of select="0"/></xsl:attribute>
	<xsl:attribute name="y"><xsl:value-of select="$int_height - $int_hr_2"/></xsl:attribute>
	<xsl:attribute name="height"><xsl:value-of select="$int_hr_2 - $int_hr_1"/></xsl:attribute>
	<xsl:attribute name="width"><xsl:value-of select="$int_width"/></xsl:attribute>
	<xsl:element name="title">
	  <xsl:value-of select="concat('Endurance zone: ', $int_hr_1, ' .. ', $int_hr_2)"/>
	</xsl:element>
      </xsl:element>

      <xsl:element name="line">
	<xsl:attribute name="stroke">blue</xsl:attribute>
	<xsl:attribute name="stroke-width">.5</xsl:attribute>
	<xsl:attribute name="x1"><xsl:value-of select="0"/></xsl:attribute>
	<xsl:attribute name="y1"><xsl:value-of select="$int_height - ($int_speed_1 * 2)"/></xsl:attribute>
	<xsl:attribute name="x2"><xsl:value-of select="$int_width"/></xsl:attribute>
	<xsl:attribute name="y2"><xsl:value-of select="$int_height - ($int_speed_1 * 2)"/></xsl:attribute>
      </xsl:element>

      <xsl:element name="line">
	<xsl:attribute name="stroke">blue</xsl:attribute>
	<xsl:attribute name="stroke-width">.5</xsl:attribute>
	<xsl:attribute name="x1"><xsl:value-of select="0"/></xsl:attribute>
	<xsl:attribute name="y1"><xsl:value-of select="$int_height - ($int_speed_2 * 2)"/></xsl:attribute>
	<xsl:attribute name="x2"><xsl:value-of select="$int_width"/></xsl:attribute>
	<xsl:attribute name="y2"><xsl:value-of select="$int_height - ($int_speed_2 * 2)"/></xsl:attribute>
      </xsl:element>
      
      <xsl:element name="line">
	<xsl:attribute name="stroke">black</xsl:attribute>
	<xsl:attribute name="stroke-width">1</xsl:attribute>
	<xsl:attribute name="x1"><xsl:value-of select="0"/></xsl:attribute>
	<xsl:attribute name="y1"><xsl:value-of select="$int_height"/></xsl:attribute>
	<xsl:attribute name="x2"><xsl:value-of select="0"/></xsl:attribute>
	<xsl:attribute name="y2"><xsl:value-of select="0"/></xsl:attribute>
      </xsl:element>

      <xsl:element name="line">
	<xsl:attribute name="stroke">black</xsl:attribute>
	<xsl:attribute name="stroke-width">1</xsl:attribute>
	<xsl:attribute name="x1"><xsl:value-of select="0"/></xsl:attribute>
	<xsl:attribute name="y1"><xsl:value-of select="$int_height"/></xsl:attribute>
	<xsl:attribute name="x2"><xsl:value-of select="$int_width"/></xsl:attribute>
	<xsl:attribute name="y2"><xsl:value-of select="$int_height"/></xsl:attribute>
      </xsl:element>

      <xsl:call-template name="VRULE_DIAGRAM"/>
<!--
-->
      <xsl:for-each select="descendant::fit[number(session/total_distance) &gt; 50000 and number(session/total_distance) &lt; 55000]">
	<xsl:call-template name="RECORD_DIAGRAM">
	  <xsl:with-param name="r" select="255 - 20 * position()"/>
	</xsl:call-template>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template name="VRULE_DIAGRAM">
    <xsl:param name="d" select="0"/>

    <xsl:element name="line">
      <xsl:attribute name="stroke">rgb(128,128,128)</xsl:attribute>
      <xsl:attribute name="stroke-width">.5</xsl:attribute>
      <xsl:attribute name="x1"><xsl:value-of select="$d * 100.0"/></xsl:attribute>
      <xsl:attribute name="y1"><xsl:value-of select="0"/></xsl:attribute>
      <xsl:attribute name="x2"><xsl:value-of select="$d * 100.0"/></xsl:attribute>
      <xsl:attribute name="y2"><xsl:value-of select="$int_height"/></xsl:attribute>
    </xsl:element>

    <xsl:choose>
      <xsl:when test="$d &lt; 60">
	<xsl:call-template name="VRULE_DIAGRAM">
	  <xsl:with-param name="d" select="$d + 5"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="RECORD_DIAGRAM">
    <xsl:param name="r" select="255"/>
    
    <xsl:for-each select="record">
      <xsl:variable name="int_x" select="number(distance) * 100.0"/>
      
      <xsl:for-each select="speed">
	<xsl:variable name="int_y" select="$int_height - format-number(. * 2,'#,')"/>
	
	<xsl:element name="line">
	  <xsl:attribute name="stroke">blue</xsl:attribute>
	  <xsl:attribute name="stroke-width">.25</xsl:attribute>
	  <xsl:attribute name="x1"><xsl:value-of select="$int_x"/></xsl:attribute>
	  <xsl:attribute name="y1"><xsl:value-of select="$int_height"/></xsl:attribute>
	  <xsl:attribute name="x2"><xsl:value-of select="$int_x"/></xsl:attribute>
	  <xsl:attribute name="y2"><xsl:value-of select="$int_y"/></xsl:attribute>
	  <xsl:if test="number(.) &gt; $int_speed_1">
	    <xsl:element name="title">
	      <xsl:value-of select="."/>
	    </xsl:element>
	  </xsl:if>
	</xsl:element>
      </xsl:for-each>

      <xsl:for-each select="heart_rate">
	<xsl:variable name="int_y" select="$int_height - format-number(.,'#,')"/>
	
	<xsl:element name="circle">
	  <xsl:attribute name="fill"><xsl:value-of select="concat('rgb(',$r,',128,128)')"/></xsl:attribute>
	  <xsl:attribute name="cx"><xsl:value-of select="$int_x"/></xsl:attribute>
	  <xsl:attribute name="cy"><xsl:value-of select="$int_y"/></xsl:attribute>
	  <xsl:attribute name="r"><xsl:value-of select="1"/></xsl:attribute>
	  <xsl:element name="title">
	    <xsl:value-of select="concat(../../@src,': ',.,' bpm, ',../distance)"/>
	  </xsl:element>
	</xsl:element>
      </xsl:for-each>
      
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*"/>
  
</xsl:stylesheet>
