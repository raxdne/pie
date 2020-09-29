<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:cxp="http://www.tenbusch.info/cxproc" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:template match="/">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates select="map|pie"/>
    <xsl:text>]</xsl:text>
  </xsl:template>
  <xsl:template match="map">
    <xsl:variable name="flag_section" select="count(descendant::font[@BOLD='true']) + count(descendant::icon[@BUILTIN='list']) &gt; 0"/>
    <xsl:variable name="h_max" select="3"/>
    <xsl:variable name="depth" select="count(ancestor::node)"/>
    <!-- !!! to synchronize with "mm2pie.xsl" !!! -->
    <xsl:for-each select="//node[@TEXT and not(ancestor-or-self::node[contains(icon/@BUILTIN,'cancel')]) and not(ancestor-or-self::node[@FOLDED='true']) and not(icon[@BUILTIN='list']) and (($flag_section=true() and (font/@BOLD='true' or descendant::font/@BOLD='true' or descendant::icon/@BUILTIN='list')) or ($flag_section=false() and $depth &lt; $h_max))]">
      <xsl:variable name="str_header" select="translate(normalize-space(@TEXT),'&quot;','_')"/>
      <xsl:if test="position() &gt; 1">
        <xsl:value-of select="','"/>
      </xsl:if>
      <xsl:value-of select="concat('{','xpath',' : ','&quot;',@xpath,'&quot;',',')"/>
      <xsl:value-of select="concat('intIndent',' : ',count(ancestor::node[@TEXT]),',')"/>
      <xsl:value-of select="concat('strHeader',' : ','&quot;',$str_header,'&quot;','}')"/>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:for-each select="//section[h and not(ancestor-or-self::section[@valid='no'])]">
      <xsl:variable name="str_header" select="translate(normalize-space(h),'&quot;','_')"/>
      <xsl:if test="position() &gt; 1">
        <xsl:value-of select="','"/>
      </xsl:if>
      <xsl:value-of select="concat('{','xpath',' : ','&quot;',@xpath,'&quot;',',')"/>
      <xsl:value-of select="concat('intIndent',' : ',count(ancestor::section[h]),',')"/>
      <xsl:value-of select="concat('strHeader',' : ','&quot;',$str_header,'&quot;','}')"/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
