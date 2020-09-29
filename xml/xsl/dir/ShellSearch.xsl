<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- (p) 2007 Tenbusch Alexander FRD TK-C -->

  <xsl:output method="text" encoding="UTF-8"/>  

<xsl:variable name="nl">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="nodes_call" select="/pie//file[@ext = 'txt' or @ext = 'pie']"/>

<xsl:template match="/">
  <xsl:text>@echo off</xsl:text>
  <xsl:value-of select="$nl"/>
  <xsl:text>set MODEL_PREFIX=&quot;</xsl:text>
  <xsl:value-of select="/pie/dir/@name"/>
  <xsl:text>&quot;</xsl:text>
  <xsl:value-of select="$nl"/>
  <xsl:value-of select="$nl"/>
  <xsl:for-each select="$nodes_call">
    <xsl:call-template name="file" select="."/>
  </xsl:for-each>
</xsl:template>
      
<xsl:template name="file">
  <!-- <xsl:variable name="id_name" select="translate(@name,'.','_')"/> -->
  <xsl:variable name="dir_name">
    <xsl:text>%MODEL_PREFIX%</xsl:text>
    <xsl:for-each select="ancestor::dir[parent::dir]">
      <xsl:text>\</xsl:text>
      <xsl:value-of select="@name"/>
    </xsl:for-each>
  </xsl:variable>
  <!--  -->
  <xsl:choose>
    <xsl:when test="contains($dir_name,'tmp')"/>
    <xsl:when test="contains($dir_name,'report')"/>
    <xsl:when test="contains($dir_name,'\_')"/>
    <xsl:when test="contains($dir_name,'\.')"/>
    <xsl:otherwise>
      <xsl:text>grep -inHs %1 &quot;</xsl:text>
      <xsl:value-of select="$dir_name"/>
      <xsl:text>\</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>&quot;</xsl:text>
      <xsl:value-of select="$nl"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
      
</xsl:stylesheet>

