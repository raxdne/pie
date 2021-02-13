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

  <xsl:output method="xml" encoding="UTF-8"/>  

  <!-- ignore all elements with an id and valid="no" -->

  <xsl:template match="/pie">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
      
  <xsl:template match="section">
    <xsl:element name="{name()}">
      <xsl:element name="h">
	<xsl:value-of select="string(child::h)"/>
      </xsl:element>
      <xsl:apply-templates select="child::section|child::task"/>
    </xsl:element>
  </xsl:template>
      
  <xsl:template match="task">
    <xsl:choose>
      <!-- in valids -->
      <xsl:when test="@state = 'rejected'"/>
      <xsl:when test="@done or @class = 'done' or @state = 'done'"/>
      <xsl:otherwise>
	<xsl:element name="{name()}">
	  <xsl:copy-of select="@*|h"/>
          <xsl:apply-templates select="node()"/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
      
  <xsl:template match="@*|node()">
    <xsl:apply-templates />
  </xsl:template>
      
</xsl:stylesheet>
