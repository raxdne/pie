<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../Utils.xsl"/>

<xsl:output method='text' version='1.0' encoding='UTF-8'/>

<xsl:variable name="h_max" select="3"/>

<xsl:template match="/map">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="node">
  <xsl:if test="child::icon[contains(@BUILTIN, 'cancel')]">
    <xsl:text>; </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="count(ancestor::node) &lt; $h_max">
      <!-- header -->
      <xsl:text>*</xsl:text>
      <xsl:for-each select="ancestor::node">
        <xsl:call-template name="headize"/>
      </xsl:for-each>
    </xsl:when>
    <xsl:when test="count(ancestor::node) = $h_max">
      <!-- par -->
    </xsl:when>
    <xsl:otherwise>
      <!-- itemize -->
      <xsl:for-each select="ancestor::node">
        <xsl:call-template name="itemize"/>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text> </xsl:text>
  <xsl:call-template name="lf2br">
    <xsl:with-param name="StringToTransform" select="normalize-space(@TEXT)"/>
  </xsl:call-template>
  <xsl:text>
</xsl:text>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template name="headize">
  <xsl:if test="not(position() > $h_max)">
    <xsl:text>*</xsl:text>
  </xsl:if>
</xsl:template>


<xsl:template name="itemize">
  <xsl:if test="not(position() &lt;= $h_max)">
    <xsl:text>-</xsl:text>
  </xsl:if>
</xsl:template>


<xsl:template match="hook">
  <xsl:if test="@NAME = 'accessories/plugins/NodeNote.properties' and child::text">
    <xsl:apply-templates/>
  </xsl:if>
</xsl:template>


<xsl:template match="text">
  <xsl:for-each select="ancestor::node">
    <xsl:call-template name="itemize"/>
  </xsl:for-each>
  <xsl:text> </xsl:text><xsl:value-of select="."/>
</xsl:template>


<xsl:template match="icon">
  <!--
  <xsl:text> </xsl:text><xsl:value-of select="@BUILTIN"/>
  -->
</xsl:template>

</xsl:stylesheet>
