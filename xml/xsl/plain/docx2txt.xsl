<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" mc:Ignorable="w14 wp14">

<!--  
xmlns:aink="http://schemas.microsoft.com/office/drawing/2016/ink"
xmlns:am3d="http://schemas.microsoft.com/office/drawing/2017/model3d"
xmlns:cx="http://schemas.microsoft.com/office/drawing/2014/chartex"
xmlns:cx1="http://schemas.microsoft.com/office/drawing/2015/9/8/chartex"
xmlns:cx2="http://schemas.microsoft.com/office/drawing/2015/10/21/chartex"
xmlns:cx3="http://schemas.microsoft.com/office/drawing/2016/5/9/chartex"
xmlns:cx4="http://schemas.microsoft.com/office/drawing/2016/5/10/chartex"
xmlns:cx5="http://schemas.microsoft.com/office/drawing/2016/5/11/chartex"
xmlns:cx6="http://schemas.microsoft.com/office/drawing/2016/5/12/chartex"
xmlns:cx7="http://schemas.microsoft.com/office/drawing/2016/5/13/chartex"
xmlns:cx8="http://schemas.microsoft.com/office/drawing/2016/5/14/chartex"
xmlns:m="http://purl.oclc.org/ooxml/officeDocument/math"
xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:r="http://purl.oclc.org/ooxml/officeDocument/relationships"
xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:w="http://purl.oclc.org/ooxml/wordprocessingml/main"
xmlns:w10="urn:schemas-microsoft-com:office:word"
xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml"
xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml"
xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid"
xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex"
xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
xmlns:wp="http://purl.oclc.org/ooxml/drawingml/wordprocessingDrawing"
xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing"
xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas"
xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup"
xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk"
xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"
-->

  <xsl:output method="text" encoding="UTF-8"/>

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>
  
<xsl:variable name="newpar">
<xsl:text>

</xsl:text>
</xsl:variable>
  
  <xsl:template match="/">
    <xsl:value-of select="concat(';;',$newpar,$newpar)"/>
    <xsl:apply-templates select="//w:document/w:body"/>
    <!-- all table cells containing markup 'TODO:' -->
    <xsl:if test="count(descendant::w:p[parent::w:tc and descendant::w:t[contains(.,'TODO:')]]) &gt; 0">
      <xsl:value-of select="concat('*** Tasks from the table',$newpar,$newpar)"/>
      <xsl:apply-templates select="descendant::w:p[parent::w:tc and descendant::w:t[contains(.,'TODO:')]]"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="w:p[contains(w:pPr/w:pStyle/@w:val,'berschrift')]"> <!-- TODO: check language dependencies -->
    <xsl:if test="descendant::w:strike or descendant::w:dstrike"> <!-- text strike -->
      <xsl:text>;</xsl:text>
    </xsl:if>
    <xsl:call-template name="SECTION">
      <xsl:with-param name="str_markup">
	<xsl:text>*</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="level" select="substring-after(w:pPr/w:pStyle/@w:val,'berschrift')"/>
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
	  <xsl:when test="contains('38',w:pPr/w:numPr/w:numId/@w:val)">
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

  <xsl:template name="SECTION">
    <xsl:param name="level"/>
    <xsl:param name="str_markup" select="'*'"/>
    <xsl:choose>
      <xsl:when test="$level &gt; 0">
	<xsl:value-of select="$str_markup"/>
	<xsl:call-template name="SECTION">
	  <xsl:with-param name="str_markup" select="$str_markup"/>
	  <xsl:with-param name="level" select="$level - 1"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
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

  <xsl:template match="w:p">
    <xsl:if test="descendant::w:rPr[child::w:strike or child::w:dstrike] and not(ancestor::w:p/descendant::w:pPr[contains(w:pStyle/@w:val,'berschrift')])"> <!-- text strike, but not header -->
      <xsl:text>; </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:value-of select="$newpar"/>
  </xsl:template>

  <xsl:template match="w:tab">
    <xsl:value-of select="'	'"/>
  </xsl:template>

  <xsl:template match="w:tbl">
    <xsl:value-of select="concat('#begin_of_csv',$newline)"/>
    <xsl:apply-templates select="w:tr"/>
    <xsl:value-of select="concat('#end_of_csv',$newpar)"/>
  </xsl:template>

  <xsl:template match="w:tr">
    <xsl:apply-templates select="w:tc"/>
    <xsl:value-of select="concat('','&#10;')"/>
  </xsl:template>
  
  <xsl:template match="w:tc">
    <xsl:value-of select="concat(normalize-space(.),';')"/>
  </xsl:template>

  <xsl:template match="w:drawing">
    <xsl:value-of select="concat('Fig. ',wp:inline/@wp14:editId,' ',wp:inline/wp:docPr/@descr,' (',wp:inline/wp:docPr/@name,')',$newpar)"/>
  </xsl:template>

</xsl:stylesheet>
