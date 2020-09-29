<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml"/>
  <xsl:decimal-format name="f1" grouping-separator="." decimal-separator=","/>
  <xsl:key name="listprojects" match="project" use="."/>
  <xsl:key name="listversions" match="version[parent::item]" use="."/>
  <xsl:key name="listcomponents" match="component" use="."/>
  <xsl:template match="/">
    <xsl:element name="pie">
      <xsl:apply-templates select="rss/channel"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="channel">
    <xsl:element name="section">
      <xsl:element name="h">
        <xsl:value-of select="concat('JIRA ','&quot;',title,'&quot;')"/>
      </xsl:element>
      <xsl:apply-templates select="//project[generate-id(.) = generate-id(key('listprojects',.))]"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="project">
    <xsl:variable name="str_h" select="."/>
    <xsl:element name="section">
      <xsl:element name="h">
        <xsl:value-of select="$str_h"/>
      </xsl:element>
      <xsl:apply-templates select="//version[generate-id(.) = generate-id(key('listversions',.))]">
        <xsl:sort select="."/>
        <xsl:with-param name="str_project" select="$str_h"/>
      </xsl:apply-templates>
      <!--  -->
      <xsl:element name="section">
        <xsl:element name="h">
          <xsl:value-of select="'n.n.'"/>
        </xsl:element>
        <xsl:apply-templates select="//component[generate-id(.) = generate-id(key('listcomponents',.))]">
          <xsl:sort select="."/>
          <xsl:with-param name="str_project" select="$str_h"/>
          <xsl:with-param name="str_version" select="''"/>
        </xsl:apply-templates>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="version">
    <xsl:param name="str_project"/>
    <xsl:variable name="str_h" select="."/>
    <xsl:element name="section">
      <xsl:element name="h">
        <xsl:value-of select="$str_h"/>
      </xsl:element>
      <xsl:apply-templates select="//component[generate-id(.) = generate-id(key('listcomponents',.))]">
        <xsl:sort select="."/>
        <xsl:with-param name="str_project" select="$str_project"/>
        <xsl:with-param name="str_version" select="$str_h"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>
  <xsl:template match="component">
    <xsl:param name="str_project"/>
    <xsl:param name="str_version"/>
    <xsl:variable name="str_h" select="."/>
    <xsl:variable name="nodeset_items" select="//item[project = $str_project and (version = $str_version or ($str_version = '' and not(version))) and component = $str_h]"/>
    <xsl:if test="count($nodeset_items)">
      <xsl:element name="section">
        <xsl:element name="h">
          <xsl:value-of select="$str_h"/>
        </xsl:element>
        <xsl:apply-templates select="$nodeset_items">
          <xsl:sort select="key/@id"/>
          <xsl:with-param name="str_project" select="$str_project"/>
          <xsl:with-param name="str_version" select="$str_version"/>
          <xsl:with-param name="str_component" select="$str_h"/>
        </xsl:apply-templates>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template match="item">
    <xsl:param name="str_project"/>
    <xsl:param name="str_version"/>
    <xsl:param name="str_component"/>
    <xsl:element name="task">
      <xsl:choose>
        <xsl:when test="resolved">
          <xsl:attribute name="done">
            <xsl:call-template name="FORMDATE">
              <xsl:with-param name="strDate" select="resolved"/>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="date">
            <xsl:call-template name="FORMDATE">
              <xsl:with-param name="strDate" select="created"/>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:element name="h">
        <xsl:element name="link">
          <xsl:attribute name="href">
            <xsl:value-of select="link"/>
          </xsl:attribute>
          <xsl:value-of select="concat(key,' :: ',summary)"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="FORMDATE">
    <xsl:param name="strDate"/>
    <xsl:variable name="strDateInt">
      <xsl:value-of select="substring-after($strDate,', ')"/>
    </xsl:variable>
    <xsl:variable name="strDateDay">
      <xsl:value-of select="format-number(substring-before($strDateInt,' '),'#.#00','f1')"/>
    </xsl:variable>
    <xsl:variable name="strDateMon">
      <xsl:value-of select="substring-before(substring-after($strDateInt,' '),' ')"/>
    </xsl:variable>
    <xsl:variable name="intDateMon">
      <xsl:choose>
        <xsl:when test="$strDateMon='Jan'">
          <xsl:value-of select="'01'"/>
        </xsl:when>
        <xsl:when test="$strDateMon='Feb'">
          <xsl:value-of select="'02'"/>
        </xsl:when>
        <xsl:when test="$strDateMon='Mar'">
          <xsl:value-of select="'03'"/>
        </xsl:when>
        <xsl:when test="$strDateMon='Apr'">
          <xsl:value-of select="'04'"/>
        </xsl:when>
        <xsl:when test="$strDateMon='May'">
          <xsl:value-of select="'05'"/>
        </xsl:when>
        <xsl:when test="$strDateMon='Jun'">
          <xsl:value-of select="'06'"/>
        </xsl:when>
        <xsl:when test="$strDateMon='Jul'">
          <xsl:value-of select="'07'"/>
        </xsl:when>
        <xsl:when test="$strDateMon='Aug'">
          <xsl:value-of select="'08'"/>
        </xsl:when>
        <xsl:when test="$strDateMon='Sep'">
          <xsl:value-of select="'09'"/>
        </xsl:when>
        <xsl:when test="$strDateMon='Oct'">
          <xsl:value-of select="'10'"/>
        </xsl:when>
        <xsl:when test="$strDateMon='Nov'">
          <xsl:value-of select="'11'"/>
        </xsl:when>
        <xsl:when test="$strDateMon='Dec'">
          <xsl:value-of select="'12'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'xx'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="strDateYear">
      <xsl:value-of select="substring-before(substring-after(substring-after($strDateInt,' '),' '),' ')"/>
    </xsl:variable>
    <xsl:value-of select="concat($strDateYear,$intDateMon,$strDateDay)"/>
  </xsl:template>
  <xsl:template match="*"/>
</xsl:stylesheet>
