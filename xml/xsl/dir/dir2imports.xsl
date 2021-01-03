<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" encoding="UTF-8"/>

<xsl:variable name="nl">
<xsl:text>

</xsl:text>
</xsl:variable>

  <xsl:template match="dir">
    <xsl:for-each select="ancestor-or-self::dir">
      <xsl:text>*</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="concat(' ',@name,$nl)"/>
    <xsl:apply-templates match="file|dir">
      <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="name()"/>
      <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
      <xsl:with-param name="str_prefix">
        <xsl:for-each select="ancestor-or-self::dir[@urlname]">
          <xsl:value-of select="concat(@urlname,'/')"/>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="file[@ext='txt' or @ext='csv' or @ext='pie' or @ext='md']">
    <xsl:param name="str_prefix"/>
    <xsl:text>#import(&quot;</xsl:text>
    <xsl:value-of select="concat($str_prefix,@name)"/>
    <xsl:text>&quot;,root)</xsl:text>
    <xsl:value-of select="$nl"/>
  </xsl:template>

  <xsl:template match="file[starts-with(@type,'image/')]">
    <xsl:param name="str_prefix"/>
    <xsl:value-of select="concat('![Fig. ',@name,'](',$str_prefix,@urlname,')',$nl)"/>
  </xsl:template>

  <xsl:template match="file[@ext='pdf' or starts-with(@type,'application/vnd.oasis.opendocument') or starts-with(@type,'application/vnd.openxmlformats-officedocument')]">
    <xsl:param name="str_prefix"/>
    <xsl:value-of select="concat('[',@name,'](',$str_prefix,@urlname,')',$nl)"/>
  </xsl:template>

  <xsl:template match="meta|file"/>
</xsl:stylesheet>
