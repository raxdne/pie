<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="PiePlain.xsl"/>
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:variable name="newline">
    <xsl:text>
</xsl:text>
  </xsl:variable>
  <xsl:variable name="newpar">
    <xsl:text>

</xsl:text>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="h">
    <xsl:for-each select="ancestor::section">
      <xsl:text>=</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:for-each select="ancestor::section">
      <xsl:text>=</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="$newpar"/>
  </xsl:template>
  

  <xsl:template match="section">
    <xsl:apply-templates select="h"/>
    <xsl:apply-templates select="*[not(name(.) = 'h')]"/>
    <xsl:value-of select="$newline"/>
  </xsl:template>


  <xsl:template match="task">
    <!--  -->
    <xsl:call-template name="DATESTRING"/>
    <xsl:call-template name="TIMESTRING"/>
    <xsl:value-of select="normalize-space(h)"/>
    <xsl:value-of select="$newpar"/>
    <xsl:apply-templates select="p|list|pre"/>
  </xsl:template>

  <xsl:template match="list">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="p">
    <xsl:choose>
      <xsl:when test="name(parent::*) = 'list' or name(parent::*) = 'task'">
        <!-- list item -->
        <xsl:choose>
          <xsl:when test="parent::list/attribute::enum = 'yes'">
            <!-- eumerated item -->
            <xsl:for-each select="ancestor::list">
              <xsl:text>#</xsl:text>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="parent::task">
            <!-- eumerated item -->
            <xsl:text>*</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <!-- list item -->
            <xsl:for-each select="ancestor::list">
              <xsl:text>*</xsl:text>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <!-- para -->
    <xsl:call-template name="DATESTRING"/>
    <xsl:call-template name="TIMESTRING"/>
    <xsl:apply-templates/>
    <xsl:value-of select="$newline"/>
  </xsl:template>


  <xsl:template match="img">
    <xsl:value-of select="@src"/>
  </xsl:template>
  <xsl:template match="fig">
    <xsl:text>Abb. </xsl:text>
    <xsl:value-of select="img/@src"/>
    <xsl:if test="h">
      <xsl:text>: </xsl:text>
      <xsl:value-of select="h"/>
    </xsl:if>
    <xsl:value-of select="$newpar"/>
  </xsl:template>
  <xsl:template match="pre">
    <xsl:value-of select="concat($newline,'&lt;','code','&gt;')"/>
    <xsl:copy-of select="text()"/>
    <xsl:value-of select="concat('&lt;','/code','&gt;',$newpar)"/>
  </xsl:template>
  <xsl:template match="*"/>
</xsl:stylesheet>
