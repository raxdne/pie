<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" mc:Ignorable="w14 wp14">

  <xsl:import href="docx2md.xsl"/>

  <xsl:output method="text" encoding="UTF-8"/>

  <!-- header structure with templates 'Heading' 'berschrift' -->

  <xsl:template match="w:p[contains(w:pPr/w:pStyle/@w:val,'Heading') or contains(w:pPr/w:pStyle/@w:val,'berschrift')]">
    <xsl:if test="descendant::w:strike or descendant::w:dstrike"> <!-- text strike -->
      <xsl:text>;</xsl:text>
    </xsl:if>
    <xsl:call-template name="SECTION">
      <xsl:with-param name="str_markup">
	<xsl:text>*</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="level">
	<xsl:choose>
	  <xsl:when test="starts-with(w:pPr/w:pStyle/@w:val,'berschrift')">
	    <xsl:value-of select="substring-after(w:pPr/w:pStyle/@w:val,'berschrift')"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="substring-after(w:pPr/w:pStyle/@w:val,'Heading')"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
    <xsl:value-of select="$newpar"/>
  </xsl:template>

  <xsl:template match="w:p[w:pPr/w:numPr]">
    <xsl:call-template name="ENUM">
      <xsl:with-param name="level" select="w:pPr/w:numPr/w:ilvl/@w:val"/>
      <xsl:with-param name="str_markup">
	<xsl:if test="w:r/w:rPr/w:strike">
	  <xsl:text>;</xsl:text>
	</xsl:if>
	<xsl:choose>
	  <xsl:when test="contains('18',w:pPr/w:numPr/w:numId/@w:val)"> <!-- BUG: string value is not portable -->
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

  <xsl:template match="w:p">
    <xsl:if test="descendant::w:rPr[child::w:strike or child::w:dstrike] and not(ancestor::w:p/descendant::w:pPr[contains(w:pPr/w:pStyle/@w:val,'Heading') or contains(w:pPr/w:pStyle/@w:val,'berschrift')])"> <!-- text strike, but not header -->
      <xsl:text>; </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:choose>
      <xsl:when test="parent::w:tc"/>
      <xsl:otherwise>
	<xsl:value-of select="$newpar"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ENUM">
    <xsl:param name="level"/>
    <xsl:param name="str_markup" select="'-'"/>
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

</xsl:stylesheet>
