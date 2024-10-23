<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ap="http://schemas.mindjet.com/MindManager/Application/2003" xmlns:cor="http://schemas.mindjet.com/MindManager/Core/2003" xmlns:pri="http://schemas.mindjet.com/MindManager/Primitive/2003" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:cst0="http://schemas.mindjet.com/MindManager/UpdateCompatibility/2004" xmlns:cst1="http://schemas.iaresearch.com/PTMAddin" xmlns:cxp="http://www.tenbusch.info/cxproc" version="1.0">

  <!-- converts a Mindmanager xmmap file into pie format -->

  <xsl:variable name="flag_folded" select="true()"/> <!-- default true(): ignore folded state of branches -->

  <xsl:variable name="flag_images" select="true()"/> <!-- default true(): ignore folded state of branches -->

  <xsl:variable name="h_max" select="3"/> <!-- default 3: -->

  <xsl:output method="xml"/>

  <xsl:template match="/">
    <xsl:apply-templates select="descendant::ap:Map"/>
  </xsl:template>

  <xsl:template match="ap:Map">
    <xsl:element name="pie">
      <xsl:if test="$flag_images and ../../file[@name='Preview.png']">
	<xsl:element name="img">
	  <xsl:copy-of select="../../file[@name='Preview.png']/@type"/>
	  <xsl:copy-of select="../../file[@name='Preview.png']/base64"/>
	</xsl:element>
      </xsl:if>
      <!--
      <xsl:for-each select="../../dir[@name='bin']/file">
      <xsl:element name="img">
	<xsl:copy-of select="@type"/>
	<xsl:copy-of select="base64"/>
      </xsl:element>
      </xsl:for-each>
      <xsl:copy-of select="descendant::ap:NotesXhtmlData//*[name() = 'html'][1]"/>
      <xsl:copy-of select="descendant::ap:NotesXhtmlData/*[name() = 'html']"/>
      -->
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="ap:OneTopic">
    <xsl:choose>
      <xsl:when test="$h_max &gt; 0">
	<xsl:element name="section">
	  <xsl:element name="h">
	    <xsl:apply-templates select="ap:Topic/ap:Text"/>
	  </xsl:element>
	  <xsl:apply-templates select="ap:Topic/ap:SubTopics/ap:Topic|ap:Topic/ap:FloatingTopics/ap:Topic"/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="p">
	  <xsl:apply-templates select="ap:Topic/ap:Text"/>
	  <xsl:apply-templates select="ap:Topic/ap:SubTopics|ap:Topic/ap:FloatingTopics"/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
    <!-- <xsl:apply-templates select="descendant::ap:NotesGroup"/> -->
  </xsl:template>

  <xsl:template match="ap:SubTopics|ap:FloatingTopics">
    <xsl:element name="list">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ap:OneImage">
    <xsl:variable name="str_name" select="substring-after(ap:Image/ap:ImageData/cor:Uri,'mmarch://bin/')"/>
    <xsl:if test="$flag_images and /descendant::file[@name=$str_name]/base64">
      <xsl:element name="img">
	<xsl:choose>
	  <xsl:when test="ap:Image/ap:ImageData[@ImageType='urn:mindjet:PngImage']">
	    <xsl:attribute name="type">image/png</xsl:attribute>
	  </xsl:when>
	  <xsl:otherwise>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:copy-of select="/descendant::file[@name=$str_name]/base64"/>
	<!--
	    <xsl:element name="fig">
	    <xsl:element name="t">#fig</xsl:element>
	    </xsl:element>
	-->
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ap:Topic">
    <xsl:choose>
      <xsl:when test="ap:Text[starts-with(@PlainText,'TEST: ')]">
	<xsl:element name="task">
	  <xsl:element name="h">
	    <xsl:value-of select="substring-after(ap:Text/@PlainText,'TEST: ')"/>
	  </xsl:element>
	  <xsl:apply-templates select="ap:OneImage"/>
          <xsl:if test="$flag_folded or not(ap:TopicViewGroup/ap:Collapsed[@Collapsed='true'])">
	    <xsl:apply-templates select="ap:SubTopics/ap:Topic"/>
	  </xsl:if>
	</xsl:element>
      </xsl:when>
      <xsl:when test="ap:Task">
	<xsl:element name="task">
          <xsl:if test="ap:Task[@TaskPercentage='100']">
	    <xsl:attribute name="state">done</xsl:attribute>
	  </xsl:if>
	  <xsl:element name="h">
	    <xsl:apply-templates select="ap:Text"/>
	    <xsl:call-template name="TAGRESOURCES">
	      <xsl:with-param name="str_arg" select="ap:Task/@Resources"/>
	    </xsl:call-template>
	  </xsl:element>
	  <xsl:apply-templates select="ap:OneImage"/>
          <xsl:if test="$flag_folded or not(ap:TopicViewGroup/ap:Collapsed[@Collapsed='true'])">
	    <xsl:apply-templates select="ap:SubTopics/ap:Topic"/>
	  </xsl:if>
	</xsl:element>
      </xsl:when>
      <xsl:when test="count(ancestor::ap:Topic) &lt; $h_max">
	<xsl:element name="section">
	  <xsl:element name="h">
	    <xsl:apply-templates select="ap:Text"/>
	    <xsl:call-template name="TAGRESOURCES">
	      <xsl:with-param name="str_arg" select="ap:Task/@Resources"/>
	    </xsl:call-template>
	  </xsl:element>
	  <xsl:apply-templates select="ap:OneImage"/>
          <xsl:if test="$flag_folded or not(ap:TopicViewGroup/ap:Collapsed[@Collapsed='true'])">
	    <xsl:apply-templates select="ap:SubTopics/ap:Topic"/>
	  </xsl:if>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="p">
	  <xsl:apply-templates select="ap:Text"/>
	  <xsl:apply-templates select="ap:OneImage"/>
          <xsl:if test="$flag_folded or not(ap:TopicViewGroup/ap:Collapsed[@Collapsed='true'])">
	    <xsl:apply-templates select="ap:SubTopics"/>
	  </xsl:if>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
    <!-- <xsl:apply-templates select="ap:NotesGroup"/> -->
  </xsl:template>

<!-- 
  <xsl:template match="ap:NotesGroup">
    <xsl:copy-of select="child::ap:NotesXhtmlData/child::html"/>
    <xsl:copy-of select="ap:NotesXhtmlData/*[name() = 'html']"/>
	  <xsl:element name="block">
	    <xsl:attribute name="type">text/html</xsl:attribute>
	    <xsl:copy-of select="ap:NotesXhtmlData/*[name() = 'html']/*"/>
	  </xsl:element>
  </xsl:template>
-->

  <xsl:template match="ap:Text">

    <xsl:for-each select="following-sibling::ap:IconsGroup//ap:Icon|ap:CustomIconImageData">
      <xsl:choose>
	<xsl:when test="@IconSignature='+MX//QAAAAAAAAAAAAAAAA==' or @IconSignature='Wiv+KgAAAAAAAAAAAAAAAA=='">
	</xsl:when>
	<xsl:when test="@IconSignature='9iYORwAAAAAAAAAAAAAAAA==' or @IconSignature='q7oC4AAAAAAAAAAAAAAAAA=='">
	</xsl:when>
	<xsl:when test="contains(@IconType,'Meeting')">
	</xsl:when>
	<xsl:when test="contains(@IconType,'BrokenConnection') or @IconSignature='TocHXAAAAAAAAAAAAAAAAA=='">
	  <xsl:attribute name="valid">no</xsl:attribute>
	</xsl:when>
	<xsl:otherwise>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

    <xsl:if test="following-sibling::ap:Color/@FillColor and not(following-sibling::ap:Color/@FillColor = '00000000') and not(following-sibling::ap:Color/@FillColor = 'ffffffff')">
      <xsl:attribute name="background">
        <xsl:value-of select="concat('#',substring(following-sibling::ap:Color/@FillColor,3,6))"/>
      </xsl:attribute>
    </xsl:if>
    
    <xsl:if test="ap:Font/@Color">
      <xsl:attribute name="color">
        <xsl:value-of select="concat('#',substring(ap:Font/@Color,3,6))"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="ap:Font/@Strikethrough='true'" >
	<!-- no text output when strikethrough -->
      </xsl:when>
      <xsl:when test="ap:Font[@Italic='true']">
        <xsl:element name="em">
	  <xsl:call-template name="PLAINTEXT"/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="ap:Font[@Bold='true']">
        <xsl:element name="strong">
	  <xsl:call-template name="PLAINTEXT"/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="PLAINTEXT"/>
      </xsl:otherwise>
    </xsl:choose>
    
	    <xsl:for-each select="../ap:TextLabels/ap:TextLabel">
              <xsl:value-of select="concat(' #',translate(@TextLabelName,' ','_'))"/>
	    </xsl:for-each>

            <xsl:if test="following-sibling::ap:TaskYYY[@TaskPercentage='100']">
	      <xsl:text> ✔</xsl:text>
	    </xsl:if>

          <xsl:if test="following-sibling::ap:NotesGroup/ap:NotesXhtmlData_YYY">
	    <!-- TODO: either ap:NotesGroup/ap:NotesXhtmlData/html or ap:NotesGroup/ap:NotesXhtmlData/@PreviewPlainText -->
	  <xsl:element name="block">
	    <xsl:attribute name="type">text/html</xsl:attribute>
	    <xsl:copy-of select="following-sibling::ap:NotesGroup/ap:NotesXhtmlData/*[name() = 'html']/*"/>
	  </xsl:element>
          </xsl:if>

  </xsl:template>

  <xsl:template name="PLAINTEXT">
    <xsl:choose>
      <xsl:when test="../ap:Hyperlink">
        <xsl:element name="link">
	  <xsl:attribute name="href">
            <xsl:value-of select="../ap:Hyperlink/@Url"/>
	  </xsl:attribute>
          <xsl:value-of select="@PlainText"/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@PlainText"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:for-each select="../ap:HyperlinkGroup/ap:IndexedHyperlink">
      <xsl:text> </xsl:text>
      <xsl:element name="link">
	<xsl:attribute name="href">
          <xsl:value-of select="@Url"/>
	</xsl:attribute>
        <xsl:value-of select="concat('[',position(),']')"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="TAGRESOURCES">
    <xsl:param name="str_arg" select="''"/>
    <xsl:choose>
      <xsl:when test="string-length($str_arg) &lt; 1">
      </xsl:when>
      <xsl:when test="string-length(substring-before($str_arg,', ')) &lt; 1">
        <xsl:value-of select="concat(' @',$str_arg)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(' @',substring-before($str_arg,', '))"/>
	<xsl:call-template name="TAGRESOURCES">
	  <xsl:with-param name="str_arg" select="substring-after($str_arg,', ')"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*|@*|text()"/>

</xsl:stylesheet>
