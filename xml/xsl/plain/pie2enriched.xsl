<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" encoding="UTF-8"/> <!-- https://tools.ietf.org/html/rfc1896 -->

<xsl:variable name="newpar">
<xsl:text>

</xsl:text>
</xsl:variable>

  <xsl:template match="/">
<xsl:text>Content-Type: text/enriched
Text-Width: 70


</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="pie">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="h">
    <xsl:text>&lt;bold&gt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&lt;/bold&gt;</xsl:text>
    <xsl:value-of select="concat($newpar,$newpar,$newpar)"/>
  </xsl:template>
  

  <xsl:template match="section">
    <xsl:apply-templates select="h"/>
    <xsl:apply-templates select="*[not(name(.) = 'h' or name(.) = 't')]"/>
  </xsl:template>


  <xsl:template match="task">
    <!--  -->
    <xsl:value-of select="normalize-space(h)"/>
    <xsl:value-of select="$newpar"/>
    <xsl:apply-templates select="p|list|pre|contact"/>
  </xsl:template>

  <xsl:template match="target">
    <!--  -->
    <xsl:value-of select="normalize-space(concat('Ziel: ',h))"/>
    <xsl:value-of select="$newpar"/>
  </xsl:template>


  <xsl:template match="contact">
    <!--  -->
    <xsl:if test="child::*">
      <xsl:value-of select="concat(@idref,':')"/>
      <xsl:value-of select="$newpar"/>
      <xsl:apply-templates select="p|list|pre"/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="list">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="p">
    <xsl:text>&lt;indent&gt;</xsl:text>
    <xsl:choose>
      <xsl:when test="name(parent::*) = 'list' or name(parent::*) = 'contact' or name(parent::*) = 'task'">
        <!-- list item -->
        <xsl:choose>
          <xsl:when test="parent::list/attribute::enum = 'yes'">
            <!-- eumerated item -->
            <xsl:for-each select="ancestor::list">
              <xsl:text>+</xsl:text>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="parent::contact or parent::task">
            <!-- eumerated item -->
            <xsl:text>-</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <!-- list item -->
            <xsl:for-each select="ancestor::list">
              <xsl:text>-</xsl:text>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
    <xsl:text>&lt;/indent&gt;</xsl:text>
    <xsl:value-of select="concat($newpar,$newpar)"/>
  </xsl:template>


  <xsl:template match="pre">
    <xsl:text>#begin_of_pre
</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>#end_of_pre</xsl:text>
    <xsl:value-of select="$newpar"/>
  </xsl:template>


  <xsl:template match="fig">
    <xsl:text>Abb. </xsl:text>
    <xsl:value-of select="img/@src"/>
    <xsl:if test="h">
      <xsl:text> </xsl:text>
      <xsl:value-of select="h"/>
    </xsl:if>
    <xsl:value-of select="$newpar"/>
  </xsl:template>

  <xsl:template match="tag|t">
    <!-- ignore normal text nodes -->
  </xsl:template>

</xsl:stylesheet>

