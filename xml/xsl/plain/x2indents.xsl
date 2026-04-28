<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:variable name="newline">
    <xsl:text>
</xsl:text>
  </xsl:variable>

  <xsl:variable name="l_max" select="-1"/>

  <xsl:variable name="str_pre" select="''"/>

  <xsl:variable name="str_sep" select="'  '"/>

  <xsl:variable name="str_post" select="''"/>

  <xsl:template match="pie[@class='directory']">
    <xsl:choose>
      <xsl:when test="child::file">
	<xsl:apply-templates  select="child::file/child::*"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:for-each select="//dir[@name and not(@name='') and not(ancestor-or-self::archive)]">
	  <xsl:value-of select="$str_pre"/>
	  <xsl:for-each select="ancestor-or-self::dir[not(@name='')]">
            <xsl:if test="position() &gt; 1">
              <xsl:value-of select="$str_sep"/>
            </xsl:if>
	  </xsl:for-each>
	  <xsl:choose>
	    <xsl:when test="$l_max &gt; 0">
	      <xsl:value-of select="substring(normalize-space(@name),1,$l_max)"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="normalize-space(@name)"/>
	    </xsl:otherwise>
	  </xsl:choose>
	  <xsl:value-of select="concat($str_post,$newline)"/>
	</xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="map">
    <xsl:for-each select="//node[@TEXT and not(@TEXT='') and not(@FOLDED='true') and not(icon[contains(@BUILTIN, 'cancel')])]">
      <xsl:value-of select="$str_pre"/>
      <xsl:for-each select="ancestor-or-self::*[name()='node' and (position() &lt; last() - 1) and @TEXT]">
        <xsl:value-of select="$str_sep"/>
        <xsl:if test="position() = last()">
          <xsl:value-of select="normalize-space()"/>
        </xsl:if>
      </xsl:for-each>
      <xsl:choose>
	<xsl:when test="$l_max &gt; 0">
	  <xsl:value-of select="substring(normalize-space(@TEXT),1,$l_max)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="normalize-space(@TEXT)"/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="concat($str_post,$newline)"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="pie[@class='article' or not(@class)]">
    <xsl:for-each select="descendant::*[(name() = 'h' or name() = 'list' or name() = 'p' or name() = 'pre') and not(ancestor::section[@valid='no'])]">
      <xsl:value-of select="$str_pre"/>
      <xsl:for-each select="ancestor::section[not(h='')]">
        <xsl:if test="position() &gt; 1">
          <xsl:value-of select="$str_sep"/>
        </xsl:if>
      </xsl:for-each>
      <xsl:choose>
	<xsl:when test="$l_max &gt; 0">
	  <xsl:value-of select="substring(normalize-space(.),1,$l_max)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="normalize-space(.)"/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="concat($str_post,$newline)"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="*|text()|comment()"/>
  
</xsl:stylesheet>
