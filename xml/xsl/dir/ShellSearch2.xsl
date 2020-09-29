<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- (p) 2007 Tenbusch Alexander FRD TK-C -->

  <xsl:output method="text" encoding="CP1252"/>

<xsl:variable name="nl">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="nodes_call" select="/pie//file[@ext = 'txt' or @ext = 'pie']"/>
<xsl:variable name="grep_call" select="'grep -n -H -s %* '"/>
<xsl:variable name="dir_prefix" select="translate(concat(/pie/dir/@prefix,'/',/pie/dir/@name),'/','\')"/>

<xsl:template match="/">
  <xsl:text>@echo off</xsl:text>
  <xsl:value-of select="$nl"/>
  <xsl:text>chcp 1252</xsl:text>
  <xsl:value-of select="$nl"/>
  <xsl:text>@echo Suche nach &quot;%*&quot;</xsl:text>
  <xsl:value-of select="$nl"/>
  <xsl:value-of select="concat('REM cd /d ',$dir_prefix,$nl)"/>
  <xsl:apply-templates select="pie/dir"/>
  <xsl:value-of select="$nl"/>
  <xsl:text>REM grep -inHs %1 NUL</xsl:text>
  <xsl:value-of select="$nl"/>
  <xsl:text>echo OK</xsl:text>
  <xsl:value-of select="$nl"/>
</xsl:template>

<xsl:template match="dir[contains(@name,'Backup') or contains(@name,'Temp') or contains(@name,'tmp') or contains(@name,'Cache')]">
  <!-- to ignore -->
</xsl:template>

<xsl:template match="file">
  <xsl:variable name="dir_name">
    <xsl:for-each select="ancestor::dir">
      <xsl:if test="@prefix">
        <xsl:value-of select="concat(@prefix,'\')"/>
      </xsl:if>
      <xsl:value-of select="@name"/>
      <xsl:text>\</xsl:text>
    </xsl:for-each>
  </xsl:variable>
  <!--  -->
  <xsl:choose>
    <xsl:when test="contains($dir_name,'report')"/>
    <xsl:when test="not(@name) or @name = '' or starts-with(@name,'.') or starts-with(@name,'_') or contains(@name,'~')"/>
    <xsl:otherwise>
      <!-- one call and line per file because of max. length of single command line (BUT slow) --> 
      <xsl:value-of select="concat($nl,'REM echo &quot;',$dir_name,@name,'&quot; | ',$grep_call,$nl)"/>
      <xsl:if test="contains('txt,mm,pie,csv,html,ics',@ext)">
	<xsl:value-of select="concat($grep_call,' &quot;',$dir_name,@name,'&quot;',$nl)"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
      
<xsl:template match="@*|text()|comment()"/>
</xsl:stylesheet>

