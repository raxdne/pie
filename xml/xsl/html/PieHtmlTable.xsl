<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pkg="http://www.tenbusch.info/pkg" version="1.0">

  <xsl:import href="./PieHtml.xsl"/>

  <xsl:template match="block">
    <xsl:element name="div">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="section">
    <xsl:if test="parent::section">
      <xsl:text> :: </xsl:text>
    </xsl:if>
    <xsl:element name="i">
      <xsl:apply-templates select="h"/>
    </xsl:element>
    <xsl:apply-templates select="*[not(name()='h')]|text()"/>
  </xsl:template>

  <xsl:template match="task_YYY">
    <!-- task element in a calendar table/tbody/tr/td -->
    <xsl:call-template name="TASK"/>
  </xsl:template>

  <xsl:template name="TASK">
    <!-- callable for task element -->
    <xsl:element name="span">
      <xsl:call-template name="ADDSTYLE"/>
      <xsl:call-template name="CLASSATRIBUTE"/>
      <xsl:if test="@xpath">
	<xsl:attribute name="id">
	  <xsl:value-of select="translate(@xpath,'/*[]','_')"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:element name="span">
	<xsl:call-template name="MENUSET"/>
	<xsl:call-template name="FORMATTASKPREFIX"/>
	<xsl:apply-templates select="h"/>
      </xsl:element>
      <xsl:apply-templates select="p|list"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="list">
    <xsl:apply-templates select="p|list[not(@hidden) or @hidden &lt;= $level_hidden]"/>
  </xsl:template>

  <xsl:template match="p">
    <xsl:if test="not(@hidden)">
      <xsl:text> / </xsl:text>
      <xsl:element name="span">
	<xsl:call-template name="CLASSATRIBUTE"/>
	<xsl:call-template name="ADDSTYLE"/>
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="meta">
    <xsl:if test="count(error/*) &gt; 0">
      <xsl:element name="h2">Calendar Errors</xsl:element>
      <xsl:apply-templates select="error/*"/>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
