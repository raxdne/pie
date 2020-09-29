<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" version="1.0" encoding="UTF-8"/>
  <xsl:variable name="flag_spacing" select="true()"/>
  <xsl:variable name="int_depth" select="-1"/>
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="pie">
	<xsl:apply-templates select="pie/file/map/*"/>
      </xsl:when>
      <xsl:when test="file">
	<xsl:apply-templates select="file/map/*"/>
      </xsl:when>
      <xsl:when test="node">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="map/*"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="node">
    <xsl:call-template name="TREELINE">
      <xsl:with-param name="str_spaces">
	<xsl:text>  </xsl:text>
      </xsl:with-param>
      <xsl:with-param name="flag_spacing" select="$flag_spacing"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="TREELINE">
    <xsl:param name="str_prefix" select="''"/>
    <xsl:param name="str_spaces" select="'  '"/>
    <xsl:param name="flag_spacing" select="false()"/>
    <xsl:choose>
      <xsl:when test="self::node[$int_depth &gt; -1 and count(ancestor-or-self::node) &gt; $int_depth]"/>
      <xsl:when test="self::node[@FOLDED='true' or icon[contains(@BUILTIN, 'cancel')]]"/>
      <xsl:when test="self::node">
	<xsl:if test="$flag_spacing">
          <xsl:value-of select="concat($str_prefix,$str_spaces,'│&#10;')"/>
	</xsl:if>
        <xsl:value-of select="concat($str_prefix,$str_spaces)"/>
        <xsl:choose>
          <xsl:when test="following-sibling::node[not(@FOLDED='true') and not(icon[contains(@BUILTIN, 'cancel')])]">
            <xsl:text>├─</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>└─</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <!--
	<xsl:choose>
	  <xsl:when test="icon[@BUILTIN='list']">
	    <xsl:text> &#x02610;</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	  </xsl:otherwise>
	  </xsl:choose>
	-->
        <xsl:value-of select="concat(' ',normalize-space(@TEXT),'&#10;')"/>
        <xsl:for-each select="node[@TEXT]">
          <xsl:call-template name="TREELINE">
            <xsl:with-param name="str_prefix">
              <xsl:choose>
                <xsl:when test="parent::node/following-sibling::node[not(@FOLDED='true') and not(icon[contains(@BUILTIN, 'cancel')])]">
                  <xsl:value-of select="concat($str_prefix,$str_spaces,'│')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat($str_prefix,$str_spaces,' ')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="str_spaces">
              <xsl:value-of select="$str_spaces"/>
            </xsl:with-param>
	    <xsl:with-param name="flag_spacing" select="$flag_spacing"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="node[@TEXT]">
          <xsl:call-template name="TREELINE">
            <xsl:with-param name="str_prefix">
              <xsl:value-of select="$str_prefix"/>
            </xsl:with-param>
            <xsl:with-param name="str_spaces">
              <xsl:value-of select="$str_spaces"/>
            </xsl:with-param>
	    <xsl:with-param name="flag_spacing" select="$flag_spacing"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
