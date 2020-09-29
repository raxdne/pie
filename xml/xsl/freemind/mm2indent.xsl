<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
  <xsl:template match="/map">
    <xsl:element name="html">
      <xsl:element name="head">
        <xsl:element name="title">
          <xsl:value-of select="node/@TEXT"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="body">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="node">
    <xsl:choose>
      <xsl:when test="count(ancestor::node) &lt; 2">
        <xsl:element name="p">
          <xsl:value-of select="@TEXT"/>
        </xsl:element>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="count(ancestor::node) &lt; 3">
        <xsl:element name="p">
          <xsl:value-of select="@TEXT"/>
        </xsl:element>
        <xsl:if test="child::node">
          <xsl:element name="ul">
            <xsl:apply-templates/>
          </xsl:element>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="li">
          <xsl:choose>
            <xsl:when test="starts-with(@TEXT,'&lt;html&gt;')">
              <!-- node with HTML tags -->
              <xsl:element name="img">
                <xsl:attribute name="src">
                  <xsl:value-of select="substring-before(substring-after(@TEXT, '&lt;html&gt;&lt;img src=&quot;'),'&quot;&gt;')"/>
                </xsl:attribute>
              </xsl:element>
            </xsl:when>
            <xsl:when test="@LINK">
              <!-- node with a link -->
              <xsl:element name="p">
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="@LINK"/>
                  </xsl:attribute>
                  <xsl:value-of select="@TEXT"/>
                </xsl:element>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <!-- plain text node -->
              <xsl:element name="p">
                <!-- because OpenOffice/Writer/Web -->
                <xsl:value-of select="@TEXT"/>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="child::node">
            <xsl:element name="ul">
              <xsl:apply-templates/>
            </xsl:element>
          </xsl:if>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
