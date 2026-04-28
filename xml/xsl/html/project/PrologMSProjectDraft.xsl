<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../Utils.xsl"/>
  <xsl:output method="text"/>
  <xsl:decimal-format name="f1" grouping-separator="." decimal-separator=","/>
  <xsl:template match="/pie">
    <xsl:value-of select="concat($tabulator,'Planung',$tabulator,'0d?',$newline)"/>
    <xsl:apply-templates select="*"/>
    <xsl:value-of select="concat($tabulator,'MS_END',$tabulator,'0',$newline)"/>
  </xsl:template>
  <xsl:template match="section">
<!-- Projekt -->
    <xsl:choose>
      <xsl:when test="@done"/>
      <xsl:otherwise>
        <xsl:apply-templates select="*"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*|@*"/>
</xsl:stylesheet>
