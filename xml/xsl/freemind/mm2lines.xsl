<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- writes all Freemind nodes into a plain line format -->
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:variable name="str_sep" select="' :: '"/>
  <xsl:template match="/">
    <xsl:for-each select="//*[name()='node' and @TEXT and not(child::node)]">
      <xsl:for-each select="ancestor-or-self::*[name()='node' and (position() &lt; last() - 1) and @TEXT]">
        <xsl:if test="position() &gt; 1">
          <xsl:value-of select="$str_sep"/>
        </xsl:if>
        <xsl:value-of select="translate(normalize-space(@TEXT),'&quot;',' ')"/>
      </xsl:for-each>
      <xsl:value-of select="concat('','&#10;')"/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
