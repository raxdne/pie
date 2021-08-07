<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../Utils.xsl"/>

  <xsl:output method="text" encoding="UTF-8"/>

<xsl:variable name="newpar">
<xsl:text>

</xsl:text>
</xsl:variable>

  <xsl:template match="processing-instruction('regexp-tag')">
    <xsl:value-of select="concat('TAGS: ',.,$newpar)"/>
  </xsl:template>

  <xsl:template match="processing-instruction()">
    <xsl:value-of select="concat('; ',name(),': ',.,$newpar)"/>
  </xsl:template>
  
  <xsl:template match="hr">
    <!-- para -->
        <xsl:text>____</xsl:text>
	<xsl:value-of select="$newpar"/>
  </xsl:template>

  <xsl:template match="tt">
    <!-- para -->
        <xsl:text>`</xsl:text>
	<xsl:value-of select="."/>
        <xsl:text>`</xsl:text>
  </xsl:template>

  <xsl:template match="em">
    <!-- para -->
        <xsl:text>__</xsl:text>
	<xsl:value-of select="."/>
        <xsl:text>__</xsl:text>
  </xsl:template>

  <xsl:template match="strong">
    <!-- para -->
        <xsl:text>___</xsl:text>
	<xsl:value-of select="."/>
        <xsl:text>___</xsl:text>
  </xsl:template>

  <xsl:template match="link">
    <xsl:choose>
      <xsl:when test="starts-with(@href,'mailto:')">
        <xsl:value-of select="@href"/>
      </xsl:when>
      <xsl:when test="@href = .">
        <xsl:value-of select="concat('&lt;',.,'&gt;')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('[',.,'](',@href,')')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="img">
    <xsl:value-of select="concat('![',@title,'](',@src,')',$newpar)"/>
  </xsl:template>

  <xsl:template match="fig">
    <xsl:value-of select="concat('Fig. ![',h,'](',img/@src,')',$newpar)"/>
  </xsl:template>

  <xsl:template name="TAGTIME">
    <xsl:param name="str_tagtime" select="''"/>
	<xsl:if test="not($str_tagtime = '')">
       <xsl:value-of select="concat('&#10;',$str_tagtime,'&#10;')"/>
	</xsl:if>
  </xsl:template>

  <xsl:template name="TREE">
      <xsl:text>
</xsl:text>
    <xsl:call-template name="TREELINE">
      <xsl:with-param name="str_spaces">
	<xsl:text>  </xsl:text>
      </xsl:with-param>
      <xsl:with-param name="flag_spacing" select="true()"/>
    </xsl:call-template>
      <xsl:text>

</xsl:text>
  </xsl:template>

  <xsl:template name="TREELINE">
    <xsl:param name="str_prefix" select="''"/>
    <xsl:param name="str_spaces" select="'  '"/>
    <xsl:param name="flag_spacing" select="false()"/>
    <xsl:choose>
      <xsl:when test="self::section|self::task">
	<xsl:if test="$flag_spacing">
          <xsl:value-of select="concat($str_prefix,$str_spaces,'│&#10;')"/>
	</xsl:if>
	<xsl:value-of select="concat($str_prefix,$str_spaces)"/>
	<xsl:choose>
	  <xsl:when test="following-sibling::section">
	    <xsl:text>├─</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>└─</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:if test="self::task">
	  <xsl:call-template name="FORMATTASKPREFIX"/>
	</xsl:if>
	<xsl:value-of select="concat(' ',normalize-space(h),'&#10;')"/>
	<xsl:for-each select="section[child::h]|task[@class = 'target' and child::h]">
	  <xsl:call-template name="TREELINE">
	    <xsl:with-param name="str_prefix">
	      <xsl:choose>
		<xsl:when test="parent::section/following-sibling::section">
		  <xsl:value-of select="concat($str_prefix,$str_spaces,'│')"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="concat($str_prefix,$str_spaces,' ')"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:with-param>
            <xsl:with-param name="str_spaces">
              <xsl:value-of select="$str_spaces"/>
            </xsl:with-param>
	    <xsl:with-param name="flag_spacing" select="$flag_spacing"/>
	  </xsl:call-template>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<xsl:for-each select="pie|block|section[h]|task[@class = 'target' and child::h]">
	  <xsl:call-template name="TREELINE">
	    <xsl:with-param name="str_prefix">
	      <xsl:value-of select="$str_prefix"/>
	    </xsl:with-param>
            <xsl:with-param name="str_spaces">
              <xsl:value-of select="$str_spaces"/>
            </xsl:with-param>
	    <xsl:with-param name="flag_spacing" select="$flag_spacing"/>
	  </xsl:call-template>
	</xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="TIMESTRING">
    <xsl:if test="@hour">
      <xsl:value-of select="concat(@hour,'.',@minute)"/>
      <xsl:if test="@hour-end">
	<xsl:value-of select="concat('-',@hour-end,'.',@minute-end)"/>
      </xsl:if>
    <xsl:value-of select="concat('',' ')"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="FORMATPREFIX">
    <xsl:choose>
      <xsl:when test="name(parent::*) = 'list' or name(parent::*) = 'p' or name(parent::*) = 'task'">
        <!-- list item -->
        <xsl:choose>
          <xsl:when test="parent::list/attribute::enum = 'yes'">
            <!-- eumerated item -->
            <xsl:for-each select="ancestor::list">
              <xsl:text>+</xsl:text>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="parent::task">
            <!-- eumerated item -->
            <xsl:text>-</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <!-- list item -->
            <xsl:for-each select="ancestor::list">
              <xsl:text>-</xsl:text>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
