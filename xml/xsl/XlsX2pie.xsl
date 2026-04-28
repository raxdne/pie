<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sst="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac" version="1.0">
  <!--
      (shell-command (concat "xsltproc" " " (buffer-file-name) " " "~/cxproc-build/cxproc/t-xslx.xml") "test.out" "test.err")
  -->
  <xsl:output method="xml"/>
  
  <xsl:variable name="ns_si" select="//sst:sst"/>
  
  <xsl:variable name="ns_hyperlink" select="//sst:hyperlink"/>
  
  <xsl:template match="/">
    <xsl:element name="pie">
      <xsl:apply-templates select="//sst:worksheet"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="sst:worksheet">
    <xsl:variable name="ns_cols" select="sst:cols"/>
    <xsl:element name="table">
      <xsl:attribute name="cells">
	<xsl:value-of select="sst:dimension/attribute::ref"/>
      </xsl:attribute>
      <xsl:attribute name="name">
	<xsl:value-of select="parent::file/attribute::name"/>
      </xsl:attribute>
      <xsl:for-each select="sst:sheetData/sst:row">
	<xsl:variable name="int_row" select="@r"/>
	<xsl:variable name="ns_row" select="self::node()"/>
	<xsl:element name="tr">
	  <xsl:for-each select="$ns_cols/sst:col">
	    <xsl:variable name="int_col" select="position()"/>
	    <xsl:variable name="id_cell">
		<xsl:call-template name="CELL">
		  <xsl:with-param name="int_row" select="$int_row"/>
		  <xsl:with-param name="int_col" select="$int_col"/>
		</xsl:call-template>
	    </xsl:variable>
	    <xsl:element name="td">
	      <xsl:attribute name="name">
		<xsl:value-of select="$id_cell"/>
	      </xsl:attribute>
	      <xsl:choose>
		<xsl:when test="$ns_hyperlink[@ref=$id_cell]">
		  <xsl:element name="link">
		    <xsl:attribute name="title">
		      <xsl:value-of select="$ns_hyperlink[@ref=$id_cell]/@tooltip"/>
		    </xsl:attribute>
		    <xsl:attribute name="href">
		      <xsl:value-of select="$ns_hyperlink[@ref=$id_cell]/@display"/>
		    </xsl:attribute>
		    <xsl:apply-templates select="$ns_row/sst:c[@r = $id_cell]"/>
		  </xsl:element>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:apply-templates select="$ns_row/sst:c[@r = $id_cell]"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:element>
	  </xsl:for-each>
	</xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="sst:c[@t = 's' and sst:v]">
    <xsl:variable name="int_index" select="sst:v"/>
      <xsl:value-of select="$ns_si/sst:si[position() = $int_index + 1]//sst:t"/>
  </xsl:template>
  
  <xsl:template name="CELL">
    <xsl:param name="int_row" select="-1"/>
    <xsl:param name="int_col" select="-1"/>
    <xsl:choose>
      <xsl:when test="$int_col &lt; 2">
	<xsl:text>A</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 3">
	<xsl:text>B</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 4">
	<xsl:text>C</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 5">
	<xsl:text>D</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 6">
	<xsl:text>E</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 7">
	<xsl:text>F</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 8">
	<xsl:text>G</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 9">
	<xsl:text>H</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 10">
	<xsl:text>I</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 11">
	<xsl:text>J</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 12">
	<xsl:text>K</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 13">
	<xsl:text>L</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 14">
	<xsl:text>M</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 15">
	<xsl:text>N</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 16">
	<xsl:text>O</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 17">
	<xsl:text>P</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 18">
	<xsl:text>Q</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 19">
	<xsl:text>R</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 20">
	<xsl:text>S</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 21">
	<xsl:text>T</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 22">
	<xsl:text>U</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 23">
	<xsl:text>V</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 24">
	<xsl:text>W</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 25">
	<xsl:text>X</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 26">
	<xsl:text>Y</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 27">
	<xsl:text>Z</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 28">
	<xsl:text>AA</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 29">
	<xsl:text>AB</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 30">
	<xsl:text>AC</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 31">
	<xsl:text>AD</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 32">
	<xsl:text>AE</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 33">
	<xsl:text>AF</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 34">
	<xsl:text>AG</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 35">
	<xsl:text>AH</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 36">
	<xsl:text>AI</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 37">
	<xsl:text>AJ</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 38">
	<xsl:text>AK</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 39">
	<xsl:text>AL</xsl:text>
      </xsl:when>
      <xsl:when test="$int_col &lt; 40">
	<xsl:text>AM</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$int_row"/>
  </xsl:template>
  <xsl:template match="@*|comment()|text()"/>
</xsl:stylesheet>
