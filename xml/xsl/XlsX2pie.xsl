<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sst="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac" version="1.0">
  <!--
      (shell-command (concat "\"C:/UserData/Program Files/xmlsoft/bin/xsltproc.exe\"" " " (buffer-file-name) " " "C:/UserData/Work/Temp/Use-Testcases.xml") "test.out" "test.err")
  -->
  <xsl:output method="xml"/>
  <xsl:variable name="ns_si" select="//sst:sst"/>
  <xsl:template match="/">
    <xsl:element name="pie">
      <xsl:apply-templates select="//sst:worksheet"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="sst:worksheet">
    <xsl:element name="table">
      <xsl:apply-templates select="sst:*"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="sst:row">
    <xsl:comment>
      <xsl:value-of select="@r"/>
    </xsl:comment>
    <xsl:element name="tr">
      <xsl:apply-templates select="sst:c"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="sst:c[@r:t = 'str']">
    <xsl:comment>
      <xsl:value-of select="@r"/>
    </xsl:comment>
    <xsl:comment>
      <xsl:value-of select="sst:f"/>
    </xsl:comment>
    <xsl:element name="td">
      <xsl:value-of select="sst:v"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="sst:c[@t = 's' and sst:v]">
    <xsl:variable name="int_index" select="sst:v"/>
    <xsl:comment>
      <xsl:value-of select="@r"/>
    </xsl:comment>
    <xsl:element name="td">
      <xsl:value-of select="$ns_si/sst:si[position() = $int_index + 1]//sst:t"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="sst:c[sst:v]">
    <xsl:element name="td">
      <xsl:comment>
	<xsl:value-of select="@r"/>
      </xsl:comment>
      <xsl:value-of select="sst:v"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="@*|comment()|text()"/>
</xsl:stylesheet>
