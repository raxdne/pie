<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- http://ch.tudelft.nl/~arthur/svn2cl/downloads.html -->

  <xsl:output method="xml"/>

  <!-- <xsl:variable name="str_title" select="''"/> -->

  <xsl:template match="/">
    <xsl:element name="pie">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="log">
    <xsl:element name="section">
      <xsl:element name="h">        
        <xsl:value-of select="concat('Subversion Log ',$str_title)"/>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!--  and starts-with(date,'2008-') and not(msg='') -->
  <xsl:template match="logentry[author='raxdne']">
    <xsl:element name="task">
      <xsl:attribute name="done">
        <xsl:value-of select="translate(substring-before(date,'T'),'-','')"/>
      </xsl:attribute>
      <!--
           <xsl:attribute name="effort">1</xsl:attribute>
           -->
      <xsl:element name="h">
        <xsl:text>rev</xsl:text>
        <xsl:value-of select="@revision"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="normalize-space(msg)"/>
      </xsl:element>
      <xsl:element name="list">
        <xsl:for-each select="paths/path">
          <xsl:element name="p">
            <xsl:value-of select="normalize-space(substring-after(substring-after(substring-after(.,'/'),'/'),'/'))"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*"/>

</xsl:stylesheet>
