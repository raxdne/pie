<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cxp="http://www.tenbusch.info/cxproc" version="1.0">
  <xsl:import href="../../Utils.xsl"/>
  <xsl:import href="../PieHtml.xsl"/>

  <!-- -->
  <xsl:variable name="file_norm"></xsl:variable>
  <xsl:variable name="dir_icons" select="'../html/icons'"/>
  <!--  -->
  <xsl:variable name="flag_tips" select="true()"/>
  <!--  -->
  <xsl:variable name="file_css" select="'pie.css'"/>
  <!--  -->
  <xsl:variable name="file_cxp" select="''"/>
  <!--  -->
  <xsl:variable name="node_cols" select="/calendar/meta/cxp:calendar/cxp:col[@id]"/>
  <xsl:variable name="id_cols" select="$node_cols/@id"/>
  <xsl:variable name="context" select="'Day'"/>
  <!--  -->
  <xsl:variable name="nowYear" select="0"/>
  <xsl:variable name="nowMonth" select="0"/>
  <xsl:variable name="nowWeek" select="0"/>
  <xsl:variable name="nowDay" select="0"/>
  <!--  -->
  <xsl:variable name="listDays" select="''"/>
  
  <xsl:output encoding="UTF-8" method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" media-type="text/html"/>

  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
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
          <xsl:when test="$nowYear=0">
            <!-- no current date informations -->
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:when test="$context='Year'">
            <xsl:apply-templates select="year[@ad=$nowYear]"/>
          </xsl:when>
          <xsl:when test="$context='Day'">
            <xsl:apply-templates select="year[@ad=$nowYear]//day[@oy=$nowDay]"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- default context is 'Month' -->
            <xsl:apply-templates select="year[@ad=$nowYear]/month[@nr=$nowMonth]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="year">
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
    <xsl:apply-templates select="month|week"/>
    <!-- -->
    <xsl:if test="not(contains($listDays,'y')) and child::col/child::node()">
      <xsl:element name="tr">
        <!--
      <xsl:element name="td">
        <xsl:value-of select="@ad"/>        
      </xsl:element>
      -->
        <xsl:call-template name="LINE">
          <xsl:with-param name="pwd" select="self::node()"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="month">
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
    <xsl:apply-templates select="day"/>
    <!-- -->
    <xsl:if test="not(contains($listDays,'m')) and child::col/child::node()">
      <xsl:element name="tr">
        <!--
      <xsl:element name="td">
        <xsl:value-of select="@name"/>        
      </xsl:element>
      -->
        <xsl:call-template name="LINE">
          <xsl:with-param name="pwd" select="self::node()"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="week">
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
        <!-- next -->
        <xsl:element name="a">
          <xsl:value-of select="concat('#w',parent::year/attribute::ad,following-sibling::month/attribute::nr)"/>
          <xsl:text>next</xsl:text>
        </xsl:element>
      </xsl:element>
    </xsl:element>
    <!-- -->
    <xsl:apply-templates select="day"/>
    <!-- -->
    <xsl:if test="not(contains($listDays,'m')) and child::col/child::node()">
      <xsl:element name="tr">
        <!--
      <xsl:element name="td">
        <xsl:value-of select="@name"/>        
      </xsl:element>
      -->
        <xsl:call-template name="LINE">
          <xsl:with-param name="pwd" select="self::node()"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="day">
    <xsl:variable name="cw" select="@cw"/>
    <xsl:variable name="ow" select="number(@ow)"/>
    <xsl:if test="not(contains($listDays,@ow)) and (col[contains($id_cols,@name) and child::node()] or @today)">
      <xsl:variable name="own" select="@own"/>
      <xsl:element name="tr">
        <!-- -->
        <xsl:call-template name="LINE">
          <xsl:with-param name="pwd" select="self::node()"/>
          <xsl:with-param name="class">
            <xsl:choose>
              <xsl:when test="descendant::*[@holiday = 'yes']">
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
    <!-- week related entries -->
    <xsl:if test="not(contains($listDays,'w'))">
      <xsl:variable name="pwd_week" select="../../week[@nr = $cw]"/>
      <xsl:if test="$ow = 5 and $pwd_week/col">
        <xsl:element name="tr">
          <xsl:call-template name="LINE">
            <xsl:with-param name="pwd" select="$pwd_week"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="p">
    <xsl:choose>
      <xsl:when test="name(parent::node()) = 'list'">
        <!-- list item -->
        <xsl:element name="li">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="@hstr">
        <!-- par with hstr -->
        <xsl:element name="p">
          <xsl:copy-of select="@class"/>
          <xsl:call-template name="TIMESTRING"/>
          <xsl:element name="i">
            <xsl:value-of select="@hstr"/>
          </xsl:element>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <!-- para -->
        <xsl:element name="p">
          <xsl:copy-of select="@class"/>
          <xsl:call-template name="TIMESTRING"/>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="task">
    <xsl:call-template name="TASK">
      <xsl:with-param name="flag_ancestor" select="true()"/>
      <xsl:with-param name="flag_line" select="true()"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="section">
    <xsl:element name="p">
      <xsl:attribute name="class">project</xsl:attribute>
      <xsl:choose>
        <xsl:when test="@begin">
          <xsl:text>&#x25BC;</xsl:text>
        </xsl:when>
        <xsl:when test="@end">
          <xsl:text>&#x25B2;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="concat(@hstr,h)"/>
    </xsl:element>
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

  <xsl:template name="NAVI">
    <xsl:variable name="nextDay">
      <!-- day value for next button -->
      <xsl:choose>
        <xsl:when test="$context='Day' and $nowDay &gt; 364">
          <xsl:value-of select="1"/>
        </xsl:when>
        <xsl:when test="$context='Day'">
          <xsl:value-of select="$nowDay+1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nowDay"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="nextWeek">
      <!-- week value for next button -->
      <xsl:choose>
        <xsl:when test="$context='Week' and $nowWeek &gt; 50">
          <xsl:value-of select="1"/>
        </xsl:when>
        <xsl:when test="$context='Week'">
          <xsl:value-of select="$nowWeek+1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nowWeek"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="nextMonth">
      <!-- month value for next button -->
      <xsl:choose>
        <xsl:when test="$context='Month' and $nowMonth &gt; 11">
          <xsl:value-of select="1"/>
        </xsl:when>
        <xsl:when test="$context='Month'">
          <xsl:value-of select="$nowMonth+1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nowMonth"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="nextYear">
      <!-- year value for next button -->
      <xsl:choose>
        <xsl:when test="$context='Year' or ($context='Month' and $nowMonth &gt; 11)">
          <xsl:value-of select="$nowYear+1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nowYear"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="prevDay">
      <!-- day value for prev button -->
      <xsl:choose>
        <xsl:when test="$context='Day' and $nowDay &lt; 2">
          <xsl:value-of select="1"/>
        </xsl:when>
        <xsl:when test="$context='Day'">
          <xsl:value-of select="$nowDay - 1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nowDay"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="prevWeek">
      <!-- week value for prev button -->
      <xsl:choose>
        <xsl:when test="$context='Week' and $nowWeek &lt; 2">
          <xsl:value-of select="1"/>
        </xsl:when>
        <xsl:when test="$context='Week'">
          <xsl:value-of select="$nowWeek - 1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nowWeek"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="prevMonth">
      <!-- month value for prev button -->
      <xsl:choose>
        <xsl:when test="$context='Month' and $nowMonth &lt; 2">
          <xsl:value-of select="12"/>
        </xsl:when>
        <xsl:when test="$context='Month'">
          <xsl:value-of select="$nowMonth - 1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nowMonth"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="prevYear">
      <!-- year value for prev button -->
      <xsl:choose>
        <xsl:when test="$context='Year' or ($context='Month' and $nowMonth &lt; 2)">
          <xsl:value-of select="$nowYear - 1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nowYear"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="table">
      <xsl:attribute name="class">formicons</xsl:attribute>
      <xsl:element name="tr">
        <xsl:call-template name="FORMICON">
          <xsl:with-param name="icon">
            <xsl:text>go-previous.png</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="text">
            <xsl:value-of select="concat('Previous ',$context)"/>
          </xsl:with-param>
          <xsl:with-param name="file">
            <xsl:value-of select="$file_cxp"/>
          </xsl:with-param>
          <xsl:with-param name="context">
            <xsl:value-of select="$context"/>
          </xsl:with-param>
          <xsl:with-param name="year">
            <xsl:value-of select="$prevYear"/>
          </xsl:with-param>
          <xsl:with-param name="m">
            <xsl:value-of select="$prevMonth"/>
          </xsl:with-param>
          <xsl:with-param name="d">
            <xsl:value-of select="$prevDay"/>
          </xsl:with-param>
          <xsl:with-param name="w">
            <xsl:value-of select="$prevWeek"/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="SEPICONS"/>
        <xsl:call-template name="FORMICON">
          <xsl:with-param name="text">
            <xsl:text>Day</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="file">
            <xsl:value-of select="$file_cxp"/>
          </xsl:with-param>
          <xsl:with-param name="context">
            <xsl:text>Day</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="year">
            <xsl:value-of select="$nowYear"/>
          </xsl:with-param>
          <xsl:with-param name="m">
            <xsl:value-of select="$nowMonth"/>
          </xsl:with-param>
          <xsl:with-param name="d">
            <xsl:value-of select="$nowDay"/>
          </xsl:with-param>
          <xsl:with-param name="w">
            <xsl:value-of select="$nowWeek"/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="FORMICON">
          <xsl:with-param name="text">
            <xsl:text>Month</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="file">
            <xsl:value-of select="$file_cxp"/>
          </xsl:with-param>
          <xsl:with-param name="context">
            <xsl:text>Month</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="year">
            <xsl:value-of select="$nowYear"/>
          </xsl:with-param>
          <xsl:with-param name="m">
            <xsl:value-of select="$nowMonth"/>
          </xsl:with-param>
          <xsl:with-param name="d">
            <xsl:value-of select="$nowDay"/>
          </xsl:with-param>
          <xsl:with-param name="w">
            <xsl:value-of select="$nowWeek"/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="FORMICON">
          <xsl:with-param name="text">
            <xsl:text>Year</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="file">
            <xsl:value-of select="$file_cxp"/>
          </xsl:with-param>
          <xsl:with-param name="context">
            <xsl:text>Year</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="year">
            <xsl:value-of select="$nowYear"/>
          </xsl:with-param>
          <xsl:with-param name="m">
            <xsl:value-of select="$nowMonth"/>
          </xsl:with-param>
          <xsl:with-param name="d">
            <xsl:value-of select="$nowDay"/>
          </xsl:with-param>
          <xsl:with-param name="w">
            <xsl:value-of select="$nowWeek"/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="SEPICONS"/>
        <xsl:call-template name="FORMICON">
          <xsl:with-param name="icon">
            <xsl:text>go-next.png</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="text">
            <xsl:value-of select="concat('Next ',$context)"/>
          </xsl:with-param>
          <xsl:with-param name="file">
            <xsl:value-of select="$file_cxp"/>
          </xsl:with-param>
          <xsl:with-param name="context">
            <xsl:value-of select="$context"/>
          </xsl:with-param>
          <xsl:with-param name="year">
            <xsl:value-of select="$nextYear"/>
          </xsl:with-param>
          <xsl:with-param name="m">
            <xsl:value-of select="$nextMonth"/>
          </xsl:with-param>
          <xsl:with-param name="d">
            <xsl:value-of select="$nextDay"/>
          </xsl:with-param>
          <xsl:with-param name="w">
            <xsl:value-of select="$nextWeek"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="FORMFILTER">
    <xsl:element name="table">
      <xsl:element name="tr">
        <xsl:element name="td">
          <xsl:element name="form">
            <xsl:element name="input">
              <xsl:attribute name="type">hidden</xsl:attribute>
              <xsl:attribute name="name">year</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="$nowYear"/>
              </xsl:attribute>
            </xsl:element>
            <xsl:element name="input">
              <xsl:attribute name="type">hidden</xsl:attribute>
              <xsl:attribute name="name">m</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="$nowMonth"/>
              </xsl:attribute>
            </xsl:element>
            <xsl:element name="input">
              <xsl:attribute name="type">hidden</xsl:attribute>
              <xsl:attribute name="name">d</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="$nowDay"/>
              </xsl:attribute>
            </xsl:element>
            <xsl:element name="input">
              <xsl:attribute name="type">hidden</xsl:attribute>
              <xsl:attribute name="name">w</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="$nowWeek"/>
              </xsl:attribute>
            </xsl:element>
            <xsl:element name="input"><xsl:attribute name="type">hidden</xsl:attribute><xsl:attribute name="name">cxp</xsl:attribute><xsl:attribute name="value">cxp</xsl:attribute></xsl:element><xsl:element name="input"><xsl:attribute name="type">hidden</xsl:attribute><xsl:attribute name="name">path</xsl:attribute><xsl:attribute name="value"><xsl:value-of select="$file_cxp"/></xsl:attribute></xsl:element><xsl:element name="input"><xsl:attribute name="type">hidden</xsl:attribute><xsl:attribute name="name">context</xsl:attribute><xsl:attribute name="value"><xsl:value-of select="$context"/></xsl:attribute></xsl:element><xsl:element name="input"><xsl:attribute name="type">submit</xsl:attribute><xsl:attribute name="value">Remove</xsl:attribute><xsl:attribute name="alt">Filter</xsl:attribute></xsl:element><xsl:element name="input"><xsl:attribute name="type">checkbox</xsl:attribute><xsl:attribute name="name">mon</xsl:attribute><xsl:attribute name="value">1</xsl:attribute><xsl:if test="contains($listDays,'1')"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></xsl:element>mon
            <xsl:element name="input"><xsl:attribute name="type">checkbox</xsl:attribute><xsl:attribute name="name">tue</xsl:attribute><xsl:attribute name="value">2</xsl:attribute><xsl:if test="contains($listDays,'2')"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></xsl:element>tue
            <xsl:element name="input"><xsl:attribute name="type">checkbox</xsl:attribute><xsl:attribute name="name">wed</xsl:attribute><xsl:attribute name="value">3</xsl:attribute><xsl:if test="contains($listDays,'3')"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></xsl:element>wed
            <xsl:element name="input"><xsl:attribute name="type">checkbox</xsl:attribute><xsl:attribute name="name">thu</xsl:attribute><xsl:attribute name="value">4</xsl:attribute><xsl:if test="contains($listDays,'4')"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></xsl:element>thu
            <xsl:element name="input"><xsl:attribute name="type">checkbox</xsl:attribute><xsl:attribute name="name">fri</xsl:attribute><xsl:attribute name="value">5</xsl:attribute><xsl:if test="contains($listDays,'5')"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></xsl:element>fri
            <xsl:element name="input"><xsl:attribute name="type">checkbox</xsl:attribute><xsl:attribute name="name">sat</xsl:attribute><xsl:attribute name="value">6</xsl:attribute><xsl:if test="contains($listDays,'6')"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></xsl:element>sat
            <xsl:element name="input"><xsl:attribute name="type">checkbox</xsl:attribute><xsl:attribute name="name">sun</xsl:attribute><xsl:attribute name="value">0</xsl:attribute><xsl:if test="contains($listDays,'0')"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></xsl:element>sun
            <xsl:element name="input"><xsl:attribute name="type">checkbox</xsl:attribute><xsl:attribute name="name">rmweek</xsl:attribute><xsl:attribute name="value">w</xsl:attribute><xsl:if test="contains($listDays,'w')"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></xsl:element>week
            <xsl:element name="input"><xsl:attribute name="type">checkbox</xsl:attribute><xsl:attribute name="name">rmmonth</xsl:attribute><xsl:attribute name="value">m</xsl:attribute><xsl:if test="contains($listDays,'m')"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></xsl:element>month
            <xsl:element name="input"><xsl:attribute name="type">checkbox</xsl:attribute><xsl:attribute name="name">rmyear</xsl:attribute><xsl:attribute name="value">y</xsl:attribute><xsl:if test="contains($listDays,'y')"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></xsl:element>year
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="FORMICON">
    <xsl:param name="anchor"/>
    <xsl:param name="icon"/>
    <xsl:param name="text"/>
    <xsl:param name="file"/>
    <xsl:param name="context"/>
    <xsl:param name="year"/>
    <xsl:param name="m"/>
    <xsl:param name="d"/>
    <xsl:param name="w"/>
    <xsl:element name="td">
      <!-- form button -->
      <xsl:attribute name="class">formicon</xsl:attribute>
      <xsl:element name="form">
        <xsl:attribute name="action">
          <xsl:choose>
            <xsl:when test="$anchor=''">
              <xsl:value-of select="concat('#','today')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('#',$anchor)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:element name="input">
          <xsl:choose>
            <xsl:when test="$icon=''">
              <xsl:attribute name="type">submit</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="$text"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="type">image</xsl:attribute>
              <xsl:attribute name="src">
                <xsl:value-of select="concat('/pie/icons/',$icon)"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:attribute name="alt">
            <xsl:value-of select="$text"/>
          </xsl:attribute>
          <xsl:if test="$flag_tips">
            <xsl:attribute name="title">
              <xsl:value-of select="$text"/>
            </xsl:attribute>
          </xsl:if>
        </xsl:element>
        <!-- hidden form input -->
        <xsl:element name="input">
          <xsl:attribute name="type">hidden</xsl:attribute>
          <xsl:attribute name="name">cxp</xsl:attribute>
          <xsl:attribute name="value">cxp</xsl:attribute>
        </xsl:element>
        <xsl:element name="input">
          <xsl:attribute name="type">hidden</xsl:attribute>
          <xsl:attribute name="name">path</xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$file"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:element name="input">
          <xsl:attribute name="type">hidden</xsl:attribute>
          <xsl:attribute name="name">context</xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$context"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:element name="input">
          <xsl:attribute name="type">hidden</xsl:attribute>
          <xsl:attribute name="name">year</xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$year"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:element name="input">
          <xsl:attribute name="type">hidden</xsl:attribute>
          <xsl:attribute name="name">m</xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$m"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:element name="input">
          <xsl:attribute name="type">hidden</xsl:attribute>
          <xsl:attribute name="name">d</xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$d"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:element name="input">
          <xsl:attribute name="type">hidden</xsl:attribute>
          <xsl:attribute name="name">w</xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$w"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="SEPICONS">
    <xsl:element name="td">
      <xsl:attribute name="class">
        <xsl:text>separator</xsl:text>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="meta">
    <xsl:if test="count(error/*) &gt; 0">
      <xsl:element name="h2">Calendar Errors</xsl:element>
      <xsl:apply-templates select="error/*"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="col"/>
  
</xsl:stylesheet>
