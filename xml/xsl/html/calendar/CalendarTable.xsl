<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!--   -->
  <xsl:import href="../PieHtmlTable.xsl"/>
  <!-- -->
  <xsl:variable name="flag_extended" select="false()"/>
  <!-- -->
  <xsl:variable name="file_norm"></xsl:variable>
  <xsl:variable name="flag_tips" select="true()"/>
  <!--  -->
  <xsl:variable name="file_css" select="''"/>
  <!--  -->
  <xsl:variable name="node_cols" select="/calendar/col[@id]"/>
  <xsl:variable name="id_cols" select="/calendar/col/@id"/>
  <xsl:variable name="context" select="''"/>
  <!--  -->
  <xsl:variable name="str_tag"></xsl:variable>
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
  <xsl:variable name="flag_days" select="descendant::day"/>

  <xsl:output encoding="UTF-8" method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" media-type="text/html"/>

  <xsl:template match="/">
    <xsl:element name="html">

      <xsl:element name="body">
	<xsl:comment>
	  <xsl:value-of select="concat(' $flag_extended: ',$flag_extended)"/>
	  <xsl:value-of select="concat(' $id_cols: ',$id_cols)"/>
	  <xsl:value-of select="concat(' $context: ',$context)"/>
	  <xsl:value-of select="concat(' $year: ',$year)"/>
	  <xsl:value-of select="concat(' $month: ',$month)"/>
	  <xsl:value-of select="concat(' $week: ',$week)"/>
	  <xsl:value-of select="concat(' $day: ',$day)"/>
	</xsl:comment>
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
        <xsl:choose>
          <xsl:when test="$node_cols">
            <xsl:element name="tr">
	      <xsl:element name="th">
	      </xsl:element>
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
	  </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
	</xsl:choose>
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
          <xsl:when test="$context='week'">
            <xsl:choose>
              <xsl:when test="$year = 0 or $week = 0">
		<xsl:apply-templates select="descendant::week"/>
              </xsl:when>
              <xsl:otherwise>
		<xsl:apply-templates select="year[@ad=$year]/week[@nr=$week]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$context='day'">
            <xsl:choose>
              <xsl:when test="$year = 0 or $day = 0">
		<xsl:apply-templates select="descendant::day"/>
              </xsl:when>
              <xsl:otherwise>
		<xsl:apply-templates select="year[@ad=$year]/descendant::day[@oy=$day]"/>
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
    <xsl:comment>
      <xsl:value-of select="name()"/>
    </xsl:comment>
    <!-- header line -->
    <xsl:element name="tr">
      <xsl:element name="th">
        <xsl:attribute name="colspan">
          <xsl:value-of select="count($id_cols) + 1"/>
        </xsl:attribute>
        <xsl:value-of select="@ad"/>
      </xsl:element>
    </xsl:element>
    <!-- child lines -->
    <xsl:choose>
      <xsl:when test="day|month|week">
	<xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="node_year" select="."/>
	<xsl:element name="tr">
	  <xsl:for-each select="$id_cols">
	    <xsl:variable name="id_col" select="."/>
	    <xsl:element name="td">
    	      <xsl:for-each select="$node_year/col[@idref=$id_col]">
		<xsl:apply-templates>
		  <xsl:sort select="date[1]/@hour" data-type="number"/>
		  <xsl:sort select="date[1]/@minute" data-type="number"/>
		  <xsl:sort select="date[1]/@second" data-type="number"/>
		  <xsl:sort select="@hstr"/>
		  <xsl:sort select="."/>
		</xsl:apply-templates>
	      </xsl:for-each>
	    </xsl:element>
	  </xsl:for-each>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="month">
    <xsl:comment>
      <xsl:value-of select="name()"/>
    </xsl:comment>
    <!-- header line -->
    <xsl:element name="tr">
      <xsl:element name="th">
        <xsl:attribute name="colspan">
          <xsl:value-of select="count($id_cols) + 1"/>
        </xsl:attribute>
        <xsl:value-of select="concat(@name,' / ',../@ad)"/>
      </xsl:element>
    </xsl:element>
    <!-- child lines -->
    <xsl:choose>
      <xsl:when test="$flag_days">
	<xsl:apply-templates select="day"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="node_month" select="."/>
	<xsl:element name="tr">
	  <xsl:for-each select="$id_cols">
	    <xsl:variable name="id_col" select="."/>
	    <xsl:element name="td">
    	      <xsl:for-each select="$node_month/col[@idref=$id_col]">
		<xsl:apply-templates>
		  <xsl:sort select="date[1]/@hour" data-type="number"/>
		  <xsl:sort select="date[1]/@minute" data-type="number"/>
		  <xsl:sort select="date[1]/@second" data-type="number"/>
		  <xsl:sort select="@hstr"/>
		  <xsl:sort select="."/>
		</xsl:apply-templates>
	      </xsl:for-each>
	    </xsl:element>
	  </xsl:for-each>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>   
  </xsl:template>
  
  <xsl:template match="week">
    <xsl:comment>
      <xsl:value-of select="name()"/>
    </xsl:comment>
    <!-- header line -->
    <xsl:element name="tr">
      <xsl:element name="th">
        <xsl:attribute name="colspan">
          <xsl:value-of select="count($id_cols)"/>
        </xsl:attribute>
        <xsl:value-of select="concat('Week ',@nr,' / ',../@ad)"/>
      </xsl:element>
    </xsl:element>
    <!-- child lines -->
    <xsl:choose>
      <xsl:when test="$flag_days">
	<xsl:apply-templates select="day"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="node_week" select="."/>
	<xsl:element name="tr">
	  <xsl:for-each select="$id_cols">
	    <xsl:variable name="id_col" select="."/>
	    <xsl:element name="td">
    	      <xsl:for-each select="$node_week/col[@idref=$id_col]">
		<xsl:apply-templates>
		  <xsl:sort select="date[1]/@hour" data-type="number"/>
		  <xsl:sort select="date[1]/@minute" data-type="number"/>
		  <xsl:sort select="date[1]/@second" data-type="number"/>
		  <xsl:sort select="@hstr"/>
		  <xsl:sort select="."/>
		</xsl:apply-templates>
	      </xsl:for-each>
	    </xsl:element>
	  </xsl:for-each>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="day">
    <xsl:variable name="pwd" select="self::node()"/>
    <xsl:comment>
      <xsl:value-of select="name()"/>
    </xsl:comment>
    <xsl:if test="$flag_extended or child::col">
      <xsl:element name="tr">
	<xsl:choose>
	  <xsl:when test="$pwd/@diffy = '-1'">
	    <!-- yesterday anchor -->
	    <xsl:attribute name="id">
	      <xsl:text>yesterday</xsl:text>
	    </xsl:attribute>
	  </xsl:when>
	  <xsl:when test="$pwd/@today">
	    <!-- today anchor -->
	    <xsl:attribute name="id">
	      <xsl:text>today</xsl:text>
	    </xsl:attribute>
	  </xsl:when>
	  <xsl:otherwise>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:attribute name="class">
          <xsl:choose>
	    <xsl:when test="descendant-or-self::*[@holiday = 'yes']">
              <xsl:text>sat</xsl:text>
	    </xsl:when>
	    <xsl:when test="@today">
              <xsl:text>today</xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
              <xsl:value-of select="@own"/>
	    </xsl:otherwise>
          </xsl:choose>
	</xsl:attribute>
	<xsl:choose>
	  <xsl:when test="$id_cols">
	    <xsl:element name="td">
	      <xsl:value-of select="concat(../../@ad,'-',../@nr,'-',@om)"/>
	      <xsl:element name="br"/>
	      <xsl:value-of select="concat(../../@ad,'-W',@cw,'-',@ow)"/>
	      <xsl:element name="br"/>
	      <xsl:value-of select="concat(../../@ad,'-',@oy)"/>
	      <xsl:element name="br"/>
	      <xsl:value-of select="concat(@own,'')"/>
	    </xsl:element>
	    <xsl:for-each select="$id_cols">
	      <xsl:variable name="id_col" select="."/>
	      <xsl:element name="td">
		<xsl:for-each select="$pwd/col[@idref=$id_col]">
		  <xsl:apply-templates>
		    <xsl:sort select="date[1]/@hour" data-type="number"/>
		    <xsl:sort select="date[1]/@minute" data-type="number"/>
		    <xsl:sort select="date[1]/@second" data-type="number"/>
		    <xsl:sort select="@hstr"/>
		    <xsl:sort select="."/>
		  </xsl:apply-templates>
		</xsl:for-each>
	      </xsl:element>
	    </xsl:for-each>
	  </xsl:when>
          <xsl:otherwise>		<!-- empty day -->
	    <xsl:element name="td">
              <xsl:value-of select="concat(../../@ad,'-',../@nr,'-',@om,' ',@own)"/>
	    </xsl:element>
          </xsl:otherwise>
	</xsl:choose>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="t|img|fig|pre"/>

</xsl:stylesheet>
