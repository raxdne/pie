<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:variable name="str_location" select="concat('http://192.168.178.20/cgi-bin/cxproc?','cxp=PlayTrack')"/>
  <xsl:variable name="str_subst" select="'/home/share/Audio/'"/>
  <xsl:variable name="flag_link" select="true()"/>
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="dir">
    <xsl:apply-templates select="file[contains(@type,'audio') or contains(@type,'video')]">
      <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="name()"/>
      <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="file[contains(@type,'audio') or contains(@type,'video')]">
    <xsl:variable name="str_path">
      <xsl:for-each select="ancestor::dir">
        <xsl:if test="@name">
          <xsl:if test="position() &gt; 0">
            <xsl:text>/</xsl:text>
          </xsl:if>
          <xsl:value-of select="@name"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@read='no' or @error">
        <xsl:value-of select="'Error.mp3'"/>
      </xsl:when>
      <xsl:when test="id3/track and number(id3/track) &gt; 0">
        <xsl:call-template name="REPLACE">
          <xsl:with-param name="str_needle">
            <xsl:value-of select="' '"/>
          </xsl:with-param>
          <xsl:with-param name="str_haystack">
            <xsl:value-of select="concat($str_location,substring-after($str_path,$str_subst),'&amp;','t=',id3/track)"/>
          </xsl:with-param>
          <xsl:with-param name="str_to">
            <xsl:value-of select="'%20'"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="REPLACE">
          <xsl:with-param name="str_needle">
            <xsl:value-of select="' '"/>
          </xsl:with-param>
          <xsl:with-param name="str_haystack">
        <xsl:value-of select="concat($str_location,substring-after($str_path,$str_subst),'&amp;','t=',position())"/>
          </xsl:with-param>
          <xsl:with-param name="str_to">
            <xsl:value-of select="'%20'"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="*"/>

  <xsl:template name="REPLACE">
    <xsl:param name="str_needle"/>
    <xsl:param name="str_haystack"/>
    <xsl:param name="str_to"/>
    <xsl:variable name="str_tail" select="substring-after($str_haystack,$str_needle)"/>
    <xsl:choose>
      <xsl:when test="contains($str_haystack,$str_needle)">
        <xsl:value-of select="substring-before($str_haystack,$str_needle)"/>
        <xsl:value-of select="$str_to"/>
        <xsl:if test="string-length($str_tail) &gt; 0">
          <xsl:call-template name="REPLACE">
            <!-- recursive call -->
            <xsl:with-param name="str_needle">
              <xsl:value-of select="$str_needle"/>
            </xsl:with-param>
            <xsl:with-param name="str_haystack">
              <xsl:value-of select="$str_tail"/>
            </xsl:with-param>
            <xsl:with-param name="str_to">
              <xsl:value-of select="$str_to"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str_haystack"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
