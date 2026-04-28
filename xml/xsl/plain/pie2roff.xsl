<?xml version="1.0" encoding="UTF-8"?>

<!-- s. http://troff.org/papers.html https://github.com/bwarken/roff_classical -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" encoding="UTF-8"/>

<xsl:variable name="newpar">
<xsl:text>

</xsl:text>
</xsl:variable>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="pie">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="h">
    <xsl:value-of select="concat('.SH ', normalize-space(.), $newpar)"/>
  </xsl:template>
  

  <xsl:template match="section">
    <xsl:apply-templates select="h"/>
    <xsl:apply-templates select="*[not(name(.) = 'h' or name(.) = 't')]"/>
  </xsl:template>

  <xsl:template match="list">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="p">
    <xsl:value-of select="$newpar"/>
  </xsl:template>

  <xsl:template match="pre">
    <xsl:value-of select="$newpar"/>
  </xsl:template>

  <xsl:template match="fig">
    <xsl:text>Abb. </xsl:text>
    <xsl:if test="h">
      <xsl:text> </xsl:text>
      <xsl:value-of select="h"/>
    </xsl:if>
    <xsl:value-of select="$newpar"/>
  </xsl:template>

  <xsl:template match="tag|t">
    <!-- ignore normal text nodes -->
  </xsl:template>


</xsl:stylesheet>
