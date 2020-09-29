<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Freemind-Mindmap in eine Projektstruktur umwandeln
       PROJEKT/TP/HAP/AP/task 
       -->

  <xsl:output method='xml' version='1.0'/>

  <!--  -->
  <xsl:variable name="target_str" select="'Ziel'"/>
  <!--  -->
  <xsl:variable name="multiplier_effort" select="7.0"/>

  <xsl:template match="/map">
    <!-- <xsl:processing-instruction name="xml-stylesheet">
      <xsl:text>href="pie2html.xsl" type="text/xsl"</xsl:text>
    </xsl:processing-instruction> -->
    <xsl:element name="pie">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>


  <xsl:template match="node">
    <xsl:variable name="depth" select="count(ancestor::node)"/>
    <xsl:choose>
      <xsl:when test="starts-with(@TEXT,$target_str)">
        <!-- TARGET -->
<!-- 
        <xsl:element name="section">
          <xsl:if test="@FOLDED='true' or child::icon[contains(@BUILTIN, 'cancel')]">
            <xsl:attribute name="valid">no</xsl:attribute>
          </xsl:if>
          <xsl:call-template name="name_effort">
            <xsl:with-param name="node_text" select="@TEXT"/>
          </xsl:call-template>
 -->
          <xsl:for-each select="node">
            <xsl:element name="target">
              <xsl:element name="h">
                <xsl:value-of select="@TEXT"/>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
<!-- 
        </xsl:element>
 -->
      </xsl:when>
      <xsl:when test="$depth &gt; 4">
        <!-- list -->
        <xsl:element name="p">
          <xsl:value-of select="@TEXT"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$depth = 4">
        <!-- TASK -->
        <xsl:element name="task">
          <xsl:if test="child::icon[contains(@BUILTIN, 'cancel')]">
            <xsl:attribute name="valid">no</xsl:attribute>
          </xsl:if>
          <xsl:call-template name="name_effort">
            <xsl:with-param name="node_text" select="@TEXT"/>
          </xsl:call-template>
          <xsl:element name="list">
            <xsl:apply-templates/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$depth &lt; 4">
        <!-- AP/HAP/TP/P -->
        <xsl:element name="section">
          <xsl:if test="@FOLDED='true' or child::icon[contains(@BUILTIN, 'cancel')]">
            <xsl:attribute name="valid">no</xsl:attribute>
          </xsl:if>
          <xsl:call-template name="name_effort">
            <xsl:with-param name="node_text" select="@TEXT"/>
          </xsl:call-template>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <!-- header -->
  </xsl:template>


  <xsl:template name="name_effort">
    <xsl:param name="node_text"></xsl:param>
    <xsl:choose>
      <xsl:when test="contains($node_text,' / ')">
        <!-- effort -->
        <xsl:attribute name="effort">
          <xsl:value-of select="$multiplier_effort * substring-after($node_text,' / ')"/>
        </xsl:attribute>
        <xsl:element name="h">
          <xsl:value-of select="substring-before($node_text,' / ')"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="h">
          <xsl:value-of select="$node_text"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="hook">
    <xsl:if test="@NAME = 'accessories/plugins/NodeNote.properties' and child::text">
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="text">
    <xsl:for-each select="ancestor::node">
      <xsl:call-template name="itemize"/>
    </xsl:for-each>
    <xsl:text> </xsl:text><xsl:value-of select="."/>
  </xsl:template>


  <xsl:template match="icon">
    <!--
         <xsl:text> </xsl:text><xsl:value-of select="@BUILTIN"/>
         -->
       </xsl:template>


</xsl:stylesheet>
