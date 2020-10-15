<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:include href="../Utils.xsl"/>
  <xsl:output method="xml" version="1.0" encoding="US-ASCII"/>
  <xsl:variable name="flag_p" select="true()"/>
  <xsl:variable name="flag_attr" select="false()"/>
  <xsl:variable name="flag_fold" select="true()"/>
  <xsl:variable name="str_title" select="''"/>
  <xsl:template match="/">
    <xsl:element name="map">
      <xsl:if test="$flag_attr">
        <attribute_registry SHOW_ATTRIBUTES="hide"/>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="file">
    <xsl:apply-templates select="pie"/>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:choose>
      <xsl:when test="count(child::*[not(name()='meta' or name()='date' or name()='error' or name()='author')]) &gt; 1">
        <!-- create root node -->
        <xsl:element name="node">
          <xsl:attribute name="TEXT">
            <xsl:value-of select="$str_title"/>
            <xsl:if test="date or author">
              <xsl:value-of select="concat('&#10;',date,'&#10;',author)"/>
            </xsl:if>
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
      <xsl:attribute name="TEXT">
        <xsl:value-of select="normalize-space(h)"/>
      </xsl:attribute>
      <xsl:if test="h/@ref">
        <xsl:attribute name="LINK">
          <xsl:value-of select="h/@ref"/>
        </xsl:attribute>
      </xsl:if>
      <!-- icons for attribute 'state' -->
      <xsl:choose>
        <xsl:when test="@state">
        <xsl:element name="icon">
          <xsl:attribute name="BUILTIN">
            <xsl:choose>
              <xsl:when test="@state='0'">
                <xsl:text>stop</xsl:text>
              </xsl:when>
              <xsl:when test="@state='1'">
                <xsl:text>go</xsl:text>
              </xsl:when>
              <xsl:when test="@state='2'">
                <xsl:text>button_ok</xsl:text>
              </xsl:when>
              <xsl:when test="@state='-'">
                <xsl:text>button_cancel</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>prepare</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:element>
        </xsl:when>
        <xsl:when test="@assignee">
        <xsl:element name="icon">
          <xsl:attribute name="BUILTIN">
            <xsl:text>male2</xsl:text>
          </xsl:attribute>
        </xsl:element>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
      <font BOLD="true" NAME="SansSerif" SIZE="12"/>
      <xsl:if test="$flag_attr">
        <xsl:call-template name="CREATEATTRIBUTES"/>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="task|target">
    <xsl:if test="$flag_p">
      <xsl:element name="node">
        <xsl:attribute name="TEXT">
          <xsl:call-template name="FORMATTASKPREFIX"/>
          <xsl:value-of select="string(h)"/>
	  <xsl:call-template name="FORMATIMPACT"/>
        </xsl:attribute>
        <xsl:if test="h/@ref">
          <xsl:attribute name="LINK">
            <xsl:value-of select="h/@ref"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@done">
          <xsl:element name="icon">
            <xsl:attribute name="BUILTIN">
              <xsl:text>button_ok</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>
        <xsl:if test="@prio &lt; 3">
          <xsl:element name="icon">
            <xsl:attribute name="BUILTIN">
              <xsl:text>messagebox_warning</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>
        <xsl:if test="@valid = 'no' or @hidden">
          <xsl:element name="icon">
            <xsl:attribute name="BUILTIN">
              <xsl:text>button_cancel</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>
        <xsl:if test="$flag_attr">
          <xsl:call-template name="CREATEATTRIBUTES"/>
        </xsl:if>
        <xsl:element name="icon">
          <xsl:attribute name="BUILTIN">
            <xsl:choose>
              <xsl:when test="@class='todo'">
                <xsl:text>list</xsl:text>
              </xsl:when>
              <xsl:when test="@class='target'">
                <xsl:text>flag-yellow</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text></xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:element>
        <xsl:apply-templates select="child::*[not(name()='h')]"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template match="list">
    <xsl:if test="$flag_p">
      <xsl:choose>
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
          <xsl:value-of select="normalize-space(h)"/>
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
  <xsl:template match="link">
    <xsl:value-of select="text()"/>
  </xsl:template>
  <xsl:template match="p">
    <xsl:if test="$flag_p">
      <xsl:element name="node">
        <xsl:attribute name="TEXT">
          <xsl:for-each select="child::*|text()">
	    <xsl:choose>
	      <xsl:when test="self::list">
		<!-- ignore the list element here -->
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="normalize-space(.)"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:for-each>
	  <xsl:call-template name="FORMATIMPACT"/>
        </xsl:attribute>
        <xsl:if test="link/@href">
          <xsl:attribute name="LINK">
            <xsl:value-of select="link[1]/@href"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@hidden &gt; 0">
          <xsl:element name="font">
            <xsl:attribute name="ITALIC">true</xsl:attribute>
            <xsl:attribute name="NAME">SansSerif</xsl:attribute>
            <xsl:attribute name="SIZE">10</xsl:attribute>
          </xsl:element>
        </xsl:if>
        <xsl:if test="$flag_attr">
          <xsl:call-template name="CREATEATTRIBUTES"/>
        </xsl:if>
        <xsl:apply-templates select="list"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template match="table">
    <xsl:for-each select="tr[1]/*">
      <xsl:variable name="int_col" select="position()"/>
      <xsl:choose>
        <xsl:when test="self::th">
          <!-- there is a header cell -->
	  <xsl:element name="node">
	    <xsl:attribute name="TEXT">
              <xsl:apply-templates/>
	    </xsl:attribute>
            <xsl:for-each select="../../tr[position() &gt; 1]">
              <xsl:for-each select="*[position() = $int_col]">
		<xsl:element name="node">
		  <xsl:attribute name="TEXT">
                    <xsl:apply-templates/>
		  </xsl:attribute>
		</xsl:element>
              </xsl:for-each>
            </xsl:for-each>
	  </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <!-- there is no header cell -->
	  <xsl:element name="node">
            <xsl:for-each select="../../tr">
              <xsl:for-each select="*[position() = $int_col]">
		<xsl:element name="node">
		  <xsl:attribute name="TEXT">
		    <xsl:apply-templates/>
		  </xsl:attribute>
		</xsl:element>
              </xsl:for-each>
            </xsl:for-each>
	  </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="tr">
    <xsl:element name="node">
      <xsl:attribute name="TEXT">
        <xsl:value-of select="''"/>
      </xsl:attribute>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="th">
    <xsl:element name="node">
      <xsl:attribute name="TEXT">
        <xsl:apply-templates/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="td">
    <xsl:element name="node">
      <xsl:attribute name="TEXT">
        <xsl:apply-templates/>
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
          <xsl:attribute name="NAME">Courier</xsl:attribute>
          <xsl:attribute name="SIZE">10</xsl:attribute>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template match="block">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="*|text()|@*">
    <!-- ignore other elements --> 
  </xsl:template>
  <xsl:template name="CREATEATTRIBUTES">
    <!--
    <xsl:element name="attribute">
      <xsl:attribute name="NAME">
        <xsl:value-of select="'class'"/>
      </xsl:attribute>
      <xsl:attribute name="VALUE">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
    </xsl:element>
    -->
    <!-- add all mindmap node attributes -->
    <xsl:for-each select="attribute::*[contains('date,impact,effort,origin',name())]">
      <xsl:element name="attribute">
        <xsl:attribute name="NAME">
          <xsl:value-of select="name()"/>
        </xsl:attribute>
        <xsl:attribute name="VALUE">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
