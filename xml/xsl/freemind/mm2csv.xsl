<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- writes all Freemind nodes into a Comma separated format (CSV) -->
  <xsl:output method="text" encoding="ISO-8859-1"/>
  <xsl:variable name="str_sep" select="','"/>
  <xsl:template match="/">
    <xsl:value-of select="concat('sep=',$str_sep,'&#10;')"/>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="node[@TEXT]">
    <!-- -->
    <xsl:value-of select="concat(count(ancestor-or-self::node),$str_sep)"/>
    <xsl:for-each select="ancestor::*[name()='node' and @TEXT]">
      <xsl:value-of select="$str_sep"/>
    </xsl:for-each>
    <xsl:choose>
      <xsl:when test="@LINK">
	<xsl:value-of select="concat('=HYPERLINK(','&quot;',@LINK,'&quot;;&quot;',translate(normalize-space(@TEXT),'&quot;',' '),'&quot;)',$str_sep)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('&quot;',translate(normalize-space(@TEXT),'&quot;',' '),'&quot;',$str_sep)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>
</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
