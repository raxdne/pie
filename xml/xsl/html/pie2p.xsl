<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!--  -->

<xsl:import href="../Utils.xsl"/>

  <xsl:output method="html" encoding="utf-8"/>

  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="body">
        <xsl:element name="p">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*">
    <xsl:for-each select="child::text()">
      <xsl:variable name="str_text">
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:variable>
      <xsl:if test="not($str_text='') and not($str_text=' ')">
        <xsl:value-of select="concat($str_text,' ')"/>
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates select="child::*"/>
  </xsl:template>

  <xsl:template match="meta|tags|tag|t">
    <!-- ignore this elements -->
  </xsl:template>

</xsl:stylesheet>
