<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="xml" encoding="UTF-8" version="1.0"/>

  <xsl:variable name="str_path" select="''" />

  <xsl:variable name="flag_section" select="count(descendant::font[@BOLD='true']) &gt; 0"/>

  <xsl:variable name="h_max" select="3"/>

  <xsl:template match="/">
    <xsl:element name="pie" xmlns="http://www.tenbusch.info/cxproc/">
      <xsl:attribute name="class">
        <xsl:text>mindmap</xsl:text>
      </xsl:attribute>
      <xsl:choose>
	<xsl:when test="string-length($str_path) &gt; 0">
	  <xsl:attribute name="context">
	    <xsl:value-of select="$str_path"/>
	  </xsl:attribute>
	</xsl:when>
	<xsl:when test="pie/file/@name">
	  <xsl:attribute name="context">
	    <xsl:value-of select="concat(pie/file/@prefix,'/',pie/file/@name)"/>
	  </xsl:attribute>
	</xsl:when>
	<xsl:otherwise>
	  <!-- no locator found -->
	</xsl:otherwise>
      </xsl:choose>
      <xsl:comment>
	<xsl:value-of select="concat(' mm2pie.xsl: ','flag_section=',$flag_section,' ','h_max=',$h_max,' ')"/>
      </xsl:comment>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="pie|file">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="map">
    <xsl:if test="node[1]/attribute[@NAME = 'regexp-tag']">
      <xsl:processing-instruction name="regexp-tag">
        <xsl:value-of select="node[1]/attribute[@NAME = 'regexp-tag']/@VALUE"/>
      </xsl:processing-instruction>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="node[attribute[@NAME='class']/@VALUE]">
    <!-- node with explicit element name -->
    <xsl:element name="{attribute[1][@NAME='class']/@VALUE}">
      <xsl:call-template name="CREATEATTRIBUTES"/>
      <xsl:choose>
        <xsl:when test="attribute[@NAME='class']/@VALUE='section' or attribute[@NAME='class']/@VALUE='task'">
          <xsl:element name="h">
            <xsl:value-of select="@TEXT"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@TEXT"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="node[node[1]/richcontent/html/body/img]">
    <!-- first node has an image child: figure -->
    <xsl:element name="fig">
      <xsl:call-template name="CREATEATTRIBUTES"/>
      <xsl:copy-of select="node[1]/richcontent/html/body/img"/>
      <xsl:choose>
        <xsl:when test="@LINK">
          <!-- node with a link -->
          <xsl:element name="h">
            <xsl:element name="link">
              <xsl:attribute name="href">
                <xsl:choose>
                  <xsl:when test="starts-with(@LINK,'\\')">
                    <xsl:value-of select="concat('file://',translate(@LINK,'\','/'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="@LINK"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:value-of select="@TEXT"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="@TEXT and not(@TEXT = '')">
          <!-- node with text only -->
          <xsl:element name="h">
            <xsl:value-of select="@TEXT"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <!-- node without text -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="node[child::font[@NAME='Monospaced' or contains(@NAME,'Courier')]]">
    <xsl:element name="pre">
      <xsl:value-of select="@TEXT"/>
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="node">
    <!-- regular node -->
    <xsl:variable name="depth" select="count(ancestor::node)"/>
    <xsl:choose>
      <xsl:when test="($flag_section and (child::font[@BOLD='true'] or descendant::font[@BOLD='true'])) or (not($flag_section) and $depth &lt; $h_max)">
        <!-- section node -->
        <xsl:element name="section">
          <xsl:call-template name="CREATEATTRIBUTES"/>
          <!-- header -->
          <xsl:element name="h">
            <xsl:choose>
              <xsl:when test="@LINK">
                <!-- node with a link -->
                <xsl:element name="link">
                  <xsl:attribute name="href">
                    <xsl:choose>
                      <xsl:when test="starts-with(@LINK,'\\')">
                        <xsl:value-of select="concat('file://',translate(@LINK,'\','/'))"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="@LINK"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:value-of select="@TEXT"/>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@TEXT"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <!-- <xsl:apply-templates select="node[node[1]/richcontent/html/body/img/@src]"/> -->
          <xsl:choose>
            <xsl:when test="$flag_section=false() and ($h_max - $depth &lt; 2) and child::node">
              <xsl:element name="list">
                <xsl:apply-templates/>
		<!-- TODO: select="child::*[not(child::icon[contains(@BUILTIN, 'male')] and not(child::node))]" -->
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <!-- itemized par -->
        <xsl:if test="string-length(@TEXT) &gt; 0">
        <xsl:element name="p">
          <xsl:call-template name="CREATEATTRIBUTES"/>
          <xsl:choose>
            <xsl:when test="@LINK">
              <!-- node with a link -->
              <xsl:element name="link">
                <xsl:attribute name="href">
                    <xsl:choose>
                      <xsl:when test="starts-with(@LINK,'\\')">
                        <xsl:value-of select="concat('file://',translate(@LINK,'\','/'))"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="@LINK"/>
                      </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="@TEXT"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <!-- font attributes for current node -->
              <xsl:choose>
                <xsl:when test="child::font[@BOLD='true']">
                  <xsl:element name="strong">
                    <xsl:value-of select="@TEXT"/>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="child::font[@ITALIC='true']">
                  <xsl:element name="em">
                    <xsl:value-of select="@TEXT"/>
                  </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@TEXT"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="child::node">
            <xsl:element name="list">
              <xsl:if test="child::node/child::attribute[@NAME='enum' and @VALUE='yes']">
		<xsl:attribute name="enum">
                  <xsl:text>yes</xsl:text>
		</xsl:attribute>
              </xsl:if>
              <xsl:apply-templates/>
            </xsl:element>
          </xsl:if>
        </xsl:element>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="hook">
    <xsl:if test="@NAME = 'accessories/plugins/NodeNote.properties' and child::text">
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="text">
    <!--
  <xsl:for-each select="ancestor::node">
    <xsl:call-template name="itemize"/>
  </xsl:for-each>
       -->
    <xsl:text> </xsl:text>
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template name="CREATEATTRIBUTES">
    <xsl:copy-of select="@flocator"/>
    <xsl:copy-of select="@fxpath"/>
    <xsl:if test="child::icon[contains(@BUILTIN, 'cancel')]">
      <xsl:attribute name="valid">
        <xsl:text>no</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="child::icon[@BUILTIN='button_ok']">
      <xsl:attribute name="done">
        <xsl:text>1</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@BACKGROUND_COLOR">
      <xsl:attribute name="background">
        <xsl:value-of select="@BACKGROUND_COLOR"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@COLOR">
      <xsl:attribute name="color">
        <xsl:value-of select="@COLOR"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="contains(@TEXT,'+++')">
      <xsl:attribute name="impact">
        <xsl:value-of select="'1'"/>
      </xsl:attribute>
    </xsl:if>
    <!-- add all mindmap node attributes -->
    <xsl:for-each select="attribute">
      <xsl:choose>
        <xsl:when test="@NAME='class'"/>
	<xsl:when test="@NAME='regexp-tag'"/>
        <xsl:otherwise>
          <xsl:attribute name="{@NAME}">
            <xsl:value-of select="@VALUE"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="*|@*|text()|comment()|meta|t">
    <!-- ignore other elements --> 
  </xsl:template>
</xsl:stylesheet>
