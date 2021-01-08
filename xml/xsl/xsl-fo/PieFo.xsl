<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">
  <xsl:import href="../Utils.xsl"/>
  <xsl:variable name="flag_fig" select="true()"/>
  <xsl:attribute-set name="paragraph">
    <!-- <xsl:attribute name="font-family">Courier</xsl:attribute> -->
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="hyphenate">true</xsl:attribute>
    <xsl:attribute name="margin-bottom">5pt</xsl:attribute>
    <xsl:attribute name="text-align">justify</xsl:attribute>
    <xsl:attribute name="xml:lang">de</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="struct">
    <xsl:attribute name="hyphenate">true</xsl:attribute>
    <xsl:attribute name="margin-bottom">15pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="item">
    <xsl:attribute name="text-align">left</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="header">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="keep-with-next">always</xsl:attribute>
    <xsl:attribute name="margin-top">10pt</xsl:attribute>
    <xsl:attribute name="margin-bottom">10pt</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
  </xsl:attribute-set>
  <xsl:template match="author|date">
    <xsl:element name="center">
      <xsl:element name="i">
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="section">
    <xsl:param name="str_number_context"/>
    <xsl:variable name="str_number">
      <xsl:if test="not($str_number_context)=''">
        <xsl:value-of select="concat($str_number_context,'.')"/>
      </xsl:if>
      <xsl:number/>
    </xsl:variable>
    <xsl:if test="h">
      <xsl:element name="fo:block" use-attribute-sets="paragraph header">
        <xsl:attribute name="font-size">
          <xsl:choose>
            <xsl:when test="count(ancestor::section) &lt; 1">
              <!-- -->
              <xsl:text>14pt</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::section) &lt; 2">
              <!-- -->
              <xsl:text>12pt</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <!--  -->
              <xsl:text>10pt</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:if test="h/@hidden">
          <xsl:attribute name="font-style">italic</xsl:attribute>
        </xsl:if>
        <xsl:if test="count(ancestor-or-self::section) &lt; 4">
          <xsl:value-of select="concat($str_number,' ')"/>
        </xsl:if>
        <xsl:value-of select="h"/>
      </xsl:element>
    </xsl:if>
    <xsl:apply-templates select="*[not(name(.) = 'h')]">
      <!-- * -->
      <xsl:with-param name="str_number_context" select="$str_number"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="task">
    <xsl:element name="fo:block" use-attribute-sets="paragraph struct">
      <xsl:attribute name="border-style">solid</xsl:attribute>
      <xsl:attribute name="margin">10pt</xsl:attribute>
      <xsl:attribute name="padding">10pt</xsl:attribute>
      <xsl:if test="h">
        <xsl:element name="fo:block">
          <xsl:choose>
            <xsl:when test="@done">
              <!-- -->
              <xsl:attribute name="text-decoration">line-through</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <!--  -->
              <xsl:attribute name="font-style">italic</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="h"/>
        </xsl:element>
      </xsl:if>
      <xsl:apply-templates select="*[not(name(.) = 'h')]"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="list">
    <xsl:if test="child::*[not(@hidden) or @hidden &lt;= $level_hidden]">
      <xsl:choose>
        <xsl:when test="name(parent::node()) = 'list'">
          <!-- list item -->
          <xsl:element name="fo:list-item">
            <xsl:element name="fo:list-item-label">
              <xsl:element name="fo:block">
                <xsl:text/>
              </xsl:element>
            </xsl:element>
            <xsl:element name="fo:list-item-body">
              <xsl:attribute name="start-indent">body-start() + 5pt</xsl:attribute>
              <xsl:element name="fo:list-block">
                <xsl:apply-templates/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="fo:block">
            <xsl:element name="fo:list-block">
              <xsl:attribute name="provisional-label-separation">2pt</xsl:attribute>
              <xsl:attribute name="start-indent">5pt</xsl:attribute>
              <xsl:apply-templates/>
            </xsl:element>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template match="p">
    <xsl:choose>
      <xsl:when test="name(parent::node()) = 'list'">
        <!-- list item -->
        <xsl:element name="fo:list-item">
          <xsl:element name="fo:list-item-label">
            <xsl:attribute name="end-indent">label-end()</xsl:attribute>
            <xsl:element name="fo:block" use-attribute-sets="paragraph item">
              <xsl:choose>
                <xsl:when test="@hidden &gt; $level_hidden">
                  <!-- ignore hidden paragraph -->
                </xsl:when>
                <xsl:when test="parent::list/attribute::enum = 'yes'">
                  <!-- simple paragraph -->
                  <xsl:number/>
                  <xsl:text>.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <!-- really hidden paragraph -->
                  <xsl:text>-</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:element>
          <xsl:element name="fo:list-item-body">
            <xsl:attribute name="start-indent">body-start()</xsl:attribute>
            <xsl:element name="fo:block" use-attribute-sets="paragraph item">
              <xsl:choose>
                <xsl:when test="@hidden &gt; $level_hidden">
                  <!-- ignore hidden paragraph -->
                </xsl:when>
                <xsl:otherwise>
                  <!--  -->
                  <xsl:if test="@hidden">
                    <xsl:attribute name="font-style">italic</xsl:attribute>
                  </xsl:if>
                  <xsl:apply-templates/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <!-- simple paragraph -->
        <xsl:element name="fo:block" use-attribute-sets="paragraph">
          <xsl:if test="@hidden">
            <xsl:attribute name="font-style">italic</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="i">
    <!-- italic -->
    <xsl:element name="fo:inline" use-attribute-sets="paragraph">
      <xsl:attribute name="font-style">italic</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="pre|import">
    <!-- preformatted paragraph -->
    <xsl:element name="fo:block" use-attribute-sets="paragraph">
      <xsl:attribute name="font-family">Courier</xsl:attribute>
      <xsl:attribute name="font-size">8pt</xsl:attribute>
      <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="link">
    <xsl:choose>
      <xsl:when test="@href">
        <xsl:element name="fo:inline" use-attribute-sets="paragraph">
          <xsl:attribute name="color">#0000ff</xsl:attribute>
          <xsl:attribute name="text-decoration">underline</xsl:attribute>
          <xsl:element name="fo:basic-link">
            <!--  -->
            <xsl:attribute name="external-destination">
              <xsl:value-of select="@href"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:element>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="fig">
    <xsl:element name="fo:block-container">
      <xsl:attribute name="margin-bottom">10pt</xsl:attribute>
      <!-- normal figure -->
      <xsl:if test="$flag_fig">
	<xsl:apply-templates select="img"/>
      </xsl:if>
      <xsl:if test="h">
	<xsl:element name="fo:block">
          <xsl:attribute name="margin">10pt</xsl:attribute>
          <xsl:attribute name="text-align">center</xsl:attribute>
          <xsl:element name="fo:inline">
            <xsl:attribute name="text-decoration">underline</xsl:attribute>
            <xsl:text>Abb.:</xsl:text>
          </xsl:element>
          <xsl:text> </xsl:text>
          <xsl:value-of select="h"/>
	</xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  <xsl:template match="img">
    <xsl:element name="fo:block">
      <xsl:attribute name="margin">10pt</xsl:attribute>
      <xsl:attribute name="text-align">center</xsl:attribute>
      <xsl:element name="fo:external-graphic">
        <xsl:copy-of select="@src"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="table">
    <xsl:element name="fo:table">
      <xsl:element name="fo:table-body">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tr">
    <xsl:if test="th or td">
      <xsl:element name="fo:table-row">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template match="th|td">
    <xsl:element name="fo:table-cell">
      <xsl:attribute name="border-style">solid</xsl:attribute>
      <xsl:element name="fo:block" use-attribute-sets="paragraph">
        <xsl:attribute name="margin">3pt</xsl:attribute>
        <xsl:if test="name() = 'th'">
          <xsl:attribute name="font-weight">bold</xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="*">
    <xsl:element name="fo:block" use-attribute-sets="paragraph">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template name="HEADER">
    <fo:layout-master-set>
      <!-- layout for the first page -->
      <fo:simple-page-master master-name="first" page-height="29.7cm" page-width="21cm" margin-top="1cm" margin-bottom="2cm" margin-left="2.5cm" margin-right="2.5cm">
        <fo:region-body margin-top="1cm"/>
        <fo:region-before extent="1cm"/>
        <fo:region-after extent="1.5cm"/>
      </fo:simple-page-master>
      <!-- layout for the other pages -->
      <fo:simple-page-master master-name="rest" page-height="29.7cm" page-width="21cm" margin-top="1cm" margin-bottom="2cm" margin-left="2.5cm" margin-right="2.5cm">
        <fo:region-body margin-top="1cm"/>
        <fo:region-before extent="1cm"/>
        <fo:region-after extent="1.5cm"/>
      </fo:simple-page-master>
      <fo:page-sequence-master master-name="basicPSM">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference master-reference="first" page-position="first"/>
          <fo:conditional-page-master-reference master-reference="rest" page-position="rest"/>
          <!-- recommended fallback procedure -->
          <fo:conditional-page-master-reference master-reference="rest"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>
    </fo:layout-master-set>
    <!--
    <xsl:element name="head">

      <xsl:element name="meta">
        <xsl:attribute name="name">
          <xsl:text>generator</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="content">
          <xsl:text>cxproc PIE/XML</xsl:text>
        </xsl:attribute>
      </xsl:element>

      <xsl:if test="/pie/section/h">
        <xsl:element name="title">
          <xsl:value-of select="/pie/section/h"/>
        </xsl:element>
      </xsl:if>
    </xsl:element>
-->
  </xsl:template>
  <xsl:template match="*[@valid='no']">
    <!-- ignore this elements -->
  </xsl:template>
  <xsl:template match="meta|t|tag">
    <!-- ignore this elements -->
  </xsl:template>
</xsl:stylesheet>
