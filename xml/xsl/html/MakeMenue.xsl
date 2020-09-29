<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cxp="http://www.tenbusch.info/cxproc" version="1.0">
  <xsl:import href="PieHtml.xsl"/>
  <xsl:variable name="file_css" select="'pie.css'"/>
  <!-- BuUG: not configurable via config.xml -->
  <xsl:variable name="dir_prefix" select="'.'"/>
  <xsl:variable name="rm_prefix" select="''"/>
  <!--  -->
  <xsl:variable name="length_link" select="-1"/>
  <xsl:output method="html" version="1.0" encoding="UTF-8"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="cxp:make">
    <xsl:apply-templates select="*[((name()='cxp:xml' and parent::cxp:pie) or (name()='cxp:xhtml' and attribute::text)) and not(ancestor::*[attribute::text]) and not(@valid='no') and attribute::name]">
      <!-- <xsl:sort order="ascending" data-type="number" select="count(child::*)"/> -->
      <!-- <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@text"/> -->
      <xsl:sort order="ascending" data-type="number" select="position()"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template name="BASENAME">
    <xsl:param name="StringToTransform"/>
    <xsl:choose>
      <xsl:when test="contains($StringToTransform,'/')">
        <xsl:call-template name="BASENAME">
          <xsl:with-param name="StringToTransform">
            <xsl:value-of select="substring-after($StringToTransform,'/')"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$StringToTransform"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*">
    <xsl:variable name="url_file">
      <xsl:choose>
        <xsl:when test="starts-with(@name,'http') or starts-with(@name,'ftp')">
          <xsl:value-of select="@name"/>
        </xsl:when>
        <xsl:when test="name()='cxp:xhtml' and not(child::*)">
          <xsl:value-of select="concat($dir_prefix,'/',@name)"/>
        </xsl:when>
        <xsl:otherwise>
          <!--  --> 
          <xsl:call-template name="BASENAME">
            <xsl:with-param name="StringToTransform">
              <xsl:value-of select="@name"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="text_node">
      <xsl:choose>
        <xsl:when test="@text != ''">
          <xsl:value-of select="@text"/>
        </xsl:when>
        <xsl:when test="contains($url_file,'.pie')">
          <xsl:value-of select="substring(document($url_file)/pie/section[1]/h,0,20)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>AAA</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="p">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="$url_file"/>
          <xsl:if test="@path">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="@path"/>
          </xsl:if>
        </xsl:attribute>
        <xsl:attribute name="target">
          <xsl:choose>
            <xsl:when test="@target">
              <xsl:value-of select="@target"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>mainframe</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="$text_node"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
