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
  <xsl:variable name="depth_max" select="-1"/>
  <!--  -->
  <xsl:template match="/">
    <xsl:element name="map">
      <xsl:choose>
        <xsl:when test="node">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
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
    <xsl:variable name="depth" select="count(ancestor::node)"/>
    <xsl:if test="$depth_max &lt; 1 or $depth &lt; $depth_max">
      <xsl:choose>
        <xsl:when test="child::icon[contains(@BUILTIN, 'cancel')]">
          <!-- ignore this and all descendant nodes -->
        </xsl:when>
        <xsl:when test="@FOLDED='true'">
          <!-- ignore all descendant nodes -->
          <xsl:element name="node">
            <xsl:copy-of select="@*[not(name()='FOLDED')]"/>
            <xsl:copy-of select="child::font"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <!--  -->
          <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
          </xsl:copy>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
