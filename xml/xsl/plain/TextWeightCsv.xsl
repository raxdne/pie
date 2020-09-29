<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" encoding="iso-8859-1"/>
  <!--    -->
  <xsl:variable name="str_sep" select="';'"/>
  <xsl:variable name="int_depth" select="2"/>
  <xsl:template match="/">
    <xsl:value-of select="concat('sep=',$str_sep,'&#10;')"/>
    <xsl:apply-templates select="//section[count(ancestor::*) = $int_depth]"/>
  </xsl:template>
  <xsl:template match="section">
    <xsl:variable name="int_size">
      <xsl:value-of select="count(descendant::task[not(@done)])"/>
    </xsl:variable>
    <xsl:variable name="str_name">
      <xsl:for-each select="ancestor-or-self::section">
	<xsl:choose>
          <xsl:when test="h">
            <xsl:value-of select="concat(' :: ',translate(normalize-space(h),'&quot;','_'))"/>
          </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <!--  -->
    <xsl:if test="$int_size &gt; 1">
      <xsl:value-of select="concat('&quot;',$str_name,'&quot;',$str_sep,$int_size,'&#10;')"/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
