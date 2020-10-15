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
  <xsl:import href="./PieHtml.xsl"/>
  <xsl:variable name="file_css" select="'pie.css'"/>
  <xsl:variable name="file_ref" select="''"/>
  <!--  -->
  <xsl:variable name="flag_form" select="true()"/>
  <xsl:variable name="level_hidden" select="0"/>
  <xsl:output method="html" encoding="UTF-8"/>
  <xsl:include href="../Utils.xsl"/>
  <!-- index with all contact in valid structures where parent task is not @done -->
  <xsl:key name="listtag" match="t[not(parent::meta)]" use="."/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
        <xsl:call-template name="PIETAG"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ignore all elements with an id and valid="no" -->
  <xsl:template name="PIETAG">
    <xsl:element name="p">
      <xsl:for-each select="//t[generate-id(.) = generate-id(key('listtag',.))]">
        <xsl:sort select="."/>
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
          <xsl:value-of select="."/>
          </xsl:attribute>
          <xsl:value-of select="."/>
        </xsl:element>
        <xsl:text> / </xsl:text>
      </xsl:for-each>
    </xsl:element>
    <xsl:element name="hr"/>
    <!-- Todo lists -->
      <xsl:for-each select="//t[generate-id(.) = generate-id(key('listtag',.))]">
      <xsl:sort select="."/>
      <xsl:element name="p">
        <xsl:element name="b">
          <xsl:element name="a">
          <xsl:attribute name="name">
          <xsl:value-of select="."/>
          </xsl:attribute>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:element name="ol">
        <xsl:for-each select="key('listtag',.)">
          <xsl:element name="li">
            <xsl:for-each select="parent::*">
              <!-- context switch -->
              <xsl:apply-templates/>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
