<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pkg="http://www.tenbusch.info/pkg" version="1.0">

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

  <xsl:output method="xml"/>  

  <xsl:variable name="id_lang" select="''"/>

  <!-- ignore all elements translation -->

  <xsl:template match="@*|node()">
    <xsl:choose>
      <!-- in valids -->
      <xsl:when test="child::translation[@lang=$id_lang]">
        <xsl:element name="{name(.)}">
          <xsl:apply-templates select="@*"/> 
          <xsl:apply-templates select="child::translation"/> 
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/> 
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
      
  <xsl:template match="translation">
    <xsl:choose>
      <xsl:when test="@lang=$id_lang">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <!-- ignore other languages -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
      
</xsl:stylesheet>
