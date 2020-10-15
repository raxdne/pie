<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../PieHtml.xsl"/>
  <!--  -->
  <xsl:variable name="file_css" select="'pie.css'"/>

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
    <xsl:apply-templates select="year"/>
  </xsl:template>

  <xsl:template match="year">
    <xsl:element name="table">
      <xsl:element name="tbody">
        <!-- 
        <xsl:element name="tr">
          <xsl:element name="th">
            <xsl:attribute name="class">marker</xsl:attribute>
            <xsl:attribute name="colspan">13</xsl:attribute>
          </xsl:element>
        </xsl:element>
        -->
        <!-- -->
        <xsl:call-template name="DAYCOUNTER"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="DAYCOUNTER">
    <xsl:param name="i">0</xsl:param>

    <xsl:element name="tr">
      <xsl:choose>
        <xsl:when test="$i &lt; 1">
          <!-- insert month headers -->
          <xsl:element name="th">
            <xsl:value-of select="@ad"/>
          </xsl:element>
          <xsl:for-each select="month">
            <xsl:element name="th">
              <xsl:attribute name="class">marker</xsl:attribute>
              <xsl:value-of select="@name"/>
            </xsl:element>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <!-- -->
          <xsl:element name="td">
            <xsl:value-of select="$i"/>
          </xsl:element>
          <!-- -->
          <xsl:for-each select="month">
            <xsl:element name="td">
              <xsl:choose>
                <xsl:when test="day[number(@om)=$i]/@ow='6' or day[number(@om)=$i]/@ow='0'">
                  <xsl:element name="b">
                    <xsl:value-of select="substring(day[number(@om)=$i]/@own,1,2)"/>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="day[number(@om)=$i]/@ow='1'">
                  <xsl:value-of select="substring(day[number(@om)=$i]/@own,1,2)"/>
                  <xsl:text> </xsl:text>
                  <xsl:element name="i">
                    <xsl:value-of select="day[number(@om)=$i]/@cw"/>
                  </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(day[number(@om)=$i]/@own,1,2)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    <!-- -->
    <xsl:choose>
      <xsl:when test="$i &lt; 31">
        <xsl:call-template name="DAYCOUNTER">
          <xsl:with-param name="i">
            <xsl:value-of select="$i+1"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
