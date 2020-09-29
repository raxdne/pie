<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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

  <xsl:output method="text"/>  

  <xsl:variable name="prefix">h:/tmp</xsl:variable>

  <!-- ignore all elements with an id and valid="no" -->

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
      
  <xsl:template match="pie|dir">
    <xsl:apply-templates/>
  </xsl:template>
      
  <xsl:template match="file">
    <xsl:choose>
      <xsl:when test="contains(@name,'.ppt')">
        <xsl:text>gzip &quot;</xsl:text>
        <xsl:for-each select="ancestor::dir">
          <xsl:value-of select="@name"/>
          <xsl:text>/</xsl:text>
        </xsl:for-each>
        <xsl:value-of select="@name"/>
      <xsl:text>&quot;
</xsl:text>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
      
  <xsl:template match="*"></xsl:template>
      
</xsl:stylesheet>

