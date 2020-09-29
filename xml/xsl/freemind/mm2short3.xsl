<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method='html' doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" encoding='UTF-8'/>

<xsl:template match="/map">
  <xsl:element name="html">
    <xsl:element name="head">
      <link rel="stylesheet" media="screen, print" type="text/css" href="../html/pie.css"/>
    </xsl:element>
    <xsl:element name="body">
      <!-- create header -->
      <xsl:element name="h2">
        <xsl:value-of select="node/@TEXT"/>
      </xsl:element>
      <xsl:apply-templates select="node"/>
    </xsl:element>
  </xsl:element>
</xsl:template>


<xsl:template match="node">
  <xsl:choose>
    <xsl:when test="attribute::FOLDED = 'true'"/>
    <xsl:when test="child::icon[contains(@BUILTIN, 'cancel') or contains(@BUILTIN, 'ok')]"/>
    <xsl:otherwise>
      <!-- -->
      <xsl:choose>
        <xsl:when test="child::node">
          <!-- a node with childs -->
          <xsl:element name="DT">
            <xsl:value-of select="@TEXT"/>
          </xsl:element>
          <xsl:element name="DL">
            <!-- all childs without childs -->
            <xsl:element name="DD">
              <xsl:for-each select="child::node[not(child::node)]">
                <xsl:apply-templates select="."/>
              </xsl:for-each>
            </xsl:element>
            <!-- all childs with own childs -->
            <xsl:for-each select="child::node[child::node]">
              <xsl:apply-templates select="."/>
            </xsl:for-each>
          </xsl:element>

        </xsl:when>
        <xsl:otherwise>
          <!-- node without childs -->
          <xsl:value-of select="@TEXT"/>
          <xsl:text>; </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>
