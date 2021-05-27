<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!--  -->

  <xsl:output method="html" encoding="utf-8"/>

  <xsl:decimal-format name="f1" grouping-separator="." decimal-separator=","/>
  
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="body">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="pie|file|dir">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="fit">
    <xsl:element name="table">
      <xsl:attribute name="border">1</xsl:attribute>
      <xsl:element name="tbody">
        <xsl:apply-templates select="lap"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="lap">
    <xsl:if test="position()=1">
      <xsl:element name="tr">
	<xsl:element name="td">
          <xsl:value-of select="' '"/>
	</xsl:element>
	<xsl:for-each select="start_time|avg_heart_rate|avg_speed|max_speed|max_heart_rate|total_distance">
	  <xsl:sort select="name()"/>
	  <xsl:element name="td">
            <xsl:value-of select="concat(name(),' [', @unit,']')"/>
	  </xsl:element>
	</xsl:for-each>
      </xsl:element>
    </xsl:if>
    <xsl:element name="tr">
      <xsl:element name="td">
        <xsl:value-of select="position()"/>
      </xsl:element>
      <xsl:for-each select="start_time|avg_heart_rate|avg_speed|max_speed|max_heart_rate|total_distance">
	<xsl:sort select="name()"/>
	<xsl:element name="td">
          <xsl:value-of select="."/> <!-- format-number(.,'#,##','f1') -->
	</xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*"/>
  
</xsl:stylesheet>
