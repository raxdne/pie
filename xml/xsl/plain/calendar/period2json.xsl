<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="../../Utils.xsl"/>
  
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:strip-space elements="*"/>

  <xsl:variable name="n_depth" select="2"/> <!-- default: 2 -->

  <xsl:variable name="flag_todo" select="false()"/> <!-- default: false() -->

  <xsl:variable name="flag_prefix" select="false()"/> <!-- default: false() -->

  <xsl:variable name="flag_target" select="true()"/> <!-- default: true() -->

  <xsl:variable name="int_lmax" select="-1" /> <!-- default: -1 maximum length of an event summary -->
  
<xsl:variable name="newline">
<!-- a newline xsl:text element -->
<xsl:text>
</xsl:text>
</xsl:variable>

  <xsl:template match="/">
<xsl:text>[
</xsl:text>
      <xsl:choose>
	<xsl:when test="$flag_todo">
	  <xsl:apply-templates select="descendant::h[(child::date[@interval &gt; 1] and parent::section[not(@state='done' or @done='yes')]) or (child::date[@interval &gt; 5] and parent::task[@impact and not(@state='done' or @done='yes')]) or (child::date[@iso] and parent::task[@class='target'])]"/>
	</xsl:when>
	<xsl:when test="$flag_target">
	  <xsl:apply-templates select="descendant::h[(child::date[@interval &gt; 1] and parent::section[not(@state='done' or @done='yes')]) or (child::date[@iso] and parent::task[@class='target' and not(@state='done' or @done='yes')])]"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="descendant::h[(child::date[@interval &gt; 1] and parent::section[not(@state='done' or @done='yes')])]"/>
	</xsl:otherwise>
      </xsl:choose>
<xsl:text>{}]
</xsl:text>
  </xsl:template>
  
  <xsl:template name="DISPLAYTITLE">
    <xsl:for-each select="descendant::*|text()">
      <!--  <xsl:value-of select="concat(' ',position(),' ',name(),': ')"/> -->
      <xsl:choose>
	<xsl:when test="self::t"/>
	<xsl:when test="self::date"/>
	<xsl:when test="starts-with(.,'@')"/>
	<xsl:when test="self::text()">
	  <xsl:value-of select="translate(substring(.,1,$int_lmax),'&quot;','_')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="DISPLAYTITLE"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="h">
    <xsl:variable name="str_title">
      <xsl:if test="$flag_prefix">
	<xsl:for-each select="parent::task[@class]">
	  <xsl:call-template name="FORMATTASKPREFIX"/>
	</xsl:for-each>
      </xsl:if>
      <xsl:for-each select="ancestor-or-self::*[position() &lt;= $n_depth]/child::h">
	<xsl:if test="position() &gt; 1">
	  <xsl:text> :: </xsl:text>
	</xsl:if>
	<xsl:call-template name="DISPLAYTITLE"/>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="str_url">
      <xsl:choose>
	<xsl:when test="child::link">
	  <xsl:value-of select="concat(',','&quot;','url','&quot;',': ','&quot;',child::link[1]/attribute::href,'&quot;')"/>
	</xsl:when>
	<xsl:when test="ancestor::block[@context]">
	  <xsl:value-of select="concat(',','&quot;','url','&quot;',': ','&quot;','/cxproc/exe?path=',translate(ancestor::block[@context][1]/@context,'\','/'))"/>
	  <xsl:if test="ancestor-or-self::*[@bxpath]">
	    <!-- <xsl:value-of select="concat('&amp;','xpath=/descendant-or-self::*[@bxpath = ',ancestor::*[@bxpath][1]/@bxpath,']')"/> -->
	    <xsl:text>&amp;xpath=/descendant-or-self::*[@bxpath='</xsl:text>
	    <xsl:value-of select="ancestor-or-self::*[@bxpath][2]/@bxpath"/>
	    <xsl:text>']</xsl:text>
	  </xsl:if>
	  <xsl:value-of select="concat('&amp;','cxp=PiejQDefault','&quot;','')"/>
	</xsl:when>
	<xsl:otherwise>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$str_title = ''">
	<!-- to be ignored -->
      </xsl:when>
      <xsl:otherwise>
	<!--
	    <xsl:if test="position() = 1">
	    <xsl:text>,</xsl:text>
	    </xsl:if>
	-->
    <xsl:for-each select="date">
	<xsl:value-of select="concat('{',$newline)"/>
	<xsl:value-of select="concat('&quot;','_comment','&quot;',': ','&quot;',text(),'&quot;',',')"/>
	<xsl:choose>
	  <xsl:when test="@interval">
	    <xsl:value-of select="concat('&quot;','dt_0','&quot;',': ','&quot;',@begin,'&quot;',',')"/>
	    <xsl:value-of select="concat('&quot;',  'dt_1','&quot;',': ','&quot;',@end,  '&quot;',',')"/>
	    <xsl:value-of select="concat('&quot;','title','&quot;',': ','&quot;',$str_title,'&quot;')"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="concat('&quot;','dt_0','&quot;',': ','&quot;',@iso,'&quot;',',')"/>
	    <xsl:value-of select="concat('&quot;','title','&quot;',': ','&quot;',$str_title,'&quot;')"/>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
	  <xsl:when test="parent::h/parent::task[attribute::class]">
	    <xsl:value-of select="concat(',','&quot;','class','&quot;',': ','&quot;',parent::h/parent::task/attribute::class,'&quot;')"/>
	  </xsl:when>
	  <xsl:when test="ancestor::*[attribute::impact]">
	    <xsl:value-of select="concat(',','&quot;','class','&quot;',': ','&quot;','h',ancestor::*[attribute::impact][1]/attribute::impact,'&quot;')"/>
	  </xsl:when>
	  <xsl:otherwise>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:if test="ancestor::*[attribute::done = 'yes']">
	  <xsl:value-of select="concat(',','&quot;','done','&quot;',': ','true')"/>
	</xsl:if>
	<xsl:if test="ancestor::*[attribute::impact]">
	  <xsl:value-of select="concat(',','&quot;','flag','&quot;',': ','true')"/>
	</xsl:if>
	<xsl:value-of select="concat($str_url,'},',$newline)"/>
    </xsl:for-each>
      </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
