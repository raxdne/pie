<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cxp="http://www.tenbusch.info/cxproc/" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:ap="http://schemas.mindjet.com/MindManager/Application/2003" version="1.0">
  <xsl:import href="../Utils.xsl"/>
  <xsl:output method="text" encoding="UTF-8"/>
  <!--  -->
  <xsl:variable name="flag_text" select="true()"/>
  <!--  -->
  <xsl:variable name="flag_audio" select="false()"/>
  <!--  -->
  <xsl:variable name="flag_video" select="false()"/>
  <!--  -->
  <xsl:variable name="flag_application" select="true()"/>
  <!--  -->
  <xsl:variable name="flag_image" select="false()"/>
  <!--  -->
  <xsl:template match="/">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates select="pie/*"/>
    <xsl:text>]</xsl:text>
  </xsl:template>
  <xsl:template match="file|dir">
    <xsl:variable name="str_path">
      <xsl:choose>
        <xsl:when test="@name = '.'">
          <xsl:text>/</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="ancestor-or-self::*[(name()='dir' or name()='file')]">
            <xsl:if test="@urlprefix">
              <xsl:value-of select="concat(@urlprefix,'/')"/>
              <xsl:if test="position() &gt; 1">
                <xsl:text>/</xsl:text>
              </xsl:if>
            </xsl:if>
            <xsl:if test="@name">
              <xsl:if test="position() &gt; 1">
                <xsl:text>/</xsl:text>
              </xsl:if>
              <xsl:value-of select="@urlname"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="str_name">
      <xsl:choose>
        <xsl:when test="@name = '.'">
          <xsl:text>/</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="not(self::dir) and @name = '.'"/>
      <xsl:when test="starts-with(@name,'_')"/>
      <xsl:when test="starts-with(@name,'.Y')"/>
      <xsl:when test="not($flag_text)  and starts-with(@type,'text/')"/>
      <xsl:when test="not($flag_audio) and starts-with(@type,'audio/')"/>
      <xsl:when test="not($flag_video) and starts-with(@type,'video/')"/>
      <xsl:when test="not($flag_image) and starts-with(@type,'image/')"/>
      <xsl:when test="not($flag_application) and starts-with(@type,'application/')"/>
      <xsl:when test="contains(@name,'~')"/>
      <xsl:when test="contains(@type,'script')"/>
      <xsl:when test="@type='application/command' or @type='application/x-sh'"/>
      <xsl:when test="@name = 'tmp'"/>
      <xsl:when test="child::*[contains(name(),'make')]">
        <!-- cxp make file -->
        <xsl:if test="child::*[contains(name(),'make') and child::*[contains(name(),'description')]]">
          <xsl:text>{</xsl:text>
          <xsl:value-of select="concat('&quot;','name','&quot;',' : ','&quot;')"/>
          <xsl:call-template name="lf2br">
            <xsl:with-param name="StringToTransform" select="child::*[contains(name(),'make') and child::*[contains(name(),'description')]]"/>
          </xsl:call-template>
          <xsl:value-of select="concat('','&quot;')"/>
          <xsl:text> , </xsl:text>
          <xsl:value-of select="concat('&quot;','type','&quot;',' : ','&quot;',name(),'&quot;')"/>
          <xsl:text> , </xsl:text>
          <xsl:value-of select="concat('&quot;','mime','&quot;',' : ','&quot;',@type,'&quot;')"/>
          <xsl:text> , </xsl:text>
          <xsl:choose>
            <xsl:when test="child::*[contains(name(),'make')]/child::*[contains(name(),'description')]/@anchor">
          <xsl:value-of select="concat('&quot;','url','&quot;',' : ','&quot;',$str_path,'#',child::*[contains(name(),'make')]/child::*[contains(name(),'description')]/@anchor,'&quot;')"/>
            </xsl:when>
            <xsl:otherwise>
          <xsl:value-of select="concat('&quot;','url','&quot;',' : ','&quot;',$str_path,'&quot;')"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text> , </xsl:text>
          <xsl:value-of select="concat('&quot;','childs','&quot;',' : ','[]')"/>
          <xsl:text>}</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:when test="pie[@class='shortcuts']">
        <!-- shortcuts -->
        <xsl:for-each select="descendant::link[not(ancestor-or-self::*[@valid='no'])]">
          <xsl:if test="position() &gt; 1">
            <xsl:text> , </xsl:text>
          </xsl:if>
          <xsl:text>{</xsl:text>
          <xsl:value-of select="concat('&quot;','name','&quot;',' : ','&quot;')"/>
          <xsl:call-template name="lf2br">
            <xsl:with-param name="StringToTransform" select="."/>
          </xsl:call-template>
          <xsl:value-of select="concat('','&quot;')"/>
          <xsl:text> , </xsl:text>
          <xsl:value-of select="concat('&quot;','type','&quot;',' : ','&quot;',name(),'&quot;')"/>
          <xsl:text> , </xsl:text>
          <xsl:value-of select="concat('&quot;','url','&quot;',' : ','&quot;',@href,'&quot;')"/>
          <xsl:text>}</xsl:text>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>{</xsl:text>
        <xsl:value-of select="concat('&quot;','name','&quot;',' : ','&quot;',@name,'&quot;')"/>
        <xsl:text> , </xsl:text>
        <xsl:value-of select="concat('&quot;','type','&quot;',' : ','&quot;',name(),'&quot;')"/>
        <xsl:text> , </xsl:text>
        <xsl:value-of select="concat('&quot;','mime','&quot;',' : ','&quot;',@type,'&quot;')"/>
        <xsl:text> , </xsl:text>
        <xsl:choose>
          <xsl:when test="$str_path=''">
            <xsl:value-of select="concat('&quot;','url','&quot;',' : ','&quot;',@name,'&quot;')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('&quot;','url','&quot;',' : ','&quot;',$str_path,'&quot;')"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> , </xsl:text>
        <xsl:value-of select="concat('&quot;','childs','&quot;',' : ','[')"/>
        <xsl:for-each select="dir|file|pie|map|office:document-content|ap:Map">
          <xsl:sort lang="de" order="ascending" data-type="text" select="name(.)"/>
          <xsl:sort lang="de" order="ascending" data-type="text" select="@name"/>
          <xsl:if test="position() &gt; 1">
            <xsl:text> , </xsl:text>
          </xsl:if>
          <xsl:apply-templates select=".">
            </xsl:apply-templates>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
        <xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template match="pie">
    <xsl:apply-templates select="section">
      <xsl:with-param name="str_prefix">
        <xsl:value-of select="concat('/',name())"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="section">
    <xsl:param name="str_prefix"/>
    <xsl:variable name="str_xpath">
      <xsl:value-of select="concat($str_prefix,'/',name(),'[',position(),']')"/>
    </xsl:variable>
    <xsl:if test="preceding-sibling::section">
      <xsl:text> , </xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <!-- <xsl:value-of select="concat('name : ','&quot;',h,'&quot;')"/> -->
    <xsl:value-of select="concat('&quot;','name','&quot;',' : ','&quot;')"/>
    <xsl:call-template name="lf2br">
      <xsl:with-param name="StringToTransform" select="translate(h,'&quot;','_')"/>
    </xsl:call-template>
    <xsl:value-of select="concat('','&quot;')"/>
    <xsl:text> , </xsl:text>
    <xsl:value-of select="concat('&quot;','type','&quot;',' : ','&quot;',name(),'&quot;')"/>
    <xsl:text> , </xsl:text>
    <xsl:value-of select="concat('&quot;','url','&quot;',' : ','&quot;',$str_xpath,'&quot;')"/>
    <xsl:text> , </xsl:text>
    <xsl:value-of select="concat('&quot;','childs','&quot;',' : ','[')"/>
    <xsl:apply-templates select="section">
      <xsl:with-param name="str_prefix">
        <xsl:value-of select="$str_xpath"/>
      </xsl:with-param>
    </xsl:apply-templates>
    <xsl:text>]</xsl:text>
    <xsl:text>}</xsl:text>
  </xsl:template>
  <!-- -->
  <xsl:template match="map">
    <xsl:apply-templates select="node">
      <xsl:with-param name="str_prefix">
        <xsl:value-of select="concat('/',name())"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="node">
    <xsl:param name="str_prefix"/>
    <xsl:variable name="str_xpath">
      <xsl:value-of select="concat($str_prefix,'/',name(),'[',position(),']')"/>
    </xsl:variable>
    <xsl:if test="preceding-sibling::node">
      <xsl:text> , </xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="concat('&quot;','name','&quot;',' : ','&quot;')"/>
    <xsl:call-template name="lf2br">
      <xsl:with-param name="StringToTransform" select="translate(@TEXT,'&quot;','_')"/>
    </xsl:call-template>
    <xsl:value-of select="concat('','&quot;')"/>
    <xsl:text> , </xsl:text>
    <xsl:value-of select="concat('&quot;','type','&quot;',' : ','&quot;',name(),'&quot;')"/>
    <xsl:text> , </xsl:text>
    <xsl:value-of select="concat('&quot;','url','&quot;',' : ','&quot;',$str_xpath,'&quot;')"/>
    <xsl:text> , </xsl:text>
    <xsl:value-of select="concat('&quot;','childs','&quot;',' : ','[')"/>
    <xsl:apply-templates select="node">
      <xsl:with-param name="str_prefix">
        <xsl:value-of select="$str_xpath"/>
      </xsl:with-param>
    </xsl:apply-templates>
    <xsl:text>]</xsl:text>
    <xsl:text>}</xsl:text>
  </xsl:template>
  <!-- -->
  <xsl:template match="ap:Map">
    <xsl:apply-templates>
      <xsl:with-param name="str_prefix">
        <xsl:value-of select="concat('/',name())"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="*[contains(name(),'Topic')]">
    <xsl:param name="str_prefix"/>
    <xsl:variable name="str_xpath">
      <xsl:value-of select="concat($str_prefix,'/','ap:*','[',position(),']')"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="name() = 'ap:Topic'">
    <xsl:if test="preceding-sibling::*[contains(name(),'Topic')]">
      <xsl:text> , </xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="concat('&quot;','name','&quot;',' : ','&quot;')"/>
    <xsl:call-template name="lf2br">
      <xsl:with-param name="StringToTransform" select="translate(ap:Text/@PlainText,'&quot;','_')"/>
    </xsl:call-template>
    <xsl:value-of select="concat('','&quot;')"/>
    <xsl:text> , </xsl:text>
    <xsl:value-of select="concat('&quot;','type','&quot;',' : ','&quot;',name(),'&quot;')"/>
    <xsl:text> , </xsl:text>
    <xsl:value-of select="concat('&quot;','url','&quot;',' : ','&quot;',$str_xpath,'&quot;')"/>
    <xsl:text> , </xsl:text>
    <xsl:value-of select="concat('&quot;','childs','&quot;',' : ','[')"/>
    <xsl:apply-templates>
      <xsl:with-param name="str_prefix">
        <xsl:value-of select="$str_xpath"/>
      </xsl:with-param>
    </xsl:apply-templates>
    <xsl:text>]</xsl:text>
    <xsl:text>}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates>
      <xsl:with-param name="str_prefix">
        <xsl:value-of select="$str_xpath"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:otherwise>
</xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template match="office:document-content">
    <xsl:apply-templates select="office:body/office:text/text:h"/>
  </xsl:template>
  <xsl:template match="text:h">
    <xsl:if test="preceding-sibling::text:h">
      <xsl:text> , </xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="concat('&quot;','name','&quot;',' : ','&quot;')"/>
    <xsl:call-template name="lf2br">
      <xsl:with-param name="StringToTransform" select="translate(.,'&quot;','_')"/>
    </xsl:call-template>
    <xsl:value-of select="concat('','&quot;')"/>
    <xsl:text> , </xsl:text>
    <xsl:value-of select="concat('&quot;','type','&quot;',' : ','&quot;',name(),'&quot;')"/>
    <xsl:text> , </xsl:text>
    <xsl:value-of select="concat('&quot;','url','&quot;',' : ','&quot;',position(),'&quot;')"/>
    <xsl:text> , </xsl:text>
    <xsl:value-of select="concat('&quot;','childs','&quot;',' : ','[')"/>
    <xsl:apply-templates select="text:h"/>
    <xsl:text>]</xsl:text>
    <xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="*"/>
</xsl:stylesheet>
