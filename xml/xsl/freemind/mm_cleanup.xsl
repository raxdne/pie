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
  <!-- remove all elements other than map/node/@TEXT -->
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

  <xsl:template match="*">
    <xsl:choose>
      <xsl:when test="child::icon[@BUILTIN='button_cancel']"/>
      <xsl:when test="name()='node'">
        <xsl:element name="node">
          <xsl:copy-of select="@flocator"/>
          <xsl:copy-of select="@fxpath"/>
          <xsl:copy-of select="@xpath"/>
          <xsl:copy-of select="@TEXT"/>
          <xsl:copy-of select="@BACKGROUND_COLOR"/>
          <xsl:copy-of select="@COLOR"/>
          <xsl:copy-of select="@LINK"/>
          <xsl:apply-templates select="*[name()='node' or name()='attribute' or name()='font' or name()='richcontent']"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="name()='richcontent'">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:when test="name()='attribute'">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:when test="name()='font'">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
