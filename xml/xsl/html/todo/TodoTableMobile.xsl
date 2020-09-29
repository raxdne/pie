<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../PieHtmlMobile.xsl"/>
  <!--  -->
  <xsl:variable name="level_hidden" select="0"/>
  <xsl:output method="html"/>
  <xsl:include href="../../Utils.xsl"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:element name="div">
      <xsl:element name="div">
        <xsl:attribute name="data-role">page</xsl:attribute>
        <xsl:attribute name="id">p0</xsl:attribute>
        <xsl:call-template name="PIENAVMOBILEHEADER"/>
        <xsl:element name="div">
          <xsl:attribute name="data-role">content</xsl:attribute>
          <xsl:element name="div">
            <xsl:attribute name="data-role">collapsible-set</xsl:attribute>
            <xsl:call-template name="PIETODO"/>
          </xsl:element>
        </xsl:element>
        <xsl:call-template name="PIENAVMOBILEFOOTER"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="PIETODO">
    <xsl:for-each select="//section[child::task[not(@done) and not(@valid = 'no')] or child::list[descendant::task[not(@done) and not(@valid = 'no')]]]">
      <xsl:element name="div">
        <xsl:attribute name="data-role">collapsible</xsl:attribute>
        <xsl:attribute name="data-collapsed">true</xsl:attribute>
        <xsl:element name="h1">
          <xsl:for-each select="ancestor-or-self::section">
            <xsl:if test="position() &gt; 1 and child::h">
              <xsl:value-of select="h"/>
              <xsl:text> :: </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:element>
        <xsl:element name="ol">
          <xsl:for-each select="child::task|child::list/descendant::task">
            <xsl:call-template name="TASK">
              <xsl:with-param name="flag_line" select="true()"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
