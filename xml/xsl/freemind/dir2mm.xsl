<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" version="1.0" omit-xml-declaration="yes" encoding="US-ASCII"/>
  <xsl:variable name="flag_file" select="true()"/>
  <xsl:variable name="flag_link" select="true()"/>
  <xsl:variable name="flag_id" select="true()"/>
  <xsl:variable name="flag_absolute" select="true()"/>
  <xsl:variable name="flag_attributes" select="false()"/>
  <xsl:variable name="str_title" select="'Directories'"/>
  <xsl:template match="/pie">
    <xsl:element name="map">
      <xsl:choose>
        <xsl:when test="count(child::*) &gt; 1">
          <!-- create root node -->
          <xsl:element name="node">
            <xsl:attribute name="TEXT">
              <xsl:value-of select="$str_title"/>
            </xsl:attribute>
            <xsl:apply-templates/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <!-- there is a root node already -->
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dir">
    <xsl:element name="node">
      <xsl:if test="child::dir and count(ancestor::dir) &gt; 0">
        <xsl:attribute name="FOLDED">
          <xsl:text>true</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$flag_link">
        <xsl:attribute name="LINK">
          <xsl:if test="$flag_absolute">
            <xsl:value-of select="concat(/pie/dir/@prefix,'/')"/>
          </xsl:if>
          <xsl:for-each select="ancestor::dir">
            <xsl:if test="@name">
              <xsl:value-of select="@name"/>
              <xsl:text>/</xsl:text>
            </xsl:if>
          </xsl:for-each>
          <xsl:value-of select="@name"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="CREATED">
        <xsl:value-of select="@mtime"/>
      </xsl:attribute>
      <xsl:attribute name="MODIFIED">
        <xsl:value-of select="@mtime"/>
      </xsl:attribute>
      <xsl:if test="$flag_id">
        <xsl:attribute name="ID">
          <xsl:value-of select="generate-id(.)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="TEXT">
        <xsl:value-of select="@name"/>
      </xsl:attribute>
      <xsl:apply-templates>
        <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
      </xsl:apply-templates>
      <xsl:call-template name="CREATEATTRIBUTES"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="file">
    <!-- and not(@name='index.html') -->
    <xsl:if test="$flag_file">
      <xsl:element name="node">
        <xsl:if test="$flag_id">
          <xsl:attribute name="ID">
            <xsl:value-of select="generate-id(.)"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$flag_link and @size &gt; 0">
          <xsl:attribute name="LINK">
            <xsl:if test="$flag_absolute">
              <xsl:value-of select="concat(/pie/dir/@prefix,'/')"/>
            </xsl:if>
            <xsl:for-each select="ancestor::dir">
              <xsl:if test="@name">
                <xsl:value-of select="@name"/>
                <xsl:text>/</xsl:text>
              </xsl:if>
            </xsl:for-each>
            <xsl:value-of select="@name"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:attribute name="CREATED">
          <xsl:value-of select="@mtime"/>
        </xsl:attribute>
        <xsl:attribute name="MODIFIED">
          <xsl:value-of select="@mtime"/>
        </xsl:attribute>
        <xsl:attribute name="TEXT">
          <xsl:value-of select="@name"/>
        </xsl:attribute>
        <xsl:call-template name="CREATEATTRIBUTES"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template match="archive">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="*"/>
  <xsl:template name="CREATEATTRIBUTES">
    <xsl:if test="$flag_attributes">
      <!-- add all mindmap node attributes -->
      <xsl:for-each select="@*">
        <xsl:element name="attribute">
          <xsl:attribute name="NAME">
            <xsl:value-of select="name(.)"/>
          </xsl:attribute>
          <xsl:attribute name="VALUE">
            <xsl:value-of select="."/>
          </xsl:attribute>
        </xsl:element>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
