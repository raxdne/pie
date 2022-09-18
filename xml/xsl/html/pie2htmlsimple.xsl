<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- transformation of PIE/XML to a simple, non-interactive HTML format -->
  
  <xsl:import href="PieHtml.xsl"/>

  <xsl:output 
    method="html"
    encoding="UTF-8"
    omit-xml-declaration="no"
    doctype-public="-//W3C//DTD HTML 4.01//EN" />

  <!--  -->
  <xsl:variable name="flag_simplified" select="true()"/>

  <xsl:output 
      method="html"
      encoding="UTF-8"
      omit-xml-declaration="no"
      doctype-public="-//W3C//DTD HTML 4.01//EN" />

  <xsl:template match="/">
    <xsl:element name="html">
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
      <!-- TODO: str_title -->
      <xsl:element name="title">
	<xsl:choose>
	  <xsl:when test="/pie/descendant::section[1]/h">
	    <xsl:value-of select="/pie/descendant::section[1]/h"/>
	  </xsl:when>
	  <xsl:otherwise>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:element>
     </xsl:element>
     <xsl:element name="body">
       <xsl:apply-templates/>
     </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
