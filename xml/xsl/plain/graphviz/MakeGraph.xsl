<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="config.xsl"/>

<xsl:output method='text' encoding='UTF-8'/>

<xsl:variable name="tabulator">
  <xsl:text>	</xsl:text>
</xsl:variable>

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="font">Helvetica</xsl:variable>

<xsl:variable name="dot_header">
  <xsl:text>// </xsl:text><xsl:value-of select="NAME"/>

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


<xsl:template match="/MAKE">
  <xsl:value-of select="$dot_header"/>
  <xsl:apply-templates select="*"/>
  <xsl:value-of select="$dot_footer"/>
  <xsl:value-of select="$newline"/>
</xsl:template>


<xsl:template match="*">
  <!-- -->
  <xsl:variable name="label_self">
    <xsl:text>&quot;</xsl:text>
    <xsl:value-of select="@NAME"/>
    <xsl:text>&quot;</xsl:text>
  </xsl:variable>

  <xsl:variable name="label_function">
    <xsl:text>&quot;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>&quot;</xsl:text>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="count(*) &gt; 0 and not(name()='XSL')">
      <!-- there are childrens -->
      <xsl:value-of select="$label_function"/>
      <xsl:text> -&gt; </xsl:text>
      <xsl:value-of select="$label_self"/>
      <xsl:value-of select="$newline"/>
      <!-- -->
      <xsl:for-each select="*">
        <xsl:value-of select="$label_self"/>
        <xsl:text> -&gt; </xsl:text>
        <xsl:value-of select="$newline"/>
      </xsl:for-each>
      <xsl:apply-templates select="*"/>
      <xsl:value-of select="$newline"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$label_self"/>
      <xsl:text> -&gt; </xsl:text>
      <xsl:value-of select="$label_function"/>
      <xsl:value-of select="$newline"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


</xsl:stylesheet>
