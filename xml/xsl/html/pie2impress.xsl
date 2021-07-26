<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- transformation of PIE/XML to a simple, non-interactive HTML format
 -->
  
  <xsl:import href="../Utils.xsl"/>

  <xsl:output 
    method="html"
    encoding="UTF-8"
    omit-xml-declaration="no"
    doctype-public="-//W3C//DTD HTML 4.01//EN" />

  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="pie">
    <xsl:element name="head">
      <xsl:element name="meta">
	<xsl:attribute name="name">
	  <xsl:text>generator</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="content">
	  <xsl:text>cxproc PIE/XML</xsl:text>
	</xsl:attribute>
      </xsl:element>
      <xsl:element name="meta">
	<xsl:attribute name="http-equiv">
	  <xsl:text>cache-control</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="content">
	  <xsl:text>no-cache</xsl:text>
	</xsl:attribute>
      </xsl:element>
      <xsl:element name="meta">
	<xsl:attribute name="http-equiv">
	  <xsl:text>pragma</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="content">
	  <xsl:text>no-cache</xsl:text>
	</xsl:attribute>
      </xsl:element>
      <xsl:element name="link">
	<xsl:attribute name="rel">
	  <xsl:text>stylesheet</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="href">
	  <xsl:text>/impress/examples/classic-slides/css/classic-slides.css</xsl:text>
	</xsl:attribute>
      </xsl:element>
      <xsl:element name="link">
	<xsl:attribute name="rel">
	  <xsl:text>stylesheet</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="href">
	  <xsl:text>/impress/examples/classic-slides/css/fonts.css</xsl:text>
	</xsl:attribute>
      </xsl:element>
      <xsl:if test="/pie/section/h">
	<xsl:element name="title">
	  <xsl:value-of select="/pie/section/h"/>
	</xsl:element>
      </xsl:if>
    </xsl:element>

    <xsl:element name="div">
      <xsl:attribute name="id">
	<xsl:text>impress</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
    
  </xsl:template>

  <xsl:template match="author">
    <xsl:element name="center">
      <xsl:element name="i">
	<xsl:value-of select="."/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="section">
    <xsl:choose>
      <xsl:when test="h">
	<xsl:choose>
	  <xsl:when test="count(ancestor::section) = 0">
	    <xsl:element name="div">
	      <xsl:attribute name="class">
		<xsl:text>step slide title</xsl:text>
	      </xsl:attribute>
	      <xsl:comment>
		<xsl:text>title slide</xsl:text>
	      </xsl:comment>
	      <xsl:element name="h1">
		<xsl:apply-templates select="h"/>
	      </xsl:element>
	    </xsl:element>
	    <xsl:apply-templates select="*[not(name(.) = 'h')]"/>
	  </xsl:when>
	  <xsl:when test="count(ancestor::section) = 1">
	    <xsl:element name="div">
	      <xsl:attribute name="class">
		<xsl:text>step slide</xsl:text>
	      </xsl:attribute>
	      <xsl:comment>
		<xsl:text>section slide</xsl:text>
	      </xsl:comment>
	      <xsl:element name="h1">
		<xsl:apply-templates select="h"/>
	      </xsl:element>
	      <xsl:element name="div">
		<xsl:attribute name="class">
		  <xsl:text>notes</xsl:text>
		</xsl:attribute>
		<xsl:apply-templates select="*[not(name(.) = 'h') and not(name(.) = 'section')]"/>
	      </xsl:element>
	    </xsl:element>
	    <xsl:apply-templates select="child::section"/>
	  </xsl:when>
	  <xsl:when test="count(ancestor::section) = 2">
	    <xsl:element name="div">
	      <xsl:attribute name="class">
		<xsl:text>step slide</xsl:text>
	      </xsl:attribute>
	      <xsl:comment>
		<xsl:text>content slide</xsl:text>
	      </xsl:comment>
	      <xsl:element name="h1">
		<xsl:apply-templates select="h"/>
	      </xsl:element>
	      <xsl:element name="div">
		<xsl:attribute name="class">
		  <xsl:text>notes</xsl:text>
		</xsl:attribute>
		<xsl:apply-templates select="*[not(name(.) = 'h')]"/>
	      </xsl:element>
	    </xsl:element>
	  </xsl:when>
	  <xsl:otherwise>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="task">
    <xsl:choose>
      <xsl:when test="name(parent::node()) = 'list'">
	<!-- list item -->
	<xsl:element name="li">
	  <xsl:call-template name="FORMATTASK"/>
	  <xsl:call-template name="FORMATIMPACT"/>
	  <xsl:apply-templates select="*[not(name(.) = 'h')]"/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="p">
	  <xsl:call-template name="FORMATTASK"/>
	  <xsl:call-template name="FORMATIMPACT"/>
	</xsl:element>
	<xsl:apply-templates select="*[not(name(.) = 'h')]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="list">
    <xsl:if test="child::*[not(@hidden)]">
      <xsl:choose>
	<xsl:when test="@enum = 'yes'">
	  <!-- numerated list -->
	  <xsl:element name="ol">
	    <xsl:apply-templates/>
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise>
	  <!-- para -->
	  <xsl:element name="ul">
	    <xsl:apply-templates/>
	  </xsl:element>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="link">
    <xsl:element name="a">
      <xsl:copy-of select="@href"/>
      <xsl:apply-templates/>
    </xsl:element>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="abstract">
    <xsl:element name="p">
      <xsl:attribute name="class">
	<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="b|u|i|date">
    <!-- map former elements to span -->
    <xsl:element name="{name()}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p">
    <xsl:choose>
      <xsl:when test="name(parent::node()) = 'list'">
	<!-- list item -->
	<xsl:choose>
	  <xsl:when test="not(@hidden)">
	    <!-- simple paragraph -->
	    <xsl:element name="li">
	      <xsl:apply-templates/>
	      <xsl:call-template name="FORMATIMPACT"/>
	    </xsl:element>
	  </xsl:when>
	  <xsl:otherwise>
	    <!-- really hidden paragraph -->
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:choose>
	  <xsl:when test="not(@hidden)">
	    <!-- simple paragraph -->
	    <xsl:element name="p">
	      <xsl:apply-templates/>
	      <xsl:call-template name="FORMATIMPACT"/>
	    </xsl:element>
	  </xsl:when>
	  <xsl:when test="@hidden">
	    <!-- hidden paragraph -->
	    <xsl:element name="p">
	      <xsl:element name="i">
		<xsl:apply-templates/>
	      </xsl:element>
	      <xsl:call-template name="FORMATIMPACT"/>
	    </xsl:element>
	  </xsl:when>
	  <xsl:otherwise>
	    <!-- really hidden paragraph -->
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="pre">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="table">
    <xsl:element name="center">
      <xsl:element name="table">
	<xsl:copy-of select="@*"/>
	<xsl:attribute name="width">90%</xsl:attribute>
	<xsl:copy-of select="*[not(name()='t')]"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="fig">
    <xsl:element name="p">
      <xsl:choose>
	<xsl:when test="@hidden">
	  <!-- hidden figure -->
	  <xsl:element name="i">
	    <xsl:value-of select="concat('; Fig. ',img/@src,': ',h)"/>
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="concat('Fig. ',img/@src,': ',h)"/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="FORMATIMPACT"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[@valid='no']">
    <!-- ignore this elements -->
  </xsl:template>

  <xsl:template match="meta|t|tag">
    <!-- ignore this elements -->
  </xsl:template>

</xsl:stylesheet>
