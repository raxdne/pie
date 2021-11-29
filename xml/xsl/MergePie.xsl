<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- merge all dir/file//pie/block in a structure -->

  <xsl:variable name="opt_cxp" select="''"/>
  
  <xsl:output method="xml" version="1.0"/>

  <xsl:template match="/">
    <xsl:element name="pie">
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="dir">
    <xsl:element name="block">
      <xsl:copy-of select="@name"/>
      <xsl:element name="section">
	<xsl:element name="h">
	  <xsl:value-of select="@name"/>
	</xsl:element>
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="file[child::pie]">
    <xsl:copy-of select="pie/block"/>
  </xsl:template>

  <xsl:template match="file[starts-with(@type,'image')]">
    <xsl:variable name="file_path">
      <xsl:for-each select="ancestor::dir">
        <xsl:if test="@prefix">
          <xsl:value-of select="concat(@prefix,'/')"/>
        </xsl:if>
        <xsl:value-of select="concat(@urlname,'/')"/>
      </xsl:for-each>
      <xsl:value-of select="@urlname"/>
    </xsl:variable>
    <xsl:variable name="image_testname" select="translate(substring-before(@name,'.txt'),'_','.')"/>
    <xsl:choose>
      <xsl:when test="parent::dir/child::file[@name=$image_testname]">
        <!-- skip image comment text files -->
      </xsl:when>
      <xsl:when test="@name='albumfiles.txt'"/>
      <xsl:when test="descendant::pie">
        <xsl:element name="p">
          <xsl:value-of select="@name"/>
        </xsl:element>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="descendant::map">
        <xsl:element name="p">
          <xsl:value-of select="@name"/>
        </xsl:element>
        <xsl:apply-templates select="map/*"/>
      </xsl:when>
      <xsl:when test="contains(@type,'image')">
        <xsl:variable name="image_comment_name" select="concat(translate(@name,'.','_'),'.txt')"/>

	<xsl:element name="block">
          <xsl:attribute name="context">
            <xsl:value-of select="concat('/',$file_path)"/>
	  </xsl:attribute>
	  
        <xsl:element name="fig">
          <xsl:element name="img">
            <xsl:attribute name="src">
            <xsl:choose>
              <xsl:when test="$opt_cxp = ''">
              <xsl:value-of select="concat('/',$file_path)"/>
              </xsl:when>
              <xsl:otherwise>
		<xsl:value-of select="concat('?',$opt_cxp,$file_path)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="exif/size">
            <xsl:variable name="int_width" select="200"/>
            <xsl:variable name="int_image_width" select="exif/size/@x"/>
            <xsl:attribute name="width">
              <xsl:value-of select="$int_image_width * $int_width div $int_image_width"/>
            </xsl:attribute>
          </xsl:if>
          </xsl:element>
          <xsl:element name="h">
            <xsl:choose>
              <xsl:when test="parent::dir/file[@name=$image_comment_name]/pie">
                <xsl:copy-of select="parent::dir/file[@name=$image_comment_name]/pie/*"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@name"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
       </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
