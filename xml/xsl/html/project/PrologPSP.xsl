<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../PieHtml.xsl"/>

  <!-- -->
  <xsl:variable name="file_norm"></xsl:variable>
  <!--  -->
  <xsl:variable name="file_css" select="'pie.css'"/>
  <!--  -->
  <xsl:variable name="level_hidden" select="0"/>

  <xsl:output method='html' version='1.0' encoding='UTF-8'/>

<xsl:variable name="flag_details" select="true()"/>
<xsl:variable name="flag_ap" select="true()"/>
<xsl:variable name="str_unit" select="''"/>

<xsl:decimal-format name="f1" grouping-separator="." decimal-separator=","/>

<xsl:template match="/">
  <xsl:element name="html">
    <xsl:call-template name="HEADER"/>
    <xsl:element name="body">
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:element>
</xsl:template>

<xsl:template match="pie">
  <xsl:apply-templates select="section"/>
</xsl:template>

<xsl:template match="section[count(ancestor::section) = 0]">
  <!-- Projekt -->
  <xsl:element name="h1">
    <xsl:text>Projektstrukturplan &quot;</xsl:text>
    <xsl:value-of select="h"/>
    <xsl:text>&quot;</xsl:text>
  </xsl:element>
  <xsl:element name="p">
    <xsl:text>Legende: &quot;TP&quot; - Teilprojekt, &quot;HAP&quot; - Hauptarbeitspaket, &quot;AP&quot; - Arbeitspaket</xsl:text>
  </xsl:element>
  <xsl:element name="table">
    <xsl:attribute name="class">unlined</xsl:attribute>
    <xsl:attribute name="border">0</xsl:attribute>
    <xsl:attribute name="cellpadding">2</xsl:attribute>
    <xsl:element name="tbody">
      <xsl:element name="tr">
        <xsl:element name="th">
          <xsl:attribute name="align">center</xsl:attribute>
          <xsl:attribute name="colspan">
            <xsl:value-of select="count(section)"/>
          </xsl:attribute>
          <xsl:text>Projekt </xsl:text>
          <xsl:text> </xsl:text>
          <xsl:value-of select="@effort"/>
          <!-- value for Effort -->
          <xsl:text>: </xsl:text>
          <xsl:value-of select="format-number(sum(descendant::task/@effort),'#.##0','f1')"/>
          <xsl:value-of select="$str_unit"/>
          <br/>
          <xsl:value-of select="h"/>
            <xsl:if test="@date">
            <xsl:text> (bis zum </xsl:text>
              <xsl:value-of select="@date"/>
            <xsl:text>)</xsl:text>
            </xsl:if>
        </xsl:element>
      </xsl:element>
        <!-- Row with target/h's -->
        <xsl:if test="target">
          <xsl:element name="tr">
            <xsl:element name="td">
            <xsl:attribute name="colspan">
              <xsl:value-of select="count(section)"/>
            </xsl:attribute>
            <xsl:attribute name="class">summary</xsl:attribute>
              <xsl:text>Ziele</xsl:text>
              <xsl:element name="ol">
                <xsl:for-each select="target">
                  <xsl:element name="li">
                    <xsl:value-of select="h"/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <!--  -->
      <xsl:element name="tr">
        <xsl:apply-templates select="section"/>
      </xsl:element>
    </xsl:element>
  </xsl:element>
</xsl:template>


<xsl:template match="section[count(ancestor::section) = 1]">
  <!-- TP -->
  <xsl:variable name="position" select="position()"/>
  <xsl:element name="td">
    <xsl:element name="table">
      <xsl:attribute name="class">
        <xsl:value-of select="name(.)"/>
      </xsl:attribute>
      <xsl:attribute name="border">0</xsl:attribute>
      <xsl:attribute name="cellspacing">1</xsl:attribute>
      <xsl:attribute name="cellpadding">3</xsl:attribute>
      <xsl:element name="tbody">
        <xsl:element name="tr">
          <xsl:element name="th">
            <xsl:attribute name="colspan">
              <xsl:value-of select="count(section)"/>
            </xsl:attribute>
            <xsl:text>TP_</xsl:text>
            <xsl:value-of select="$position"/>
            <!-- value for Effort -->
            <xsl:text>: </xsl:text>
            <xsl:choose>
              <xsl:when test="@effort">
                <xsl:value-of select="format-number(@effort,'#.##0,0','f1')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="format-number(sum(descendant::task/@effort),'#.##0,0','f1')"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$str_unit"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="h"/>
            <xsl:if test="@date">
            <xsl:text> (bis zum </xsl:text>
              <xsl:value-of select="@date"/>
            <xsl:text>)</xsl:text>
            </xsl:if>
          </xsl:element>
        </xsl:element>
        <!-- Row with target/h's -->
        <xsl:if test="target">
          <xsl:element name="tr">
            <xsl:element name="td">
            <xsl:attribute name="colspan">
              <xsl:value-of select="count(section)"/>
            </xsl:attribute>
            <xsl:attribute name="class">summary</xsl:attribute>
              <xsl:text>Ziele</xsl:text>
              <xsl:element name="ol">
                <xsl:for-each select="target">
                  <xsl:element name="li">
                    <xsl:value-of select="h"/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <!--  -->
        <xsl:element name="tr">
          <xsl:choose>
            <xsl:when test="@done">
              <xsl:element name="td">
              <xsl:text>(abgeschlossen)</xsl:text>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="section">
                <xsl:with-param name="pos_tp" select="$position"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:element>
</xsl:template>


<xsl:template match="section[count(ancestor::section) = 2]">
  <!-- HAP -->
  <xsl:param name="pos_tp"/>
  <xsl:variable name="position" select="position()"/>
  <xsl:element name="td">
    <xsl:element name="table">
      <xsl:attribute name="class">
        <xsl:value-of select="name(.)"/>
      </xsl:attribute>
      <xsl:attribute name="border">0</xsl:attribute>
      <xsl:attribute name="cellspacing">1</xsl:attribute>
      <xsl:attribute name="cellpadding">3</xsl:attribute>
      <xsl:element name="tbody">
        <xsl:element name="tr">
          <xsl:element name="th">
<!-- 
            <xsl:attribute name="colspan">
              <xsl:value-of select="count(section)"/>
            </xsl:attribute>
 -->
            <xsl:text>HAP_</xsl:text>
            <xsl:value-of select="$pos_tp"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$position"/>
            <!-- value for Effort -->
            <xsl:text>: </xsl:text>
            <xsl:choose>
              <xsl:when test="@effort">
                <xsl:value-of select="format-number(@effort,'#.##0,0','f1')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="format-number(sum(descendant::task/@effort),'#.##0,0','f1')"/>
              </xsl:otherwise>
            </xsl:choose>
             <xsl:value-of select="$str_unit"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="h"/>
            <xsl:if test="@date">
            <xsl:text> (bis zum </xsl:text>
              <xsl:value-of select="@date"/>
            <xsl:text>)</xsl:text>
            </xsl:if>
          </xsl:element>
        </xsl:element>
        <!-- Row with target/h's -->
        <xsl:if test="target">
          <xsl:element name="tr">
            <xsl:element name="td">
            <xsl:attribute name="class">summary</xsl:attribute>
               <xsl:text>Ziele</xsl:text>
             <xsl:element name="ol">
                <xsl:for-each select="target">
                  <xsl:element name="li">
                    <xsl:value-of select="h"/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <!--  -->
        <xsl:if test="$flag_ap">
          <xsl:apply-templates select="section">
            <xsl:with-param name="pos_tp" select="$pos_tp"/>
            <xsl:with-param name="pos_hap" select="$position"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:element>
</xsl:template>


<xsl:template match="section[count(ancestor::section) = 3]">
  <!-- AP -->
  <xsl:param name="pos_tp"/>
  <xsl:param name="pos_hap"/>
  <xsl:element name="tr">
    <xsl:element name="td">
      <xsl:element name="b">
        <xsl:text>AP_</xsl:text>
        <xsl:value-of select="$pos_tp"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="$pos_hap"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="position()"/>
      </xsl:element>
      <!-- value for Effort -->
      <xsl:text>: </xsl:text>
      <xsl:choose>
        <xsl:when test="@effort">
          <xsl:value-of select="format-number(@effort,'#.##0,0','f1')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="format-number(sum(descendant::task/@effort),'#.##0,0','f1')"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$str_unit"/>
      <br/>
      <xsl:value-of select="h"/>
      <xsl:choose>
        <xsl:when test="@done">
          <xsl:element name="p">
            <xsl:attribute name="class">done</xsl:attribute>
            <xsl:text>(abgeschlossen)</xsl:text>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$flag_details and child::task">
          <!-- additional informations -->
          <xsl:element name="ul">
            <xsl:for-each select="task">
              <xsl:element name="li">
                <xsl:if test="@done">
                  <xsl:attribute name="class">done</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="h"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:element>
</xsl:template>


<xsl:template match="section">
  <!-- ignore -->
</xsl:template>


</xsl:stylesheet>
