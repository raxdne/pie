<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="TodoTable.xsl"/>

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
                  <xsl:value-of select="concat('Backlog (',count(descendant::task),' items)')" />
                </xsl:element>
              </xsl:element>
            </xsl:element>
	    <xsl:call-template name="BACKLOG">
	      <xsl:with-param name="set_nodes" select="descendant::task[@impact = 1]"/>
	    </xsl:call-template>
	    <xsl:call-template name="BACKLOG">
	      <xsl:with-param name="set_nodes" select="descendant::task[@impact = 2]"/>
	    </xsl:call-template>
	    <xsl:call-template name="BACKLOG">
	      <xsl:with-param name="set_nodes" select="descendant::task[not(@impact) or @impact &gt; 2]"/>
	    </xsl:call-template>
	  </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="BACKLOG">
    <xsl:param name="set_nodes" />
    <xsl:for-each select="$set_nodes">
      <xsl:sort order="ascending" data-type="number" select="@diff"/>
      <xsl:sort order="ascending" data-type="number" select="child::h/child::date[1]/@diff"/>
      <xsl:sort order="ascending" data-type="number" select="parent::section/child::h/child::date[1]/@diff"/>
      <xsl:element name="tr">
	<xsl:element name="td">
	  <xsl:call-template name="TASK">
	    <xsl:with-param name="flag_line" select="true()"/>
	    <xsl:with-param name="flag_ancestor" select="true()"/>
	  </xsl:call-template>
	</xsl:element>
      </xsl:element>
    </xsl:for-each>    
  </xsl:template>
  
</xsl:stylesheet>
