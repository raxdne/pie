<?xml version="1.0"?>
<xsl:stylesheet xmlns:cxp="http://www.tenbusch.info/cxproc" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../xml/xsl/html/PieHtml.xsl"/>
  <xsl:variable name="file_css" select="'/pie/non-js/CgiPieUi.css'"/>
<!-- file:///H:/opt/cxproc/contrib/pie/html/ -->
<!--  -->
  <xsl:variable name="flag_header" select="true()"/>
<!--  -->
  <xsl:variable name="str_path" select="'Template'"/>

  <xsl:output method="html" encoding="UTF-8"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="body">
        <xsl:apply-templates select="pie"/>
<!--
        <xsl:call-template name="MENUCROSSLOAD"/>
        <h3>from file upload</h3>
            <form action="?cxp=PieUpload&amp;dir=%CGIDIR%" method="post" enctype="multipart/form-data">
              <p>Select a local file for upload into '%CGIDIR%'</p>
              <p>
                <input class="additor" name="file" type="file" size="50" maxlength="100000" accept="text/*"/>
                <input type="submit" value="Upload"/>
              </p>
            </form>
-->
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:choose>
      <xsl:when test="dir[1]/@error">
        <xsl:element name="pre">
          <xsl:text>This is no valid directory!</xsl:text>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<h3>New file from template</h3>
        <xsl:element name="form">
          <xsl:element name="input">
            <xsl:attribute name="type">hidden</xsl:attribute>
            <xsl:attribute name="name">cxp</xsl:attribute>
            <xsl:attribute name="value">CopyTemplate</xsl:attribute>
<!-- info -->
          </xsl:element>
          <xsl:element name="p">
            <xsl:element name="input">
              <xsl:attribute name="type">submit</xsl:attribute>
              <xsl:attribute name="value">Create</xsl:attribute>
            </xsl:element>
            <xsl:text> new file </xsl:text>
            <xsl:element name="input">
              <xsl:attribute name="class">additor</xsl:attribute>
              <xsl:attribute name="name">file</xsl:attribute>
              <xsl:attribute name="maxlength">125</xsl:attribute>
              <xsl:attribute name="size">70</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="concat($str_path,'/','New')"/>
              </xsl:attribute>
            </xsl:element>
          </xsl:element>
          <xsl:element name="p">from Template
            <xsl:element name="select">
              <xsl:attribute name="class">additor</xsl:attribute>
              <xsl:attribute name="name">template</xsl:attribute>
              <xsl:apply-templates select="descendant::file[@name]"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
    <h3>New subdirectory</h3>
    <xsl:element name="form">
      <xsl:element name="input">
        <xsl:attribute name="type">hidden</xsl:attribute>
        <xsl:attribute name="name">cxp</xsl:attribute>
        <xsl:attribute name="value">MakeDirectory</xsl:attribute>
	<!-- info -->
      </xsl:element>
      <xsl:element name="p">
        <xsl:element name="input">
          <xsl:attribute name="type">submit</xsl:attribute>
          <xsl:attribute name="value">Create</xsl:attribute>
        </xsl:element>
        <xsl:text> subdirectory </xsl:text>
        <xsl:element name="input">
          <xsl:attribute name="class">additor</xsl:attribute>
          <xsl:attribute name="name">path</xsl:attribute>
          <xsl:attribute name="maxlength">125</xsl:attribute>
          <xsl:attribute name="size">70</xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="concat($str_path,'/','New')"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="file">
<!--  -->
    <xsl:choose>
      <xsl:when test="@read = 'no'"/>
      <xsl:when test="@name = ''"/>
      <xsl:when test="@name = 'index.htm' or @name = 'index.html'"/>
      <xsl:when test="@name = 'tmp'"/>
      <xsl:when test="contains(@type,'error')"/>
      <xsl:when test="substring-before(@name,'~')"/>
      <xsl:when test="starts-with(@name,'_')"/>
      <xsl:when test="starts-with(@name,'.') and not(@name = '.svn')"/>
      <xsl:when test="@ext='txt' or @ext='mm' or @ext='pie' or @ext='csv' or @ext='cal' or @ext='gcal'">
        <!-- Template content using cxproc -->
        <xsl:element name="option">
          <xsl:attribute name="value">
          <xsl:for-each select="ancestor-or-self::*[name()='dir' or name()='file']">
            <xsl:choose>
              <xsl:when test="@prefix">
                <xsl:value-of select="concat(translate(@prefix,'\','/'),'/')"/>
              </xsl:when>
              <xsl:when test="@name='.'">
              </xsl:when>
              <xsl:when test="self::dir">
                <xsl:value-of select="concat(@name,'/')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(@name,'')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
          </xsl:attribute>
          <xsl:value-of select="concat(../@name,' :: ',@ext,' :: ')"/>
          <xsl:choose>
            <xsl:when test="pie/section[1]/h">
              <xsl:value-of select="pie/section[1]/h"/>
            </xsl:when>
            <xsl:when test="map/node/@TEXT">
              <xsl:value-of select="map/node/@TEXT"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-before(@name,concat('.',@ext))"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <!-- ignore anything else -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*[@error]">
    <!-- ignore all error entries -->
  </xsl:template>
  <xsl:template name="MENUCROSSLOAD">
    <h3>from file crossload</h3>
    <form enctype="multipart/form-data">
      <p>Insert a HTML content URL to download and transfrom into a PIE document.</p>
      <p>
        <input class="additor" name="file" value="{$str_path}/New.pie" size="50" maxlength="100" accept="text/*"/>
      </p>
      <p>
        <input class="additor" name="url" value="http://" size="50" maxlength="200" accept="text/*"/>
        <input type="submit" value="Load"/>
        <input type="hidden" name="cxp" value="PieCrossload"/>
        <input type="hidden" name="dir" value="{$str_path}"/>
        <input type="hidden" name="type" value="application-pie-xml"/>
      </p>
    </form>
  </xsl:template>
</xsl:stylesheet>
