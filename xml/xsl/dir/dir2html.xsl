<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../html/PieHtml.xsl"/>
  
  <xsl:variable name="flag_result" select="//result"/>
  <xsl:variable name="dir_plain" select="''"/>
  <xsl:variable name="prefix_tmp" select="''"/>
  <xsl:variable name="prefix_tmpi" select="translate($prefix_tmp,'\','/')"/>


  <xsl:output method="html" encoding="UTF-8"/>  
  <!--  -->
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="body">
      <xsl:element name="h3">Dir</xsl:element>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
      
  <xsl:template match="dir|pie">
    <xsl:choose>
      <xsl:when test="@name = 'tmp'"/>
      <xsl:when test="starts-with(@name,'_')"/>
      <xsl:when test="starts-with(@name,'.') and not(@name = '.svn')"/>
      <xsl:otherwise>
        <xsl:apply-templates select="dir|file">
          <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
      
<xsl:template match="file">
  <xsl:variable name="dir_name">
    <xsl:for-each select="ancestor::dir">
      <xsl:if test="@prefix">
        <xsl:value-of select="@prefix"/>
        <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:value-of select="@name"/>
      <xsl:text>/</xsl:text>
    </xsl:for-each>
  </xsl:variable>
  <!--  -->
  <xsl:choose>
    <xsl:when test="starts-with(@type,'image/')">
      <xsl:element name="p">
        <xsl:element name="img">
          <xsl:attribute name="title">
            <xsl:value-of select="@name"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:value-of select="@name"/>
          </xsl:attribute>
	  <xsl:choose>
	    <xsl:when test="child::base64">
	      <xsl:attribute name="src">
		<xsl:value-of select="concat('data:',@type,';base64,',child::base64/child::text())"/>
	      </xsl:attribute>
	    </xsl:when>
	    <xsl:otherwise>
              <xsl:attribute name="src">
		<xsl:value-of select="@name"/>
              </xsl:attribute>
	    </xsl:otherwise>
	  </xsl:choose>
        </xsl:element>
      </xsl:element>
    </xsl:when>
    <xsl:when test="starts-with(@type,'text/')">
      <xsl:apply-templates select="pie/*"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="p">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="@name"/>
          </xsl:attribute>
          <xsl:value-of select="@name"/>
        </xsl:element>
      </xsl:element>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
