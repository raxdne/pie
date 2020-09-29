<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" encoding="ISO-8859-1"/>
  <xsl:decimal-format name="f1" grouping-separator="." decimal-separator=","/>
  <xsl:variable name="str_sep">
    <xsl:text>;</xsl:text>
  </xsl:variable>
  <xsl:variable name="flag_numbers" select="true()"/>
  <xsl:variable name="str_tab">
    <xsl:value-of select="$str_sep"/>
  </xsl:variable>
  <xsl:variable name="int_maxdepth">
    <xsl:value-of select="9"/>
  </xsl:variable>
  <xsl:variable name="nl">
    <xsl:text>
</xsl:text>
  </xsl:variable>
  <xsl:template match="/map">
    <xsl:value-of select="concat('sep=',$str_sep,'&#10;')"/>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="node">
    <xsl:param name="sum_siblings">
      <xsl:value-of select="1.0"/>
    </xsl:param>
    <xsl:param name="weight_parent">
      <xsl:value-of select="1.0"/>
    </xsl:param>
    <xsl:param name="value_self">
      <xsl:choose>
        <xsl:when test="attribute[@NAME='weight']/@VALUE &gt; -1.0">
          <xsl:value-of select="number(attribute[@NAME='weight']/@VALUE)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1.0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:variable name="weight_self">
      <xsl:value-of select="$value_self div $sum_siblings * $weight_parent"/>
    </xsl:variable>
    <xsl:call-template name="ADDTAB">
      <xsl:with-param name="n">
        <xsl:value-of select="count(ancestor::node)"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:if test="$flag_numbers">
      <xsl:value-of select="concat($str_sep,format-number($weight_self * 100.0,'#,##','f1'),$str_tab)"/>
    </xsl:if>
    <xsl:value-of select="concat('&quot;',normalize-space(@TEXT),'&quot;')"/>
    <xsl:if test="$flag_numbers">
      <xsl:choose>
        <xsl:when test="count(child::*[name()='node']) &lt; 1">
          <xsl:call-template name="ADDTAB">
            <xsl:with-param name="n">
              <xsl:value-of select="$int_maxdepth - count(ancestor::node)"/>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:value-of select="format-number($weight_self * 100.0,'#,##','f1')"/>
        </xsl:when>
        <xsl:otherwise>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
<!-- <xsl:value-of select="concat(' (value_self=',$value_self,' sum_siblings=',$sum_siblings,' weight_parent=',$weight_parent,')')"/> -->
    <xsl:value-of select="concat('',$nl)"/>
    <xsl:apply-templates select="node">
      <xsl:with-param name="sum_siblings">
        <xsl:value-of select="sum(node/attribute[@NAME='weight']/@VALUE) + count(node[not(attribute[@NAME='weight']/@VALUE)])"/>
      </xsl:with-param>
      <xsl:with-param name="weight_parent">
        <xsl:value-of select="$weight_self"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template name="ADDTAB">
    <xsl:param name="n">
      <xsl:value-of select="1"/>
    </xsl:param>
    <xsl:value-of select="$str_tab"/>
    <xsl:if test="$n &gt; 0">
      <xsl:call-template name="ADDTAB">
        <xsl:with-param name="n">
          <xsl:value-of select="$n - 1"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template match="*|text()"/>
</xsl:stylesheet>
