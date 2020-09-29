<?xml version="1.0"?>
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

<xsl:import href="../Utils.xsl"/>

  <xsl:output method="text" encoding="utf-8"/>

  <xsl:template match="*">
    <xsl:for-each select="child::text()">
      <xsl:variable name="str_text">
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:variable>
      <xsl:if test="not($str_text='') and not($str_text=' ')">
        <xsl:value-of select="concat($str_text,' ')"/>
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates select="child::*"/>
  </xsl:template>

</xsl:stylesheet>
