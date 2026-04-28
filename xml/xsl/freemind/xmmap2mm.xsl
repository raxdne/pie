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
            <xsl:if test="ap:Task[@TaskPercentage='100']">
	      <xsl:text> ✔</xsl:text>
	    </xsl:if>
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
          <xsl:if test="ap:NotesGroup/ap:NotesXhtmlData">
	    <!-- TODO: either ap:NotesGroup/ap:NotesXhtmlData/html or ap:NotesGroup/ap:NotesXhtmlData/@PreviewPlainText -->
	    <xsl:choose>
              <xsl:when test="false() and ap:NotesGroup/ap:NotesXhtmlData/@PreviewPlainText">
		<xsl:element name="node">
		  <xsl:attribute name="BACKGROUND_COLOR">
		    <xsl:value-of select="'#ffffaa'"/>
		  </xsl:attribute>
		  <xsl:attribute name="TEXT">
		    <xsl:value-of select="ap:NotesGroup/ap:NotesXhtmlData/@PreviewPlainText"/>
		    <xsl:call-template name="lf2br">
		      <xsl:with-param name="StringToTransform" select="ap:NotesGroup/ap:NotesXhtmlData/@PreviewPlainText"/>
		    </xsl:call-template>
		  </xsl:attribute>
		</xsl:element>
	      </xsl:when>
              <xsl:when test="true() and ap:NotesGroup/ap:NotesXhtmlData/@PreviewPlainText">
		<xsl:element name="node">
		  <xsl:attribute name="BACKGROUND_COLOR">
		    <xsl:value-of select="'#ffffaa'"/>
		  </xsl:attribute>
		  <xsl:attribute name="TEXT">
		    <xsl:text>NOTE</xsl:text>
		  </xsl:attribute>
		<xsl:call-template name="BR2NODE">
		  <xsl:with-param name="StringToTransform" select="ap:NotesGroup/ap:NotesXhtmlData/@PreviewPlainText"/>
		</xsl:call-template>
		</xsl:element>
	      </xsl:when>
              <xsl:when test="true() and ap:NotesGroup/ap:NotesXhtmlData/html">
		<xsl:element name="richcontent">
		  <xsl:attribute name="TYPE">
		    <xsl:text>node</xsl:text>
		  </xsl:attribute>
		  <xsl:copy-of select="ap:NotesGroup/ap:NotesXhtmlData/*"/>
		</xsl:element>
	      </xsl:when>
	      <xsl:otherwise>
		<!-- ignoring notes -->
	      </xsl:otherwise>
	    </xsl:choose>

          </xsl:if>
          <xsl:apply-templates/>
	    <!-- TODO: avoid fixed @NAME and @SIZE, use global ones -->
	  <xsl:choose>
          <xsl:when test="ap:Text/ap:Font[@Italic='true']">
            <xsl:element name="font">
              <xsl:attribute name="ITALIC">
		<xsl:text>true</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="NAME">
		<xsl:text>SansSerif</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="SIZE">
		<xsl:text>12</xsl:text>
              </xsl:attribute>
	    </xsl:element>
	  </xsl:when>
          <xsl:when test="ap:Text/ap:Font[@Bold='true']">
            <xsl:element name="font">
              <xsl:attribute name="BOLD">
		<xsl:text>true</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="NAME">
		<xsl:text>SansSerif</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="SIZE">
		<xsl:text>12</xsl:text>
              </xsl:attribute>
	    </xsl:element>
	  </xsl:when>
	  <xsl:otherwise>
	  </xsl:otherwise>
	  </xsl:choose>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*|@*"/>

  <xsl:template name="BR2NODE">
    <xsl:param name="StringToTransform"/>
    <xsl:choose>
      <xsl:when test="contains($StringToTransform,'&lt;br&gt;')">

	<xsl:if test="string-length(substring-before($StringToTransform,'&lt;br&gt;')) &gt; 0">
          <xsl:element name="node">
            <xsl:attribute name="TEXT">
	      <xsl:value-of select="substring-before($StringToTransform,'&lt;br&gt;')"/>
	    </xsl:attribute>
	  </xsl:element>
	</xsl:if>
	
	<xsl:call-template name="BR2NODE">
          <xsl:with-param name="StringToTransform">
            <xsl:value-of select="substring-after($StringToTransform,'&lt;br&gt;')"/>
          </xsl:with-param>
	</xsl:call-template>
	
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="node">
          <xsl:attribute name="TEXT">
	    <xsl:value-of select="$StringToTransform"/>
	  </xsl:attribute>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="lf2br">
    <xsl:param name="StringToTransform"/>
    <xsl:choose>
      <xsl:when test="contains($StringToTransform,'&lt;br&gt;')">
	<xsl:value-of select="substring-before($StringToTransform,'&lt;br&gt;')"/>
	<xsl:text> </xsl:text>
	<xsl:call-template name="lf2br">
          <xsl:with-param name="StringToTransform">
            <xsl:value-of select="substring-after($StringToTransform,'&lt;br&gt;')"/>
          </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$StringToTransform"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
