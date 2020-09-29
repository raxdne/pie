<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method='text' encoding='UTF-8'/>

<xsl:decimal-format name="f1" grouping-separator="." decimal-separator=","/>

<xsl:variable name="flag_details" select="true()"/>
<xsl:variable name="length_max" select="25"/>
<xsl:variable name="str_unit" select="'Tage'"/>

<xsl:variable name="tabulator">
  <xsl:text>	</xsl:text>
</xsl:variable>

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="font">Helvetica</xsl:variable>

<xsl:variable name="dot_header">
  <xsl:text>// </xsl:text><xsl:value-of select="name"/>

<xsl:text>
digraph pkg2 {
//overlap=&quot;false&quot;;
//splines=&quot;true&quot;;
//Damping=&quot;0.5&quot;;
//ratio = &quot;fill&quot;;
fontsize = &quot;8&quot;
</xsl:text>

<xsl:text>  fontname = &quot;</xsl:text>
<xsl:value-of select="$font"/>
<xsl:text>&quot;
</xsl:text>

<xsl:text>label = &quot;(C) </xsl:text>
<xsl:value-of select="COPYRIGHT"/>
<xsl:text>&quot;
</xsl:text>

<xsl:text>

node [
  fixedsize= &quot;true&quot;
  shape = &quot;box&quot;
  fontsize = &quot;8&quot;
</xsl:text>

<xsl:text>  fontname = &quot;</xsl:text>
<xsl:value-of select="$font"/>
<xsl:text>&quot;
</xsl:text>

<xsl:text>
];

</xsl:text>
</xsl:variable>


<xsl:variable name="dot_footer">
<xsl:text>
} // end of graph </xsl:text>
</xsl:variable>


<xsl:template match="/pie">
  <xsl:value-of select="$dot_header"/>
  <xsl:apply-templates select="section"/>
  <xsl:value-of select="$dot_footer"/>
  <xsl:value-of select="$newline"/>
</xsl:template>


<xsl:template match="section[count(ancestor::section) = 0]">
  <!-- Projekt -->
  <xsl:apply-templates select="section"/>
</xsl:template>


<xsl:template match="section[count(ancestor::section) = 1]">
  <!-- TP -->
  <xsl:text>
subgraph cluster</xsl:text><xsl:value-of select="position()"/><xsl:text> {
  label=&quot;</xsl:text>
    <xsl:value-of select="h"/><xsl:text>&quot;
</xsl:text>
  <xsl:apply-templates select="section"/>
<xsl:text>
} // end of graph </xsl:text>
</xsl:template>


<xsl:template match="section[count(ancestor::section) = 2]">
  <!-- HAP -->
  <xsl:for-each select="section">
    <xsl:text>&quot;</xsl:text>
    <xsl:value-of select="../../h"/>
    <xsl:text>::</xsl:text>
    <xsl:value-of select="../h"/>
    <xsl:text>::</xsl:text>
    <xsl:value-of select="h"/>
    <xsl:text>&quot;</xsl:text>
    <xsl:call-template name="LABEL">
      <xsl:with-param name="str_label" select="h"/>
    </xsl:call-template>
    <xsl:value-of select="$newline"/>
  </xsl:for-each>
  <xsl:value-of select="$newline"/>
  <xsl:for-each select="section">
    <xsl:text>&quot;</xsl:text>
    <xsl:value-of select="../../h"/>
    <xsl:text>::</xsl:text>
    <xsl:value-of select="../h"/>
    <xsl:text>::</xsl:text>
    <xsl:value-of select="h"/>
    <xsl:text>&quot;</xsl:text>
    <xsl:if test="position() &lt; last()">
      <xsl:text> -> </xsl:text>
    </xsl:if>
  </xsl:for-each>
  <xsl:value-of select="$newline"/>
</xsl:template>


<xsl:template match="section">
  <!-- ignore -->
</xsl:template>


<xsl:template name="LABEL"><!-- code from pkg2/xsl/dot/Graph.xsl -->
  <xsl:param name="str_label"/>
  <xsl:text> [label = &quot;</xsl:text>

<xsl:choose>
  <xsl:when test="contains($str_label,' ')">
    <xsl:value-of select="substring-before($str_label,' ')"/>
    <xsl:text>\n</xsl:text>
    <xsl:variable name="next" select="substring-after($str_label,' ')"/>
    <xsl:choose>
      <xsl:when test="contains($next,' ')">
        <xsl:value-of select="substring-before($next,' ')"/>
        <xsl:text>\n</xsl:text>
        <xsl:variable name="nnext" select="substring-after($next,' ')"/>
        <xsl:value-of select="substring($nnext,0,$length_max)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($next,0,$length_max)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>

  <xsl:when test="contains($str_label,'-')">
    <xsl:value-of select="substring-before($str_label,'-')"/>
    <xsl:text>-\n</xsl:text>
    <xsl:variable name="next" select="substring-after($str_label,'-')"/>
    <xsl:choose>
      <xsl:when test="contains($next,'-')">
        <xsl:value-of select="substring-before($next,'-')"/>
        <xsl:text>-\n</xsl:text>
        <xsl:variable name="nnext" select="substring-after($next,'-')"/>
        <xsl:value-of select="substring($nnext,0,$length_max)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($next,0,$length_max)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>

  <xsl:otherwise>
    <xsl:value-of select="substring($str_label,0,$length_max)"/>
  </xsl:otherwise>
</xsl:choose>
  <xsl:text>&quot;]</xsl:text>
</xsl:template>

<xsl:template match="/PIEZZ">
  <xsl:value-of select="$dot_header"/>
  <xsl:for-each select="//task">
    <xsl:text>&quot;</xsl:text>
    <xsl:value-of select="../../h"/>
    <xsl:text>::</xsl:text>
    <xsl:value-of select="../h"/>
    <xsl:text>::</xsl:text>
    <xsl:value-of select="h"/>
    <xsl:text>&quot;</xsl:text>
    <xsl:if test="position() &lt; last()">
      <xsl:text> -- </xsl:text>
    </xsl:if>
  </xsl:for-each>
  <xsl:value-of select="$dot_footer"/>
  <xsl:value-of select="$newline"/>
</xsl:template>

</xsl:stylesheet>
