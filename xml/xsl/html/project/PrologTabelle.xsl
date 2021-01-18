<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../PieHtml.xsl"/>

  <!-- -->
  <xsl:variable name="file_norm"></xsl:variable>
  <xsl:variable name="file_css" select="'pie.css'"/>
  <!--  -->
  <xsl:variable name="level_hidden" select="0"/>

<xsl:output method='html' version='1.0' encoding='UTF-8'/>

<xsl:variable name="flag_details" select="true()"/>
<xsl:variable name="str_unit" select="''"/>

<xsl:decimal-format name="f1" grouping-separator="." decimal-separator=","/>

<xsl:template match="/pie">
  <xsl:element name="html">
    <xsl:call-template name="HEADER"/>
    <xsl:element name="body">
      <xsl:element name="table">
        <xsl:attribute name="class">unlined</xsl:attribute>
        <xsl:attribute name="border">0</xsl:attribute>
        <xsl:attribute name="cellpadding">2</xsl:attribute>
        <xsl:element name="tbody">
          <xsl:element name="tr">
            <xsl:element name="th">
              <xsl:attribute name="align">center</xsl:attribute>
              <xsl:attribute name="colspan">3</xsl:attribute>
              <xsl:text>Arbeitspakete im Projekt: </xsl:text>
              <xsl:text> </xsl:text>
              <xsl:value-of select="section/h"/>
            </xsl:element>
          </xsl:element>
          <xsl:apply-templates select="//section[count(ancestor::section) = 3]"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:element>
</xsl:template>


<xsl:template match="section[count(ancestor::section) = 3]">
  <!-- AP -->
  <xsl:param name="pos_tp"/>
  <xsl:param name="pos_hap"/>
  <xsl:element name="tr">
    <xsl:element name="td">
      <xsl:value-of select="position()"/>
    </xsl:element>
    <xsl:element name="td">
      <!--
      <xsl:element name="b">
        <xsl:text>AP_</xsl:text>
        <xsl:value-of select="$pos_tp"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="$pos_hap"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="position()"/>
      </xsl:element>
      -->
      <xsl:for-each select="ancestor::section">
        <xsl:if test="position() &gt; 1">
          <xsl:value-of select="h"/>
          <xsl:text>:: </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:value-of select="h"/>
      <xsl:if test="$flag_details and child::task">
        <!-- additional informations -->
        <xsl:text> (</xsl:text>
        <xsl:for-each select="task">
          <xsl:value-of select="h"/>
          <xsl:text>, </xsl:text>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </xsl:element>
    <xsl:element name="td">
      <!-- value for Effort -->
      <xsl:value-of select="format-number(sum(descendant::task/@effort),'#.##0,00','f1')"/>
      <xsl:value-of select="$str_unit"/>
    </xsl:element>
  </xsl:element>
</xsl:template>


<xsl:template match="section">
  <!-- ignore -->
</xsl:template>


</xsl:stylesheet>
