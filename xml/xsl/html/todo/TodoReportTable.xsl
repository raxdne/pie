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
  <xsl:import href="../PieHtmlTable.xsl" />
  
  <!-- -->
  <xsl:variable name="file_norm"></xsl:variable>
  <!-- -->
  <xsl:variable name="dir_icons" select="'../html/icons'" />
  <!-- -->
  <xsl:variable name="flag_tips" select="true()" />
  <!-- -->
  <xsl:variable name="file_css" select="''" />

  <xsl:output method="html" encoding="UTF-8" />
  <xsl:include href="../../Utils.xsl" />
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER" />
      <xsl:element name="body">
        <xsl:element name="table">
          <xsl:element name="tbody">
            <xsl:attribute name="class">
              <xsl:value-of select="name(.)" />
            </xsl:attribute>
            <xsl:attribute name="border">
              <xsl:text>0</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="cellspacing">
              <xsl:text>5</xsl:text>
            </xsl:attribute>
            <xsl:for-each select="//task[@done and @diff]">
              <xsl:sort select="@diff" order="descending" data-type="number" />
              <xsl:element name="tr">
                <xsl:element name="td">
                  <xsl:if test="@account">
                    <xsl:value-of select="@account" />
                  </xsl:if>
                </xsl:element>
                <xsl:element name="td">
                  <!-- all deadline related -->
                  <xsl:element name="i">
                    <xsl:element name="a">
                      <xsl:if test="$flag_tips">
                        <xsl:attribute name="title">
                          <xsl:call-template name="FORMATTOOLTIP">
                            <xsl:with-param name="node" select="self::node()" />
                          </xsl:call-template>
                        </xsl:attribute>
                      </xsl:if>
                      <xsl:for-each select="ancestor::section[h]">
                        <xsl:value-of select="concat(h,' :: ')" />
                      </xsl:for-each>
                    </xsl:element>
                  </xsl:element>
                  <xsl:apply-templates select="h" />
                </xsl:element>
                <xsl:element name="td">
                  <xsl:for-each select="htag">
                    <xsl:value-of select="concat(translate(@idref,'_-','  '),'; ')" />
                  </xsl:for-each>
                </xsl:element>
                <xsl:element name="td">
                  <xsl:if test="@effort">
                    <xsl:value-of select="concat(@effort,'h')" />
                  </xsl:if>
                </xsl:element>
                <xsl:element name="td">
                  <xsl:value-of select="@done" />
                </xsl:element>
                <xsl:element name="td">
                  <xsl:value-of select="concat(@diff,'d')" />
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
