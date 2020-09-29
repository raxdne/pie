<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" version="1.0">
  <xsl:output method="xml" encoding="UTF-8"/>
  <!--  -->
  <xsl:variable name="entry_max" select="-1"/>
  <!--  -->
  <xsl:variable name="flag_description" select="false()"/>
  <xsl:template match="/">
    <xsl:element name="pie">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="rdf:RDF">
    <xsl:element name="section">
      <xsl:for-each select="*[name()='channel']">
        <xsl:element name="h">
          <xsl:element name="link">
            <xsl:attribute name="href">
              <xsl:value-of select="*[name()='link']"/>
            </xsl:attribute>
            <xsl:value-of select="*[name()='title']"/>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
      <xsl:element name="list">
        <xsl:attribute name="enum">yes</xsl:attribute>
        <xsl:for-each select="*[name()='item' and ($entry_max &lt; 0 or position() &lt; $entry_max)]">
          <xsl:element name="p">
            <xsl:element name="link">
              <xsl:attribute name="href">
                <xsl:value-of select="*[name()='link']"/>
              </xsl:attribute>
              <xsl:value-of select="concat(*[name()='title'],'.')"/>
            </xsl:element>
            <xsl:value-of select="*[name()='description']"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
