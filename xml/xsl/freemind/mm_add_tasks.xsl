<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- Add Task icons to a Freemind-Mindmap -->
  <xsl:output method="xml" version="1.0" encoding="US-ASCII"/>
  <xsl:template match="/">
    <xsl:element name="map">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="map">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates select="*"/>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:copy-of select="file/map/@*"/>
    <xsl:apply-templates select="file/map/*"/>
  </xsl:template>
  <xsl:template match="@*|node()">
    <xsl:choose>
      <xsl:when test="self::node[@FOLDED='true' or @LINK or child::icon[contains(@BUILTIN, 'cancel') or contains(@BUILTIN, 'list')] or child::attribute[@NAME = 'date']]">
        <!--  -->
        <xsl:copy-of select="self::node()"/>
      </xsl:when>
      <xsl:when test="self::node[not(child::node or child::font[@BOLD = 'true'])]">
        <!--  -->
        <xsl:element name="{name()}">
          <xsl:copy-of select="@*|*"/>
          <xsl:element name="icon">
            <xsl:attribute name="BUILTIN">list</xsl:attribute>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
