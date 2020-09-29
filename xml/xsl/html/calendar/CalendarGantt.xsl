<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- Gantt table format of a calendar -->
  <xsl:import href="../../Utils.xsl"/>
  <xsl:import href="../PieHtml.xsl"/>
  <xsl:variable name="file_css" select="'pie.css'"/>
  <xsl:variable name="str_year" select="''"/>
  <xsl:variable name="flag_cluster" select="count(/descendant::section[attribute::cluster]) &gt; 0"/>
  <xsl:output encoding="UTF-8" method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" media-type="text/html"/>
  <xsl:key name="listprojects" match="section[@pid and (not(@state) or @state &lt; 2) and not(@state='-')]" use="@pid"/><!-- and @assignee='Muller' -->
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="calendar">
    <xsl:choose>
      <xsl:when test="$str_year = ''">
        <xsl:apply-templates select="year[descendant::*[@pidref]]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="year[@ad = $str_year and descendant::*[@pidref]]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="year">
    <xsl:variable name="node_year" select="self::node()"/>
    <xsl:element name="table">
      <xsl:attribute name="id">ganttTable</xsl:attribute>
      <xsl:attribute name="class">tablesorter</xsl:attribute>
      <!-- TODO: handle multiple tables -->
      <xsl:element name="thead">
        <xsl:element name="tr">
          <xsl:element name="th">
            <xsl:value-of select="''"/>
          </xsl:element>
          <xsl:element name="th">
            <xsl:value-of select="@ad"/>
          </xsl:element>
          <xsl:element name="th">
            <xsl:value-of select="'Project'"/>
          </xsl:element>
          <xsl:element name="th">
            <xsl:value-of select="'assignee'"/>
          </xsl:element>
          <xsl:if test="$flag_cluster">
            <xsl:element name="th">
              <xsl:value-of select="'cluster'"/>
            </xsl:element>
          </xsl:if>
          <xsl:element name="th">
            <xsl:value-of select="'state'"/>
          </xsl:element>
          <xsl:for-each select="month|week">
            <xsl:element name="th">
              <xsl:if test="@today = 'yes'">
		<xsl:attribute name="class">today</xsl:attribute>
              </xsl:if>
                <xsl:value-of select="@nr"/>
              </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
      <xsl:element name="tbody">
        <xsl:for-each select="/descendant::section[generate-id(.) = generate-id(key('listprojects',@pid))]">
          <xsl:variable name="str_class">
            <xsl:choose>
              <xsl:when test="@class">
                <xsl:value-of select="@class"/>
              </xsl:when>
              <xsl:when test="@impact">
                <xsl:value-of select="'gantt-high'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'gantt'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:call-template name="PROJECT">
            <xsl:with-param name="str_pid" select="@pid"/>
            <xsl:with-param name="str_class" select="$str_class"/>
            <xsl:with-param name="node_year" select="$node_year"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="PROJECT">
    <xsl:param name="node_year"/>
    <xsl:param name="str_class"/>
    <xsl:param name="str_pid"/>
    <xsl:variable name="int_pos">
      <xsl:value-of select="position()"/>
    </xsl:variable>
    <xsl:for-each select="/descendant::section[@pid = $str_pid]">
      <!-- context switch !!! -->
      <xsl:element name="tr">
	<xsl:element name="td">
          <xsl:attribute name="align">right</xsl:attribute>
          <xsl:value-of select="concat($int_pos,'.')"/>
	</xsl:element>
	<xsl:element name="td">
          <xsl:attribute name="class">
            <xsl:value-of select="$str_class"/>
          </xsl:attribute>
          <xsl:value-of select="$str_pid"/>
	</xsl:element>
	<xsl:element name="td">
	  <xsl:element name="span">
            <xsl:call-template name="MENUSET"/>
            <xsl:value-of select="h"/>
          </xsl:element>
	</xsl:element>
	<xsl:element name="td">
          <xsl:value-of select="ancestor-or-self::section[attribute::assignee]/attribute::assignee"/>
	</xsl:element>
	<xsl:if test="$flag_cluster">
          <xsl:element name="td">
            <xsl:value-of select="attribute::cluster"/>
          </xsl:element>
	</xsl:if>
	<xsl:element name="td">
          <xsl:value-of select="attribute::state"/>
	</xsl:element>
	<xsl:for-each select="$node_year/week|$node_year/month">
	  <!-- context switch !!! -->
          <xsl:element name="td">
            <xsl:if test="@today = 'yes'">
	      <xsl:attribute name="class">today</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="descendant::section[@pidref = $str_pid and @begin]">
		<xsl:attribute name="class">
                  <xsl:value-of select="$str_class"/>
		</xsl:attribute>
		<xsl:value-of select="'&#x25BA;'"/>
              </xsl:when>
              <xsl:when test="descendant::section[@pidref = $str_pid and @end]">
		<xsl:attribute name="class">
                  <xsl:value-of select="$str_class"/>
		</xsl:attribute>
		<xsl:value-of select="'&#x25C4;'"/>
              </xsl:when>
              <xsl:when test="descendant::*[@pidref = $str_pid]">
		<xsl:attribute name="class">
                  <xsl:value-of select="$str_class"/>
		</xsl:attribute>
		<xsl:value-of select="'&#x25C7;'"/>
              </xsl:when>
              <xsl:when test="(preceding::week[descendant::*[@pidref = $str_pid and @begin]] and following::week[descendant::*[@pidref = $str_pid and @end]]) or (preceding::month[descendant::*[@pidref = $str_pid and @begin]] and following::month[descendant::*[@pidref = $str_pid and @end]])">
		<xsl:attribute name="class">
                  <xsl:value-of select="$str_class"/>
		</xsl:attribute>
		<xsl:text>&#xB7;</xsl:text>
              </xsl:when>
              <xsl:otherwise>
		<xsl:text> </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
	</xsl:for-each>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="*"/>
</xsl:stylesheet>
