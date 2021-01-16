<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml" xmlns:php="http://php.net/xsl" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.0" exclude-result-prefixes="xhtml php xsl office style text table draw fo xlink">

  <xsl:output method="xml" encoding="UTF-8" version="1.0"/>

  <xsl:variable name="str_path" select="''" />

  <xsl:template match="/">
    <xsl:element name="pie" xmlns="http://www.tenbusch.info/cxproc/">
      <xsl:attribute name="class">
        <xsl:text>odt</xsl:text>
      </xsl:attribute>
      <xsl:choose>
	<xsl:when test="string-length($str_path) &gt; 0">
	  <xsl:attribute name="context">
	    <xsl:value-of select="$str_path"/>
	  </xsl:attribute>
	</xsl:when>
	<xsl:when test="pie/file/@name">
	  <xsl:attribute name="context">
	    <xsl:value-of select="concat(pie/file/@prefix,'/',pie/file/@name)"/>
	  </xsl:attribute>
	</xsl:when>
	<xsl:otherwise>
	  <!-- no locator found -->
	</xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
	<xsl:when test="pie//file/archive/file[@name = 'content.xml']/office:document-content">
	  <xsl:apply-templates select="pie//file/archive/file[@name = 'content.xml']/office:document-content/office:body/office:text"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="//office:document-content/office:body/office:text"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="office:text">
    <xsl:element name="section">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="text:h">
    <xsl:element name="h">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="text:a">
    <xsl:element name="link">
      <xsl:attribute name="href">
        <xsl:value-of select="@xlink:href"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="text:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <xsl:template match="text:span[@text:style-name]">
    <xsl:call-template name="apply-style"/>
  </xsl:template>
  <xsl:template name="apply-style">
    <xsl:variable name="style" select="/office:document-content/office:automatic-styles/style:style[@style:name = current()/@text:style-name]"/>
    <xsl:call-template name="apply-font-weight">
      <xsl:with-param name="style" select="$style"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="apply-font-weight">
    <xsl:param name="style"/>
    <xsl:choose>
      <xsl:when test="$style/style:text-properties[@fo:font-weight = 'bold']">
        <b>
          <xsl:call-template name="apply-font-style">
            <xsl:with-param name="style" select="$style"/>
          </xsl:call-template>
        </b>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="apply-font-style">
          <xsl:with-param name="style" select="$style"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="apply-font-style">
    <xsl:param name="style"/>
    <xsl:choose>
      <xsl:when test="$style/style:text-properties[@fo:font-style = 'italic']">
        <i>
          <xsl:call-template name="apply-text-underline">
            <xsl:with-param name="style" select="$style"/>
          </xsl:call-template>
        </i>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="apply-text-underline">
          <xsl:with-param name="style" select="$style"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="apply-text-underline">
    <xsl:param name="style"/>
    <xsl:choose>
      <xsl:when test="$style/style:text-properties[@style:text-underline-width = 'auto']">
        <u>
          <xsl:call-template name="apply-text-subsup">
            <xsl:with-param name="style" select="$style"/>
          </xsl:call-template>
        </u>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="apply-text-subsup">
          <xsl:with-param name="style" select="$style"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="apply-text-subsup">
    <xsl:param name="style"/>
    <xsl:choose>
      <xsl:when test="$style/style:text-properties[contains(@style:text-position,'sub')]">
        <sub>
          <xsl:call-template name="apply-last">
            <xsl:with-param name="style" select="$style"/>
          </xsl:call-template>
        </sub>
      </xsl:when>
      <xsl:when test="$style/style:text-properties[contains(@style:text-position,'super')]">
        <sup>
          <xsl:call-template name="apply-last">
            <xsl:with-param name="style" select="$style"/>
          </xsl:call-template>
        </sup>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="apply-last">
          <xsl:with-param name="style" select="$style"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="apply-last">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="text:list">
    <xsl:variable name="style" select="/office:document-content/office:automatic-styles/text:list-style[@style:name = current()/@text:style-name]"/>
    <xsl:choose>
      <xsl:when test="$style/text:list-level-style-number">
        <ol>
          <xsl:apply-templates/>
        </ol>
      </xsl:when>
      <xsl:otherwise>
        <ul>
          <xsl:apply-templates/>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="text:list-item/text:p">
    <xsl:call-template name="apply-style"/>
  </xsl:template>
  <xsl:template match="text:list-item">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  <xsl:template match="table:table">
    <table>
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  <xsl:template match="table:table-row">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>
  <xsl:template match="table:table-cell[local-name(../..) = 'table-header-rows']">
    <th>
      <xsl:apply-templates/>
    </th>
  </xsl:template>
  <xsl:template match="table:table-cell" name="table-cell">
    <td>
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  <xsl:template match="text:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <xsl:template match="draw:frame/draw:image">
    <img src="{@src}"/>
  </xsl:template>
</xsl:stylesheet>
