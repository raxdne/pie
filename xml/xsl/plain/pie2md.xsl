<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="PiePlain.xsl"/>

  <xsl:variable name="flag_md" select="true()"/>
  
  <xsl:output method="text" encoding="UTF-8"/>
  
  <xsl:template match="section">
    <xsl:variable name="str_markup">
      <xsl:for-each select="ancestor-or-self::section">
	<xsl:text>#</xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="concat($newpar,$str_markup,' ')"/>
    <xsl:apply-templates select="child::h"/>
    <xsl:value-of select="concat(' ',$str_markup)"/>
    <xsl:apply-templates select="*[not(name(.) = 'h')]|text()|comment()"/>
  </xsl:template>

  <xsl:template match="list">
    <xsl:if test="parent::section">
      <xsl:value-of select="$newline"/>
    </xsl:if>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="p|task">
    <xsl:value-of select="$newline"/>
    <xsl:choose>
      <xsl:when test="parent::list or parent::task">
	<xsl:call-template name="FORMATPREFIX"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$newline"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="self::task">
	<xsl:call-template name="FORMATTASKPREFIX"/>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates />
  </xsl:template>
  
  <xsl:template match="pre">
    <xsl:value-of select="concat($newpar,'~~~',$newline,.,$newline,'~~~',$newline)"/>
  </xsl:template>
  
  <xsl:template name="FORMATPREFIX">
    <xsl:for-each select="ancestor::list[position() &gt; 1]">
      <xsl:if test="attribute::enum = 'yes'">
	<!-- eumerated -->
	<xsl:text> </xsl:text>
      </xsl:if>
      <xsl:text>  </xsl:text>
    </xsl:for-each>
    <xsl:choose>
      <xsl:when test="parent::list/attribute::enum = 'yes'">
        <!-- eumerated -->
	<xsl:text>1)</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>-</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="t|meta">
    <!-- ignore nodes -->
  </xsl:template>

</xsl:stylesheet>
