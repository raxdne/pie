<?xml version="1.0"?>
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
  <xsl:output method="xml" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:element name="site">
      <xsl:apply-templates select="pie/section/section/section[@class='slide']"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="section[@class='slide']">
    <xsl:element name="page">
      <xsl:element name="title">
        <xsl:text>Folie </xsl:text>
        <xsl:value-of select="position()"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="h"/>
      </xsl:element>
      <xsl:element name="url">
        <xsl:text>presentation-</xsl:text>
        <xsl:value-of select="position()"/>
        <xsl:text>.html</xsl:text>
      </xsl:element>
<!--
      <xsl:element name="text">
        <xsl:value-of select="h"/>
      </xsl:element>
-->
      <xsl:element name="content">
<!--
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
-->
<xsl:apply-templates/>
      </xsl:element>
      <xsl:element name="rank">
        <xsl:text>1</xsl:text>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="."/>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
