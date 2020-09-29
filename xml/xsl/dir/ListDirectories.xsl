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

  <xsl:variable name="separator" select="'\'"/>

  <xsl:variable name="str_cmd" select="''"/> <!-- md c:\temp\ -->

  <xsl:template match="/">
    <xsl:apply-templates select="pie"/>
  </xsl:template>

  <xsl:template match="pie[@class='directory']">
    <xsl:for-each select="//*[name()='dir']">

      <xsl:variable name="str_path">
        <xsl:for-each select="ancestor::dir">
          <xsl:value-of select="concat(@name,$separator)"/>
        </xsl:for-each>
        <xsl:value-of select="@name"/>
      </xsl:variable>

      <xsl:variable name="str_path_sep">
        <xsl:choose>
          <xsl:when test="$separator='\'">
            <xsl:value-of select="translate($str_path,'/',$separator)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="translate($str_path,'\',$separator)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>


      <xsl:choose>
        <xsl:when test="contains($str_path_sep,'tmp')">
          <!-- ignore this directories -->
        </xsl:when>
        <xsl:otherwise>
      <xsl:value-of select="$str_cmd"/>
      <xsl:choose>
        <xsl:when test="substring-before($str_path_sep,':\')">
          <xsl:value-of select="substring-after($str_path_sep,':\')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$str_path_sep"/>
        </xsl:otherwise>
      </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>
</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*"/>

</xsl:stylesheet>
