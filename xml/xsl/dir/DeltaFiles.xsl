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
  <xsl:variable name="file_0" select="'../../tmp/test-dir-0.xml'"/>

  <xsl:template match="@*|node()">
    <xsl:for-each select="ancestor::dir">
      <xsl:choose>
        <!--   -->
        <xsl:when test="document($file_0)/pie/"/>
        <xsl:otherwise>
          <xsl:copy>
            <xsl:apply-templates select="@*|node()"/> 
          </xsl:copy>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
      
</xsl:stylesheet>

