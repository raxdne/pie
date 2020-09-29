<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../PieHtml.xsl"/>
  <xsl:variable name="file_css" select="'pie.css'"/>
  <!-- name of plain input file -->
  <xsl:variable name="file_plain" select="''"/>
  <xsl:variable name="file_ref" select="'TodoContactTable.html'"/>
  <!--  -->
  <xsl:variable name="level_hidden" select="0"/>
  <!--  -->
  <xsl:variable name="flag_form" select="true()"/>
  <!--  -->
  <xsl:variable name="str_write" select="''"/>
  <xsl:output method="html"/>
  <xsl:include href="../../Utils.xsl"/>
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
	    <xsl:apply-templates select="pie|block|section"/>
            <xsl:element name="tr">
              <xsl:element name="th">
		<xsl:attribute name="style">text-align: right;</xsl:attribute>
		<xsl:value-of select="concat(count(descendant::task[not(ancestor-or-self::*/@done) and not(ancestor-or-self::*/@valid = 'no')]),' Tasks')"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="pie|block|section">
    <xsl:if test="child::task|child::list/descendant::task">
      <xsl:if test="child::h">
	<!-- separate header row -->
	<xsl:element name="tr">
	  <xsl:element name="th">
            <xsl:if test="count(ancestor-or-self::section) &lt; 2">
              <xsl:attribute name="class">transition</xsl:attribute>
            </xsl:if>
	    <xsl:element name="span">
	      <xsl:call-template name="MENUSET"/>
              <xsl:for-each select="ancestor-or-self::section">
		<xsl:if test="child::h">
		  <xsl:value-of select="h"/>
		  <xsl:text> :: </xsl:text>
		</xsl:if>
              </xsl:for-each>
	    </xsl:element>
	  </xsl:element>
	</xsl:element>
      </xsl:if> 
      <xsl:element name="tr">
	<xsl:element name="td">
	  <xsl:for-each select="child::task|child::list/descendant::task">
	    <xsl:call-template name="TASK">
	      <xsl:with-param name="flag_line" select="true()"/>
	    </xsl:call-template>
	  </xsl:for-each>
	</xsl:element>
      </xsl:element>
    </xsl:if>
    <xsl:apply-templates select="block|section"/>
  </xsl:template>
</xsl:stylesheet>
