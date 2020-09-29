<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- transformation of PIE/XML to a simple, non-interactive HTML format -->

  <xsl:output 
    method="html"
    encoding="UTF-8"
    omit-xml-declaration="no"
    doctype-public="-//W3C//DTD HTML 4.01//EN" />

  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="pie">
    <xsl:element name="head">
      <xsl:element name="meta">
	<xsl:attribute name="name">
	  <xsl:text>generator</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="content">
	  <xsl:text>cxproc PIE/XML</xsl:text>
	</xsl:attribute>
      </xsl:element>
      <xsl:element name="meta">
	<xsl:attribute name="http-equiv">
	  <xsl:text>cache-control</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="content">
	  <xsl:text>no-cache</xsl:text>
	</xsl:attribute>
      </xsl:element>
      <xsl:element name="meta">
	<xsl:attribute name="http-equiv">
	  <xsl:text>pragma</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="content">
	  <xsl:text>no-cache</xsl:text>
	</xsl:attribute>
      </xsl:element>
      <xsl:if test="/pie/section/h">
	<xsl:element name="title">
	  <xsl:value-of select="/pie/section/h"/>
	</xsl:element>
      </xsl:if>
    </xsl:element>
    <xsl:element name="body">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="h">
    <xsl:choose>
      <xsl:when test="@hidden">
	<!-- ignore -->
      </xsl:when>
      <xsl:when test="parent::section">
	<xsl:text> / </xsl:text>
	<xsl:element name="b">
	  <xsl:apply-templates />
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>; </xsl:text>
	<xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="section">
    <xsl:choose>
      <xsl:when test="parent::pie">
	<xsl:element name="h2">
	  <xsl:apply-templates select="h"/>
	</xsl:element>
	<xsl:element name="p">
	  <xsl:apply-templates select="*[not(name() = 'h')]"/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="parent::section/parent::pie">
	<xsl:element name="p">
	  <xsl:apply-templates select="*"/>
	</xsl:element>
      </xsl:when>
       <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>  
  </xsl:template>

  <xsl:template match="link">
    <xsl:element name="a">
      <xsl:copy-of select="@href"/>
      <xsl:apply-templates/>
    </xsl:element>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="b|u|i">
    <!-- map former elements to span -->
    <xsl:element name="{name()}">
      <xsl:apply-templates/>
    </xsl:element>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="p">
    <xsl:choose>
      <xsl:when test="not(@hidden)">
	<!-- simple paragraph -->
	<xsl:apply-templates/>
	<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<!-- really hidden paragraph -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="table">
    <xsl:element name="center">
      <xsl:element name="table">
	<xsl:copy-of select="@*"/>
	<xsl:attribute name="width">90%</xsl:attribute>
	<xsl:copy-of select="*[not(name()='t')]"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[@valid='no']">
    <!-- ignore this elements -->
  </xsl:template>

  <xsl:template match="meta|t|tag">
    <!-- ignore this elements -->
  </xsl:template>

</xsl:stylesheet>
