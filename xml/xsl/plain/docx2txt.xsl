<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" mc:Ignorable="w14 wp14">

  <xsl:import href="docx2md.xsl"/>

  <xsl:output method="text" encoding="UTF-8"/>

  <!-- header structure with templates 'Heading' 'berschrift' -->

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="string-length($str_path) &gt; 0">
	<xsl:value-of select="concat('ORIGIN: ', $str_path, $newpar)"/>
      </xsl:when>
      <xsl:when test="pie/file/@name">
	<xsl:value-of select="concat('ORIGIN: ', pie/file/@prefix,'/',pie/file/@name, $newpar)"/>
      </xsl:when>
      <xsl:otherwise>
	<!-- no locator found -->
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="//w:document/w:body"/>
    <!-- all table cells containing markup 'TODO:' -->
    <xsl:if test="count(descendant::w:p[parent::w:tc and descendant::w:t[contains(.,'TODO:')]]) &gt; 0">
      <xsl:value-of select="concat('*** Tasks from the table',$newpar,$newpar)"/>
      <xsl:apply-templates select="descendant::w:p[parent::w:tc and descendant::w:t[contains(.,'TODO:')]]"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="w:p[contains(w:pPr/w:pStyle/@w:val,'Title')]">
    <xsl:value-of select="concat('___',.,'___',$newpar)"/>
  </xsl:template>

  <xsl:template match="w:p[contains(w:pPr/w:pStyle/@w:val,'Subtitle')]">
    <xsl:value-of select="concat('__',.,'__',$newpar)"/>
  </xsl:template>

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

  <xsl:template match="w:t[preceding-sibling::w:rPr/w:b]">
    <xsl:value-of select="concat('___',.,'___')"/>
  </xsl:template>

  <xsl:template match="w:t[preceding-sibling::w:rPr/w:i]">
    <xsl:value-of select="concat('__',.,'__')"/>
  </xsl:template>

  <xsl:template match="w:t[preceding-sibling::w:rPr/child::w:rFonts[attribute::w:ascii = 'Courier New']]">
    <xsl:value-of select="concat('`',.,'`')"/>
  </xsl:template>

  <xsl:template match="w:hyperlink">
    <xsl:choose>
      <xsl:when test="w:r[w:t]">
	<xsl:value-of select="concat('[LINK](',w:r/w:t,')')"/> <!-- TODO: find href value  -->
      </xsl:when>
      <xsl:when test="attribute::r:id">
	<xsl:variable name="str_url_id" select="attribute::r:id"/>
	<xsl:choose>
	  <xsl:when test="//Relationships/Relationship[@Id = $str_url_id]">
	    <xsl:value-of select="concat('[',w:r/w:t,'](',//Relationships/Relationship[@Id = $str_url_id]/@Target,')')"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="concat('[',w:r/w:t,']()')"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="w:r/w:t[1]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="w:tab">
    <xsl:value-of select="'	'"/>
  </xsl:template>

  <xsl:template match="w:tbl">
    <xsl:value-of select="concat('&lt;csv&gt;',$newline)"/>
    <xsl:apply-templates select="w:tr"/>
    <xsl:value-of select="concat('&lt;/csv&gt;',$newline)"/>
  </xsl:template>

  <xsl:template match="w:tr">
    <xsl:apply-templates select="w:tc"/>
    <xsl:value-of select="$newline"/>
  </xsl:template>
  
  <xsl:template match="w:tc">
    <xsl:apply-templates/>
    <xsl:text>;</xsl:text>
  </xsl:template>

  <xsl:template match="w:drawing">
    <xsl:value-of select="concat('Fig. ',wp:inline/@wp14:editId,' ',wp:inline/wp:docPr/@descr,' (',wp:inline/wp:docPr/@name,')',$newpar)"/>
  </xsl:template>

</xsl:stylesheet>
