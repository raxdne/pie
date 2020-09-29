<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" version="1.0" mc:Ignorable="w14 wp14">
  <xsl:output method="xml"/>
  <xsl:template match="/">
    <xsl:element name="pie">
      <xsl:element name="section">
        <xsl:apply-templates select="//w:document/w:body/*"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="w:p[contains(w:pPr/w:pStyle/@w:val,'berschrift')]"> <!-- TODO: check language dependencies -->
    <xsl:call-template name="SECTION">
      <xsl:with-param name="level" select="substring-after(w:pPr/w:pStyle/@w:val,'berschrift')"/>
      <xsl:with-param name="str_h" select="normalize-space(w:r/w:t)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="w:p[w:pPr/w:numPr]">
    <xsl:call-template name="ENUM">
      <xsl:with-param name="level" select="w:pPr/w:numPr/w:ilvl/@w:val"/>
      <xsl:with-param name="flag_enum">
	<xsl:choose>
	  <xsl:when test="w:pPr/w:numPr/w:numId/@w:val = 8">
	    <xsl:value-of select="true()"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="false()"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="ns_p" select="w:r/w:t"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="w:t">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="w:p">
    <xsl:element name="p">
      <xsl:value-of select="normalize-space(descendant::w:t)"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="w:tbl">
    <xsl:element name="table">
      <xsl:apply-templates select="w:tr"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="w:tr">
    <xsl:element name="tr">
      <xsl:apply-templates select="w:tc"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="w:tc">
    <xsl:element name="td">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="SECTION">
    <xsl:param name="level"/>
    <xsl:param name="str_h" select="''"/>
    <xsl:choose>
      <xsl:when test="$level &gt; 0">
	<xsl:element name="section">
	  <xsl:call-template name="SECTION">
	    <xsl:with-param name="level" select="$level - 1"/>
	    <xsl:with-param name="str_h" select="$str_h"/>
	  </xsl:call-template>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="h">
	  <xsl:value-of select="$str_h"/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ENUM">
    <xsl:param name="level"/>
    <xsl:param name="flag_enum" select="false()"/>
    <xsl:param name="ns_p"/>
    <xsl:choose>
      <xsl:when test="$level &gt; -1">
	<xsl:element name="list">
	  <xsl:call-template name="ENUM">
	    <xsl:with-param name="level" select="$level - 1"/>
	    <xsl:with-param name="flag_enum" select="$flag_enum"/>
	    <xsl:with-param name="ns_p" select="$ns_p"/>
	  </xsl:call-template>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="p">
	  <xsl:apply-templates select="$ns_p"/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*"/>
</xsl:stylesheet>
