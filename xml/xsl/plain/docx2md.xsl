<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" mc:Ignorable="w14 wp14">

  <xsl:output method="text" encoding="UTF-8"/>
  
  <xsl:variable name="str_path"></xsl:variable>

  <!-- header structure with templates 'Heading' 'berschrift' -->

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
	<xsl:value-of select="concat('ORIGIN: ', $str_path, $newpar)"/>
      </xsl:when>
      <xsl:when test="dir/file/@name">
	<xsl:value-of select="concat('ORIGIN: ', dir/file/@prefix,'/',dir/file/@name, $newpar)"/>
      </xsl:when>
      <xsl:otherwise>
	<!-- no locator found -->
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="//w:document/w:body"/>
    <!-- all table cells containing markup 'TODO:' -->
    <xsl:if test="count(descendant::w:p[parent::w:tc and descendant::w:t[contains(.,'TODO:')]]) &gt; 0">
      <xsl:value-of select="concat('### Tasks from the table ###',$newpar,$newpar)"/>
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
    <xsl:value-of select="$newpar"/>
    <xsl:if test="descendant::w:strike or descendant::w:dstrike"> <!-- text strike -->
      <xsl:text>;</xsl:text>
    </xsl:if>
    <xsl:call-template name="SECTION">
      <xsl:with-param name="str_markup">
	<xsl:text>#</xsl:text>
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
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="w:p[w:pPr/w:numPr]">
    <xsl:call-template name="ENUM">
      <xsl:with-param name="level" select="w:pPr/w:numPr/w:ilvl/@w:val"/>
      <xsl:with-param name="str_markup">
	<xsl:if test="w:r/w:rPr/w:strike">
	  <xsl:text>;</xsl:text>
	</xsl:if>
	<xsl:choose>
	  <xsl:when test="contains('38',w:pPr/w:numPr/w:numId/@w:val)"> <!-- BUG: string value is not portable -->
	    <xsl:text>-</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>-</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
    <xsl:value-of select="$newline"/>
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
    <xsl:param name="str_markup" select="'-'"/>
    <xsl:choose>
      <xsl:when test="$level &gt; 0">
	<xsl:choose>
	  <xsl:when test="$str_markup = '1)'">
	    <xsl:text>   </xsl:text>		<!-- BUG: spacing depends on type of parent enum -->
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>  </xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:call-template name="ENUM">
	  <xsl:with-param name="level" select="$level - 1"/>
	  <xsl:with-param name="str_markup" select="$str_markup"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$str_markup"/>
	<xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="w:p">
    <xsl:value-of select="$newline"/>
    <xsl:if test="descendant::w:rPr[child::w:strike or child::w:dstrike] and not(ancestor::w:p/descendant::w:pPr[contains(w:pPr/w:pStyle/@w:val,'Heading') or contains(w:pPr/w:pStyle/@w:val,'berschrift')])"> <!-- text strike, but not header -->
      <xsl:text>; </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:choose>
      <xsl:when test="parent::w:tc"/>
      <xsl:otherwise>
	<xsl:value-of select="$newline"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="w:r[w:rPr/w:b]">
    <xsl:value-of select="concat('**',w:t,'**')"/>
  </xsl:template>

  <xsl:template match="w:r[w:rPr/w:i]">
    <xsl:value-of select="concat('__',w:t,'__')"/>
  </xsl:template>

  <xsl:template match="w:r[contains(w:rPr/w:rFonts/attribute::w:ascii,'Courier') or contains(w:rPr/w:rFonts/attribute::w:ascii,'Monospace')]">
    <xsl:value-of select="concat('`',w:t,'`')"/>
  </xsl:template>

  <xsl:template match="w:hyperlink">
    <xsl:variable name="str_url_display">
      <xsl:copy-of select="w:r//w:t/text()"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="attribute::r:id">
	<xsl:variable name="str_url_id" select="attribute::r:id"/>
	<xsl:variable name="str_url_target">
	  <xsl:for-each select="/descendant::*[name() = 'Relationship' and attribute::Id = $str_url_id][1]">
	    <xsl:value-of select="attribute::Target"/>
	  </xsl:for-each>
	</xsl:variable>
	<xsl:value-of select="concat('[',$str_url_display,'](',$str_url_target,')')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$str_url_display"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="w:tab">
    <xsl:value-of select="'	'"/>
  </xsl:template>

  <xsl:template match="w:tbl">
    <xsl:value-of select="concat($newline,'&lt;csv&gt;',$newline)"/>
    <xsl:for-each select="descendant::w:tr">
      <xsl:for-each select="descendant::w:tc">
	<xsl:if test="position() &gt; 1">
	  <xsl:text>;</xsl:text>
	</xsl:if>
	<xsl:copy-of select="descendant::w:t"/>
      </xsl:for-each>
      <xsl:value-of select="$newline"/>
    </xsl:for-each>
    <xsl:value-of select="concat('&lt;/csv&gt;',$newline)"/>
  </xsl:template>

  <xsl:template match="w:drawing">
    <xsl:variable name="id_image">
      <xsl:value-of select="wp:inline/a:graphic/a:graphicData//a:blip/@r:embed"/>
    </xsl:variable>
    <xsl:variable name="path_image">
      <xsl:value-of select="//file[@name='document.xml.rels']/child::*[1]/child::*[name()='Relationship' and @Id=$id_image]/@Target"/>
    </xsl:variable>
    <xsl:for-each select="//file[@name=substring-after($path_image,'/')]">
      <xsl:value-of select="concat('; Fig. ',$id_image)"/>
      <xsl:if test="child::base64">
	<xsl:value-of select="concat($newpar,'data:',@type,';base64,',child::base64,$newpar)"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="w:object">
    <xsl:variable name="id_object">
      <xsl:value-of select="o:OLEObject/@r:id"/>
    </xsl:variable>
    <xsl:variable name="path_object">
      <xsl:value-of select="//file[@name='document.xml.rels']/child::*[1]/child::*[name()='Relationship' and @Id=$id_object]/@Target"/>
    </xsl:variable>
    <xsl:value-of select="concat($newpar,'[OLE Object](?path=',$str_path,'/',$path_object,')',$newpar)"/>

  </xsl:template>

</xsl:stylesheet>
