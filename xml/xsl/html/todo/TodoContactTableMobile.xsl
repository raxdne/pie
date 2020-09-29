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
  <xsl:import href="../PieHtmlMobile.xsl"/>
  <xsl:variable name="file_ref" select="'TodoContactTable.html'"/>
  <!--  -->
  <xsl:variable name="flag_mobile" select="false()"/>
  <xsl:variable name="flag_form" select="true()"/>
  <xsl:variable name="level_hidden" select="0"/>
  <xsl:output method="html" encoding="UTF-8"/>
  <xsl:include href="../../Utils.xsl"/>
  <!-- index with all contact in valid structures where parent task is not @done -->
  <xsl:key name="listcontact" match="contact[not(@idref='') and parent::task[not(@done)]]" use="@idref"/>
  <!-- index with all contacts -->
  <xsl:key name="listcontactall" match="contact[not(@idref='')]" use="@idref"/>
  <!-- ignore all elements with an id and valid="no" -->
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:element name="div">
      <xsl:element name="div">
        <xsl:attribute name="data-role">page</xsl:attribute>
        <xsl:attribute name="id">p0</xsl:attribute>
        <xsl:call-template name="PIENAVMOBILEHEADER"/>
        <xsl:element name="div">
          <xsl:attribute name="data-role">content</xsl:attribute>
          <xsl:element name="div">
            <xsl:attribute name="data-role">collapsible-set</xsl:attribute>
	    <xsl:call-template name="PIECONTACT"/>
          </xsl:element>
        </xsl:element>
        <xsl:call-template name="PIENAVMOBILEFOOTER"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="PIECONTACT">
    <xsl:variable name="set_contact" select="//contact[generate-id(.) = generate-id(key('listcontact',@idref))]"/>
    <!-- Contact/Todo lists -->
    <xsl:for-each select="$set_contact">
      <xsl:sort select="@idref"/>
      <xsl:element name="div">
	<xsl:attribute name="data-role">collapsible</xsl:attribute>
	<xsl:attribute name="data-collapsed">true</xsl:attribute>
	<xsl:element name="h1">
          <xsl:value-of select="@idref"/>
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
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
