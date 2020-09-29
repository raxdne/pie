<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="xml"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="pie">
    <xsl:element name="{name()}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="table">
    <xsl:apply-templates>
      <xsl:sort order="ascending" select="td[2]"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="tr">
    <xsl:element name="vcard">
      <xsl:element name="name">
        <xsl:choose>
          <xsl:when test="string-length(td[2]) &gt; 0">
            <xsl:value-of select="td[2]"/>
          </xsl:when>
	  <xsl:otherwise>
          <xsl:value-of select="substring-before(td[5],'@')"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:element>
      <xsl:choose>
        <xsl:when test="string-length(td[1]) &gt; 0">
          <xsl:element name="firstname">
            <xsl:value-of select="td[1]"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="string-length(td[8]) &gt; 0">
          <xsl:element name="phone">
            <xsl:element name="private">
              <xsl:value-of select="td[8]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:element name="mail">
        <xsl:element name="private">
          <xsl:value-of select="td[5]"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
