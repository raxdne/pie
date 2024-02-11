<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  
  <xsl:include href="../Utils.xsl"/>

  <xsl:output method="xml" version="1.0" encoding="US-ASCII"/>

  <xsl:variable name="flag_p" select="true()"/>
  <xsl:variable name="flag_attr" select="false()"/>
  <xsl:variable name="flag_fold" select="true()"/>
  <xsl:variable name="str_title" select="''"/>
  <xsl:variable name="str_font" select="'SansSerif'"/> <!--  -->
  <xsl:variable name="int_fontsize" select="12"/>
  
  <xsl:template match="/">
    <xsl:element name="map">
      <xsl:if test="$flag_attr">
        <attribute_registry SHOW_ATTRIBUTES="hide"/>
      </xsl:if>
      <xsl:comment>
	<xsl:value-of select="concat(' pie2mm.xsl: ','flag_attr=',$flag_attr,' ')"/>
      </xsl:comment>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="file">
    <xsl:apply-templates select="pie"/>
  </xsl:template>

  <xsl:template match="pie">
    <xsl:choose>
      <xsl:when test="count(child::*[not(name()='meta')]) &gt; 1">
        <!-- create root node -->
        <xsl:element name="node">
          <xsl:attribute name="TEXT">
            <xsl:value-of select="$str_title"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <!-- there is a root node already -->
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="section">
    <xsl:element name="node">
      <xsl:if test="$flag_fold and child::*[not(name() = 'h')] and count(ancestor::section) &gt; 0">
        <xsl:attribute name="FOLDED">
          <xsl:text>true</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:for-each select="child::h">
	<xsl:if test="link[@href]">
          <xsl:attribute name="LINK">
            <xsl:value-of select="link[1]/@href"/>
          </xsl:attribute>
	</xsl:if>
	<xsl:call-template name="CREATECOLORS"/>
	<xsl:attribute name="TEXT">
	  <xsl:for-each select="child::*[not(name()='t')]|child::text()">
            <xsl:value-of select="."/>
	  </xsl:for-each>
	</xsl:attribute>
      </xsl:for-each>
      <xsl:element name="font">
	<xsl:attribute name="BOLD">
          <xsl:text>true</xsl:text>
	</xsl:attribute>
        <xsl:attribute name="NAME">
          <xsl:value-of select="$str_font"/>
        </xsl:attribute>
        <xsl:attribute name="SIZE">
          <xsl:value-of select="$int_fontsize"/>
        </xsl:attribute>
      </xsl:element>
      <xsl:call-template name="CREATEATTRIBUTES"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="task">
    <xsl:if test="$flag_p">
      <xsl:element name="node">
        <xsl:attribute name="TEXT">
          <xsl:call-template name="FORMATTASKPREFIX"/>
          <xsl:value-of select="string(h)"/>
        </xsl:attribute>
        <xsl:if test="h/@ref">
          <xsl:attribute name="LINK">
            <xsl:value-of select="h/@ref"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:call-template name="CREATECOLORS"/>
	<xsl:choose>
          <xsl:when test="@done">
            <xsl:element name="icon">
              <xsl:attribute name="BUILTIN">
		<xsl:text>button_ok</xsl:text>
              </xsl:attribute>
            </xsl:element>
	  </xsl:when>
          <xsl:when test="@valid = 'no' or @hidden">
            <xsl:element name="icon">
              <xsl:attribute name="BUILTIN">
		<xsl:text>button_cancel</xsl:text>
              </xsl:attribute>
            </xsl:element>
	  </xsl:when>
	</xsl:choose>
        <xsl:call-template name="CREATEATTRIBUTES"/>
        <xsl:apply-templates select="child::*[not(name()='h')]"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="list">
    <xsl:if test="$flag_p">
      <xsl:choose>
	<xsl:when test="count(ancestor::section) &lt; 1">
	  <xsl:element name="node">
            <xsl:attribute name="TEXT"/>
            <xsl:apply-templates select="*"/>
	  </xsl:element>
	</xsl:when>
	<xsl:when test="not(child::*)">
          <!-- ignore the list without child elements -->
	</xsl:when>
	<xsl:otherwise>
          <!-- there are more childs of the parent section element -->
          <xsl:apply-templates select="*"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="fig">
    <xsl:element name="node">
      <xsl:if test="h">
        <!-- write header as TEXT in this node -->
        <xsl:attribute name="TEXT">
	  <xsl:for-each select="child::h/child::*[not(name()='t')]|child::h/child::text()">
            <xsl:value-of select="."/>
	  </xsl:for-each>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="img/@src">
        <!-- add link to image -->
        <xsl:element name="node">
	  <richcontent TYPE="NODE">
	    <html>
	      <head>
	      </head>
	      <body>
		<img src="{img/@src}" />
	      </body>
	    </html>
	  </richcontent>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p">
    <xsl:if test="$flag_p">
      <xsl:element name="node">
        <xsl:attribute name="TEXT">
          <xsl:for-each select="child::node()|child::text()">
	    <xsl:choose>
	      <xsl:when test="self::list"/>
	      <xsl:when test="self::t"/>
	      <xsl:when test="self::text()">
		<xsl:value-of select="."/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="."/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:for-each>
        </xsl:attribute>
        <xsl:call-template name="CREATECOLORS"/>
        <xsl:if test="link/@href">
          <xsl:attribute name="LINK">
            <xsl:value-of select="link[1]/@href"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@hidden &gt; 0">
	  <xsl:element name="font">
	    <xsl:attribute name="ITALIC">
              <xsl:text>true</xsl:text>
	    </xsl:attribute>
            <xsl:attribute name="NAME">
              <xsl:value-of select="$str_font"/>
            </xsl:attribute>
            <xsl:attribute name="SIZE">
              <xsl:value-of select="$int_fontsize"/>
            </xsl:attribute>
	  </xsl:element>
        </xsl:if>
        <xsl:call-template name="CREATEATTRIBUTES"/>
        <xsl:apply-templates select="list"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="table">
    <xsl:for-each select="child::tr[1]/child::*[name() = 'th' or name() = 'td']"> <!-- first row defines columns -->
      <xsl:variable name="int_col" select="position()"/>
      <xsl:element name="node">
	<xsl:attribute name="TEXT">
          <xsl:value-of select="$int_col"/>
	</xsl:attribute>
	<xsl:for-each select="parent::tr/parent::table/child::tr">
	  <xsl:variable name="int_row" select="position()"/>
          <xsl:apply-templates select="child::*[position() = $int_col]"/>
	</xsl:for-each>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tableYYY">
    <xsl:apply-templates select="tr"/>
  </xsl:template>

  <xsl:template match="tr">
    <xsl:element name="node">
      <xsl:attribute name="TEXT">
        <xsl:value-of select="position()"/>
      </xsl:attribute>
      <xsl:apply-templates select="th|td"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="th">
    <xsl:element name="node">
      <xsl:attribute name="TEXT">
	<xsl:for-each select="child::*[not(name()='t')]|child::text()">
          <xsl:value-of select="."/>
	</xsl:for-each>
      </xsl:attribute>
      <xsl:element name="font">
	<xsl:attribute name="BOLD">
          <xsl:text>true</xsl:text>
	</xsl:attribute>
        <xsl:attribute name="NAME">
          <xsl:value-of select="$str_font"/>
        </xsl:attribute>
        <xsl:attribute name="SIZE">
          <xsl:value-of select="$int_fontsize"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="td">
    <xsl:element name="node">
      <xsl:attribute name="TEXT">
	<xsl:for-each select="child::*[not(name()='t')]|child::text()">
          <xsl:value-of select="."/>
	</xsl:for-each>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="pre">
    <xsl:if test="$flag_p">
      <xsl:element name="node">
        <xsl:attribute name="TEXT">
          <xsl:apply-templates/>
        </xsl:attribute>
	<xsl:element name="font">
          <xsl:attribute name="NAME">
            <xsl:text>Courier</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="SIZE">
            <xsl:value-of select="$int_fontsize - 2"/>
          </xsl:attribute>
	</xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="block">
    <xsl:choose>
      <xsl:when test="count(child::*[not(name()='meta')]) &gt; 1">
	<!-- its a block with more than one child, create explicit node -->
        <xsl:element name="node">
          <xsl:attribute name="TEXT">
            <xsl:value-of select="@name"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<!-- simple block can be ignored -->
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*|text()|@*">
    <!-- ignore other elements --> 
  </xsl:template>

  <xsl:template name="CREATECOLORS"> <!-- to be aligned with "html/pie.css" -->
    <xsl:if test="@impact">
      <xsl:attribute name="BACKGROUND_COLOR">
	<xsl:choose>
	  <xsl:when test="@impact = 1">
	    <xsl:text>#ffffbb</xsl:text>
	  </xsl:when>
	  <xsl:when test="@impact = 2">
	    <xsl:text>#ddffdd</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="CREATEATTRIBUTES">
    <xsl:if test="$flag_attr">
      <!-- add all mindmap node attributes -->
      <xsl:for-each select="attribute::*[contains('date,effort,origin',name())]">
	<xsl:element name="attribute">
          <xsl:attribute name="NAME">
            <xsl:value-of select="name()"/>
          </xsl:attribute>
          <xsl:attribute name="VALUE">
            <xsl:value-of select="."/>
          </xsl:attribute>
	</xsl:element>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
