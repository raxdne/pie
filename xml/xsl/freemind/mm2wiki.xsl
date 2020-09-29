<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../Utils.xsl"/>

<xsl:output method='text' version='1.0' encoding='UTF-8'/>

  <xsl:variable name="str_top">
  <xsl:call-template name="lf2br">
    <xsl:with-param name="StringToTransform" select="normalize-space(/map/node[1]/@TEXT)"/>
  </xsl:call-template>
  </xsl:variable>

<xsl:template match="/map">
  <xsl:value-of select="concat('= [[',$str_top,'|',$str_top,']] =',$newline)"/>
  <xsl:apply-templates select="node[1]/*"/>
</xsl:template>

<xsl:template match="node">
  <xsl:variable name="str_markup">
    <xsl:for-each select="ancestor::node">
      <xsl:text>*</xsl:text>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="str_text">
  <xsl:call-template name="lf2br">
    <xsl:with-param name="StringToTransform" select="normalize-space(@TEXT)"/>
  </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat($str_markup,' [[',$str_top,'_',$str_text,'|',$str_text,']]',$newline)"/>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="*|@*|text()"/>

</xsl:stylesheet>
