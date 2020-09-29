<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../Utils.xsl"/>

  <xsl:output method='text' encoding='UTF-8'/>

  <xsl:template match="/">
    <xsl:apply-templates select="//node[attribute[@NAME='date' and not(@VALUE='')]]"/>
  </xsl:template>

  <xsl:template match="node">
    <xsl:value-of select="attribute[@NAME='date']/@VALUE"/>
    <xsl:text> </xsl:text> 
    <xsl:for-each select="ancestor-or-self::node[@TEXT]">
      <xsl:if test="position() &gt; 1">
        <xsl:text> :: </xsl:text> 
      </xsl:if>
      <xsl:call-template name="lf2br">
        <xsl:with-param name="StringToTransform" select="@TEXT"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>
