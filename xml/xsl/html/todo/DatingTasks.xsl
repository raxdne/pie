<?xml version="1.0" encoding="utf-8"?>
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
  <xsl:output method="xml" encoding="utf-8"/>
  <!--  -->
  <xsl:template match="task">
    <xsl:element name="{name()}">
      <!--  -->
      <xsl:variable name="nodeset_section_date" select="ancestor::section[@date]"/>
      <xsl:if test="not(@date) and count($nodeset_section_date) &gt; 0">
        <xsl:copy-of select="$nodeset_section_date[position()=last()]/@date"/>
      </xsl:if>
      <!--  -->
      <xsl:variable name="nodeset_section_done" select="ancestor::section[@done]"/>
      <xsl:if test="not(@done) and count($nodeset_section_done) &gt; 0">
        <xsl:copy-of select="$nodeset_section_done[position()=last()]/@done"/>
      </xsl:if>
      <!--  -->
      <xsl:variable name="nodeset_section_impact" select="ancestor::section[@impact]"/>
      <xsl:if test="count($nodeset_section_impact) &gt; 0 and (not(@impact) or @impact &gt; count($nodeset_section_impact))">
        <xsl:copy-of select="$nodeset_section_impact[position()=last()]/@impact"/>
      </xsl:if>
      <!--  -->
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
