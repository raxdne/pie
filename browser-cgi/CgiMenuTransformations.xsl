<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../xsl/Utils.xsl"/>
  <xsl:variable name="type" select="''"/>
  <xsl:variable name="str_path" select="''"/>
  <xsl:variable name="str_xpath" select="'/*'"/>
  <xsl:variable name="str_tag" select="''" />
  <xsl:output method="html"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="body">
        <xsl:element name="h3">
          <xsl:value-of select="concat('Transform ','&quot;',$type,'&quot;',' into')"/>
        </xsl:element>
        <xsl:element name="ul">
          <xsl:apply-templates select="//stelle[not(@id=$type)]">
            <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="h"/>
          </xsl:apply-templates>
        </xsl:element>
        <xsl:element name="p">
          <xsl:attribute name="align">
            <xsl:text>right</xsl:text>
          </xsl:attribute>
          <xsl:text>(Configuration: </xsl:text>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="concat('?','cxp=PetrinetGraph')"/>
            </xsl:attribute>
            <xsl:text>Petrinet</xsl:text>
          </xsl:element>
          <xsl:text>)</xsl:text>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="stelle">
    <xsl:element name="li">
      <xsl:element name="a">
        <xsl:attribute name="target">_blank</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=Format','&amp;','b=')"/>
	  <xsl:call-template name="MIMETYPE">
	    <xsl:with-param name="str_type" select="@id"/>
	  </xsl:call-template>
          <xsl:if test="not($str_xpath='/' or $str_xpath='/*')">
            <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
          </xsl:if>
          <xsl:if test="not($str_tag = '')">
            <xsl:value-of select="concat('&amp;','pattern=',$str_tag)"/>
          </xsl:if>
        </xsl:attribute>
        <xsl:value-of select="h"/>
      </xsl:element>
      <xsl:if test="p">
        <xsl:value-of select="concat(' (',p,')')"/>
      </xsl:if>
      <xsl:text> / </xsl:text>
      <xsl:element name="a">
        <xsl:attribute name="target">_blank</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=ShowTransformations','&amp;','b=')"/>
	  <xsl:call-template name="MIMETYPE">
	    <xsl:with-param name="str_type" select="@id"/>
	  </xsl:call-template>
          <xsl:if test="not($str_xpath='/' or $str_xpath='/*')">
            <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
          </xsl:if>
          <xsl:if test="not($str_tag = '')">
            <xsl:value-of select="concat('&amp;','pattern=',$str_tag)"/>
          </xsl:if>
        </xsl:attribute>
	<xsl:text> cxp</xsl:text>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="@*|node()">
  </xsl:template>
</xsl:stylesheet>
