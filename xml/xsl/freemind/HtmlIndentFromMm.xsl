<?xml version="1.0" encoding="UTF-8"?>

<!--  --> 

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../Utils.xsl"/>
  <xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>

  <xsl:template match="/map">
    <xsl:element name="html">
      <xsl:element name="head">
        <xsl:element name="title">
          <xsl:value-of select="node/@TEXT"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="body">
        <xsl:element name="pre">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="node">
    <xsl:for-each select="ancestor::node">
      <xsl:text>    </xsl:text>
    </xsl:for-each>  
    <!--       <xsl:value-of select="$tabulator"/> -->
    <xsl:call-template name="lf2br">
      <xsl:with-param name="StringToTransform" select="@TEXT"/>
    </xsl:call-template>
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates select="node"/>
  </xsl:template>

</xsl:stylesheet>
