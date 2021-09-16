<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="TodoTable.xsl"/>

  <!-- -->
  <xsl:variable name="file_norm"></xsl:variable>
  <!--  -->
  <xsl:variable name="file_css" select="''"/>
  <!--  -->
  <xsl:variable name="flag_done" select="false()"/>
  <!--  -->
  <xsl:variable name="ns_task" select="/descendant::task"/>

  <!-- TODO: parameters/variables for tag strings ('#review' etc) -->
  
  <xsl:output method="html"/>
  
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
      <xsl:element name="style">
table {
  margin: 0px 0px 0px 0px;
  width: 100%;
  }
*.unlined {
  border: 0px solid #ffffff;
}
      </xsl:element>
        <xsl:call-template name="PIETAGCLOUD"/>
        <xsl:call-template name="KANBAN"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="KANBAN">
    <xsl:element name="table">
      <xsl:element name="tbody">
        <xsl:element name="tr">
          <xsl:element name="th">
	    <xsl:attribute name="colspan">
	      <xsl:choose>
		<xsl:when test="$flag_done">
		  <xsl:text>4</xsl:text>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:text>3</xsl:text>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:attribute>
            <xsl:element name="b">
              <xsl:value-of select="concat('Backlog (',count($ns_task),' items)')" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
          <xsl:element name="th">
	    <xsl:attribute name="width">
              <xsl:text>25%</xsl:text>
	    </xsl:attribute>
	    <xsl:text>#do (Backlog)</xsl:text>
          </xsl:element>
          <xsl:element name="th">
	    <xsl:attribute name="width">
              <xsl:text>25%</xsl:text>
	    </xsl:attribute>
	    <xsl:text>#doing#now</xsl:text>
          </xsl:element>
          <xsl:element name="th">
	    <xsl:attribute name="width">
              <xsl:text>25%</xsl:text>
	    </xsl:attribute>
	    <xsl:text>#review</xsl:text>
          </xsl:element>
	  <xsl:if test="$flag_done">
            <xsl:element name="th">
	      <xsl:attribute name="width">
		<xsl:text>25%</xsl:text>
	      </xsl:attribute>
	      <xsl:text>#done</xsl:text>
            </xsl:element>
	  </xsl:if>
        </xsl:element>
      </xsl:element>
      <xsl:element name="tr">
        <xsl:element name="td">
	  <xsl:call-template name="CELL">
	    <xsl:with-param name="set_nodes" select="$ns_task[@impact = 1 and not(descendant::htag = '#doing') and not(descendant::htag = '#now') and not(descendant::htag = '#review') and not(child::t = '#done')]"/>
	  </xsl:call-template>
	</xsl:element>
        <xsl:element name="td">
	  <xsl:call-template name="CELL">
	    <xsl:with-param name="set_nodes" select="$ns_task[@impact = 1 and (descendant::htag = '#doing' or descendant::htag = '#now') and not(child::t = '#done')]"/>
	  </xsl:call-template>
	</xsl:element>
        <xsl:element name="td">
	  <xsl:call-template name="CELL">
	    <xsl:with-param name="set_nodes" select="$ns_task[@impact = 1 and descendant::htag = '#review' and not(child::t = '#done')]"/>
	  </xsl:call-template>
	</xsl:element>
	<xsl:if test="$flag_done">
          <xsl:element name="td">
	    <xsl:call-template name="CELL">
	      <xsl:with-param name="set_nodes" select="$ns_task[@impact = 1 and child::t = '#done']"/>
	    </xsl:call-template>
	  </xsl:element>
	</xsl:if>
      </xsl:element>
      <xsl:element name="tr">
        <xsl:element name="td">
	  <xsl:call-template name="CELL">
	    <xsl:with-param name="set_nodes" select="$ns_task[@impact = 2 and not(descendant::htag = '#doing') and not(descendant::htag = '#now') and not(descendant::htag = '#review') and not(child::t = '#done')]"/>
	  </xsl:call-template>
	</xsl:element>
        <xsl:element name="td">
	  <xsl:call-template name="CELL">
	    <xsl:with-param name="set_nodes" select="$ns_task[@impact = 2 and (descendant::htag = '#doing' or descendant::htag = '#now') and not(child::t = '#done')]"/>
	  </xsl:call-template>
	</xsl:element>
        <xsl:element name="td">
	  <xsl:call-template name="CELL">
	    <xsl:with-param name="set_nodes" select="$ns_task[@impact = 2 and descendant::htag = '#review' and not(child::t = '#done')]"/>
	  </xsl:call-template>
	</xsl:element>
	<xsl:if test="$flag_done">
          <xsl:element name="td">
	    <xsl:call-template name="CELL">
	      <xsl:with-param name="set_nodes" select="$ns_task[@impact = 2 and child::t = '#done']"/>
	    </xsl:call-template>
	  </xsl:element>
	</xsl:if>
      </xsl:element>	  
      <xsl:element name="tr">
        <xsl:element name="td">
	  <xsl:call-template name="CELL">
	    <xsl:with-param name="set_nodes" select="$ns_task[not(@impact) and not(@impact &gt; 2) and not(descendant::htag = '#doing') and not(descendant::htag = '#now') and not(descendant::htag = '#review') and not(child::t = '#done')]"/>
	  </xsl:call-template>
	</xsl:element>
        <xsl:element name="td">
	  <xsl:call-template name="CELL">
	    <xsl:with-param name="set_nodes" select="$ns_task[not(@impact) and not(@impact &gt; 2) and (descendant::htag = '#doing' or descendant::htag = '#now') and not(child::t = '#done')]"/>
	  </xsl:call-template>
	</xsl:element>
        <xsl:element name="td">
	  <xsl:call-template name="CELL">
	    <xsl:with-param name="set_nodes" select="$ns_task[not(@impact) and not(@impact &gt; 2) and descendant::htag = '#review' and not(child::t = '#done')]"/>
	  </xsl:call-template>
	</xsl:element>
	<xsl:if test="$flag_done">
          <xsl:element name="td">
	    <xsl:call-template name="CELL">
	      <xsl:with-param name="set_nodes" select="$ns_task[not(@impact) and not(@impact &lt; 2) and child::t = '#done']"/>
	    </xsl:call-template>
	  </xsl:element>
	</xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="CELL">
    <xsl:param name="set_nodes" />
    <xsl:element name="table">
      <xsl:attribute name="width">
        <xsl:text>100%</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="class">
	<xsl:text>unlined</xsl:text>
      </xsl:attribute>
      <xsl:element name="tbody">
	<xsl:for-each select="$set_nodes">
	  <xsl:sort order="ascending" data-type="number" select="@diff"/>
	  <xsl:sort order="ascending" data-type="number" select="child::h/child::date[1]/@diff"/>
	  <xsl:sort order="ascending" data-type="number" select="parent::section/child::h/child::date[1]/@diff"/>
	  <xsl:element name="tr">
	    <xsl:element name="td">
	      <xsl:attribute name="class">
		<xsl:text>unlined</xsl:text>
	      </xsl:attribute>
	      <xsl:call-template name="TASK">
		<xsl:with-param name="flag_line" select="true()"/>
		<xsl:with-param name="flag_ancestor" select="true()"/>
	      </xsl:call-template>
	    </xsl:element>
	  </xsl:element>
	</xsl:for-each>    
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>
