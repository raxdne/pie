<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:cxp="http://www.tenbusch.info/cxproc" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ap="http://schemas.mindjet.com/MindManager/Application/2003" version="1.0">
  <xsl:import href="../xsl/html/PieHtml.xsl"/>
  <xsl:variable name="file_css" select="'/pie/non-js/CgiPieUi.css'"/>
  <!--  -->
  <xsl:variable name="flag_header" select="true()"/>
  <!--  -->
  <xsl:variable name="str_frame" select="'piemain'"/>
  <xsl:variable name="str_prefix" select="''"/>
  <xsl:variable name="str_tab">
    <xsl:text>   </xsl:text>
  </xsl:variable>
  <!--  -->
  <xsl:variable name="str_prefix_dir">
    <xsl:choose>
      <xsl:when test="/pie/dir/@urlprefix">
        <xsl:value-of select="concat(/pie/dir/@urlprefix,'/')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:output method="html" omit-xml-declaration="no" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="file:///tmp/dummy.dtd"/>
  <xsl:template match="/pie">
    <xsl:choose>
      <xsl:when test="$flag_header">
        <xsl:element name="html">
          <xsl:call-template name="HEADER"/>
          <xsl:element name="body">
            <!--  -->
            <xsl:element name="pre">
              <xsl:apply-templates select="dir/*[name()='dir' or name()='file']">
                <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="name()"/>
                <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="body">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="dir">
    <!--  -->
    <xsl:variable name="dir_path">
      <xsl:value-of select="$str_prefix_dir"/>
      <xsl:for-each select="ancestor::dir">
        <xsl:value-of select="@urlname"/>
        <xsl:text>/</xsl:text>
      </xsl:for-each>
      <xsl:value-of select="@urlname"/>
    </xsl:variable>
    <xsl:variable name="str_indent">
      <xsl:for-each select="ancestor::dir">
        <xsl:value-of select="$str_tab"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@hidden = 'yes'"/>
      <xsl:when test="@name = 'tmp'"/>
      <xsl:when test="starts-with(@name,'_')"/>
      <xsl:when test="not(@name = '') and not(@err)">
        <xsl:value-of select="$str_indent"/>
        <xsl:element name="a">
          <!-- the sub directories are links -->
          <xsl:attribute name="class">subdir</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="concat('?dir=',$dir_path,'&amp;','cxp=DirSitemap')"/>
          </xsl:attribute>
          <xsl:value-of select="@name"/>
          <xsl:text>/</xsl:text>
        </xsl:element>
        <xsl:element name="br"/>
        <xsl:apply-templates select="dir|file">
          <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="name()"/>
          <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="file">
    <!--  -->
    <xsl:variable name="file_path">
      <xsl:value-of select="$str_prefix_dir"/>
      <xsl:for-each select="ancestor::dir">
        <xsl:value-of select="@urlname"/>
        <xsl:text>/</xsl:text>
      </xsl:for-each>
      <xsl:value-of select="@urlname"/>
    </xsl:variable>
    <xsl:variable name="str_indent">
      <xsl:for-each select="ancestor::dir">
        <xsl:value-of select="$str_tab"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@name = ''"/>
      <xsl:when test="false() and @name = 'tmp'"/>
      <xsl:when test="substring-before(@name,'~')"/>
      <xsl:when test="@ext='css' or @ext='sh' or @ext='pl' or @ext='xsl'"/>
      <xsl:when test="starts-with(@name,'_')"/>
      <xsl:when test="@hidden = 'yes'"/>
      <xsl:when test="@ext='cxp'">
        <xsl:value-of select="$str_indent"/>
        <xsl:element name="a">
          <xsl:attribute name="class">cxp</xsl:attribute>
          <xsl:attribute name="target">
            <xsl:value-of select="$str_frame"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="@name"/>
          </xsl:attribute>
          <!-- dynamic content using cxproc -->
          <xsl:attribute name="href">
	    <xsl:value-of select="concat('/',$file_path)"/>
          </xsl:attribute>
          <!-- displayed text -->
          <xsl:choose>
            <xsl:when test="cxp:make/cxp:description">
              <xsl:value-of select="normalize-space(cxp:make/cxp:description)"/>
            </xsl:when>
            <xsl:when test="make/description">
              <xsl:value-of select="normalize-space(make/description)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-before(@name,concat('.',@ext))"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
        <xsl:element name="br"/>
      </xsl:when>
      <xsl:when test="@ext='txt' or @ext='pie' or @ext='mm' or @ext='cal' or @ext='gcal' or @ext='mmap' or @ext='xmmap' or @ext='xmind'">
        <xsl:value-of select="$str_indent"/>
        <xsl:element name="a">
          <xsl:attribute name="class">cxp</xsl:attribute>
          <xsl:attribute name="target">
            <xsl:value-of select="$str_frame"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="@name"/>
          </xsl:attribute>
          <!-- dynamic content using cxproc -->
          <xsl:attribute name="href">
            <xsl:value-of select="concat('?path=',$file_path,'&amp;','cxp=PiejQDefault','&amp;','type=')"/>
	    <xsl:call-template name="MIMETYPE">
	      <xsl:with-param name="str_type" select="@type"/>
	    </xsl:call-template>
          </xsl:attribute>
          <!-- displayed text -->
          <xsl:choose>
            <xsl:when test="@ext='xmind'">
              <!--  -->
              <xsl:choose>
                <xsl:when test="true()">
                  <xsl:value-of select="substring(normalize-space(descendant::*[name()='title']),1,50)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring-before(@name,concat('.',@ext))"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="@ext='mm'">
              <!--  or @ext='html' -->
              <xsl:choose>
                <xsl:when test="map/node[1]/@TEXT">
                  <xsl:value-of select="normalize-space(map/node[1]/@TEXT)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring-before(@name,concat('.',@ext))"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="@ext='mmap' or @ext='xmmap'">
              <!--  -->
              <xsl:choose>
                <xsl:when test="ap:Map/ap:OneTopic/ap:Topic/ap:Text/@PlainText">
                  <xsl:value-of select="normalize-space(ap:Map/ap:OneTopic/ap:Topic/ap:Text/@PlainText)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring-before(@name,concat('.',@ext))"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="@ext='pie' or @ext='txt'">
              <!--  or @ext='html' -->
              <xsl:choose>
                <xsl:when test="pie/section[1]/h">
                  <xsl:value-of select="normalize-space(pie/section[1]/h)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring-before(@name,concat('.',@ext))"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@name"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
        <xsl:if test="starts-with(@name,'shortcuts.')">
          <xsl:element name="a">
            <xsl:attribute name="class">cxp</xsl:attribute>
            <xsl:attribute name="target">
              <xsl:value-of select="$str_frame"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="@name"/>
            </xsl:attribute>
            <!-- dynamic content using cxproc -->
            <xsl:attribute name="href">
              <xsl:value-of select="concat('?','path=',$file_path,'&amp;','cxp=PiejQEditor')"/>
            </xsl:attribute>
            <xsl:text> [Edit]</xsl:text>
          </xsl:element>
        </xsl:if>
        <xsl:element name="br"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- direct link -->
        <xsl:value-of select="$str_indent"/>
        <xsl:element name="a">
          <xsl:attribute name="class">cxp</xsl:attribute>
          <xsl:attribute name="target">
            <xsl:value-of select="$str_frame"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="@name"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="concat('/',$file_path)"/>
          </xsl:attribute>
          <xsl:value-of select="@name"/>
        </xsl:element>
        <xsl:element name="br"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
