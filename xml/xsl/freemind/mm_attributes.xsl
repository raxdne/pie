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

  <xsl:output method="xml" encoding="US-ASCII"/>  

  <!--  -->

  <xsl:template match="/">
    <xsl:element name="map">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="map">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates select="*"/>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:copy-of select="file/map/@*"/>
    <xsl:apply-templates select="file/map/*"/>
  </xsl:template>
  <xsl:template match="@*|node()">
    <xsl:choose>
      <!-- in valids -->
      <xsl:when test="name()='node' and count(node) &lt; 1 and count(attribute) &lt; 1">
        <xsl:element name="{name()}">
          <xsl:copy-of select="@*"/>
          <xsl:element name="attribute">
            <xsl:attribute name="NAME">date</xsl:attribute>
            <xsl:attribute name="VALUE"></xsl:attribute>
          </xsl:element>
          <xsl:element name="attribute">
            <xsl:attribute name="NAME">effort</xsl:attribute>
            <xsl:attribute name="VALUE"></xsl:attribute>
          </xsl:element>
          <xsl:element name="attribute">
            <xsl:attribute name="NAME">prio</xsl:attribute>
            <xsl:attribute name="VALUE"></xsl:attribute>
          </xsl:element>
            <xsl:apply-templates select="*"/> 
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/> 
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
      
</xsl:stylesheet>
