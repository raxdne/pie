<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:variable name="tabulator">
    <xsl:text>	</xsl:text>
  </xsl:variable>
  <xsl:variable name="newline">
    <xsl:text>
</xsl:text>
  </xsl:variable>
  <xsl:variable name="dot_header">
    <xsl:text>
digraph pkg2 {
  label = "(p) 2013";
  fontname="Helvetica";
  fontsize=10;
  overlap=false;
  layout = "sfdp";
  splines=true;
  node [shape="plaintext",fontname="Helvetica",fontsize=9];
  edge [dir=none,color="#888888"];
</xsl:text>
  </xsl:variable>
  <xsl:variable name="dot_footer">
    <xsl:text>
} // end of graph </xsl:text>
  </xsl:variable>
  <xsl:template match="/">
    <xsl:value-of select="$dot_header"/>
    <xsl:apply-templates select="*"/>
    <xsl:value-of select="$dot_footer"/>
    <xsl:value-of select="$newline"/>
  </xsl:template>
  <xsl:template match="*">
    <xsl:choose>
      <xsl:when test="name()='p' or name()='h'">
        <xsl:variable name="str_display" select="normalize-space(.)"/>
        <xsl:value-of select="concat('  &quot;',$str_display,'&quot;',' [fontname=&quot;Helvetica&quot;,fontsize=19,fontcolor=&quot;#0000FF&quot;]',';',$newline)"/>
        <xsl:for-each select="//h|//p">
          <xsl:variable name="str_display_to" select="normalize-space(.)"/>
          <xsl:choose>
            <xsl:when test="position() &gt; 1">
              <xsl:value-of select="concat($tabulator,'//')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($tabulator,'')"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="concat('&quot;',$str_display,'&quot;',' -&gt; ','&quot;',$str_display_to,'&quot;',';',$newline)"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
