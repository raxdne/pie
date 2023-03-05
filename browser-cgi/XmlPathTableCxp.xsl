<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pkg="http://www.tenbusch.info/pkg" version="1.0">
  <!-- replaces Patterns 'PATH', 'XPATH' and 'TAG' -->
  <xsl:variable name="str_filter" select="''" />
  <xsl:variable name="str_path"></xsl:variable>
  <xsl:variable name="str_xpath" select="'/*'" />
  <xsl:variable name="str_tag" select="''" />
  <xsl:variable name="str_re" select="''" />
  <xsl:variable name="str_tagtime" select="''" />
  <xsl:variable name="int_count" select="1" />
  <xsl:output method="xml" />

  <xsl:template match="/">
    <xsl:element name="make">
      <xsl:for-each select="descendant::path[count(child::pkg:transition[position() &gt; 1 and descendant::*[@name = 'PATH']]) &lt; 1]">
        <!-- ignore paths with multiple PATHs -->
        <xsl:sort order="ascending" data-type="number" select="count(descendant::xsl)" />
        <xsl:if test="position() &lt;= $int_count">
          <xsl:apply-templates select="self::node()" />
        </xsl:if>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="path">
    <xsl:variable name="node_last" select="pkg:stelle[position()=last()]" />
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

  <xsl:template match="SUBST">
    <xsl:variable name="node_subst" select="ancestor::pkg:transition/preceding-sibling::pkg:*[child::make][1]"/>
    <xsl:choose>
      <xsl:when test="$node_subst[@id]">
	<xsl:comment>
	  <xsl:value-of select="concat(' substituted by ', $node_subst/@id)"/>
	</xsl:comment>
	<xsl:apply-templates select="$node_subst/child::make/*"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:comment>
	  <xsl:value-of select="concat(' no substitution found ','')"/>
	</xsl:comment>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="pkg:transition">
    <!--
    <xsl:comment>
      <xsl:value-of select="concat(' begin ',name(),' ',@id,' ')"/>
    </xsl:comment>
-->
    <xsl:variable name="str_id" select="@id"/>
    <xsl:choose>
      <xsl:when test="following-sibling::pkg:transition/descendant::SUBST">
	<xsl:comment>
	  <xsl:value-of select="concat(' skip ',name(),' ', $str_id,' due to later substitution ')"/>
	</xsl:comment>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="make/*" />
      </xsl:otherwise>
    </xsl:choose>
    <!--
    <xsl:comment>
      <xsl:value-of select="concat(' end ',name(),' ',@id,' ')"/>
    </xsl:comment>
-->
  </xsl:template>

  <xsl:template match="pkg:stelle">
    <xsl:variable name="str_id" select="@id"/>
    <xsl:comment>
      <xsl:value-of select="concat(' ',name(),' ',@id)" />
    </xsl:comment>

    <xsl:choose>
      <xsl:when test="following-sibling::pkg:transition/descendant::SUBST">
	<xsl:comment>
	  <xsl:value-of select="concat(' skip ',name(),' ', $str_id,' due to later substitution ')"/>
	</xsl:comment>
      </xsl:when>
      <xsl:when test="position() = 1 and not(following-sibling::pkg:transition[1]/make/descendant::*[@name = 'PATH'])">
      <!-- very first source -->
	<xsl:apply-templates select="make/*" />
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="pkg:relation">
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
      <xsl:if test="attribute::select[. = 'PATH']">
        <!-- replace 'PATH' by path value and set type attribute -->
        <xsl:attribute name="select">
          <xsl:value-of select="$str_path" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="text() = 'PATH'">
        <!-- replace 'PATH' by path value and set type attribute -->
        <xsl:value-of select="$str_path" />
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
      <xsl:if test="text() = 'TAG'">
        <!-- replace 'TAG' by path value and set type attribute -->
        <xsl:value-of select="$str_tag" />
      </xsl:if>
      <xsl:if test="attribute::regexp[. = 'RE']">
        <!-- replace 'RE' by path value and set type attribute -->
        <xsl:attribute name="regexp">
          <xsl:value-of select="$str_re" />
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
      <xsl:choose>
	<xsl:when test="text() = 'PATH'"/>
	<xsl:when test="text() = 'XPATH'"/>
	<xsl:otherwise>
	  <xsl:apply-templates />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
