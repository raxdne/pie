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

  <xsl:output method="html" encoding="UTF-8"/>  

  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:apply-templates/> 
    </xsl:element>
  </xsl:template>
      
  <xsl:template match="pie">
    <xsl:element name="ul">
      <xsl:apply-templates/> 
    </xsl:element>
  </xsl:template>
      
  <xsl:template match="section">
    <xsl:choose>
      <xsl:when test="h">
        <xsl:apply-templates select="h"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:apply-templates/> 
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
      
  <xsl:template match="list">
    <xsl:element name="ul">
      <xsl:apply-templates/> 
    </xsl:element>
  </xsl:template>
      
  <xsl:template match="h">
    <xsl:element name="li">
      <xsl:value-of select="."/>
    </xsl:element>
    <xsl:element name="ul">
      <xsl:apply-templates select="following-sibling::*"/> 
    </xsl:element>
  </xsl:template>
      
  <xsl:template match="p">
    <xsl:element name="li">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>
      
  <xsl:template match="*">
    <xsl:apply-templates/> 
  </xsl:template>
      
</xsl:stylesheet>
