<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../PieHtml.xsl"/>
  <!-- -->
  <xsl:variable name="file_norm"></xsl:variable>
  <xsl:variable name="dir_icons" select="'../html/icons'"/>
  <xsl:variable name="flag_tips" select="true()"/>
  <!--  -->
  <xsl:variable name="file_css" select="'pie.css'"/>
  <xsl:variable name="file_cxp" select="''"/>
  <!--  -->
  <xsl:variable name="node_cols" select="/calendar/col[@id]"/>
  <xsl:variable name="id_cols" select="$node_cols/@id"/>
  <xsl:variable name="context" select="''"/>
  <!--  -->
  <xsl:variable name="nowYear" select="0"/>
  <xsl:variable name="nowMonth" select="0"/>
  <xsl:variable name="nowWeek" select="0"/>
  <xsl:variable name="nowDay" select="0"/>
  <!--  -->
  <xsl:variable name="year" select="0"/>
  <xsl:variable name="month" select="0"/>
  <xsl:variable name="week" select="0"/>
  <xsl:variable name="day" select="0"/>
  <!--  -->
  <xsl:output encoding="UTF-8" method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" media-type="text/html"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
        <xsl:call-template name="PIETAGCLOUD"/>
        <xsl:apply-templates select="calendar"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="calendar">
    <!--  -->
    <xsl:element name="table">
      <xsl:attribute name="class">
        <xsl:value-of select="name(.)"/>
      </xsl:attribute>
      <xsl:attribute name="border">
        <xsl:text>0</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="cellspacing">
        <xsl:text>1</xsl:text>
      </xsl:attribute>
      <xsl:element name="tbody">
        <xsl:element name="tr">
          <xsl:for-each select="$node_cols">
            <xsl:element name="th">
              <xsl:choose>
                <xsl:when test="@name">
                  <xsl:value-of select="@name"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@id"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
        <!--  -->
        <xsl:choose>
          <xsl:when test="$context='month'">
            <xsl:choose>
              <xsl:when test="$year = 0 or $month = 0">
		<xsl:apply-templates select="descendant::month"/>
              </xsl:when>
              <xsl:otherwise>
		<xsl:apply-templates select="year[@ad=$year]/month[@nr=$month]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$context='day'">
            <xsl:choose>
              <xsl:when test="$day = 0">
		<xsl:apply-templates select="descendant::day"/>
              </xsl:when>
              <xsl:otherwise>
		<xsl:apply-templates select="year[@ad=$year]/month[@nr=$month]/day[@om=$day]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <!-- no current date informations -->
            <xsl:choose>
              <xsl:when test="$year = 0">
		<xsl:apply-templates select="year"/>
              </xsl:when>
              <xsl:otherwise>
		<xsl:apply-templates select="year[@ad=$year]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="year">
    <xsl:if test="col or week[day|col] or month[day|col]">
      <xsl:element name="tr">
	<xsl:element name="th">
          <xsl:attribute name="colspan">
            <xsl:value-of select="count($id_cols)"/>
          </xsl:attribute>
          <xsl:element name="center">
            <xsl:value-of select="@ad"/>
          </xsl:element>
	</xsl:element>
      </xsl:element>
	  <!-- TODO: process year/col too -->
      <xsl:apply-templates select="month|week"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="month">
    <xsl:if test="col or day[col]">
      <xsl:element name="tr">
	<xsl:element name="th">
          <xsl:attribute name="colspan">
            <xsl:value-of select="count($id_cols)"/>
          </xsl:attribute>
          <!-- label -->
          <xsl:element name="a">
            <xsl:attribute name="id">
              <xsl:value-of select="concat('m',../@ad,@nr)"/>
            </xsl:attribute>
          </xsl:element>
          <xsl:element name="center">
            <xsl:value-of select="concat(@name,' / ',../@ad)"/>
          </xsl:element>
          <!-- next -->
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="concat('#m',parent::year/attribute::ad,following-sibling::month/attribute::nr)"/>
            </xsl:attribute>
            <xsl:text>next</xsl:text>
          </xsl:element>
	</xsl:element>
      </xsl:element>
      <!-- -->
      <xsl:choose>
	<xsl:when test="col[contains($id_cols,@idref) and child::node()]">
	  <xsl:element name="tr">
            <!-- -->
            <xsl:call-template name="LINE">
              <xsl:with-param name="pwd" select="self::node()"/>
            </xsl:call-template>
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="day"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template match="week">
    <xsl:if test="col or day[col]">
      <xsl:element name="tr">
	<xsl:element name="th">
          <xsl:attribute name="colspan">
            <xsl:value-of select="count($id_cols)"/>
          </xsl:attribute>
          <!-- label -->
          <xsl:element name="a">
            <xsl:attribute name="id">
              <xsl:value-of select="concat('w',../@ad,@nr)"/>
            </xsl:attribute>
          </xsl:element>
          <xsl:element name="center">
            <xsl:value-of select="concat(@nr,' / ',../@ad)"/>
          </xsl:element>
	</xsl:element>
      </xsl:element>
      <!-- -->
      <xsl:choose>
	<xsl:when test="col[contains($id_cols,@idref) and child::node()]">
	  <xsl:element name="tr">
            <!-- -->
            <xsl:call-template name="LINE">
              <xsl:with-param name="pwd" select="self::node()"/>
            </xsl:call-template>
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="day"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template match="day">
    <xsl:variable name="cw" select="@cw"/>
    <xsl:variable name="ow" select="number(@ow)"/>
    <xsl:if test="col[contains($id_cols,@idref) and child::node()]">
      <xsl:variable name="own" select="@own"/>
      <xsl:element name="tr">
        <!-- -->
        <xsl:call-template name="LINE">
          <xsl:with-param name="pwd" select="self::node()"/>
          <xsl:with-param name="class">
            <xsl:choose>
              <xsl:when test="descendant-or-self::*[@holiday = 'yes']">
                <xsl:text>sat</xsl:text>
              </xsl:when>
              <xsl:when test="@today">
                <xsl:text>today</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$own"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template match="hour">
    <xsl:variable name="nr" select="@nr"/>
    <xsl:element name="tr">
      <!-- -->
      <xsl:call-template name="LINE">
        <xsl:with-param name="pwd" select="self::node()"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>
  <xsl:template match="p|h">
    <xsl:choose>
      <xsl:when test="name(parent::node()) = 'list'">
        <!-- list item -->
        <xsl:element name="li">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="contains('todo,done,target,test,bug,req',@class)">
	<!-- task item -->
	<xsl:element name="span">
	  <xsl:attribute name="class">context-menu-task</xsl:attribute>
	  <xsl:attribute name="name">
	    <xsl:value-of select="concat(':',@xpath)"/>
	  </xsl:attribute>
	  <xsl:element name="p">
	    <xsl:call-template name="CLASSATRIBUTE"/>
	    <xsl:call-template name="ADDSTYLE"/>
	    <xsl:if test="@hstr">
	      <xsl:element name="i">
		<xsl:value-of select="@hstr"/>
	      </xsl:element>
	    </xsl:if>
	    <xsl:element name="span">
	      <xsl:attribute name="class">
		<xsl:text>htag</xsl:text>
	      </xsl:attribute>
	      <xsl:value-of select="concat(translate(@class,'todnreqabugs','TODNREQABUGS'),': ')"/>
	    </xsl:element>
	    <xsl:apply-templates/>
	  </xsl:element>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <!-- para -->
        <xsl:element name="p">
	  <xsl:call-template name="CLASSATRIBUTE"/>
	  <xsl:call-template name="ADDSTYLE"/>
	  <xsl:if test="@hstr">
	    <xsl:element name="i">
	      <xsl:value-of select="@hstr"/>
	    </xsl:element>
	  </xsl:if>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="LINE">
    <xsl:param name="pwd"/>
    <xsl:param name="class">summary</xsl:param>
    <xsl:for-each select="$id_cols">
      <xsl:variable name="id_col" select="."/>
      <xsl:element name="td">
        <xsl:if test="true()"> <!-- position() = 1 -->
          <xsl:attribute name="class">
            <!-- set class of cells -->
            <xsl:choose>
              <xsl:when test="$pwd/col[@idref=$id_col]/*[@free = 'yes']">
                <xsl:text>sat</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$class"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>
        <!-- yesterday anchor -->
        <xsl:if test="$pwd/@diff='-1' and position() = 1">
          <xsl:element name="a">
            <xsl:attribute name="id">
              <xsl:text>yesterday</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>
        <!-- today anchor -->
        <xsl:if test="$pwd/@today and position() = 1">
          <xsl:element name="a">
            <xsl:attribute name="id">
              <xsl:text>today</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>
        <xsl:apply-templates select="$pwd/col[@idref=$id_col]/*">
          <xsl:sort select="@hour"/>
          <xsl:sort select="@minute"/>
          <xsl:sort select="@hour-end"/>
          <xsl:sort select="@hstr"/>
          <xsl:sort select="."/>
          <!-- position() -->
        </xsl:apply-templates>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="meta">
    <xsl:if test="count(error/*) &gt; 0">
      <xsl:element name="h2">Calendar Errors</xsl:element>
      <xsl:apply-templates select="error/*"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="t"/>
</xsl:stylesheet>
