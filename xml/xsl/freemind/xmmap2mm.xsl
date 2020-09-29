<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ap="http://schemas.mindjet.com/MindManager/Application/2003" xmlns:cxp="http://www.tenbusch.info/cxproc" version="1.0">
<!-- converts a Mindmanager xmmap file into a simplified freemind file -->
  <xsl:variable name="flag_folded" select="false()"/>
  <xsl:output method="xml" encoding="US-ASCII"/>
  <xsl:template match="/">
    <xsl:element name="map">
      <xsl:choose>
	<xsl:when test="count(descendant::ap:Map) &gt; 1">
	  <xsl:element name="node">
	    <xsl:attribute name="TEXT">
              <xsl:value-of select="pie/dir[1]/@name"/>
	    </xsl:attribute>
	    <xsl:apply-templates select="descendant::ap:Map"/>
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="descendant::ap:Map"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <xsl:template match="ap:*">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="*[contains(name(),'Topic')]">
    <xsl:choose>
      <xsl:when test="ap:Text/ap:Font/@Strikethrough='true'" />
      <xsl:when test="ap:Text/@PlainText">
        <xsl:element name="node">
          <xsl:attribute name="TEXT">
            <xsl:value-of select="ap:Text/@PlainText"/>
	    <xsl:for-each select="ap:TextLabels/ap:TextLabel">
              <xsl:value-of select="concat(' #',translate(@TextLabelName,' ','_'))"/>
	    </xsl:for-each>
          </xsl:attribute>
          <xsl:if test="$flag_folded and ap:SubTopics and ap:TopicViewGroup/ap:Collapsed/@Collapsed">
            <xsl:attribute name="FOLDED">
              <xsl:value-of select="ap:TopicViewGroup/ap:Collapsed/@Collapsed"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="ap:Hyperlink">
            <xsl:attribute name="LINK">
              <xsl:value-of select="ap:Hyperlink/@Url"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="ap:Text/ap:Font/@Color">
            <xsl:attribute name="COLOR">
              <xsl:value-of select="concat('#',substring(ap:Text/ap:Font/@Color,3,6))"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="ap:Color/@FillColor and not(ap:Color/@FillColor = '00000000') and not(ap:Color/@FillColor = 'ffffffff')">
            <xsl:attribute name="BACKGROUND_COLOR">
              <xsl:value-of select="concat('#',substring(ap:Color/@FillColor,3,6))"/>
            </xsl:attribute>
          </xsl:if>
	  <xsl:for-each select="ap:IconsGroup//ap:Icon|ap:CustomIconImageData">
	    <xsl:element name="icon"> <!-- TODO: test stability with different Mindmanager versions -->
	      <xsl:attribute name="BUILTIN">
		<xsl:choose>
		  <xsl:when test="@IconSignature='+MX//QAAAAAAAAAAAAAAAA==' or @IconSignature='Wiv+KgAAAAAAAAAAAAAAAA=='">
		    <xsl:text>full-1</xsl:text>
		  </xsl:when>
		  <xsl:when test="@IconSignature='9iYORwAAAAAAAAAAAAAAAA==' or @IconSignature='q7oC4AAAAAAAAAAAAAAAAA=='">
		    <xsl:text>full-2</xsl:text>
		  </xsl:when>
		  <xsl:when test="contains(@IconType,'Meeting')">
		    <xsl:text>desktop_new</xsl:text>
		  </xsl:when>
		  <xsl:when test="contains(@IconType,'BrokenConnection') or @IconSignature='TocHXAAAAAAAAAAAAAAAAA=='">
		    <xsl:text>button_cancel</xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:text>help</xsl:text>
		  </xsl:otherwise>
		</xsl:choose>
	      </xsl:attribute>
	    </xsl:element>
	  </xsl:for-each>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*|@*"/>
</xsl:stylesheet>
