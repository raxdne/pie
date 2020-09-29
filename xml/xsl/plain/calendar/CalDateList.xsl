<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output encoding="UTF-8" method="text"/>
  <xsl:template match="/">
    <xsl:for-each select="descendant::day">
      <xsl:value-of select="concat(ancestor::year/attribute::ad,'-',ancestor::month/attribute::nr,'-',@om,' ',@own)"/>
      <xsl:text>
</xsl:text>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
