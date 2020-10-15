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
  <xsl:variable name="str_assignee" select="''"/>
  <xsl:output method="xml"/>
<!-- ignore all sections without task descendant  -->
  <xsl:template match="@*|node()">
    <xsl:choose>
<!-- in valids -->
<!-- <xsl:when test="self::p"/> -->
      <xsl:when test="self::pre"/>
      <xsl:when test="self::list"/>
      <xsl:when test="self::import"/>
      <xsl:when test="self::section[@state = 2]"/>
      <xsl:when test="self::section[($str_assignee = '' or count(descendant-or-self::section[attribute::assignee = $str_assignee]) &lt; 1) and count(descendant::task) &lt; 1]"/>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
