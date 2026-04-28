<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="../../Utils.xsl"/>
  
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:strip-space elements="*"/>

  <xsl:variable name="n_depth" select="2"/> <!-- default: 2 -->

  <xsl:variable name="flag_prefix" select="false()"/> <!-- default: false() -->

  <xsl:variable name="flag_todo" select="false()"/> <!-- default: false() -->

  <xsl:variable name="flag_target" select="true()"/> <!-- default: true() -->

  <xsl:variable name="int_lmax" select="-1" /> <!-- default: -1 maximum length of an event summary -->
  
  <xsl:variable name="int_dmin" select="4" /> <!-- default: 4 minimum length of an event -->
  
<xsl:variable name="newline">
<!-- a newline xsl:text element -->
<xsl:text>
</xsl:text>
</xsl:variable>

  <xsl:template match="/">
<xsl:text>[
</xsl:text>
      <xsl:choose>
	<xsl:when test="$flag_todo and $flag_target">
	  <xsl:apply-templates select="descendant::p[child::date[@interval &gt; $int_dmin] and not(@state='done') and not(@done='yes')]|descendant::h[(child::date[@interval &gt; $int_dmin] and parent::*[(name()='section' or name() = 'task') and not(@state='done') and not(@done='yes')]) or parent::task[@class='target' and not(@state='done') and not(@done='yes')]]"/>
	</xsl:when>
	<xsl:when test="$flag_target">
	  <xsl:apply-templates select="descendant::h[(child::date[@interval &gt; $int_dmin] and parent::section[not(@state='done') and not(@done='yes')]) or parent::task[@class='target' and not(@state='done') and not(@done='yes')]]"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="descendant::h[child::date[@interval &gt; $int_dmin] and parent::section[not(@state='done') and not(@done='yes')]]"/>
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
	  <xsl:value-of select="."/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="DISPLAYTITLE"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="p">
    <xsl:variable name="str_title">
      <xsl:value-of select="text()"/>
    </xsl:variable>
    <xsl:for-each select="date">
	<xsl:value-of select="concat('{',$newline)"/>
	<xsl:value-of select="concat('&quot;','_comment','&quot;',': ','&quot;',text(),'&quot;',',')"/>
	<xsl:choose>
	  <xsl:when test="@interval">
	    <xsl:value-of select="concat('&quot;','dt_0','&quot;',': ','&quot;',@begin,'&quot;',',')"/>
	    <xsl:value-of select="concat('&quot;',  'dt_1','&quot;',': ','&quot;',@end,  '&quot;',',')"/>
	    <xsl:value-of select="concat('&quot;','title','&quot;',': ')"/>
	    <xsl:choose>
	      <xsl:when test="$int_lmax &lt; 1">
		<xsl:value-of select="concat('&quot;',translate($str_title,'&quot;&#x201C;&#x201D;&#x201E;&#x201F;&#x005C;','_____/'),'&quot;')"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="concat('&quot;',translate(substring($str_title,1,$int_lmax),'&quot;&#x201C;&#x201D;&#x201E;&#x201F;&#x005C;','_____/'),'&quot;')"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="concat('&quot;','dt_0','&quot;',': ','&quot;',@iso,'&quot;',',')"/>
	    <xsl:value-of select="concat('&quot;','title','&quot;',': ')"/>
	    <xsl:choose>
	      <xsl:when test="$int_lmax &lt; 1">
		<xsl:value-of select="concat('&quot;',translate($str_title,'&quot;&#x201C;&#x201D;&#x201E;&#x201F;&#x005C;','_____/'),'&quot;')"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="concat('&quot;',translate(substring($str_title,1,$int_lmax),'&quot;&#x201C;&#x201D;&#x201E;&#x201F;&#x005C;','_____/'),'&quot;')"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:otherwise>
	</xsl:choose>

	<xsl:if test="ancestor::*[attribute::done = 'yes']">
	  <xsl:value-of select="concat(',','&quot;','done','&quot;',': ','true')"/>
	</xsl:if>
	<xsl:if test="ancestor::*[attribute::impact]">
	  <xsl:value-of select="concat(',','&quot;','flag','&quot;',': ','true')"/>
	</xsl:if>

	<xsl:value-of select="concat('},',$newline)"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="h">
    <xsl:variable name="str_title">
      <xsl:if test="$flag_prefix">
	<xsl:for-each select="parent::task[@class]">
	  <xsl:call-template name="FORMATTASKPREFIX"/>
	</xsl:for-each>
      </xsl:if>
      <xsl:for-each select="ancestor-or-self::*[position() &lt;= $n_depth]/child::h|parent::p">
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
	    <xsl:value-of select="concat('&quot;','title','&quot;',': ')"/>
	    <xsl:choose>
	      <xsl:when test="$int_lmax &lt; 1">
		<xsl:value-of select="concat('&quot;',translate($str_title,'&quot;&#x201C;&#x201D;&#x201E;&#x201F;&#x005C;','_____/'),'&quot;')"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="concat('&quot;',translate(substring($str_title,1,$int_lmax),'&quot;&#x201C;&#x201D;&#x201E;&#x201F;&#x005C;','_____/'),'&quot;')"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="concat('&quot;','dt_0','&quot;',': ','&quot;',@iso,'&quot;',',')"/>
	    <xsl:value-of select="concat('&quot;','title','&quot;',': ')"/>
	    <xsl:choose>
	      <xsl:when test="$int_lmax &lt; 1">
		<xsl:value-of select="concat('&quot;',translate($str_title,'&quot;&#x201C;&#x201D;&#x201E;&#x201F;&#x005C;','_____/'),'&quot;')"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="concat('&quot;',translate(substring($str_title,1,$int_lmax),'&quot;&#x201C;&#x201D;&#x201E;&#x201F;&#x005C;','_____/'),'&quot;')"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
	  <xsl:when test="parent::p">
	    <xsl:value-of select="concat(',','&quot;','class','&quot;',': ','&quot;','par','&quot;')"/>
	  </xsl:when>
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
