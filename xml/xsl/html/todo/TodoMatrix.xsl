<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../Utils.xsl"/>
  <xsl:import href="../PieHtml.xsl"/>

  <!-- -->
  <xsl:variable name="file_norm"></xsl:variable>
  <!--  -->
  <xsl:variable name="file_css" select="'pie.css'"/>
  <!-- -->
  <xsl:variable name="file_cxp" select="''"/>
  <!--  -->
  <xsl:variable name="diff_delta_0" select="-2"/>
  <!-- -->
  <xsl:variable name="diff_delta_1" select="5"/>
  <!-- -->
  <xsl:variable name="nowYear" select="0"/>
  <!-- -->
  <xsl:variable name="nowMonth" select="0"/>
  <!-- -->
  <xsl:variable name="nowWeek" select="0"/>
  <!-- -->
  <xsl:variable name="nowDay" select="0"/>
  <!-- -->
  <xsl:variable name="ns_date" select="//task[not(@done or @class = 'done' or @state = 'done')]"/>

  <xsl:output encoding="UTF-8" method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" media-type="text/html"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
        <!--  -->
        <xsl:element name="table">
          <xsl:attribute name="border">
            <xsl:text>1</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="cellspacing">
            <xsl:text>1</xsl:text>
          </xsl:attribute>
          <xsl:element name="tbody">
            <xsl:element name="tr">
              <xsl:element name="th">
                <xsl:element name="a">
                  <xsl:attribute name="href">http://de.wikipedia.org/wiki/Eisenhower-Prinzip</xsl:attribute>
                  <xsl:text>Eisenhower-Prinzip</xsl:text>
                </xsl:element>
              </xsl:element>
              <xsl:element name="th">
                <xsl:attribute name="colspan">2</xsl:attribute>
                <xsl:attribute name="align">center</xsl:attribute>
                <!-- label -->
                <xsl:text>impact</xsl:text>
              </xsl:element>
            </xsl:element>
            <!--  -->
            <xsl:element name="tr">
              <xsl:element name="th">
                <xsl:attribute name="width">7%</xsl:attribute>
                <xsl:text>urgency</xsl:text>
              </xsl:element>
              <xsl:element name="th">
                <xsl:attribute name="width">31%</xsl:attribute>
                <xsl:text>high</xsl:text>
              </xsl:element>
              <xsl:element name="th">
                <xsl:attribute name="width">31%</xsl:attribute>
                <!-- label -->
                <xsl:text>medium</xsl:text>
              </xsl:element>
                <!-- 
              <xsl:element name="th">
                <xsl:attribute name="width">31%</xsl:attribute>
                <xsl:text>other</xsl:text>
              </xsl:element>
              -->
            </xsl:element>
            <!--  -->
            <xsl:element name="tr">
              <xsl:element name="th">
                <xsl:value-of select="concat('overdue (&#x0394; &lt; ',$diff_delta_0,')')"/>
              </xsl:element>
              <xsl:call-template name="ROWURGENCY">
                <xsl:with-param name="ns_row" select="$ns_date[descendant::date/@diff &lt; $diff_delta_0]"/>
                <xsl:with-param name="nr_row" select="2"/>
              </xsl:call-template>
            </xsl:element>
            <!--  -->
            <xsl:element name="tr">
              <xsl:element name="th">
                <xsl:value-of select="concat('high (&#x0394; &lt; ',$diff_delta_1,')')"/>
              </xsl:element>
              <xsl:call-template name="ROWURGENCY">
                <xsl:with-param name="ns_row" select="$ns_date[not(descendant::date/@diff) or (descendant::date/@diff &gt;= $diff_delta_0 and descendant::date/@diff &lt; $diff_delta_1)]"/>
                <xsl:with-param name="nr_row" select="1"/>
              </xsl:call-template>
            </xsl:element>
            <!-- 
            <xsl:element name="tr">
              <xsl:element name="th">
                <xsl:value-of select="concat('medium (&#x0394; &gt;= ',$diff_delta_1,')')"/>
              </xsl:element>
              <xsl:call-template name="ROWURGENCY">
                <xsl:with-param name="ns_row" select="$ns_date[not(descendant::date/@diff) or (descendant::date/@diff &gt;= $diff_delta_1)]"/>
                <xsl:with-param name="nr_row" select="2"/>
              </xsl:call-template>
            </xsl:element>
            -->
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="ROWURGENCY">
    <xsl:param name="ns_row"/>
    <xsl:param name="nr_row"/>
    <xsl:call-template name="COLIMPACT">
      <xsl:with-param name="ns_col" select="$ns_row[@impact=1]"/>
      <xsl:with-param name="nr_cell" select="concat($nr_row,'1')"/>
    </xsl:call-template>
    <xsl:call-template name="COLIMPACT">
      <xsl:with-param name="ns_col" select="$ns_row[@impact=2]"/>
      <xsl:with-param name="nr_cell" select="concat($nr_row,'2')"/>
    </xsl:call-template>
    <!-- 
    <xsl:call-template name="COLIMPACT">
      <xsl:with-param name="ns_col" select="$ns_row[@diff &gt; -5 and ((not(@impact) or @impact &gt; 2))]"/>
      <xsl:with-param name="nr_cell" select="concat($nr_row,'3')"/>
    </xsl:call-template>
 -->
  </xsl:template>
  <xsl:template name="COLIMPACT">
    <xsl:param name="ns_col"/>
    <xsl:param name="nr_cell"/>
    <xsl:variable name="sum_count" select="count($ns_col)"/>
    <xsl:variable name="sum_effort" select="sum($ns_col/@effort)"/>
    <xsl:element name="td">
      <xsl:apply-templates select="$ns_col">
        <xsl:sort select="@diff" order="ascending" data-type="number"/>
        <xsl:sort select="@effort"/>
      </xsl:apply-templates>
      <xsl:element name="p">
        <xsl:attribute name="align">right</xsl:attribute>
        <xsl:if test="$sum_count &gt; 1">
          <xsl:value-of select="concat('n = ',$sum_count)"/>
          <xsl:if test="$sum_effort &gt; 0">
            <xsl:value-of select="concat(', ','')"/>
          </xsl:if>
        </xsl:if>
        <xsl:if test="$sum_effort &gt; 0">
          <xsl:value-of select="concat('Σ = ',$sum_effort,'h')"/>
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="link">
    <xsl:element name="a">
      <xsl:choose>
        <xsl:when test="@href">
          <!--  -->
          <xsl:attribute name="target">
            <xsl:value-of select="''"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="task">
    <xsl:call-template name="TASK">
      <xsl:with-param name="flag_line" select="true()"/>
      <xsl:with-param name="flag_ancestor" select="true()"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
