<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ap="http://schemas.mindjet.com/MindManager/Application/2003" xmlns:cor="http://schemas.mindjet.com/MindManager/Core/2003" xmlns:cxp="http://www.tenbusch.info/cxproc" version="1.0">

  <!-- converts a Mindmanager xmmap file into pie format -->

  <xsl:variable name="flag_folded" select="true()"/> <!-- default true(): ignore folded state of branches -->

  <xsl:variable name="h_max" select="3"/> <!-- default 3: -->

  <xsl:output method="xml"/>

  <xsl:template match="/">
    <xsl:apply-templates select="descendant::ap:Map"/>
  </xsl:template>

  <xsl:template match="ap:Map">
    <xsl:element name="pie">
      <xsl:element name="img">
	<xsl:copy-of select="../../file[@name='Preview.png']/@type"/>
	<xsl:copy-of select="../../file[@name='Preview.png']/base64"/>
      </xsl:element>
      <!--
      <xsl:for-each select="../../dir[@name='bin']/file">
      <xsl:element name="img">
	<xsl:copy-of select="@type"/>
	<xsl:copy-of select="base64"/>
      </xsl:element>
      </xsl:for-each>
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
  </xsl:template>

  <xsl:template match="ap:SubTopics|ap:FloatingTopics">
    <xsl:element name="list">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ap:OneImage">
    <xsl:variable name="str_name" select="substring-after(ap:Image/ap:ImageData/cor:Uri,'mmarch://bin/')"/>
      <xsl:element name="img">
	<xsl:copy-of select="/descendant::file[@name=$str_name]/base64"/>
      </xsl:element>
      <!--
	  <xsl:element name="fig">
	  <xsl:element name="t">#fig</xsl:element>
	  </xsl:element>
      -->
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
  </xsl:template>

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

          <xsl:if test="following-sibling::ap:NotesGroup/ap:NotesXhtmlData">
	    <!-- TODO: either ap:NotesGroup/ap:NotesXhtmlData/html or ap:NotesGroup/ap:NotesXhtmlData/@PreviewPlainText -->
	    <xsl:copy-of select="following-sibling::ap:NotesGroup/ap:NotesXhtmlData/html"/>
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
  </xsl:template>
  
  <xsl:template match="*|@*|text()"/>

</xsl:stylesheet>
