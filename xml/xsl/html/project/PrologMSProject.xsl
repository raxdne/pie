<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../../Utils.xsl"/>

<xsl:output method='text'/>

<xsl:decimal-format name="f1" grouping-separator="." decimal-separator=","/>

<xsl:variable name="flag_ap" select="false()"/>

<xsl:variable name="flag_details" select="false()"/>

<xsl:variable name="str_unit" select="'Tage'"/>
<!--  -->
<xsl:variable name="multiplier_effort" select="1.0"/>
<!--  -->
<xsl:variable name="str_res" select="''"/>

<xsl:template match="/pie">
  <xsl:apply-templates select="section"/>
</xsl:template>


<xsl:template match="section[count(ancestor::section) = 0]">
  <!-- Projekt -->
  <xsl:value-of select="$tabulator"/>
  <xsl:text>Projekt: </xsl:text>
  <xsl:call-template name="lf2br">
    <xsl:with-param name="StringToTransform" select="h"/>
  </xsl:call-template>
  <xsl:value-of select="$tabulator"/>
  <xsl:value-of select="$tabulator"/>
  <xsl:value-of select="$tabulator"/>
  <xsl:value-of select="$newline"/>
  <xsl:apply-templates select="section"/>
  <xsl:if test="$flag_ap">
    <xsl:call-template name="MILESTONE">
      <!-- //section[@date] -->
      <xsl:with-param name="ms" select="//section[count(ancestor::section) &lt; 2]"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template match="section[count(ancestor::section) = 1]">
  <!-- TP -->
  <xsl:value-of select="$tabulator"/>
  <xsl:text>TP: </xsl:text>
  <xsl:call-template name="lf2br">
    <xsl:with-param name="StringToTransform" select="h"/>
  </xsl:call-template>
  <xsl:value-of select="$newline"/>
  <xsl:apply-templates select="section"/>
  <xsl:if test="not($flag_ap)">
    <xsl:call-template name="MILESTONE">
      <xsl:with-param name="ms" select="."/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template match="section[count(ancestor::section) = 2]">
  <!-- HAP -->
  <xsl:value-of select="$tabulator"/>
  <xsl:text>HAP: </xsl:text>
  <xsl:call-template name="lf2br">
    <xsl:with-param name="StringToTransform" select="h"/>
  </xsl:call-template>
  <xsl:choose>
    <xsl:when test="$flag_ap">
      <xsl:value-of select="$newline"/>
      <xsl:apply-templates select="section"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$tabulator"/>
      <!-- value for Effort -->
      <xsl:if test="descendant::task/@effort">
        <!--  -->
        <xsl:value-of select="format-number($multiplier_effort * sum(descendant::task/@effort),'#.##0,00','f1')"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$str_unit"/>
      </xsl:if>
      <xsl:value-of select="$tabulator"/>
      <xsl:value-of select="$str_res"/>
      <xsl:value-of select="$newline"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="section[count(ancestor::section) = 3]">
  <!-- AP -->
  <xsl:if test="$flag_ap">
    <xsl:value-of select="$tabulator"/>
    <xsl:text>AP: </xsl:text>
    <xsl:call-template name="lf2br">
      <xsl:with-param name="StringToTransform" select="h"/>
    </xsl:call-template>
    <xsl:if test="$flag_details and child::task">
      <!-- additional informations -->
      <xsl:text> (</xsl:text>
      <xsl:for-each select="task">
        <xsl:value-of select="h"/>
        <xsl:text>, </xsl:text>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:value-of select="$tabulator"/>
    <!-- value for Effort -->
    <xsl:if test="descendant::task/@effort">
      <!--  -->
      <xsl:value-of select="format-number($multiplier_effort * sum(descendant::task/@effort),'#.##0,00','f1')"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$str_unit"/>
    </xsl:if>
    <xsl:if test="false()">
      <xsl:value-of select="$tabulator"/>
      <xsl:value-of select="$tabulator"/>
    </xsl:if>
    <!-- predecessor -->
    <xsl:value-of select="$tabulator"/>
    <xsl:if test="preceding-sibling::section">
      <xsl:variable name="count_ancestor" select="count(ancestor::section)"/>
      <xsl:value-of select="count(preceding::section[count(ancestor::section) &lt;= $count_ancestor]) + $count_ancestor"/>
    </xsl:if>
    <!-- value for responsible -->
    <xsl:value-of select="$tabulator"/>
    <xsl:if test="true()">
      <!--  -->
      <xsl:value-of select="$str_res"/>
    </xsl:if>
    <xsl:value-of select="$newline"/>
  </xsl:if>
</xsl:template>


<xsl:template match="section">
  <!-- ignore -->
</xsl:template>

<!-- write a list of project milestone templates -->
<xsl:template name="MILESTONE">
  <xsl:param name="ms"/>
  <xsl:for-each select="$ms">
    <xsl:value-of select="$tabulator"/>
    <xsl:text>MS: Abschluss </xsl:text>
    <xsl:call-template name="lf2br">
      <xsl:with-param name="StringToTransform" select="h"/>
    </xsl:call-template>
    <xsl:value-of select="$tabulator"/>
    <xsl:value-of select="format-number(0,'#.##0,00','f1')"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$str_unit"/>
    <xsl:value-of select="$newline"/>
  </xsl:for-each>
</xsl:template>


</xsl:stylesheet>
