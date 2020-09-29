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
  <xsl:variable name="str_tag" select="''" />
  <xsl:key name="listtags" match="t[not(ancestor::meta)]" use="."/>
  <xsl:variable name="nodeset_xpath" select="/*" />
  <xsl:output method="xml" encoding="UTF-8" />
  <!--  -->
  <xsl:template match="/">
    <xsl:element name="pie">
      <xsl:choose>
        <xsl:when test="$nodeset_xpath">
          <!-- nodeset exist -->
          <xsl:apply-templates select="$nodeset_xpath" />
          <xsl:if test="not($nodeset_xpath/meta)">
            <!-- rebuild list of tags for this xpath -->
            <xsl:element name="meta">
              <xsl:element name="t">
                <!-- BUG: very first t element is missed -->
                <xsl:for-each select="$nodeset_xpath/descendant::t[generate-id(.) = generate-id(key('listtags',.))]">
                  <xsl:sort order="ascending" select="."/>
                  <xsl:variable name="str_tag_i" select="." />
                  <xsl:variable name="int_tag_i" select="count($nodeset_xpath/descendant::t[. = $str_tag_i])" />
                  <xsl:element name="t">
                    <xsl:if test="$int_tag_i &gt; 1">
                      <xsl:attribute name="count">
                        <xsl:value-of select="$int_tag_i"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="$str_tag_i"/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:element>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <!-- empty top element -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <xsl:template match="@*|node()">
    <xsl:choose>
      <xsl:when test="name() = 'pie'">
        <!-- skip top pie element -->
        <xsl:apply-templates />
      </xsl:when>
      <xsl:when test="$str_tag = ''">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/> 
        </xsl:copy>
      </xsl:when>
      <xsl:when test="child::t[contains(text(),$str_tag)]">
        <xsl:copy-of select="." />
      </xsl:when>
      <xsl:when test="self::*[contains(text(),$str_tag)]">
        <xsl:copy-of select="." />
      </xsl:when>
      <!--  -->
      <xsl:when test="descendant::*[contains(text(),$str_tag)]">
        <xsl:element name="{name()}">
          <xsl:copy-of select="@*" />
          <xsl:copy-of select="h" />
          <xsl:apply-templates select="@*|node()" />
        </xsl:element>
      </xsl:when>
      <!--  -->
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
