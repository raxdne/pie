<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="PiePlain.xsl"/>
  <xsl:output method="text" encoding="UTF-8"/>
  
  <xsl:template match="section">
    <xsl:value-of select="$newline"/>
    <xsl:for-each select="ancestor-or-self::section">
      <xsl:text>#</xsl:text>
    </xsl:for-each>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="child::h/child::*|child::h/child::text()"/>
    <xsl:call-template name="FORMATIMPACT"/>
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates select="*[not(name(.) = 'h')]"/>
  </xsl:template>

  <xsl:template match="task">
    <xsl:value-of select="$newline"/>
    <xsl:call-template name="FORMATTASK"/>
    <xsl:call-template name="FORMATIMPACT"/>
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates select="*[not(name()='h')]"/>
  </xsl:template>

  <xsl:template match="list">
    <xsl:choose>
      <xsl:when test="parent::list">
      </xsl:when>
      <xsl:when test="parent::p">
	<xsl:value-of select="$newline"/>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="p">
    <xsl:choose>
      <xsl:when test="name(parent::*) = 'list' or name(parent::*) = 'task'">
        <xsl:for-each select="ancestor::list[position() &gt; 1]">
          <xsl:if test="attribute::enum = 'yes'">
	    <!-- eumerated -->
	    <xsl:text> </xsl:text>
	  </xsl:if>
	  <xsl:text>  </xsl:text>
        </xsl:for-each>
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
	<xsl:value-of select="$newline"/>
	<xsl:apply-templates/>
	<xsl:call-template name="FORMATIMPACT"/>
	<xsl:value-of select="$newline"/>
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
      <xsl:when test="name(parent::*) = 'list' or name(parent::*) = 'task'">
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

  <xsl:template match="t|tag|meta">
    <!-- ignore normal text nodes -->
  </xsl:template>

</xsl:stylesheet>
