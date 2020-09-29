<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="PieHtml.xsl"/>
  <xsl:template name="PIENAVMOBILEHEADER">
    <xsl:element name="div">
      <xsl:attribute name="data-role">header</xsl:attribute>
      <xsl:attribute name="data-add-back-btn">true</xsl:attribute>
      <xsl:element name="h1">
        <xsl:value-of select="/pie/section/h"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="PIENAVMOBILEFOOTER">
    <xsl:element name="div">
      <xsl:attribute name="data-role">footer</xsl:attribute>
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
                <xsl:text>javascript:window.location.assign(window.document.URL.replace(/(cxp|xsl)=[^&amp;]*/i,'cxp=PiejQmTodoContact'));</xsl:text>
              </xsl:attribute>
              <xsl:text>Contact</xsl:text>
            </xsl:element>
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
  <xsl:template match="*[@valid='no']">
    <!-- ignore this elements -->
  </xsl:template>
  <xsl:template match="task|target">
    <xsl:choose>
      <xsl:when test="@done">
        <!-- ignore this elements -->
      </xsl:when>
      <xsl:when test="name(parent::node()) = 'list'">
        <!-- list item -->
        <xsl:element name="li">
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="p">
          <xsl:call-template name="CLASSATRIBUTE"/>
          <xsl:apply-templates select="h"/>
          <xsl:text> / </xsl:text>
          <!-- calendar marker -->
          <xsl:call-template name="DATESTRING"/>
          <xsl:text> / </xsl:text>
          <xsl:value-of select="@effort"/>
          <xsl:for-each select="contact">
            <xsl:text> / </xsl:text>
            <xsl:value-of select="@idref"/>
          </xsl:for-each>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="section[count(*[not(name()='h')]) &lt; 1]">
    <!-- ignore this elements -->
  </xsl:template>
  <xsl:template match="meta">
    <!-- ignore this elements -->
  </xsl:template>
</xsl:stylesheet>
