<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- converts a Xmind file into a simplified freemind file -->
  <xsl:output method="xml" encoding="US-ASCII"/>
  <xsl:template match="/">
    <xsl:element name="map">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="file|pie">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="*">
    <xsl:choose>
      <xsl:when test="name()='topic'">
        <!-- -->
        <xsl:element name="node">
          <xsl:attribute name="TEXT">
            <xsl:value-of select="child::*[name()='title']"/>
          </xsl:attribute>
          <xsl:apply-templates select="*[not(name()='title')]"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="text()|@*"/>
</xsl:stylesheet>
