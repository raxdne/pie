<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../PieHtml.xsl"/>
  <!--  -->
  <xsl:variable name="file_css" select="'pie.css'"/>

  <xsl:output encoding="UTF-8" method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" media-type="text/html"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
        <xsl:apply-templates select="calendar"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="calendar">
    <!--  -->
            <xsl:apply-templates select="year"/>
  </xsl:template>

  <xsl:template match="year">

    <xsl:element name="table">
      <xsl:element name="tbody">
        <!--  -->

    <xsl:element name="tr">
      <xsl:element name="th">
          <xsl:attribute name="class">marker</xsl:attribute>
        <xsl:attribute name="colspan">12</xsl:attribute>
          <xsl:value-of select="@ad"/>
      </xsl:element>
    </xsl:element>
    <xsl:apply-templates select="month"/>
    <!-- -->
      </xsl:element>
    </xsl:element>

   </xsl:template>
  <xsl:template match="month">
      <xsl:element name="td">
        <xsl:attribute name="valign">top</xsl:attribute>
    <xsl:element name="table">
          <xsl:attribute name="width">100%</xsl:attribute>
      <xsl:element name="tbody">
        <!--  -->

    <xsl:element name="tr">
      <xsl:element name="th">
          <xsl:attribute name="class">marker</xsl:attribute>
        <xsl:attribute name="colspan">2</xsl:attribute>
        <!-- label -->
            <xsl:value-of select="@name"/>
      </xsl:element>
    </xsl:element>
    <!-- -->
    <xsl:apply-templates select="day"/>
    <!-- -->
      </xsl:element>
    </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="day">

      <xsl:element name="tr">
      <xsl:element name="td">
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="descendant::*[@holiday = 'yes']">
                <xsl:text>sat</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@own"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>

        <!-- -->
            <xsl:value-of select="concat(@om,'. ',substring(@own,1,2))"/>
      </xsl:element>
        <!--
      <xsl:element name="td">
        <xsl:attribute name="width">70%</xsl:attribute>
      </xsl:element>
 -->
      </xsl:element>

  </xsl:template>

  <xsl:template match="meta|col"/>
</xsl:stylesheet>
