<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="../PieHtmlTable.xsl"/>
  <!-- -->
  <xsl:variable name="file_norm"></xsl:variable>
  <!--  -->
  <xsl:variable name="file_css" select="''"/>
  <!--  -->
  <xsl:variable name="level_hidden" select="0"/>

  <xsl:output method="html"/>

  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
        <xsl:call-template name="PIETAGCLOUD"/>
        <xsl:element name="table">
          <xsl:attribute name="border">
            <xsl:text>0</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="cellspacing">
            <xsl:text>1</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="width">
            <xsl:text>100%</xsl:text>
          </xsl:attribute>
          <xsl:element name="tbody">
            <xsl:element name="tr">
              <xsl:element name="th">
                <xsl:element name="b">
                  <xsl:text>TODO</xsl:text>
                </xsl:element>
              </xsl:element>
            </xsl:element>
	    <xsl:apply-templates />
	    <!--
            <xsl:element name="tr">
              <xsl:element name="th">
		<xsl:attribute name="style">text-align: right;</xsl:attribute>
		<xsl:value-of select="concat(count(descendant::task[not(ancestor-or-self::*/@done) and not(ancestor-or-self::*/@valid = 'no')]),' Tasks')"/>
              </xsl:element>
              </xsl:element>
	      -->
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="pie|block">
    <xsl:comment>
      <xsl:value-of select="concat(name(),' ')"/>
    </xsl:comment>
    <xsl:apply-templates select="child::node()"/>
  </xsl:template>
  
  <xsl:template match="list|p">
    <xsl:comment>
      <xsl:value-of select="concat(name(),' ')"/>
    </xsl:comment>
    <xsl:apply-templates select="descendant::task"/>
  </xsl:template>

  <xsl:template match="task">
    <xsl:comment>
      <xsl:value-of select="concat(name(),' ')"/>
    </xsl:comment>
    <xsl:choose>
      <xsl:when test="@done or @state = 'done' or @state = 'rejected' or @class = 'done'">
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="tr">
	  <xsl:element name="td">
	    <xsl:call-template name="TASK"/>
	  </xsl:element>
	</xsl:element>
	<xsl:apply-templates select="descendant::task"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="section">
    <xsl:comment>
      <xsl:value-of select="concat(name(),'')"/>
    </xsl:comment>
    <xsl:choose>
      <xsl:when test="child::p/descendant::task[not(@done or @state = 'done' or @state = 'rejected' or @class = 'done')]|child::task[not(@done or @state = 'done' or @state = 'rejected' or @class = 'done')]">
	<!-- separate header row -->
	<xsl:element name="tr">
	  <xsl:element name="th">
	    <xsl:element name="span">
	      <!-- <xsl:call-template name="MENUSET"/> -->
              <xsl:for-each select="ancestor-or-self::section">
		<xsl:if test="position() &gt; 1">
		  <xsl:text> :: </xsl:text>
		</xsl:if>
		<xsl:apply-templates select="h"/>
	      </xsl:for-each>
	    </xsl:element>
	  </xsl:element>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="pie|block|section|list|task|p"/>
  </xsl:template>
  
  <xsl:template match="meta|table|fig|t"/>
  
</xsl:stylesheet>
