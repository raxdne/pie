<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="PiePlain.xsl"/>
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:variable name="str_path"></xsl:variable>

  <xsl:variable name="str_tagtime"></xsl:variable>

  <xsl:variable name="newpar">
    <xsl:text>

</xsl:text>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="string-length($str_path) &gt; 0">
	<xsl:value-of select="concat($newpar,'ORIGIN: ', $str_path, $newpar)"/>
      </xsl:when>
      <xsl:when test="pie/file/@name">
	<xsl:value-of select="concat($newpar,'ORIGIN: ', pie/file/@prefix,'/',pie/file/@name, $newpar)"/>
      </xsl:when>
      <xsl:otherwise>
	<!-- no locator found -->
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="TAGTIME">
      <xsl:with-param name="str_tagtime" select="concat('; ',$str_tagtime,$newpar)"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="h">
    <xsl:if test="parent::section">
      <xsl:for-each select="ancestor::section">
        <xsl:text>*</xsl:text>
      </xsl:for-each>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:call-template name="DATESTRING"/>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="section">
    <xsl:apply-templates select="h"/>
    <xsl:call-template name="FORMATIMPACT"/>
    <xsl:value-of select="$newpar"/>
    <xsl:apply-templates select="*[not(name(.) = 'h')]"/>
  </xsl:template>
  
  <xsl:template match="task">
    <xsl:call-template name="FORMATTASK"/>
    <xsl:call-template name="FORMATIMPACT"/>
    <xsl:value-of select="$newpar"/>
    <xsl:apply-templates select="*[not(name()='h')]"/>
  </xsl:template>

  <xsl:template match="list">
    <xsl:if test="name(parent::*) = 'p'">
      <xsl:value-of select="$newpar"/>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="p">
    <xsl:call-template name="FORMATPREFIX"/>
    <xsl:apply-templates/>
    <xsl:call-template name="FORMATIMPACT"/>
    <xsl:value-of select="$newpar"/>
  </xsl:template>
  
  <xsl:template match="table">
    <xsl:text>#begin_of_csv
</xsl:text>
    <xsl:for-each select="tr">
      <xsl:for-each select="th|td"> <!-- TODO: use header markup -->
	<xsl:value-of select="concat(text(),';')"/>
      </xsl:for-each>
      <xsl:text>
</xsl:text>
    </xsl:for-each>
    <xsl:text>#end_of_csv
    
</xsl:text>
  </xsl:template>
  <xsl:template match="pre">
    <xsl:text>
#begin_of_pre
</xsl:text>
    <xsl:value-of select="text()"/>
    <xsl:text>
#end_of_pre
</xsl:text>
    <xsl:value-of select="$newpar"/>
  </xsl:template>
  <xsl:template match="t|meta">
    <!-- ignore normal text nodes -->
  </xsl:template>
</xsl:stylesheet>
