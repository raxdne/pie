<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cxp="http://www.tenbusch.info/cxproc/" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:rpt="http://openoffice.org/2005/report" xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:grddl="http://www.w3.org/2003/g/data-view#" xmlns:tableooo="http://openoffice.org/2009/table" xmlns:field="urn:openoffice:names:experimental:ooo-ms-interop:xmlns:field:1.0" xmlns:formx="urn:openoffice:names:experimental:ooxml-odf-interop:xmlns:form:1.0" xmlns:css3t="http://www.w3.org/TR/css3-text/" office:version="1.2" grddl:transformation="http://docs.oasis-open.org/office/1.2/xslt/odf2rdf.xsl" version="1.0">
  <!--  -->
  <xsl:output method="xml" encoding="UTF-8"/>

  <xsl:template match="pie|dir|file|archive|office:document-content|office:body">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="office:spreadsheet">
    <xsl:element name="pie">
      <xsl:apply-templates select="table:table" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="table:table">
    <xsl:element name="section">
      <xsl:element name="h">
	<xsl:value-of select="@table:name"/>
      </xsl:element>
      <xsl:element name="table">
	<xsl:for-each select="table:table-row">
          <xsl:element name="tr">
	    <xsl:for-each select="table:table-cell">
	      <xsl:call-template name="repeatColumn"/>
	    </xsl:for-each>
          </xsl:element>
	</xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="*"/>

  <xsl:template name="repeatColumn">
    <xsl:param name="intCount" select="0"/>
    <xsl:element name="td">
      <!-- TODO: "//style:style[@style:name=$str_style]/style:table-cell-properties/@fo:background-color" -->
      <xsl:value-of select="text:p"/>
    </xsl:element>
    <xsl:choose>
      <xsl:when test="not(following-sibling::table:table-cell[text:p])">
	<!-- interrupt recursion -->
      </xsl:when>
      <xsl:when test="$intCount = 0 and @table:number-columns-repeated &gt; 1">
	<!-- template recursion -->
	<xsl:call-template name="repeatColumn">
	  <xsl:with-param name="intCount" select="@table:number-columns-repeated - 1"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="$intCount &gt; 1">
	<!-- template recursion -->
	<xsl:call-template name="repeatColumn">
	  <xsl:with-param name="intCount" select="$intCount - 1"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<!-- interrupt recursion -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
