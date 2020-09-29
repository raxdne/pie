<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
  <xsl:variable name="file_css" select="'pie.css'"/>
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="pie|file">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="map">
    <xsl:element name="html">
      <xsl:element name="head">
        <xsl:element name="link">
          <xsl:attribute name="rel">
            <xsl:text>stylesheet</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="media">
            <xsl:text>screen, print</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="type">
            <xsl:text>text/css</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$file_css"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:element>
      <xsl:element name="body">
        <!-- create header -->
        <xsl:element name="h2">
          <xsl:value-of select="node/@TEXT"/>
        </xsl:element>
        <xsl:apply-templates select="child::node/child::node"/>
        <hr/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="node">
    <!-- -->
    <xsl:choose>
      <xsl:when test="child::node">
        <xsl:if test="child::node[not(child::node)]">
          <!-- a node with childs -->
          <xsl:element name="P">
            <xsl:element name="B">
              <xsl:for-each select="ancestor::*">
                <xsl:if test="position() &gt; 2 and @TEXT">
                  <xsl:value-of select="@TEXT"/>
                  <xsl:text> / </xsl:text>
                </xsl:if>
              </xsl:for-each>
              <xsl:value-of select="@TEXT"/>
            </xsl:element>
            <xsl:text> </xsl:text>
            <!-- all childs without childs -->
            <xsl:for-each select="child::node[not(child::node)]">
              <xsl:apply-templates select="."/>
            </xsl:for-each>
          </xsl:element>
        </xsl:if>
        <!-- all childs with own childs -->
        <xsl:for-each select="child::node[child::node]">
          <xsl:apply-templates select="."/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <!-- node without childs -->
        <xsl:value-of select="@TEXT"/>
        <xsl:text>; </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
