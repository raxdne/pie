<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ap="http://schemas.mindjet.com/MindManager/Application/2003" version="1.0">
<!-- converts a freemind file into a Mindmanager xmmap file xml -->

  <xsl:output method="xml"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="file|pie">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="map">
    <ap:Map xmlns="http://schemas.mindjet.com/MindManager/Application/2003" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.mindjet.com/MindManager/Application/2003 http://schemas.mindjet.com/MindManager/Application/2003 http://schemas.mindjet.com/MindManager/Core/2003 http://schemas.mindjet.com/MindManager/Core/2003 http://schemas.mindjet.com/MindManager/Delta/2003 http://schemas.mindjet.com/MindManager/Delta/2003 http://schemas.mindjet.com/MindManager/Primitive/2003 http://schemas.mindjet.com/MindManager/Primitive/2003">
      <xsl:element name="ap:OneTopic">
        <xsl:apply-templates/>
      </xsl:element>
    </ap:Map>
  </xsl:template>

  <xsl:template match="node">
    <xsl:element name="ap:Topic">
      <xsl:if test="child::node">
        <xsl:element name="ap:SubTopics">
          <xsl:apply-templates select="node"/>
        </xsl:element>
      </xsl:if>
      <xsl:if test="@FOLDED='true'">
        <xsl:element name="ap:TopicViewGroup">
          <xsl:attribute name="ViewIndex">0</xsl:attribute>
          <xsl:element name="ap:Collapsed">
            <xsl:attribute name="Collapsed">true</xsl:attribute>
          </xsl:element>
        </xsl:element>
      </xsl:if>
      <xsl:element name="ap:Text">
        <xsl:attribute name="PlainText">
          <xsl:value-of select="@TEXT"/>
        </xsl:attribute>
        <xsl:element name="ap:Font">
          <xsl:if test="@COLOR">
            <xsl:attribute name="Color">
              <xsl:value-of select="concat('ff',substring(@COLOR,2,6))"/>
            </xsl:attribute>
          </xsl:if>
	  <xsl:if test="font[@BOLD = 'true']">
            <xsl:attribute name="Bold">
	      <xsl:text>true</xsl:text>
	    </xsl:attribute>
	  </xsl:if>
	  <xsl:if test="font[@ITALIC = 'true']">
            <xsl:attribute name="Italic">
	      <xsl:text>true</xsl:text>
	    </xsl:attribute>
	  </xsl:if>
        </xsl:element>
      </xsl:element>
      <xsl:if test="@BACKGROUND_COLOR">
        <xsl:element name="ap:Color">
          <xsl:attribute name="FillColor">
            <xsl:value-of select="concat('ff',substring(@BACKGROUND_COLOR,2,6))"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>
      <xsl:if test="@LINK">
        <xsl:element name="ap:Hyperlink">
          <xsl:attribute name="Url">
            <xsl:value-of select="@LINK"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>
      <xsl:if test="child::richcontent[child::html]">
	<xsl:element name="ap:NotesGroup">
	  <xsl:element name="ap:NotesXhtmlData">
            <xsl:element name="html" xmlns="http://www.w3.org/1999/xhtml">
	      <xsl:copy-of select="child::richcontent/child::html/child::body/child::*"/>
	    </xsl:element>
	  </xsl:element>
	</xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>
