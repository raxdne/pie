<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- transformation of PIE/XML to an interactive HTML format -->

  <xsl:import href="PieHtml.xsl"/>

  <!--  -->
  <xsl:variable name="flag_simplified" select="false()"/>
  <!-- -->
  <xsl:variable name="file_norm"></xsl:variable>
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
  <!--  -->
  <xsl:variable name="flag_llist"  select="false()"/>
  <!--  -->
  <xsl:variable name="flag_tags"  select="false()"/>
  <!--  -->
  <xsl:variable name="str_tag"></xsl:variable>
  <!--  -->
  <xsl:variable name="toc_display"  select="'none'"/>
  <!--  -->
  <xsl:variable name="str_link_prefix" select="'.'"/>
  <!--  -->
  <xsl:variable name="str_title" select="''"/>

  <xsl:output 
    method="html"
    encoding="UTF-8"
    omit-xml-declaration="no"
    doctype-public="-//W3C//DTD HTML 4.01//EN" />

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="true()">
        <xsl:element name="html">
	  <xsl:if test="$flag_header">
            <xsl:call-template name="HEADER"/>
	  </xsl:if>
          <xsl:element name="body">
            <xsl:if test="$flag_toc">
              <xsl:call-template name="PIETOC">
                <xsl:with-param name="display">
                  <xsl:value-of select="$toc_display"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="$flag_tags">
              <xsl:call-template name="PIETAGCLOUD"/>
            </xsl:if>
            <!-- <xsl:call-template name="METAVARS"/> -->
            <xsl:apply-templates/>
            <xsl:if test="true()">
              <xsl:call-template name="METAFOOTER"/>
            </xsl:if>
            <xsl:if test="$flag_llist">
              <xsl:call-template name="PIELINKLIST"/>
            </xsl:if>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[@valid='no']">
    <!-- ignore this elements -->
  </xsl:template>

  <xsl:template match="meta">
    <!-- ignore this elements -->
  </xsl:template>

  <xsl:template name="METAFOOTER">
    <!--  -->
    <xsl:if test="$flag_footer and /pie/meta/@ctime2">
      <xsl:element name="p">
        <xsl:attribute name="style">text-align:right</xsl:attribute>
        <xsl:value-of select="/pie/meta/@ctime2"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
