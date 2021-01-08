<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="PieHtmlMobile.xsl"/>
  <!-- -->
  <xsl:variable name="file_css" select="''"/>
  <!-- cancel tree -->
  <xsl:variable name="flag_toc" select="true()"/>
  <!--  -->
  <xsl:variable name="flag_header" select="true()"/>
  <!--  -->
  <xsl:variable name="flag_footer" select="true()"/>
  <!--  -->
  <xsl:variable name="flag_fig" select="true()"/>
  <!--  -->
  <xsl:variable name="level_hidden" select="0"/>

  <xsl:variable name="flag_llist"  select="false()"/>

  <xsl:variable name="str_tag"  select="''"/>

  <xsl:variable name="toc_display"  select="'none'"/>
  <!--  -->
  <xsl:variable name="str_link_prefix" select="'.'"/>

  <xsl:output 
    method="html"
    encoding="UTF-8"
    omit-xml-declaration="no"
    doctype-public="-//W3C//DTD HTML 4.01//EN" />

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
            <xsl:apply-templates />
          </xsl:element>
        </xsl:element>
        <xsl:call-template name="PIENAVMOBILEFOOTER"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
