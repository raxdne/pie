<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  
  <xsl:output method="html" encoding="UTF-8"/>  

  <xsl:template match="/">
    <xsl:element name="html">
    <xsl:element name="table">
      <xsl:attribute name="class">
        <xsl:value-of select="name(.)"/>
      </xsl:attribute>
      <xsl:attribute name="border">
        <xsl:text>0</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="cellspacing">
        <xsl:text>5</xsl:text>
      </xsl:attribute>
      <xsl:element name="tbody">
        <xsl:element name="tr">
          <xsl:element name="th">
            <xsl:text>Name</xsl:text>
          </xsl:element>
          <xsl:element name="th">
            <xsl:text>Tel.</xsl:text>
          </xsl:element>
          <xsl:element name="th">
            <xsl:text>Berufl.</xsl:text>
          </xsl:element>
        </xsl:element>

        <xsl:for-each select="//phone">
          <xsl:sort order="ascending" select="../name"/>
          <xsl:element name="tr">
            <xsl:element name="td">
              <xsl:attribute name="align">
                <xsl:text>left</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="concat(../name,', ',../firstname)"/>
              <xsl:if test="../address/private/name">
                <xsl:value-of select="concat(' (',../address/private/name,')')"/>
              </xsl:if>
            </xsl:element>
            <xsl:element name="td">
              <xsl:value-of select="private"/>
              <xsl:if test="mobile">
                <xsl:value-of select="concat(', ',mobile)"/>
              </xsl:if>
            </xsl:element>
            <xsl:if test="work">
              <xsl:element name="td">
                <xsl:value-of select="concat('',work)"/>
              </xsl:element>
            </xsl:if>
          </xsl:element>
        </xsl:for-each>

      </xsl:element>
    </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
