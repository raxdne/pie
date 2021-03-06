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
  <xsl:variable name="str_pidref" select="''"/>
  <xsl:output method="xml" encoding="UTF-8"/>
  <!--  -->
  <xsl:template match="@*|node()">
    <xsl:choose>
      <!--  -->
      <xsl:when test="self::pie">
        <xsl:copy>
          <xsl:apply-templates select="section"/>
        </xsl:copy>
      </xsl:when>
      <xsl:when test="self::section">
        <xsl:choose>
          <xsl:when test="@pid and ($str_pidref = '' or contains($str_pidref,@pid))">
            <xsl:copy-of select="self::node()"/>
          </xsl:when>
          <xsl:when test="descendant::section[@pid and ($str_pidref = '' or contains($str_pidref,@pid))]">
            <xsl:copy>
              <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!--  -->
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
