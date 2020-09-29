<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- write a Freemind map into a pie document, depth of tasks defined by variable --> 
  <xsl:output method='xml' version='1.0' encoding="UTF-8"/>
  <xsl:variable name="intDepth" select="3"/>
  <xsl:template match="map">
    <xsl:element name="pie">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="node">
    <xsl:variable name="depth" select="count(ancestor::node)"/>
    <xsl:choose>
      <xsl:when test="$depth &gt; $intDepth">
        <!-- p and childs as list -->
        <xsl:element name="p">
          <xsl:value-of select="@TEXT"/>
        </xsl:element>
        <xsl:if test="child::node">
          <xsl:element name="list">
            <xsl:apply-templates/>
          </xsl:element>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$depth = $intDepth">
        <!-- task -->
        <xsl:element name="task">
          <xsl:if test="child::icon[contains(@BUILTIN, 'cancel')]">
            <xsl:attribute name="valid">no</xsl:attribute>
          </xsl:if>
          <xsl:element name="h">
            <xsl:value-of select="@TEXT"/>
          </xsl:element>
          <xsl:if test="child::node">
            <xsl:element name="list">
              <xsl:apply-templates/>
            </xsl:element>
          </xsl:if>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$depth &lt; $intDepth">
        <!-- sections -->
        <xsl:element name="section">
          <xsl:if test="@FOLDED='true' or child::icon[contains(@BUILTIN, 'cancel')]">
            <xsl:attribute name="valid">no</xsl:attribute>
          </xsl:if>
          <xsl:element name="h">
            <xsl:value-of select="@TEXT"/>
          </xsl:element>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
