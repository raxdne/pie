<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method='text' encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:text>Component,Summary,IssueType
</xsl:text>
    <xsl:apply-templates select="//task[not(@valid = 'no') and not(@done) and not(ancestor::section[@valid = 'no' or @done])]"/>
  </xsl:template>


  <xsl:template match="task">
    <!--
    <xsl:value-of select="concat('&quot;',translate(normalize-space(concat(parent::section/parent::section/h,' / ',parent::section/h)),'&quot;',' '),'&quot;')"/>
    --> 
    <xsl:value-of select="concat('&quot;',translate(normalize-space(parent::section/parent::section/h),'&quot;',' '),'&quot;')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="concat('&quot;',translate(normalize-space(concat(parent::section/h,', ',h)),'&quot;',' '),'&quot;')"/>
    <!--
    <xsl:value-of select="normalize-space(concat('&quot;',parent::section/parent::section/h,' / ',parent::section/h,'&quot;'))"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="normalize-space(concat('&quot;',h,'&quot;'))"/>
    <xsl:value-of select="translate(normalize-space(concat('&quot;',parent::section/parent::section/h,' / ',parent::section/h,'&quot;')),',;','__')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(normalize-space(concat('&quot;',h,'&quot;')),',;','__')"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="translate(normalize-space(concat('&quot;',descendant::*[name()='p' or name()='list'],'&quot;')),',;','__')"/>
    --> 
    <xsl:text>,</xsl:text>
    <xsl:choose>
      <xsl:when test="contains(translate(h,'abcdefghijklmnopqrstuvwxyzäöü','ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ'),'BUG')">
        <xsl:text>bug</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>task</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>
</xsl:text>
  </xsl:template>

</xsl:stylesheet>
