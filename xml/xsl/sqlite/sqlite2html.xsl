<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:variable name="flag_result" select="//result"/>
  <xsl:variable name="dir_plain" select="''"/>
  <xsl:variable name="file_css" select="'pie.css'"/>
  <xsl:variable name="prefix_tmp" select="''"/>
  <xsl:variable name="prefix_tmpi" select="translate($prefix_tmp,'\','/')"/>
  <xsl:output method="html" encoding="UTF-8"/>
  <!--  -->
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="head">
        <xsl:element name="link">
          <xsl:attribute name="rel">
            <xsl:text>stylesheet</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="media">
            <xsl:text>screen, print</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="type">
            <xsl:text>text/css</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$file_css"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:element>
      <xsl:element name="body">
        <xsl:apply-templates select="sql|file|pie/*"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="sql|file">
    <xsl:apply-templates select="table|db"/>
  </xsl:template>
  <xsl:template match="db">
    <xsl:variable name="dir_name">
      <xsl:for-each select="ancestor::dir">
        <xsl:if test="@prefix">
          <xsl:value-of select="@prefix"/>
          <xsl:text>/</xsl:text>
        </xsl:if>
        <xsl:value-of select="@name"/>
        <xsl:text>/</xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <xsl:element name="h3">
      <xsl:value-of select="concat('Database ',@name)"/>
    </xsl:element>
    <xsl:choose>
      <xsl:when test="@name = 'tmp'"/>
      <xsl:when test="starts-with(@name,'_')"/>
      <xsl:when test="starts-with(@name,'.') and not(@name = '.svn')"/>
      <xsl:otherwise>
        <xsl:apply-templates select="table">
          <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="table">
    <xsl:variable name="str_id">
      <xsl:value-of select="concat('localTable-',generate-id())"/>
    </xsl:variable>
    <xsl:element name="p">
      <xsl:choose>
        <xsl:when test="@query">
          <xsl:element name="b">
            <xsl:value-of select="@query"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:value-of select="@name"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    <xsl:element name="table">
      <xsl:attribute name="id">
        <xsl:value-of select="$str_id"/>
      </xsl:attribute>
      <xsl:attribute name="class">
	<xsl:text>tablesorter</xsl:text>
      </xsl:attribute>
      <xsl:element name="thead">
        <xsl:element name="tr">
          <xsl:element name="th">
            <xsl:value-of select="' '"/>
          </xsl:element>
          <xsl:for-each select="declaration/column">
            <xsl:element name="th">
	      <xsl:attribute name="class">
		<xsl:text>{sorter: '</xsl:text>
		<xsl:choose>
		  <xsl:when test="@type = 'REAL'">
		    <xsl:text>digit</xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:text>text</xsl:text>
		  </xsl:otherwise>
		</xsl:choose>
		<xsl:text>'}</xsl:text>
	      </xsl:attribute>
              <xsl:value-of select="concat(@name,' (',@type,')')"/>
	    </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
      <xsl:element name="tbody">
        <xsl:for-each select="entry">
          <xsl:element name="tr">
            <xsl:element name="td">
              <xsl:value-of select="@nr"/>
            </xsl:element>
            <xsl:for-each select="*">
              <xsl:element name="td">
                <xsl:value-of select="."/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
    <xsl:element name="script">
      <xsl:text>$("#</xsl:text>
      <xsl:value-of select="$str_id"/>
      <xsl:text>").tablesorter();</xsl:text>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
