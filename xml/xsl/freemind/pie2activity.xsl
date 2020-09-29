<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="pie2mm.xsl"/>
  <xsl:output method="xml" version="1.0"/>
  <xsl:variable name="flag_attr" select="false()"/>
  <xsl:variable name="str_title" select="''"/>
<!-- index with all assignee in valid structures where parent task is not @done -->
  <xsl:key name="listassignee" match="section[@assignee]" use="@assignee"/>
  <xsl:template match="/">
    <xsl:element name="map">
      <xsl:element name="node">
        <xsl:attribute name="TEXT">
          <xsl:value-of select="$str_title"/>
        </xsl:attribute>
        <xsl:call-template name="PIEASSIGNEELIST">
      </xsl:call-template>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="PIEASSIGNEELIST">
<!-- All assignee  -->
    <xsl:for-each select="//section[generate-id(.) = generate-id(key('listassignee',@assignee))]">
      <xsl:sort select="@assignee"/>
      <xsl:variable name="str_assignee" select="@assignee"/>
      <xsl:element name="node">
        <xsl:attribute name="LINK">
          <xsl:value-of select="concat($str_assignee,'.mm')"/>
        </xsl:attribute>
        <xsl:attribute name="FOLDED">
          <xsl:value-of select="'true'"/>
        </xsl:attribute>
        <xsl:attribute name="TEXT">
          <xsl:value-of select="$str_assignee"/>
        </xsl:attribute>
        <xsl:apply-templates select="//section[@assignee=$str_assignee]"/>
        <!-- <xsl:copy-of select="document(concat($str_assignee,'.mm'))/map/*"/> -->
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
