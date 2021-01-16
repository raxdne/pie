<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:variable name="str_path" select="''" />

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
    <!--
    <xsl:when test="pie/file[@name]">
      <xsl:value-of select="concat('* ',pie/file/@name,$newpar)"/>
      <xsl:for-each select="descendant::*[name() = 'TitlesOfParts']/*/*">
	<xsl:variable name="str_title" select="."/>
	<xsl:value-of select="concat('; ',$str_title,$newpar)"/>
	<xsl:apply-templates select="/descendant::p:cSld[p:spTree/p:sp[contains(normalize-space(p:txBody),$str_title)]]"/>
      </xsl:for-each>
    </xsl:when>
      -->
    <xsl:when test="pie/file/archive/dir[@name = 'ppt']/dir[@name = 'slides']/file[starts-with(@name,'slide')]">
      <xsl:value-of select="concat('* ','ToC',$newpar)"/>
      <xsl:for-each select="descendant::*[name() = 'TitlesOfParts']/*/*"> <!-- [name() = 'vector'] [name() = 'lpstr'] -->
	<xsl:variable name="str_title" select="."/>
	<xsl:value-of select="concat('+ ',$str_title,$newpar)"/>
      </xsl:for-each>
      <xsl:apply-templates select="pie/file/archive/dir[@name = 'ppt']/dir[@name = 'slides']/file[starts-with(@name,'slide')]">
	<!-- TODO: detect sort order of slides in presentation (s. above) -->
	<xsl:sort select="@name"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('* Presentation',$newpar)"/>
      <xsl:apply-templates select="/descendant::file[starts-with(@name,'slide')]">
	<xsl:sort select="@name"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="p:spTree[p:sp/p:nvSpPr/p:nvPr/p:ph/@type = 'ctrTitle']">
  <xsl:value-of select="concat('**',' ')"/>
  <xsl:apply-templates select="descendant::p:txBody[1]//a:t" />
  <xsl:if test="descendant::p:txBody[2]//a:t">
    <xsl:value-of select="concat('',' -- ')"/>
    <xsl:apply-templates select="descendant::p:txBody[2]//a:t" />
  </xsl:if>
  <xsl:value-of select="$newpar"/>
</xsl:template>

<xsl:template match="p:spTree[p:sp/p:nvSpPr/p:nvPr/p:ph/@type = 'title']">
  <xsl:value-of select="concat('***',' ')"/>
  <xsl:apply-templates select="p:sp[p:nvSpPr/p:nvPr/p:ph/@type = 'title']/descendant::p:txBody[1]//a:t" />
  <xsl:value-of select="$newpar"/>
  <xsl:apply-templates select="p:sp[not(p:nvSpPr/p:nvPr/p:ph/@type = 'title')]" />
</xsl:template>

  <xsl:template match="a:p">
    <xsl:choose>
      <xsl:when test="a:pPr/a:buNone">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="ENUM">
	  <xsl:with-param name="level" select="a:pPr/@lvl + 1"/>
	  <xsl:with-param name="str_markup">
	    <xsl:choose>
	      <xsl:when test="a:pPr/a:buAutoNum/@type='arabicPeriod'"> <!-- TODO: additional numbering schema -->
		<xsl:text>+</xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:text>-</xsl:text>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$newpar"/>
  </xsl:template>

  <xsl:template match="a:t">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="a:tbl">
    <xsl:value-of select="concat('#begin_of_pre',$newpar)"/>
    <xsl:apply-templates select="a:tr"/>
    <xsl:value-of select="concat('#end_of_pre',$newpar)"/>
  </xsl:template>

  <xsl:template match="a:tr">
    <xsl:apply-templates select="a:tc"/>
    <xsl:value-of select="$newpar"/>
  </xsl:template>
  
  <xsl:template match="a:tc">
    <xsl:value-of select="concat(normalize-space(.),'	')"/>
  </xsl:template>

  <xsl:template name="ENUM">
    <xsl:param name="level"/>
    <xsl:param name="str_markup" select="' '"/>
    <xsl:choose>
      <xsl:when test="$level &lt; 1"/>
      <xsl:when test="$level &gt; 1">
	<xsl:value-of select="$str_markup"/>
	<xsl:call-template name="ENUM">
	  <xsl:with-param name="level" select="$level - 1"/>
	  <xsl:with-param name="str_markup" select="$str_markup"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat($str_markup,' ')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
