<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:taxo="http://purl.org/rss/1.0/modules/taxonomy/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="1.0">
  <xsl:output method="xml" encoding="UTF-8" />
  <!--  -->
  <xsl:variable name="entry_max" select="1" />
  <!--  -->
  <xsl:key name="listentries" match="*[@idref and not(@done)]" use="@idref" />
  <!--  -->
  <xsl:variable name="flag_description" select="false()" />
  <xsl:template match="/">
    <xsl:element name="rss">
      <xsl:attribute name="version">2.0</xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>
  <xsl:template match="pie[section]">
    <!-- simple pie document -->
    <xsl:element name="channel">
      <xsl:if test="section/h">
        <xsl:element name="title">
          <xsl:value-of select="section/h" />
        </xsl:element>
        <xsl:element name="description">
          <xsl:value-of select="section/h" />
        </xsl:element>
      </xsl:if>
      <xsl:for-each select="child::section/descendant::*[h]">
        <xsl:element name="item">
          <xsl:element name="title">
            <xsl:value-of select="h" />
          </xsl:element>
          <xsl:element name="description">
            <xsl:value-of select="normalize-space(.)" />
          </xsl:element>
          <!--
          <xsl:element name="link">
            <xsl:attribute name="href">
              <xsl:value-of select="*[name()='link']"/>
            </xsl:attribute>
            <xsl:value-of select="*[name()='title']"/>
          </xsl:element>
	  -->
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  <xsl:template match="calendar">
    <!-- pie calendar document -->
    <xsl:element name="channel">
      <xsl:if test="section/h">
        <xsl:element name="title">
          <xsl:value-of select="section/h" />
        </xsl:element>
        <xsl:element name="description">
          <xsl:value-of select="section/h" />
        </xsl:element>
      </xsl:if>
      <xsl:for-each select="child::year/descendant::col/*[@idref and generate-id(.) = generate-id(key('listentries',@idref))]">
        <xsl:element name="item">
          <xsl:element name="title">
            <xsl:choose>
              <xsl:when test="h">
                <xsl:value-of select="concat(@hstr,' ',h)" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(@hstr,' ',.)" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <xsl:element name="description">
            <xsl:value-of select="normalize-space(*[not(name()='h')])" />
          </xsl:element>
          <xsl:element name="pubDate">
            <!-- TODO: handle date of multiple entries (s. xsl:key) -->
            <xsl:value-of select="concat(../../@own,', ',../../@om,' ',substring(../../../@name,1,3),' ',../../../../@ad)" />
            <xsl:choose>
              <xsl:when test="@hour">
                <xsl:value-of select="concat(' ',@hour,':',@minute,':',@second,' GMT')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(' ','00:00:00 GMT')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <xsl:if test="@flocator">
            <xsl:element name="link">
              <xsl:value-of select="concat('http://localhost:8182/cxproc/exe?','path=',@flocator,'&amp;','xsl=pie2html','#',translate(@fxpath,'/*[]','_'))" />
            </xsl:element>
          </xsl:if>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  <xsl:template match="*">
    <xsl:apply-templates />
  </xsl:template>
</xsl:stylesheet>