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
      <xsl:when test="@assignee">
        <xsl:value-of select="$tabulator"/>
        <xsl:for-each select="ancestor-or-self::section">
          <xsl:if test="child::h">
            <xsl:if test="position() &gt; 1">
              <xsl:text> :: </xsl:text>
            </xsl:if>
            <xsl:value-of select="normalize-space(h)"/>
          </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="$tabulator"/>
        <xsl:choose>
          <xsl:when test="@effort">
            <xsl:value-of select="concat(@effort,'d?')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(sum(descendant::task/attribute::effort),'d?')"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$tabulator"/>
        <xsl:value-of select="$tabulator"/>
        <xsl:if test="false()">
          <xsl:value-of select="concat('&quot;',position(),'&quot;')"/>
        </xsl:if>
        <xsl:value-of select="$tabulator"/>
        <xsl:value-of select="$tabulator"/>
        <xsl:for-each select="descendant-or-self::section[@assignee]">
          <xsl:if test="position() &gt; 1">
            <xsl:value-of select="';'"/>
          </xsl:if>
          <xsl:value-of select="@assignee"/>
        </xsl:for-each>
        <xsl:text>
</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*|@*"/>
</xsl:stylesheet>
