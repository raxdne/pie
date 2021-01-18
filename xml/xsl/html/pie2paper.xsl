<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="PieHtml.xsl"/>
  <!-- -->
  <xsl:variable name="file_norm"></xsl:variable>
  <!-- -->
  <xsl:variable name="file_css" select="'news.css'"/>
  <!-- cancel tree -->
  <xsl:variable name="flag_toc" select="false()"/>
  <!--  -->
  <xsl:variable name="flag_header" select="true()"/>
  <!--  -->
  <xsl:variable name="flag_fig" select="true()"/>
  <!--  -->
  <xsl:variable name="level_hidden" select="0"/>

  <xsl:output method="html" omit-xml-declaration="no" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="file:///tmp/dummy.dtd"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="section">
    <xsl:choose>
      <xsl:when test="parent::pie">
	<!-- top section -->
        <xsl:element name="h1">
          <xsl:attribute name="class">title</xsl:attribute>
          <xsl:apply-templates select="h"/>
        </xsl:element>
        <hr/>
      </xsl:when>
      <xsl:when test="parent::section[parent::pie]">
	<!-- category section -->
        <xsl:element name="h1">
          <xsl:attribute name="class">title</xsl:attribute>
          <xsl:apply-templates select="h"/>
        </xsl:element>
        <hr/>
      </xsl:when>
      <xsl:otherwise>
	<!-- section -->
        <xsl:element name="h2">
          <xsl:apply-templates select="h"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
    <!--  -->
    <xsl:element name="div">
      <xsl:choose>
        <xsl:when test="parent::section[parent::pie]">
	  <xsl:attribute name="class">
            <xsl:text>block</xsl:text>
	  </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="list">
          <xsl:for-each select="list/p">
            <xsl:element name="p">
              <xsl:element name="a">
                <xsl:attribute name="target">
                  <xsl:text>_blank</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:value-of select="text()"/>
                </xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="link/@href"/>
                </xsl:attribute>
                <xsl:value-of select="link"/>
                <!--
                     <xsl:apply-templates select="link"/>
                     <xsl:element name="br"/>
                     <xsl:value-of select="substring(text(),0,120)"/>
                     -->
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="p">
          <xsl:copy-of select="."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="p">
            <xsl:apply-templates select="*[not(name()='h')]"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <xsl:template match="*[@valid='no']">
    <!-- ignore this elements -->
  </xsl:template>
  <xsl:template match="meta">
    <!-- ignore this elements -->
  </xsl:template>
</xsl:stylesheet>
