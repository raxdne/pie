<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cxp="http://www.tenbusch.info/cxproc" version="1.0">

  <xsl:variable name="str_cxp" select="'PieUiDefault'"/>

  <xsl:output method="html" encoding="UTF-8"/>
  
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="body">
        <xsl:element name="h2">
          <xsl:value-of select="concat('Result ','&quot;',pie/meta/cxp:dir/@grep,pie/meta/cxp:dir/@igrep,'&quot;')"/>
	</xsl:element>
        <xsl:apply-templates />
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="dir">
    <xsl:choose>
      <xsl:when test="@name = '.'">
        <xsl:apply-templates select="dir|file">
          <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
        </xsl:apply-templates>
      </xsl:when>
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
    
    <xsl:variable name="file_path">
      <!-- directory path to display -->
      <xsl:for-each select="ancestor::dir">
        <xsl:if test="@prefix">
          <xsl:value-of select="concat(@prefix,'/')"/>
        </xsl:if>
        <xsl:if test="not(@name = '.')">
          <xsl:value-of select="concat(@name,'/')"/>
        </xsl:if>
      </xsl:for-each>
      <xsl:value-of select="@name"/>
    </xsl:variable>
    
    <xsl:variable name="file_path_url">
      <!-- directory path to link -->
      <xsl:for-each select="ancestor::dir">
        <xsl:if test="@urlprefix">
          <xsl:value-of select="concat(@urlprefix,'/')"/>
        </xsl:if>
        <xsl:if test="not(@name = '.')">
          <xsl:value-of select="concat(@urlname,'/')"/>
        </xsl:if>
      </xsl:for-each>
      <xsl:value-of select="@urlname"/>
    </xsl:variable>
    
    <xsl:element name="h3">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="concat('?path=',$file_path_url,'&amp;','cxp=',$str_cxp)"/>
        </xsl:attribute>
        <xsl:value-of select="$file_path"/>
      </xsl:element>
    </xsl:element>

    <xsl:if test="child::grep[child::match]">
      <xsl:variable name="file_xpath" select="starts-with(@type,'text/')"/>
      <xsl:element name="ol">
	<xsl:for-each select="child::grep/child::match">
	  <xsl:element name="li">
		<!-- 
	    <xsl:element name="a">
              <xsl:attribute name="href">
		<xsl:value-of select="concat('?path=',$file_path_url,'&amp;','cxp=',$str_cxp)"/>
		<xsl:if test="$file_xpath">
		  <xsl:value-of select="concat('&amp;','xpath=',@xpath,'/ancestor-or-self::section[1]')"/>
		</xsl:if>
              </xsl:attribute>
		-->
              <xsl:value-of select="concat(name(child::*[1]),' ',.,child::*[1]/attribute::*)"/>
	    </xsl:element>
	  </xsl:element>
	</xsl:for-each>
      </xsl:element>
    </xsl:if>
      
  </xsl:template>

</xsl:stylesheet>
