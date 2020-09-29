<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="PieHtml.xsl"/>
  <!--  -->
  <xsl:variable name="level_hidden" select="0"/>
  <xsl:variable name="flag_done" select="true()"/>
  <xsl:variable name="flag_details" select="true()"/>
  <xsl:variable name="file_css" select="''"/>
  <xsl:output method="html" omit-xml-declaration="yes"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER">
	<xsl:with-param name="list_js" select="'/jquery/jquery.js,/jquery/tablesorter/jquery.tablesorter.js'"/>
      </xsl:call-template>
      <xsl:element name="body">
	<script type="text/javascript">$(document).ready(function() { $("#localTable").tablesorter(); } );</script> 
        <xsl:element name="table">
	  <xsl:attribute name="id">
	    <xsl:text>localTable</xsl:text> <!-- TODO: handle multiple tables -->
	  </xsl:attribute>
	  <xsl:attribute name="class">
	    <xsl:text>tablesorter</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="border">
	    <xsl:text>1</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="width">
	    <xsl:text>100%</xsl:text>
	  </xsl:attribute>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:element name="thead">
      <xsl:element name="tr">
	<xsl:element name="th">
          <xsl:text> </xsl:text>
	</xsl:element>
	<xsl:element name="th">
          <xsl:text>_</xsl:text>
	</xsl:element>
	<xsl:element name="th">
          <xsl:text>Topic</xsl:text>
	</xsl:element>
	<xsl:element name="th">
          <xsl:text>Who?</xsl:text>
	</xsl:element>
	<xsl:element name="th">
          <xsl:text>Due date</xsl:text>
	</xsl:element>
      </xsl:element>
    </xsl:element>
    <xsl:element name="tbody">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="section">
      <!-- separate header row -->
      <xsl:element name="tr">
        <xsl:element name="td">
          <xsl:value-of select="position()"/>
        </xsl:element>
        <xsl:element name="td">
          <xsl:text>_</xsl:text>
        </xsl:element>
        <xsl:element name="td">
          <xsl:element name="b">
            <xsl:choose>
              <xsl:when test="count(ancestor-or-self::section) &lt; 2">
                <!-- top header -->
                <xsl:value-of select="h"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- sub header -->
                <xsl:for-each select="ancestor-or-self::section">
                  <xsl:if test="child::h and position() &gt; 1">
                    <xsl:if test="position() &gt; 2">
                      <xsl:text> :: </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="h"/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
        <xsl:element name="td"></xsl:element>
        <xsl:element name="td"></xsl:element>
      </xsl:element>
    <xsl:apply-templates select="*[not(name(.) = 'h')]"/>
  </xsl:template>
  <xsl:template match="p[parent::section]">
    <xsl:element name="tr">
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td">
        <xsl:apply-templates/>
      </xsl:element>
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td"></xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="list[parent::section]">
    <xsl:element name="tr">
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td">
        <xsl:choose>
          <xsl:when test="@enum = 'yes'">
            <xsl:element name="ol">
              <xsl:apply-templates/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="ul">
              <xsl:apply-templates/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td"></xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="table">
    <xsl:copy-of select="*"/>
  </xsl:template>
  <xsl:template match="fig|pre|vcard">
    <!-- para -->
    <xsl:element name="tr">
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td">I</xsl:element>
      <xsl:element name="td">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="pre">
    <!-- para -->
    <xsl:element name="tr">
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td">I</xsl:element>
      <xsl:element name="td">
        <xsl:copy-of select="."/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="task|target">
    <xsl:if test="$flag_done or not(@done)">
      <!-- valid task element -->
      <xsl:element name="tr">
	<xsl:element name="td"></xsl:element>
        <xsl:element name="td">
          <xsl:choose>
            <xsl:when test="@done">
              <xsl:text>&#x2713;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>A</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
        <xsl:element name="td">
          <xsl:choose>
            <xsl:when test="@done">
              <xsl:element name="i">
                <xsl:apply-templates select="h"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="h"/>
            </xsl:otherwise>
          </xsl:choose>
          <!--  -->
	  <xsl:if test="$flag_details">
            <xsl:apply-templates select="list|p"/>
	  </xsl:if>
        </xsl:element>
        <xsl:element name="td">
          <xsl:for-each select="child::contact[@idref]">
            <xsl:if test="position() &gt; 1">
              <xsl:text>; </xsl:text>
            </xsl:if>
            <xsl:value-of select="@idref"/>
          </xsl:for-each>
        </xsl:element>
        <xsl:element name="td">
          <xsl:choose>
            <xsl:when test="contains(@date,'*w')">
              <xsl:value-of select="concat('KW',substring(@date,7,2),'/',substring(@date,1,4))"/>
            </xsl:when>
            <xsl:when test="@date">
              <xsl:value-of select="concat(substring(@date,1,4),'-',substring(@date,5,2),'-',substring(@date,7,2))"/>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
    </xsl:element>
            </xsl:if>
  </xsl:template>
  <xsl:template match="*[@valid='no']">
    <!-- ignore this elements -->
  </xsl:template>
  <xsl:template match="meta">
    <!-- ignore this elements -->
  </xsl:template>
</xsl:stylesheet>
