<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:variable name="tabulator">
  <xsl:text>	</xsl:text>
</xsl:variable>

<xsl:variable name="newline">
<!-- a newline xsl:text element -->
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="newpar">
<xsl:text>

</xsl:text>
</xsl:variable>

<!-- template that actually does the conversion 
     http://www.xmlpitstop.com/XMLJournal/Article6-November2001/sourcecode/Q3-RecursionExamples/LineFeed_to_br/LF_to_BR.xsl
-->
<xsl:template name="lf2br">
  <xsl:param name="StringToTransform"/>
  <xsl:choose>
    <xsl:when test="contains($StringToTransform,'&#xA;')">
      <xsl:value-of select="substring-before($StringToTransform,'&#xA;')"/>
      <xsl:text> </xsl:text>
      <xsl:call-template name="lf2br">
        <xsl:with-param name="StringToTransform">
          <xsl:value-of select="substring-after($StringToTransform,'&#xA;')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$StringToTransform"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

  <xsl:template name="FORMATTASKPREFIX">
    <xsl:choose>
      <xsl:when test="@class = 'todo' and @state = 'done'">
	<xsl:value-of select="concat('DONE: ','')"/>
      </xsl:when>
      <xsl:when test="@class">
        <xsl:value-of select="concat(translate(@class,'todnreqabugs','TODNREQABUGS'),': ')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('TODO: ','')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="FORMATTASK">
    <xsl:call-template name="FORMATTASKPREFIX"/>
    <xsl:apply-templates select="h"/>
  </xsl:template>

  <xsl:template name="DATESTRING">
    <xsl:choose>
      <xsl:when test="@done = '1'">
	  <xsl:text> ✔ </xsl:text>
      </xsl:when>
      <xsl:when test="ancestor-or-self::*[@done]">
	<xsl:value-of select="concat(ancestor-or-self::*[@done][1]/@done,' ✔ ')"/>
      </xsl:when>
      <xsl:when test="ancestor-or-self::*[@date]">
	<xsl:value-of select="concat(ancestor-or-self::*[@date][1]/@date,' ')"/>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="FORMATIMPACT">
    <!--  -->
    <xsl:choose>
      <xsl:when test="@impact='1' and not(ancestor::*[@impact = '1'])">
	<xsl:text> +++</xsl:text>
      </xsl:when>
      <xsl:when test="@impact='2' and not(ancestor::*[@impact &lt; 3])">
	<xsl:text> ++</xsl:text>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="MIMETYPE">
    <!-- converts MIME type string into RFC 1738 format -->
    <xsl:param name="str_type"/>
    <xsl:choose>
      <xsl:when test="contains($str_type,'+') and contains(substring-after($str_type,'+'),'+')"> <!-- two '+' -->
        <xsl:value-of select="concat(substring-before($str_type,'+'),'%2B',substring-before(substring-after($str_type,'+'),'+'),'%2B',substring-after(substring-after($str_type,'+'),'+'))"/>
      </xsl:when>
      <xsl:when test="contains($str_type,'+')"> <!-- single '+' -->
        <xsl:value-of select="concat(substring-before($str_type,'+'),'%2B',substring-after($str_type,'+'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str_type"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
