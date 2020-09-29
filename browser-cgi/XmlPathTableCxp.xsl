<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- replaces Patterns 'PATH', 'XPATH' and 'TAG' -->
  <xsl:variable name="str_filter" select="''" />
  <xsl:variable name="str_path" select="'abc.xml'" />
  <xsl:variable name="str_xpath" select="'/*'" />
  <xsl:variable name="str_tag" select="''" />
  <xsl:variable name="str_tagtime" select="''" />
  <xsl:variable name="int_count" select="1" />
  <xsl:output method="xml" />
  <xsl:template match="/">
    <xsl:element name="make">
      <xsl:for-each select="descendant::path[count(child::transition[position() &gt; 1 and descendant::*[@name = 'PATH']]) &lt; 1]">
        <!-- ignore paths with multiple PATHs -->
        <xsl:sort order="ascending" data-type="number" select="count(descendant::xsl)" />
        <xsl:if test="position() &lt;= $int_count">
          <xsl:apply-templates select="self::node()" />
        </xsl:if>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  <xsl:template match="path">
    <xsl:variable name="node_last" select="stelle[position()=last()]" />
    <xsl:choose>
      <xsl:when test="contains($node_last/@type,'xml')">
        <xsl:element name="xml">
          <xsl:copy-of select="$node_last/@*" />
          <xsl:attribute name="name">-</xsl:attribute>
          <xsl:apply-templates />
        </xsl:element>
      </xsl:when>
      <xsl:when test="$node_last/@type='text/html'">
        <xsl:element name="xhtml">
          <xsl:copy-of select="$node_last/@*" />
          <xsl:attribute name="name">-</xsl:attribute>
          <xsl:apply-templates />
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="plain">
          <xsl:copy-of select="$node_last/@*" />
          <xsl:attribute name="name">-</xsl:attribute>
          <xsl:apply-templates />
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="transition">
    <!--
    <xsl:comment>
      <xsl:value-of select="concat(' begin ',name(),' ',@id,' ')"/>
    </xsl:comment>
-->
    <xsl:apply-templates select="make/*" />
    <!--
    <xsl:comment>
      <xsl:value-of select="concat(' end ',name(),' ',@id,' ')"/>
    </xsl:comment>
-->
  </xsl:template>
  <xsl:template match="stelle">
    <xsl:comment>
      <xsl:value-of select="concat(' ',name(),' ',@id)" />
    </xsl:comment>
    <xsl:if test="position() = 1 and not(following-sibling::transition[1]/make/descendant::*[@name = 'PATH'])">
      <!-- very first source -->
      <xsl:apply-templates select="make/*" />
    </xsl:if>
  </xsl:template>
  <xsl:template match="relation">
    <xsl:comment>
      <xsl:value-of select="concat(' ',@from,' ⇒ ',@to,' ')" />
    </xsl:comment>
  </xsl:template>
  <xsl:template match="*">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*" />
      <xsl:if test="attribute::name[. = 'PATH']">
        <!-- replace 'PATH' by path value and set type attribute -->
        <xsl:attribute name="name">
          <xsl:value-of select="$str_path" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="attribute::select[. = 'XPATH']">
        <!-- replace 'XPATH' by path value and set type attribute -->
        <xsl:attribute name="select">
          <xsl:value-of select="$str_xpath" /> <!-- TODO: test if value starts with '/' (not document(...)/* ) -->
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="attribute::xpath[. = 'XPATH']">
        <!-- replace 'XPATH' by path value and set type attribute -->
        <xsl:attribute name="xpath">
          <xsl:value-of select="$str_xpath" /> <!-- TODO: test if value starts with '/' (not document(...)/* ) -->
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="attribute::select[. = 'TAG']">
        <!-- replace 'TAG' by path value and set type attribute -->
        <xsl:attribute name="select">
          <xsl:text>'</xsl:text>
          <xsl:value-of select="$str_tag" />
          <xsl:text>'</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="attribute::pattern[. = 'TAG']">
        <!-- replace 'TAG' by path value and set type attribute -->
        <xsl:attribute name="pattern">
          <xsl:value-of select="$str_tag" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="attribute::select[. = 'TAGTIME']">
        <!-- replace 'TAGTIME' by path value and set type attribute -->
        <xsl:attribute name="select">
          <xsl:text>'</xsl:text>
          <xsl:value-of select="$str_tagtime" />
          <xsl:text>'</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*" />
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
