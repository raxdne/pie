<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- Printable table format of a calendar, no hyperlinks etc. -->
  <xsl:output encoding="UTF-8" method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" media-type="text/html"/>
  <xsl:variable name="year" select="''"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="body">
        <xsl:element name="table">
          <xsl:element name="tbody">
            <xsl:apply-templates/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="calendar">
    <xsl:choose>
      <xsl:when test="$year = ''">
        <xsl:apply-templates select="year"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="year[@ad = $year]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="year">
    <xsl:apply-templates select="week"/>
  </xsl:template>
  <xsl:template match="week">
    <xsl:variable name="year_nr" select="ancestor::year/@ad"/>
    <xsl:variable name="week_nr" select="@nr"/>
    <xsl:element name="tr">
      <xsl:element name="th">
        <xsl:element name="p">
          <xsl:text> </xsl:text>
        </xsl:element>
      </xsl:element>
      <xsl:element name="th">
        <xsl:element name="p">
          <xsl:value-of select="$week_nr"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="$year_nr"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
    <xsl:apply-templates select="//day[@cw=$week_nr and ancestor::year/@ad=$year_nr]"/>
  </xsl:template>
  <xsl:template match="day">
    <xsl:element name="tr">
      <xsl:element name="td">
        <xsl:apply-templates select="col/descendant::*[name()='p']">
          <xsl:sort select="."/>
        </xsl:apply-templates>
      </xsl:element>
      <xsl:element name="td">
        <!-- <xsl:attribute name="valign">top</xsl:attribute> -->
        <xsl:element name="p">
          <xsl:value-of select="@own"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="@om"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="../@nr"/>
          <xsl:text>.</xsl:text>
        </xsl:element>
      </xsl:element>
    </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
