<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method='xml' version='1.0'/> <!--  doctype-system="pie.dtd" -->

<xsl:template match="/map">
  <!--
  <xsl:processing-instruction name="xml-stylesheet">
    <xsl:text>href="pie2html.xsl" type="text/xsl"</xsl:text>
  </xsl:processing-instruction>
  -->
  <xsl:element name="pie">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>


<xsl:template match="node">
  <xsl:choose>
    <xsl:when test="attribute[@NAME='effort']">
      <!--  -->
      <xsl:element name="task">
        <xsl:call-template name="CREATEATTRIBUTES"/>
        <xsl:element name="h">
        <xsl:value-of select="@TEXT"/>
      </xsl:element>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:when test="descendant::node[attribute]">
      <!-- only sections when descendant nodes with attributes -->
      <xsl:element name="section">
        <xsl:call-template name="CREATEATTRIBUTES"/>
        <xsl:element name="h">
          <xsl:value-of select="@TEXT"/>
        </xsl:element>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:when test="attribute">
      <!--  -->
      <xsl:element name="link">
        <xsl:call-template name="CREATEATTRIBUTES"/>
        <xsl:value-of select="@TEXT"/>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:when test="ancestor::node[attribute]">
      <!-- ignore nodes when there are ancestors with attributes -->
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*"/>

<xsl:template name="CREATEATTRIBUTES">
  <!-- add all mindmap node attributes --> 
  <xsl:for-each select="attribute">
    <xsl:attribute name="{@NAME}">
      <xsl:value-of select="@VALUE"/>
    </xsl:attribute>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
