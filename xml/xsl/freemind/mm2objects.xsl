<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!-- writes all Freemind nodes into a Javascript object skeleton -->
  <xsl:import href="../Utils.xsl"/>
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:variable name="str_class" select="/map/node[1]/@TEXT"/>
  <xsl:template match="/map">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  <xsl:template match="node[parent::*[name()='node' and @TEXT='Methods']]">
    <xsl:value-of select="concat('// ', $newline)"/>
    <xsl:for-each select="child::*">
      <xsl:value-of select="concat('// ',@TEXT, ' - ',$newline)"/>
    </xsl:for-each>
    <xsl:value-of select="concat('// ', $newline)"/>
    <xsl:choose>
      <xsl:when test="@TEXT='Constructor'">
<!-- constructor of this object -->
        <xsl:value-of select="concat($str_class,'')"/>
      </xsl:when>
      <xsl:otherwise>
<!-- method of this object -->
        <xsl:value-of select="concat($str_class,'.prototype.',@TEXT)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="concat('',' = function (')"/>
    <xsl:for-each select="child::*">
      <xsl:if test="position() &gt; 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:value-of select="@TEXT"/>
    </xsl:for-each>
    <xsl:value-of select="concat(') {', $newline, $newline)"/>
    <xsl:if test="@TEXT='Constructor'">
      <xsl:for-each select="child::*|parent::*/parent::*/child::*[name()='node' and @TEXT='Properties']/child::*">
<!-- all properties of this object -->
        <xsl:value-of select="concat('  this.',@TEXT,' = ',@TEXT,';',' // ',child::*/@TEXT,$newline)"/>
      </xsl:for-each>
    </xsl:if>
    <xsl:value-of select="concat($newline,'  //return;', $newline, '}', $newline, $newline)"/>
    <xsl:if test="@TEXT='Constructor'">
      <xsl:for-each select="parent::*/parent::*/child::*[name()='node' and @TEXT='Properties']/child::*">
<!-- setter methods -->
        <xsl:value-of select="concat('// ', $newline)"/>
        <xsl:value-of select="concat('// set method for ',@TEXT,$newline)"/>
        <xsl:value-of select="concat('// ', $newline)"/>
        <xsl:value-of select="concat($str_class,'.prototype.','set',@TEXT,' = function (',@TEXT,') {',$newline,$newline)"/>
        <xsl:value-of select="concat('  this.',@TEXT,' = ',@TEXT,';',$newline)"/>
        <xsl:value-of select="concat($newline,'  //return;', $newline, '}', $newline, $newline)"/>
<!-- getter methods -->
        <xsl:value-of select="concat('// ', $newline)"/>
        <xsl:value-of select="concat('// get method for ',@TEXT,$newline)"/>
        <xsl:value-of select="concat('// ', $newline)"/>
        <xsl:value-of select="concat($str_class,'.prototype.','get',@TEXT,' = function () {',$newline,$newline)"/>
        <xsl:value-of select="concat('  return this.',@TEXT,';', $newline, '}', $newline, $newline)"/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
