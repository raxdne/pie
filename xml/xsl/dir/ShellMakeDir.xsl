<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" encoding="CP1252"/>
  <xsl:variable name="newline">
<!-- a newline xsl:text element -->
    <xsl:text>
</xsl:text>
  </xsl:variable>
  <xsl:variable name="l_max" select="60"/>
  <xsl:variable name="str_separator" select="'\'"/>
  <xsl:variable name="str_command" select="'mkdir'"/>
  <xsl:template match="/map">
    <xsl:for-each select="//node[@TEXT and not(@TEXT='') and not(@FOLDED='true') and not(icon[contains(@BUILTIN, 'cancel')])]">
      <xsl:value-of select="concat($str_command,' ','&quot;','')"/>
      <xsl:for-each select="ancestor-or-self::node[not(@TEXT='')]">
        <xsl:if test="position() &gt; 1">
          <xsl:value-of select="$str_separator"/>
        </xsl:if>
        <xsl:value-of select="substring(normalize-space(@TEXT),1,$l_max)"/>
      </xsl:for-each>
      <xsl:value-of select="concat('','&quot;',$newline)"/>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="/pie[@class='directory']">
    <xsl:for-each select="//dir[@name and not(@name='')]">
      <xsl:value-of select="concat($str_command,' ','&quot;','')"/>
      <xsl:for-each select="ancestor-or-self::dir[not(@name='')]">
        <xsl:if test="position() &gt; 1">
          <xsl:value-of select="$str_separator"/>
        </xsl:if>
        <xsl:value-of select="substring(normalize-space(@name),1,$l_max)"/>
      </xsl:for-each>
      <xsl:value-of select="concat('','&quot;',$newline)"/>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="/pie[@class='article' or not(@class)]">
    <xsl:for-each select="//section[h and not(h='')]">
      <xsl:value-of select="concat($str_command,' ','&quot;','')"/>
      <xsl:for-each select="ancestor-or-self::section[not(h='')]"><!-- @valid -->
        <xsl:if test="position() &gt; 1">
          <xsl:value-of select="$str_separator"/>
        </xsl:if>
        <xsl:value-of select="translate(substring(normalize-space(h),1,$l_max),'&quot;/\:„“‚‘','________')"/>
      </xsl:for-each>
      <xsl:value-of select="concat('','&quot;',$newline)"/>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="*|text()|comment()"/>
</xsl:stylesheet>
