<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/package/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" xmlns:p14="http://schemas.microsoft.com/office/powerpoint/2010/main" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">

  <xsl:import href="docx2md.xsl"/>

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:variable name="str_path" select="''" />

  <xsl:variable name="char_header" select="'#'" />

  <xsl:variable name="flag_embed" select="true()"/> <!-- default: true() -->

  <xsl:variable name="int_slides" select="count(/descendant::file[starts-with(@name,'slide')])" />

  <xsl:variable name="int_slides_max" select="250" />

<xsl:variable name="newpar">
<xsl:text>

</xsl:text>
</xsl:variable>

<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="string-length($str_path) &gt; 0">
      <xsl:value-of select="concat($newpar,'ORIGIN: ', $str_path, $newpar)"/>
      <xsl:value-of select="concat($char_header,' Presentation ',$str_path,$newpar)"/>
    </xsl:when>
    <xsl:when test="pie/file/@name">
      <xsl:value-of select="concat($newpar,'ORIGIN: ', pie/file/@prefix,'/',pie/file/@name, $newpar)"/>
      <xsl:value-of select="concat($char_header,' Presentation ',pie/file/@name,$newpar)"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- no locator found -->
      <xsl:value-of select="concat($char_header,' Presentation',$newpar)"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="MAINLOOP"/>
</xsl:template>

  <xsl:template match="p:txBody">
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="a:p">
    <xsl:choose>
      <xsl:when test="string-length(descendant::a:t) &lt; 1"/>
      <xsl:when test="a:pPr/a:buNone">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="ENUM">
	  <xsl:with-param name="level" select="a:pPr/@lvl - 1"/>
	  <xsl:with-param name="str_markup">
	    <xsl:choose>
	      <xsl:when test="a:pPr/a:buAutoNum/@type='arabicPeriod'"> <!-- TODO: additional numbering schema -->
		<xsl:text>1)</xsl:text>
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
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="a:t">
    <xsl:choose>
      <xsl:when test="preceding-sibling::a:rPr/child::a:hlinkClick">
	<xsl:variable name="str_id">
	  <xsl:value-of select="preceding-sibling::a:rPr/child::a:hlinkClick/attribute::*[name()='r:id']"/>
	</xsl:variable>
	<xsl:variable name="str_href">
	  <xsl:value-of select="/descendant::r:Relationships/r:Relationship[@TargetMode='External' and @Id=$str_id]/@Target"/>
	</xsl:variable>
	<xsl:value-of select="concat('[',.,']','(',$str_href,')')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="a:tbl">
    <xsl:value-of select="concat($newline,'```csv',$newline)"/>
    <xsl:for-each select="descendant::a:tr">
      <xsl:for-each select="descendant::a:tc">
	<xsl:if test="position() &gt; 1">
	  <xsl:text>;</xsl:text>
	</xsl:if>
	<xsl:copy-of select="descendant::a:t"/>
      </xsl:for-each>
      <xsl:value-of select="$newline"/>
    </xsl:for-each>
    <xsl:value-of select="concat('```',$newline)"/>
  </xsl:template>

  <xsl:template name="MAINLOOP">
    <xsl:choose>
      <xsl:when test="/descendant::p14:sectionLst">
	<!-- section list exists -->
	<xsl:for-each select="/descendant::p14:sectionLst/p14:section">
	  <xsl:choose>
	    <xsl:when test="@name">
	      <xsl:value-of select="concat($char_header,$char_header,' ',@name,$newpar)"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="concat($char_header,$char_header,' ',position(),$newpar)"/>
	    </xsl:otherwise>
	  </xsl:choose>
	  <xsl:for-each select="p14:sldIdLst/p14:sldId">
	    <!-- ordered list of references to slide -->
	    <xsl:variable name="str_id" select="@id"/>
	    <xsl:variable name="str_rid" select="/descendant::file[@name='presentation.xml']/p:presentation/p:sldIdLst/p:sldId[@id=$str_id]/@*[name()='r:id']"/>
	    <xsl:variable name="str_slide" select="/descendant::file[@name='presentation.xml.rels']/r:Relationships/r:Relationship[@Id=$str_rid]/@Target"/>
	    <xsl:call-template name="SLIDE">
	      <xsl:with-param name="param_slide" select="substring-after($str_slide,'slides/')"/>
	    </xsl:call-template>
	  </xsl:for-each>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<!-- fallback, no sections defined -->
	<xsl:value-of select="concat($char_header,$char_header,' Slides',$newpar)"/>
	<xsl:for-each select="/descendant::p:sldIdLst/p:sldId">
	  <!-- ordered list of references to slide -->
	  <xsl:variable name="str_id" select="@id"/>
	  <xsl:variable name="str_rid" select="/descendant::file[@name='presentation.xml']/p:presentation/p:sldIdLst/p:sldId[@id=$str_id]/@*[name()='r:id']"/>
	  <xsl:variable name="str_slide" select="/descendant::file[@name='presentation.xml.rels']/r:Relationships/r:Relationship[@Id=$str_rid]/@Target"/>
	  <xsl:call-template name="SLIDE">
	    <xsl:with-param name="param_slide" select="substring-after($str_slide,'slides/')"/>
	  </xsl:call-template>
	</xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>

  <xsl:template name="SLIDE">
    <xsl:param name="param_slide" select="''"/>
    <xsl:param name="param_prefix" select="concat($newpar,$char_header,$char_header,$char_header,' ')"/>
    <xsl:choose>
      <xsl:when test="/descendant::file[@name=$param_slide]"> <!-- slide exists -->
	<!-- <xsl:value-of select="concat('; ',$param_slide,$newpar)"/> -->
	<xsl:for-each select="/descendant::file[@name=$param_slide]">

	  <xsl:variable name="str_media">
	    <xsl:value-of select="concat($param_slide,'.rels')"/>
	  </xsl:variable>

	  <!-- try to detect header first -->
	  <xsl:value-of select="$param_prefix"/>
	  <xsl:apply-templates select="descendant::p:sp[1]/descendant::a:t" />
	  <xsl:value-of select="$newpar"/>

	  <!-- add text content -->
	  <xsl:apply-templates select="descendant::p:sp[position() &gt; 1]/descendant::p:txBody"/>

	  <!-- add all tables -->
	  <xsl:apply-templates select="descendant::a:tbl"/>

	  <xsl:if test="$flag_embed and ($int_slides &lt;= $int_slides_max)">
	    <!-- add all embedded images -->
	    <xsl:for-each select="/descendant::file[@name=$str_media]/r:Relationships/r:Relationship">
	      <xsl:choose>
		<xsl:when test="starts-with(@Target,'../media/')">
		  <xsl:variable name="str_file">
		    <xsl:value-of select="substring-after(@Target,'../media/')"/>
		  </xsl:variable>
		  <xsl:for-each select="/descendant::file[@name=$str_file]">
		    <xsl:value-of select="concat($newline,'data:',@type,';','base64,',base64,$newpar)"/>
		  </xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	      </xsl:choose>
	      <xsl:comment> No Media content</xsl:comment>
	    </xsl:for-each>
	  </xsl:if>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<!-- ends now -->
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

</xsl:stylesheet>
