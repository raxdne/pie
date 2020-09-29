<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:feed="http://www.w3.org/2005/Atom" version="1.0">
  <xsl:output method="xml" encoding="UTF-8"/>
  <!--  -->
  <xsl:variable name="entry_max" select="-1"/>
  <!--  -->
  <xsl:variable name="flag_description" select="false()"/>
  <xsl:template match="/">
    <xsl:element name="pie">
      <xsl:apply-templates select="feed:feed"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="feed:feed">
    <xsl:element name="section">
      <xsl:element name="h">
        <xsl:element name="link">
          <xsl:copy-of select="feed:link/@href"/>
          <xsl:value-of select="feed:title"/>
        </xsl:element>
      </xsl:element>
      <!-- -->
      <xsl:element name="list">
        <xsl:attribute name="enum">yes</xsl:attribute>
        <xsl:for-each select="feed:entry[$entry_max &lt; 0 or position() &lt;= $entry_max]">
          <xsl:element name="p">
            <xsl:element name="link">
              <xsl:copy-of select="feed:link/@href"/>
              <xsl:value-of select="feed:title"/>
            </xsl:element>
	    <xsl:if test="$flag_description">
	      <xsl:copy-of select="feed:summary"/>
	    </xsl:if>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="*"/>
</xsl:stylesheet>
