<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="PieHtml.xsl"/>

  <!-- -->
  <xsl:variable name="file_norm"></xsl:variable>
  <!-- -->
  <xsl:variable name="int_depth" select="-1"/>

  <xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>

  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="body">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="pie">
    <xsl:element name="ul">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="section|task|fig">
    <xsl:element name="li">
      <xsl:call-template name="ADDSTYLE">
        <xsl:with-param name="flag_background" select="false()"/>
      </xsl:call-template>
      <xsl:apply-templates select="h"/>
      <xsl:choose>
        <xsl:when test="count(*[not(name(.) = 'h') and not(name(.) = 't')]) = count(*[name(.) = 'list'])">
          <xsl:apply-templates select="*[not(name(.) = 'h') and not(name(.) = 't')]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="ul">
            <xsl:apply-templates select="*[not(name(.) = 'h') and not(name(.) = 't')]"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="table">	<!-- TODO: transform table to list -->
    <xsl:for-each select="tr[1]/*">
      <xsl:variable name="int_col" select="position()"/>
      <xsl:choose>
        <xsl:when test="self::th">
          <!-- there is a header cell -->
          <xsl:element name="li">
            <xsl:apply-templates select="self::th"/>
            <xsl:element name="ul">
              <xsl:for-each select="../../tr[position() &gt; 1]">
                <xsl:for-each select="*[position() = $int_col]">
                  <xsl:element name="li">
                    <xsl:apply-templates/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <!-- there is no header cell -->
          <xsl:element name="ul">
            <xsl:attribute name="style">margin-bottom:10px;</xsl:attribute>
            <xsl:for-each select="../../tr">
              <xsl:for-each select="*[position() = $int_col]">
                <xsl:element name="li">
                  <xsl:apply-templates/>
                </xsl:element>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="list">
    <xsl:if test="child::node()">
      <xsl:choose>
        <xsl:when test="@enum = 'yes'">
          <!-- numerated list -->
          <xsl:element name="ol">
            <xsl:apply-templates/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <!-- para -->
          <xsl:element name="ul">
            <xsl:apply-templates/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="task">
    <xsl:element name="li">
      <xsl:call-template name="FORMATTASK"/>
      <xsl:apply-templates select="*[not(name()='h')]"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p">
    <!-- para -->
    <xsl:variable name="int_depth_i" select="count(ancestor::p|ancestor::list|ancestor::task|ancestor::section)"/>
    <xsl:if test="$int_depth &lt; 0 or $int_depth_i &lt;= $int_depth">
      <xsl:element name="li">
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tt">
    <xsl:element name="i">	<!-- to avoid issues when copying into MS Powerpoint -->
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[@valid='no']|hr|img">
    <!-- ignore this elements -->
  </xsl:template>

  <xsl:template match="meta|pre">
    <!-- ignore this elements -->
  </xsl:template>
  
</xsl:stylesheet>
