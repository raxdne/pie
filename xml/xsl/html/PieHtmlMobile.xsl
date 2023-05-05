<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  
  <xsl:import href="PieHtml.xsl"/>

  <xsl:template name="HEADER">
    <xsl:copy-of select="document('../../../browser-jquery-mobile/CgiPiejQmHead.xhtml')/head"/>
  </xsl:template>

  <xsl:template name="PIENAVMOBILEHEADER">
    <xsl:element name="div">
      <xsl:attribute name="data-role">header</xsl:attribute>
      <xsl:attribute name="data-add-back-btn">true</xsl:attribute>
      <xsl:call-template name="PIENAVBAR"/>
      <xsl:element name="h1">
        <xsl:value-of select="/pie/section/h"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="PIENAVMOBILEFOOTER">
    <xsl:element name="div">
      <xsl:attribute name="data-role">footer</xsl:attribute>
      <xsl:call-template name="PIENAVBAR"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="PIENAVBAR">
    <xsl:element name="div">
      <xsl:attribute name="data-role">navbar</xsl:attribute>
      <xsl:element name="ul">
        <xsl:element name="li">
          <xsl:element name="a">
            <xsl:attribute name="data-icon">bars</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:text>javascript:window.location.assign(window.document.URL.replace(/(cxp|xsl)=[^&amp;]*/i,'cxp=PiejQmDefault'));</xsl:text>
            </xsl:attribute>
            <xsl:text>Layout</xsl:text>
          </xsl:element>
        </xsl:element>
        <xsl:element name="li">
          <xsl:element name="a">
            <xsl:attribute name="data-icon">calendar</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:text>javascript:window.location.assign(window.document.URL.replace(/(cxp|xsl)=[^&amp;]*/i,'cxp=PiejQmCalendar'));</xsl:text>
            </xsl:attribute>
            <xsl:text>Calendar</xsl:text>
          </xsl:element>
        </xsl:element>
        <xsl:element name="li">
          <xsl:element name="a">
            <xsl:attribute name="data-icon">grid</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:text>javascript:window.location.assign(window.document.URL.replace(/(cxp|xsl)=[^&amp;]*/i,'cxp=PiejQmTodo'));</xsl:text>
            </xsl:attribute>
            <xsl:text>Todo</xsl:text>
          </xsl:element>
        </xsl:element>
        <xsl:element name="li">
          <xsl:element name="a">
            <xsl:attribute name="data-icon">bullets</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:text>javascript:window.location.assign(window.document.URL.replace(/(cxp|xsl)=[^&amp;]*/i,'cxp=PiejQEditor'));</xsl:text>
            </xsl:attribute>
            <xsl:text>Editor</xsl:text>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="section[count(ancestor::section) = 1]">
    <xsl:element name="div">
      <xsl:attribute name="data-role">collapsible</xsl:attribute>
      <xsl:attribute name="data-collapsed">true</xsl:attribute>
      <xsl:element name="h3">
        <xsl:value-of select="h"/>
      </xsl:element>
      <xsl:apply-templates select="*[not(name()='h')]"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
