<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- similar to 'pie2tab.xsl' -->
  <xsl:variable name="file_css" select="''"/>
  <xsl:variable name="d_max" select="3"/>

  <xsl:output method="html" omit-xml-declaration="yes"/>
  
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="map">
    <xsl:element name="table">
      <xsl:call-template name="THEADER"/>
      <xsl:element name="tbody">
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*">
    <xsl:choose>
      <xsl:when test="count(ancestor::node) &lt; $d_max"><!-- separate header row -->
	<xsl:call-template name="TROWHEAD"/>
	<xsl:call-template name="TROWBLANK"/>
      </xsl:when>
      <xsl:when test="count(ancestor::node) = $d_max">
	<xsl:call-template name="TROWBLOCK"/>
      </xsl:when>
      <xsl:when test="@TEXT"><!-- simple par in a block -->
	<xsl:element name="li">
          <xsl:value-of select="@TEXT"/>
	</xsl:element>
	<xsl:if test="child::node">
	  <xsl:element name="ul">
	    <xsl:apply-templates select="child::*"/>
	  </xsl:element>
	</xsl:if>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="child::*"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="TROWBLOCK">
    <xsl:element name="tr">
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td">
	<xsl:element name="p">
          <xsl:value-of select="@TEXT"/>
	</xsl:element>
	<xsl:element name="ul">
	  <xsl:apply-templates select="child::*"/>
	</xsl:element>
      </xsl:element>
      <xsl:element name="td">
        <xsl:for-each select="htag|tag">
          <xsl:value-of select="."/>
	</xsl:for-each>
      </xsl:element>
      <xsl:element name="td"></xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="TROWHEAD">
    <xsl:element name="tr">
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td">
        <xsl:element name="b">
          <xsl:for-each select="ancestor::node">
            <xsl:value-of select="concat(@TEXT,' :: ')"/>
          </xsl:for-each>
	  <xsl:choose>
	    <xsl:when test="self::node">
              <xsl:value-of select="@TEXT"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:text></xsl:text>
	    </xsl:otherwise>
	  </xsl:choose>
        </xsl:element>
      </xsl:element>
      <xsl:element name="td">
        <xsl:for-each select="htag|tag">
          <xsl:value-of select="."/>
	</xsl:for-each>
      </xsl:element>
      <xsl:element name="td"></xsl:element>
    </xsl:element>
    <xsl:apply-templates select="child::*"/>
  </xsl:template>

  <xsl:template name="TROWBLANK">
    <xsl:element name="tr">
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td">&#x2800;</xsl:element> <!-- invisible blank block -->
      <xsl:element name="td"></xsl:element>
      <xsl:element name="td"></xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="THEADER">
    <xsl:element name="thead">
      <xsl:element name="tr">
	<xsl:element name="th">
          <xsl:text> </xsl:text>
	</xsl:element>
	<xsl:element name="th">
          <xsl:text>&#x2800;</xsl:text>
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
  </xsl:template>

  <xsl:template name="HEADER">
    <xsl:element name="head">
      <xsl:element name="meta">
	<xsl:attribute name="name">
	  <xsl:text>generator</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="content">
	  <xsl:text>cxproc PIE/XML</xsl:text>
	</xsl:attribute>
      </xsl:element>
      <xsl:element name="meta">
	<xsl:attribute name="http-equiv">
	  <xsl:text>cache-control</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="content">
	  <xsl:text>no-cache</xsl:text>
	</xsl:attribute>
      </xsl:element>
      <xsl:element name="meta">
	<xsl:attribute name="http-equiv">
	  <xsl:text>pragma</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="content">
	  <xsl:text>no-cache</xsl:text>
	</xsl:attribute>
      </xsl:element>
      <!-- TODO: str_title -->
      <xsl:element name="title">
	<xsl:choose>
	  <xsl:when test="/pie/section/h">
	    <xsl:value-of select="/pie/section/h"/>
	  </xsl:when>
	  <xsl:when test="/map/node[@TEXT]">
	    <xsl:value-of select="/map/node/@TEXT"/>
	  </xsl:when>
	  <xsl:otherwise>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:element>
    <xsl:element name="style">
body,table {
  background-color:#ffffff;
  font-family: Arial,sans-serif;
  /* font-family:Courier; */
  font-size:12px;
}

table {
  width: 95%;
  border-collapse: collapse;
  margin-left:auto;
  margin-right:auto;
}

tr {
}

td {
  border: 1px solid grey;
  vertical-align:top;
}

th {
  border: 1px solid grey;
  margin-bottom:0px;
  text-align:left;
  background-color:#d9d9d9;
  color:#000000;
  font-weight:bold;
}

p {
 margin: 0px 0px 0px 0px;
}

    </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
