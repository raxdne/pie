<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml" xmlns:php="http://php.net/xsl" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:dc="urn:oasis:names:dc" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xhtml php xsl office style text table draw fo xlink">

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:variable name="str_path" select="''" />

<xsl:variable name="tabsep">
<xsl:text>;</xsl:text>
</xsl:variable>
  
<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>
  
<xsl:variable name="newpar">
<xsl:text>

</xsl:text>
</xsl:variable>
  
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="string-length($str_path) &gt; 0">
	<xsl:value-of select="concat($newpar,'ORIGIN: ', $str_path, $newpar)"/>
      </xsl:when>
      <xsl:when test="pie/file/@name">
	<xsl:value-of select="concat($newpar,'ORIGIN: ', pie/file/@prefix,'/',pie/file/@name, $newpar)"/>
      </xsl:when>
      <xsl:otherwise>
	<!-- no locator found -->
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="pie//file/archive/file[@name = 'content.xml']/office:document-content">
	<xsl:element name="pie" xmlns="http://www.tenbusch.info/cxproc/">
	  <xsl:apply-templates select="pie//file/archive/file[@name = 'content.xml']/office:document-content/office:body/office:text"/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="pie" xmlns="http://www.tenbusch.info/cxproc/">
	  <xsl:apply-templates select="//office:document-content/office:body/office:text"/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text:h[@text:outline-level]|text:p[@text:style-name='Title']">
    <xsl:call-template name="SECTION">
      <xsl:with-param name="level">
	<xsl:choose>
	  <xsl:when test="@text:outline-level">
      <xsl:value-of select="@text:outline-level + 1"/>
	  </xsl:when>
	  <xsl:otherwise>
      <xsl:value-of select="1"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
    <xsl:value-of select="$newpar"/>
  </xsl:template>
  
  <xsl:template match="text:a">
    <xsl:choose>
      <xsl:when test=". = @xlink:href">
	<xsl:value-of select="concat(.,' ')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('|',@xlink:href,'|',.,'| ')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text:span">
    <xsl:variable name="str_style" select="@text:style-name"/>
    <xsl:choose>
      <xsl:when test="ancestor::office:document-content[descendant::style:style[@style:name = $str_style and child::style:text-properties[@style:font-weight-complex='bold']]]">
	<xsl:value-of select="concat('___',.,'___')"/>
      </xsl:when>
      <xsl:when test="ancestor::office:document-content[descendant::style:style[@style:name = $str_style and child::style:text-properties[@style:font-style-complex='italic']]]">
	<xsl:value-of select="concat('__',.,'__')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('',.,'')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text:p">
    <xsl:apply-templates/>
    <xsl:value-of select="$newpar"/>
  </xsl:template>

  <xsl:template match="text:p[parent::text:list-item]">
    <xsl:variable name="str_style" select="ancestor::text:list[@text:style-name]/@text:style-name"/>
    <xsl:call-template name="ENUM">
      <xsl:with-param name="level" select="count(ancestor::text:list) - 1"/>
      <xsl:with-param name="str_markup">
	<xsl:choose>
	  <xsl:when test="ancestor::file[@name='content.xml']/office:document-content//text:list-style[@style:name=$str_style and text:list-level-style-number]">
	    <xsl:text>+</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>-</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
    <xsl:value-of select="$newpar"/>
  </xsl:template>

  <xsl:template name="ENUM">
    <xsl:param name="level"/>
    <xsl:param name="str_markup" select="' '"/>
    <xsl:value-of select="$str_markup"/>
    <xsl:choose>
      <xsl:when test="$level &gt; 0">
	<xsl:call-template name="ENUM">
	  <xsl:with-param name="level" select="$level - 1"/>
	  <xsl:with-param name="str_markup" select="$str_markup"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="table:table">
    <xsl:value-of select="concat('#begin_of_csv',$newline)"/>
    <xsl:value-of select="concat('sep=',$tabsep,$newline)"/>
    <xsl:apply-templates select="table:table-row"/>
    <xsl:value-of select="concat('#end_of_csv',$newline)"/>
  </xsl:template>

  <xsl:template match="table:table-row">
    <xsl:apply-templates select="table:table-cell"/>
    <xsl:value-of select="concat('',$newline)"/>
  </xsl:template>
  
  <xsl:template match="table:table-cell">
    <xsl:value-of select="concat(normalize-space(.),$tabsep)"/>
  </xsl:template>
  
<!--
  <xsl:template match="w:t">
    <xsl:choose>
      <xsl:when test="preceding-sibling::w:rPr[child::w:strike or child::w:dstrike]">
	<xsl:text>; </xsl:text>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="."/>
  </xsl:template>

-->

  <xsl:template name="SECTION">
    <xsl:param name="level"/>
    <xsl:param name="str_markup" select="'*'"/>
    <xsl:choose>
      <xsl:when test="$level &gt; 0">
	<xsl:value-of select="$str_markup"/>
	<xsl:call-template name="SECTION">
	  <xsl:with-param name="level" select="$level - 1"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
