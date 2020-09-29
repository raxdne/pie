<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" version="1.0" encoding="US-ASCII"/>
  <xsl:variable name="flag_p" select="true()"/>
  <xsl:variable name="str_title" select="''"/>
  <xsl:template match="/">
    <xsl:element name="map">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="file">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:choose>
      <xsl:when test="count(child::*[not(name()='meta' or name()='date' or name()='author')]) &gt; 1">
        <!-- create root node -->
        <xsl:element name="node">
          <xsl:attribute name="TEXT">
            <xsl:value-of select="concat($str_title,'&#xa;',date,'&#xa;',author)"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <!-- there is a root node already -->
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="section">
    <xsl:element name="node">
      <xsl:attribute name="TEXT">
        <xsl:value-of select="h"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="task">
    <xsl:if test="not(@done)">
      <xsl:element name="node">
        <xsl:attribute name="TEXT">
          <xsl:value-of select="h"/>
        </xsl:attribute>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template match="*"/>
</xsl:stylesheet>
