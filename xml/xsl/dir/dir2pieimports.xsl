<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="UTF-8"/>
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="pie|dir">
    <xsl:element name="{name()}">
      <xsl:element name="section">
        <xsl:element name="h">
          <xsl:value-of select="dir[1]/@name"/>
        </xsl:element>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dir[not(starts-with(@name,'.'))]">
    <xsl:apply-templates select="file|dir">
      <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="name()"/>
      <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
      <xsl:with-param name="str_prefix">
        <xsl:for-each select="ancestor-or-self::dir">
          <xsl:if test="position() &gt; 1">
            <xsl:value-of select="concat(@name,'/')"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="file[@ext='txt' or @ext='pie' or @ext='csv']">  <!--  -->
    <xsl:param name="str_prefix"/>
    <xsl:element name="import">
      <xsl:attribute name="name">
        <xsl:value-of select="concat($str_prefix,@name)"/>
      </xsl:attribute>
      <xsl:attribute name="url">no</xsl:attribute>
      <xsl:choose>
        <xsl:when test="@ext='csv'">
          <xsl:attribute name="type">
            <xsl:value-of select="@ext"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <xsl:template match="file[@ext='mm']">
    <xsl:param name="str_prefix"/>
    <xsl:element name="import">
      <xsl:attribute name="type">cxp</xsl:attribute>
      <xsl:element name="xml">
        <xsl:element name="xml">
          <xsl:attribute name="name">
            <xsl:value-of select="concat($str_prefix,@name)"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:element name="xsl">
          <xsl:attribute name="name">
            <xsl:value-of select="'mm_strip_folded.xsl'"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:element name="xsl">
          <xsl:attribute name="name">
            <xsl:value-of select="'mm2pie.xsl'"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="file[@ext='mmap' or @ext='xmmap']">
    <xsl:param name="str_prefix"/>
    <xsl:element name="import">
      <xsl:attribute name="type">cxp</xsl:attribute>
      <xsl:element name="xml">
        <xsl:element name="xml">
          <xsl:attribute name="name">
            <xsl:value-of select="concat($str_prefix,@name)"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:element name="xsl">
          <xsl:attribute name="name">
            <xsl:value-of select="'xmmap2mm.xsl'"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:element name="xsl">
          <xsl:attribute name="name">
            <xsl:value-of select="'mm_strip_folded.xsl'"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:element name="xsl">
          <xsl:attribute name="name">
            <xsl:value-of select="'mm2pie.xsl'"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="file[@ext='jpg' or @ext='png' or @ext='gif']">
    <xsl:param name="str_prefix"/>
    <xsl:element name="fig">
      <xsl:element name="h">
        <xsl:value-of select="@name"/>
      </xsl:element>
      <xsl:element name="img">
        <xsl:attribute name="src">
          <xsl:value-of select="concat($str_prefix,@name)"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="*|text()"/>
</xsl:stylesheet>
