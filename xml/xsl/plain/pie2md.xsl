<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="PiePlain.xsl"/>
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:variable name="str_tagtime" select="''"/>
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:call-template name="TAGTIME">
      <xsl:with-param name="str_tagtime" select="concat('; ',$str_tagtime,$newpar)"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="h">
    <xsl:if test="parent::section">
    <xsl:for-each select="ancestor::section">
      <xsl:text>#</xsl:text>
    </xsl:for-each>
    <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="section">
    <xsl:apply-templates select="h"/>
    <xsl:call-template name="FORMATIMPACT"/>
    <xsl:value-of select="$newpar"/>
    <xsl:apply-templates select="*[not(name(.) = 'h')]"/>
  </xsl:template>
  <xsl:template match="task">
    <xsl:call-template name="FORMATPREFIX"/>
    <xsl:call-template name="FORMATTASK"/>
    <xsl:call-template name="FORMATIMPACT"/>
    <xsl:value-of select="$newpar"/>
    <xsl:apply-templates select="*[not(name()='h')]"/>
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
    <xsl:if test="not(parent::list)">
      <xsl:value-of select="$newline"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="p">
    <xsl:choose>
      <xsl:when test="name(parent::*) = 'list' or name(parent::*) = 'contact' or name(parent::*) = 'task'">
        <!-- list item -->
        <xsl:if test="count(ancestor::list) &gt; 1">
          <xsl:for-each select="ancestor::list[position() &gt; 1]">
            <xsl:if test="attribute::enum = 'yes'">
	      <!-- eumerated -->
	      <xsl:text> </xsl:text>
	    </xsl:if>
	    <xsl:text>  </xsl:text>
          </xsl:for-each>
	</xsl:if>
        <xsl:choose>
          <xsl:when test="parent::list/attribute::enum = 'yes'">
            <!-- eumerated -->
	    <xsl:text>1)</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>-</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
	<xsl:apply-templates/>
    <xsl:call-template name="FORMATIMPACT"/>
	<xsl:value-of select="$newline"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
    <xsl:call-template name="FORMATIMPACT"/>
	<xsl:value-of select="$newpar"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- para -->
  </xsl:template>
  <xsl:template match="pre">
    <xsl:call-template name="PREBLOCK">
      <xsl:with-param name="StringToTransform">
	<xsl:value-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="$newpar"/>
  </xsl:template>
  <xsl:template match="tag|t">
    <!-- ignore normal text nodes -->
  </xsl:template>

  <xsl:template name="PREBLOCK">
    <xsl:param name="StringToTransform"/>
    <xsl:choose>
      <!-- string contains linefeed -->
      <xsl:when test="contains($StringToTransform,$newline)">
	<xsl:value-of select="concat('    ',substring-before($StringToTransform,$newline),$newline)"/>
	<xsl:if test="string-length(substring-after($StringToTransform,$newline)) &gt; 0">
	  <xsl:value-of select="concat('    ',$newline)"/>
	  <!-- repeat for the remainder of the original string -->
	  <xsl:call-template name="PREBLOCK">
            <xsl:with-param name="StringToTransform">
              <xsl:value-of select="substring-after($StringToTransform,$newline)"/>
            </xsl:with-param>
	  </xsl:call-template>
	</xsl:if>
      </xsl:when>
      <!-- string does not contain newline, so just output it -->
      <xsl:when test="string-length($StringToTransform) &gt; 0">
        <xsl:value-of select="concat('&gt; ',$StringToTransform,$newline)"/>
      </xsl:when>
      <xsl:otherwise>
	<!-- ignoring empty string -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="FORMATPREFIX">
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
          <xsl:when test="parent::task">
            <!-- eumerated item -->
            <xsl:text>-</xsl:text>
          </xsl:when>
          <xsl:when test="parent::contact">
            <!-- eumerated item -->
            <xsl:text>--</xsl:text>
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
  </xsl:template>

</xsl:stylesheet>
