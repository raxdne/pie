<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="PiePlain.xsl" />
  <xsl:output method="text" encoding="UTF-8" />
  <xsl:variable name="str_tagtime" select="''" />
  <xsl:template match="/pie">
    <xsl:call-template name="TREE" />
    <xsl:call-template name="TAGTIME">
      <xsl:with-param name="str_tagtime" select="$str_tagtime" />
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>