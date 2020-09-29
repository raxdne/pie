<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text"/>
  <!--    -->
  <xsl:variable name="t_0" select="-14"/>
  <xsl:variable name="t_1" select="3"/>
  <xsl:variable name="int_level" select="1"/> <!-- BUG: impact of this value -->
  <!-- default 'true()' if there are task elements -->
  <xsl:variable name="flag_task" select="count(descendant::task) &gt; 3"/>
  <!-- default 'true()' if there are elements with attribute diff -->
  <xsl:variable name="flag_diff" select="false()"/>
  <!--  count(descendant::*[@diff]) &gt; 0  -->
  <xsl:variable name="flag_parent" select="true()"/>
  <!--    -->
  <xsl:variable name="flag_effort" select="count(descendant::task) &gt; 0"/>
  <!--    -->
  <xsl:template match="/">
    <xsl:text>{</xsl:text>
    <xsl:value-of select="concat('&quot;','name','&quot;',': ','&quot;','Global','&quot;',',',' &quot;','children','&quot;',': ','[','&#10;')"/>
    <xsl:apply-templates select="*"/>
    <xsl:value-of select="concat(']','')"/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="pie|block">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="section">
    <xsl:variable name="int_size">
      <xsl:choose>
        <xsl:when test="$flag_diff">
          <xsl:variable name="ns_task" select="child::task[not(@done) and @diff &gt;= $t_0 and @diff &lt;= $t_1]"/>
          <xsl:value-of select="count($ns_task) + count($ns_task[@impact &lt; 3]) + count($ns_task[@impact &lt; 2])"/>
        </xsl:when>
        <xsl:when test="$flag_task">
          <xsl:variable name="ns_task" select="child::task[not(@done)]"/>
          <xsl:value-of select="count($ns_task) + count($ns_task[@impact &lt; 3]) + count($ns_task[@impact &lt; 2])"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="count(child::task) + count(child::target) + count(child::fig) + count(child::pre) + count(child::p) + count(child::list/descendant::p)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="str_name">
      <xsl:choose>
        <xsl:when test="not(h)">
          <xsl:value-of select="'_'"/>
        </xsl:when>
        <xsl:when test="$flag_parent">
          <xsl:value-of select="translate(normalize-space(concat(parent::section/child::h,' :: ',h)),'&quot;','_')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="translate(normalize-space(h),'&quot;','_')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--  -->
    <xsl:if test="count(preceding-sibling::section) &gt; 0">
      <xsl:value-of select="concat(',','&#10;')"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="count(child::section[child::h]) &gt; 0 and $int_size &gt; $int_level">
        <!-- there are sections childs and a size value -->
        <xsl:text>{</xsl:text>
        <!-- dummy object, for nesting only -->
        <xsl:value-of select="concat('&quot;','name','&quot;',': ','&quot;','_',$str_name,'&quot;',',',' &quot;','children','&quot;',': ','[','&#10;')"/>
        <xsl:text>{</xsl:text>
        <xsl:call-template name="ELEMENT">
          <xsl:with-param name="str_name" select="$str_name"/>
          <xsl:with-param name="int_size" select="$int_size"/>
        </xsl:call-template>
        <xsl:text>}, </xsl:text>
        <xsl:apply-templates select="section"/>
        <xsl:text>]}</xsl:text>
      </xsl:when>
      <xsl:when test="count(child::section[child::h]) &gt; 0">
        <!-- there are sections childs only -->
        <xsl:text>{</xsl:text>
        <xsl:call-template name="ELEMENT">
          <xsl:with-param name="str_name" select="$str_name"/>
        </xsl:call-template>
        <xsl:value-of select="concat(', &quot;','children','&quot;',': ','[','&#10;')"/>
        <xsl:apply-templates select="section"/>
        <xsl:value-of select="concat(']','')"/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:when test="$int_size &gt; $int_level">
        <!-- there is a size value only, no child::section -->
        <xsl:text>{</xsl:text>
        <xsl:call-template name="ELEMENT">
          <xsl:with-param name="str_name" select="$str_name"/>
          <xsl:with-param name="int_size" select="$int_size"/>
        </xsl:call-template>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- empty object, for JSON syntax only  -->
        <xsl:text>{</xsl:text>
        <xsl:call-template name="ELEMENT">
          <xsl:with-param name="str_name" select="$str_name"/>
        </xsl:call-template>
        <xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="ELEMENT">
    <xsl:param name="str_name" select="''"/>
    <xsl:param name="int_size" select="0"/>
    <xsl:choose>
      <xsl:when test="$str_name = ''">
        <xsl:value-of select="concat('&quot;','name','&quot;',': ','&quot;','_','&quot;')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('&quot;','name','&quot;',': ','&quot;',$str_name,'&quot;')"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@flocator">
      <xsl:value-of select="concat(', &quot;','flocator','&quot;',': ','&quot;',translate(@flocator,'\','/'),'&quot;')"/>
      <xsl:if test="@fxpath">
        <xsl:value-of select="concat(', &quot;','fxpath','&quot;',': ','&quot;',@fxpath,'&quot;')"/>
      </xsl:if>
    </xsl:if>
    <xsl:if test="$int_size &gt; 0">
      <xsl:value-of select="concat(', &quot;','size','&quot;',': ',$int_size)"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="node()|text()|comment()|@*"/>
</xsl:stylesheet>
