<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>

  <xsl:variable name="separator" select="'\'"/>

  <xsl:variable name="str_cmd" select="''"/> <!-- 'md ' or 'mkdir -p ' -->

  <xsl:template match="dir[attribute::name]">
    <xsl:variable name="str_path">
      <xsl:for-each select="ancestor::dir[attribute::name]">
        <xsl:value-of select="concat(@name,$separator)"/>
      </xsl:for-each>
      <xsl:value-of select="@name"/>
    </xsl:variable>

    <xsl:variable name="str_path_sep">
      <xsl:choose>
        <xsl:when test="$separator='\'">
          <xsl:value-of select="translate($str_path,'/',$separator)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="translate($str_path,'\',$separator)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="concat($str_cmd,'&quot;',$str_path_sep,'&quot;','&#10;')"/>

    <xsl:apply-templates select="child::dir[attribute::name]"/>
  </xsl:template>

</xsl:stylesheet>
