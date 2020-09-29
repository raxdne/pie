<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="UTF-8"/>
<!-- ignore all elements with an id and valid="no" -->
  <xsl:template match="/">
    <xsl:element name="map">
      <xsl:element name="node">
        <xsl:attribute name="TEXT">
          <xsl:text>Mindmaps</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="link">
          <xsl:value-of select="pie/dir/@urlname"/>
        </xsl:attribute>
        <xsl:apply-templates select="pie/*"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dir|file">
    <xsl:variable name="dir_name">
      <xsl:value-of select="concat(/pie/dir/@urlprefix,'/')"/>
      <xsl:for-each select="ancestor::dir">
        <xsl:value-of select="concat(@urlname,'/')"/>
      </xsl:for-each>
      <xsl:value-of select="@urlname"/>
    </xsl:variable>
<!--  -->
    <xsl:choose>
      <xsl:when test="@urlname = 'tmp'"/>
<!-- false() and  -->
      <xsl:when test="starts-with(@urlname,'_')"/>
      <xsl:when test="starts-with(@urlname,'.')"/>
      <xsl:when test="name()='dir'">
        <xsl:element name="node">
          <xsl:attribute name="TEXT">
            <xsl:value-of select="@name"/>
          </xsl:attribute>
          <xsl:attribute name="link">
            <xsl:value-of select="concat('file:///',translate($dir_name,'\','/'))"/>
          </xsl:attribute>
          <xsl:if test="count(ancestor::dir) &gt; 0 and count(file[@ext]) &gt; 6">
<!--  or @ext='html' -->
            <xsl:attribute name="FOLDED">
              <xsl:text>true</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="dir[descendant::file]|file"/>
<!--  or @ext='html' -->
        </xsl:element>
      </xsl:when>
      <xsl:when test="@ext='mm' or @ext='mmap' or @ext='xmmap' or @ext='txt' or @ext='htm' or @ext='html'">
        <xsl:variable name="url_file">
          <xsl:value-of select="concat('file:///',translate($dir_name,'\','/'))"/>
        </xsl:variable>
        <xsl:variable name="str_text">
          <xsl:choose>
            <xsl:when test="@ext='pie' or @ext='txt'">
              <xsl:choose>
                <xsl:when test="pie">
                  <xsl:value-of select="pie/section[1]/h"/>
                </xsl:when>
                <xsl:when test="@ext='txt'">
                  <xsl:value-of select="@name"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="document($url_file)/pie/section[1]/h"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="@ext='mm'">
              <xsl:choose>
                <xsl:when test="map and string-length(map//node[1]/attribute::*[name()='TEXT' or name()='text'])">
                  <xsl:value-of select="map//node[1]/attribute::*[name()='TEXT' or name()='text']"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="document($url_file)/map//node[1]/attribute::*[name()='TEXT' or name()='text']"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('(',@name,')')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:element name="node">
          <xsl:attribute name="TEXT">
            <xsl:value-of select="$str_text"/>
          </xsl:attribute>
          <xsl:attribute name="link">
            <xsl:value-of select="$url_file"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
