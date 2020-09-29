<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!--

PKG2 - ProzessKettenGenerator second implementation 
Copyright (C) 1999-2006 by Alexander Tenbusch

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License 
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

-->

<xsl:output method='xml' version='1.0' encoding='UTF-8'/>

  <!--  -->
  <xsl:variable name="url_prefix" select="''"/>

  <xsl:template match="/">
  <!-- <xsl:processing-instruction name="import">
      <xsl:text>href="../xml/xsl/pie2html.xsl" type="text/xsl"</xsl:text>
    </xsl:processing-instruction> -->
    <xsl:element name="pie">
      <xsl:choose>
        <xsl:when test="//div[@id='content']"> <!-- Wikimedia -->
          <xsl:apply-templates select="//div[@id='content']/*"/> 
        </xsl:when>
        <xsl:when test="//div[@id='spArticleColumn']"> <!-- Spiegel Online -->
          <xsl:apply-templates select="//div[@id='spArticleColumn']/*"/> 
        </xsl:when>
        <xsl:when test="//div[@id='mitte_news']"> <!-- http://www.heise.de/newsticker/ -->
          <xsl:apply-templates select="//div[@id='mitte_news']/*"/> 
        </xsl:when>
        <xsl:when test="//heisetext"> <!-- http://www.heise.de/tp/ -->
          <xsl:apply-templates select="//heisetext/*"/> 
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/> 
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
      
  <xsl:template match="title|h1|h2|h3|h4">
    <xsl:element name="section">
      <xsl:element name="h">
        <xsl:value-of select="."/>
      </xsl:element>
      <!-- 
      <xsl:apply-templates select="following-sibling::*"/> 
      -->
    </xsl:element>
  </xsl:template>

  <xsl:template match="table">
    <xsl:element name="{name()}">
      <xsl:apply-templates/> 
    </xsl:element>
  </xsl:template>

  <xsl:template match="th|td|tr">
    <xsl:element name="{name()}">
      <xsl:apply-templates/> 
    </xsl:element>
  </xsl:template>

  <xsl:template match="a[@href]">
    <xsl:element name="link">
      <xsl:attribute name="href">
        <xsl:value-of select="concat($url_prefix,@href)"/>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="strong|div|font">
    <xsl:apply-templates/> 
  </xsl:template>
      
  <xsl:template match="em|it|tt|i|b|u">
    <xsl:element name="{name()}">
      <xsl:apply-templates/> 
    </xsl:element>
  </xsl:template>

  <xsl:template match="p|li|center">
    <xsl:choose>
      <xsl:when test="child::p">
        <xsl:apply-templates/> 
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="p">
          <xsl:apply-templates/> 
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
      
  <xsl:template match="img">
    <xsl:element name="fig">
      <xsl:element name="img">
        <xsl:attribute name="src">
          <xsl:value-of select="@src"/>
        </xsl:attribute>
      </xsl:element>
      <xsl:if test="not(@alt='')">
        <xsl:element name="h">
          <xsl:value-of select="@alt"/>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
      
  <xsl:template match="script">
    <!-- ignore -->
  </xsl:template>
      
  <xsl:template match="ul|ol">
    <xsl:element name="list">
      <xsl:apply-templates/> 
    </xsl:element>
  </xsl:template>
      
  <xsl:template match="*">
    <!-- ignore -->
    <xsl:apply-templates/> 
  </xsl:template>
      
</xsl:stylesheet>
