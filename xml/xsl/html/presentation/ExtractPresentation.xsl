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
  <!-- max allowed depth of elements -->
  <xsl:variable name="depth_max" select="-1"/>
  <xsl:output method="xml"/>
  <xsl:template match="@*|node()">
    <xsl:choose>
      <xsl:when test="$depth_max &gt; -1 and count(ancestor-or-self::*[name()='section' or name()='list' or name()='p']) &gt; $depth_max">
        <!-- skip deep elements -->
      </xsl:when>
      <xsl:when test="self::section[count(ancestor-or-self::section) = 3]">
        <xsl:element name="{name()}">
          <!-- insert attribute class -->
          <xsl:attribute name="class">slide</xsl:attribute>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="block">
    <!-- skip this elements itself -->
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="meta|@fxpath|@xpath|t">
    <!-- ignore this -->
  </xsl:template>
</xsl:stylesheet>
