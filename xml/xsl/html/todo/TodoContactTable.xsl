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
  <xsl:import href="../PieHtml.xsl"/>
  <xsl:variable name="file_css" select="'pie.css'"/>
  <xsl:variable name="file_ref" select="'TodoContactTable.html'"/>
  <!--  -->
  <xsl:variable name="flag_form" select="true()"/>
  <xsl:variable name="level_hidden" select="0"/>
  <xsl:output method="html" encoding="UTF-8"/>
  <xsl:include href="../../Utils.xsl"/>
  <!-- index with all contact in valid structures where parent task is not @done -->
  <xsl:key name="listcontact" match="contact[not(@idref='') and parent::task[not(@done)]]" use="@idref"/>
  <!-- index with all contacts -->
  <xsl:key name="listcontactall" match="contact[not(@idref='')]" use="@idref"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
        <xsl:call-template name="PIECONTACT"/>
        <xsl:element name="hr"/>
        <xsl:call-template name="PIECONTACTLIST"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- ignore all elements with an id and valid="no" -->
  <xsl:template name="PIECONTACT">
    <xsl:variable name="set_contact" select="//contact[generate-id(.) = generate-id(key('listcontact',@idref))]"/>
    <!-- Contact links -->
    <xsl:element name="p">
      <xsl:for-each select="$set_contact">
        <xsl:sort select="@idref"/>
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="translate(@idref,'ÄÖÜäöüß','_______')"/>
          </xsl:attribute>
          <xsl:value-of select="@idref"/>
        </xsl:element>
        <xsl:text> / </xsl:text>
      </xsl:for-each>
      <!-- count contact -->
      <xsl:element name="a">
        <xsl:value-of select="count($set_contact)"/>
        <xsl:text> Kontakte</xsl:text>
      </xsl:element>
    </xsl:element>
    <xsl:element name="hr"/>
    <!-- Contact/Todo lists -->
    <xsl:for-each select="$set_contact">
      <xsl:sort select="@idref"/>
      <xsl:element name="p">
        <xsl:element name="b">
          <xsl:element name="a">
            <xsl:attribute name="name">
              <xsl:value-of select="translate(@idref,'ÄÖÜäöüß','_______')"/>
            </xsl:attribute>
            <xsl:value-of select="@idref"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:element name="ol">
        <xsl:for-each select="key('listcontact',@idref)">
          <xsl:element name="li">
            <xsl:for-each select="parent::task">
              <!-- context switch -->
              <xsl:call-template name="TASK">
                <xsl:with-param name="flag_line" select="true()"/>
                <xsl:with-param name="flag_ancestor" select="true()"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="PIECONTACTLIST">
    <!-- All contact links -->
    <xsl:element name="p">
      <xsl:for-each select="//contact[generate-id(.) = generate-id(key('listcontactall',@idref))]">
        <xsl:sort select="@idref"/>
        <xsl:value-of select="concat(translate(@idref,'_.','  '),'; ')"/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
