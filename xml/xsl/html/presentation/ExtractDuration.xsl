<?xml version="1.0" encoding="UTF-8"?>
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
  <xsl:output method="xml"/>
  <xsl:variable name="str_sep">
    <xsl:text> :: </xsl:text>
  </xsl:variable>
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="descendant::section[@duration or contains(child::h,$str_sep)]">
          <xsl:apply-templates select="@*|node()"/>
      </xsl:when>
      <xsl:otherwise>
	<!-- pure tree copy if there is no separator in section header -->
	<xsl:copy-of select="*"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- extract all Duration markup in section header element -->
  <xsl:template match="@*|node()">
    <xsl:choose>
      <!-- section element with Duration markup in header element -->
      <xsl:when test="name()='section' and count(ancestor::section)=2 and not(@duration) and child::h">
        <xsl:variable name="str_duration">
          <xsl:choose>
            <xsl:when test="substring-after(child::h,$str_sep)">
              <xsl:value-of select="substring-after(h,$str_sep)"/>
            </xsl:when>
            <xsl:otherwise>
              <!--  -->
              <xsl:value-of select="concat('180 ','s')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:element name="{name()}">
          <xsl:apply-templates select="@*"/>
          <!-- there is a duration substring in h -->
          <xsl:attribute name="duration">
            <xsl:choose>
              <xsl:when test="substring-before($str_duration,'s')">
                <!-- unit is seconds -->
                <xsl:value-of select="substring-before($str_duration,'s')"/>
              </xsl:when>
              <xsl:when test="substring-before($str_duration,'min')">
                <!-- unit is minutes -->
                <xsl:value-of select="substring-before($str_duration,'min')*60"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- without units -->
                <xsl:value-of select="$str_duration"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="substring-after(child::h,$str_sep)">
              <xsl:element name="h">
                <xsl:value-of select="normalize-space(substring-before(h,$str_sep))"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <!--  -->
              <xsl:apply-templates select="h"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select="*[not(name()='h')]"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
