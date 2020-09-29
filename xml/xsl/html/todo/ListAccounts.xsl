<?xml version="1.0"?>
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

  <xsl:key name="listtasks" match="task" use="@idref"/>

  <xsl:key name="listappoints" match="p[@class='outlook']" use="."/>

  <!-- ignore all elements with an id and valid="no" -->

  <xsl:template match="/">
    <xsl:apply-templates select="//*[(name()='task' and @done and generate-id(.) = generate-id(key('listtasks',@idref))) or (name()='p' and @class='outlook' and generate-id(.) = generate-id(key('listappoints',.)))]">
    </xsl:apply-templates>
  </xsl:template>
      
  <xsl:template match="p">
    <xsl:text>	</xsl:text>
    <xsl:text>	</xsl:text>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:text> (</xsl:text>
    <xsl:value-of select="@date"/>
    <xsl:text>)</xsl:text>
    <xsl:text>
</xsl:text>
  </xsl:template>
      
  <xsl:template match="task">
    <xsl:value-of select="@account"/>
    <xsl:text>	</xsl:text>
    <xsl:value-of select="@effort"/>
    <xsl:text>	</xsl:text>
    <xsl:value-of select="substring(normalize-space(h),1,100)"/>
    <xsl:text> (</xsl:text>
    <xsl:value-of select="@done"/>
    <xsl:for-each select="contact">
      <xsl:text> </xsl:text>
      <xsl:value-of select="@idref"/>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
    <xsl:text>
</xsl:text>
  </xsl:template>
      
</xsl:stylesheet>
