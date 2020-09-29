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

  <xsl:output method="xml"/>  

  <!--  -->
  <xsl:variable name="int_mtime_0" select="document('../../tmp/test-dir-0.xml')/pie/@mtime"/>

  <xsl:template match="@*|node()">
    <xsl:variable name="name_compare" select="translate(@name,'abcdefghijklmnopqrstuvwxyzäöü','ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ')"/>
    <xsl:variable name="path_compare" select="ancestor-or-self::node"/>
    <xsl:choose>
      <xsl:when test="substring-before($name_compare,'~')"/>
      <xsl:when test="substring-before($name_compare,'.LOG')"/>
      <xsl:when test="contains($name_compare,'TMP')"/>
      <xsl:when test="contains($name_compare,'TRASH')"/>
      <xsl:when test="number($int_mtime_0) and @mtime - $int_mtime_0 &lt; 0"/>
      <xsl:when test="document('../../tmp/test-dir-0.xml')/$path_compare"/>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/> 
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
      
</xsl:stylesheet>

