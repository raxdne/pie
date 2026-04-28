<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- writes all Freemind nodes into a plain line format -->

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:variable name="str_sep" select="'	'"/>

  <xsl:variable name="str_newline">
    <xsl:text>
</xsl:text>
  </xsl:variable>

  <xsl:template match="map">
    <xsl:apply-templates select="child::*[name()='node']"/>
  </xsl:template>

  <xsl:template match="node">
    <xsl:param name="str_tab" select="''"/>
    <xsl:value-of select="concat($str_tab,normalize-space(@TEXT),$str_newline)"/>
    <xsl:apply-templates select="child::*[name()='node']">
      <xsl:with-param name="str_tab" select="concat($str_tab,$str_sep)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*|@*|text()|comment()"/>
  
</xsl:stylesheet>
