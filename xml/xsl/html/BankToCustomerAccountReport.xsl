<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:camt="urn:iso:std:iso:20022:tech:xsd:camt.052.001.06">

  <!--  (p) 2021 A. Tenbusch raxdne@web.de -->
  
  <!-- https://www.iso20022.org/iso-20022-message-definitions  camt.052.001.09 BankToCustomerAccountReportV09 -->

  <xsl:output method="html" encoding="UTF-8" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"/>

  <xsl:decimal-format name="f1" grouping-separator="," decimal-separator="."/>
  
  <xsl:key name="list-by-name" match="camt:Nm" use="text()"/>

  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="head">
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<xsl:call-template name="CREATESTYLE"/>
	<xsl:element name="title">
	  <xsl:value-of select="''"/>
	</xsl:element>
      </xsl:element>
      <xsl:element name="body">
	<xsl:choose>
          <xsl:when test="transform">
            <xsl:apply-templates select="document(/transform/@a)/*"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates />
          </xsl:otherwise>
	</xsl:choose>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="camt:Document">
    <xsl:call-template name="BOOKGLIST"/>
    <xsl:call-template name="NMLIST"/>
  </xsl:template>
  
  <xsl:template match="camt:TxDtls">
    <xsl:element name="tr">
      <xsl:element name="td">
	<xsl:value-of select="../../camt:BookgDt"/>
      </xsl:element>
      <xsl:element name="td">
	<xsl:value-of select="camt:Amt/@Ccy"/>
      </xsl:element>
      <xsl:choose>
	<xsl:when test="camt:CdtDbtInd = 'CRDT'">
	  <xsl:element name="td">
	    <xsl:attribute name="align">right</xsl:attribute>
	    <xsl:value-of select="format-number(camt:Amt,'#,##0.00','f1')"/>
	  </xsl:element>
	  <xsl:element name="td">
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:element name="td">
	  </xsl:element>
	  <xsl:element name="td">
	    <xsl:attribute name="align">right</xsl:attribute>
	    <xsl:value-of select="format-number(camt:Amt,'#,##0.00','f1')"/>
	  </xsl:element>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:element name="td">
	<xsl:value-of select="camt:RltdPties/camt:Dbtr/camt:Nm"/>
      </xsl:element>
      <xsl:element name="td">
	<xsl:value-of select="camt:RltdPties/camt:Cdtr/camt:Nm"/>
      </xsl:element>
      <xsl:element name="td">
	<xsl:for-each select="camt:RmtInf/camt:Ustrd">
	  <xsl:if test="position() &gt; 1">
	    <!-- <xsl:element name="br"/> -->
	    <xsl:text> </xsl:text>
	  </xsl:if>
	  <xsl:value-of select="string(.)"/>
	</xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="BOOKGLIST">
    <xsl:variable name="int_lines">
      <xsl:value-of select="count(descendant::camt:Ntry)"/>
    </xsl:variable>
    <xsl:element name="table">
      <xsl:element name="tbody">
	<xsl:element name="tr">
	  <xsl:element name="th">
	    <xsl:text>BookgDt</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Ccy</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Amt</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Amt</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Dbtr</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Cdtr</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>RmtInf</xsl:text>
	  </xsl:element>
	</xsl:element>
	<xsl:apply-templates />
	<xsl:element name="tr">
	  <!-- empty line -->
	</xsl:element>
	<xsl:element name="tr">
	  <xsl:element name="td">
	    <xsl:text>Sum</xsl:text>
	  </xsl:element>
	  <xsl:element name="td">
	  </xsl:element>
	  <xsl:element name="td">
	    <xsl:value-of select="concat('=SUM(C1:C',$int_lines + 1,')')"/>
	  </xsl:element>
	  <xsl:element name="td">
	    <xsl:value-of select="concat('=SUM(D1:D',$int_lines + 1,')')"/>
	  </xsl:element>
	</xsl:element>
	<xsl:element name="tr">
	  <!-- empty line -->
	</xsl:element>
	<xsl:element name="tr">
	  <xsl:element name="td">
	  </xsl:element>
	  <xsl:element name="td">
	  </xsl:element>
	  <xsl:element name="td">
	    <xsl:value-of select="concat('=C',$int_lines + 3,' - D',$int_lines + 3)"/>
	  </xsl:element>
	</xsl:element>    
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="NMLIST">
    <xsl:element name="table">
      <xsl:element name="tbody">
	<xsl:element name="tr">
	  <xsl:element name="td">
	  </xsl:element>
	  <xsl:element name="td">
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Amt</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Amt</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Nm</xsl:text>
	  </xsl:element>
	</xsl:element>

	<xsl:for-each select="descendant::camt:Nm[generate-id() = generate-id(key('list-by-name', .))]">
	  <xsl:sort select="."/>

	  <xsl:variable name="str_name">
	    <xsl:value-of select="."/>
	  </xsl:variable>

	  <xsl:element name="tr">
	    <xsl:element name="td">
	    </xsl:element>
	    <xsl:element name="td">
	    </xsl:element>
	    <xsl:element name="td">
	      <xsl:attribute name="align">right</xsl:attribute>
	      <xsl:value-of select="format-number(sum(/descendant::camt:TxDtls[camt:RltdPties/camt:Dbtr/camt:Nm = $str_name]/camt:Amt),'#,##0.00','f1')"/>
	    </xsl:element>
	    <xsl:element name="td">
	      <xsl:attribute name="align">right</xsl:attribute>
	      <xsl:value-of select="format-number(sum(/descendant::camt:TxDtls[camt:RltdPties/camt:Cdtr/camt:Nm = $str_name]/camt:Amt),'#,##0.00','f1')"/>
	    </xsl:element>
	    <xsl:element name="td">
	      <xsl:value-of select="$str_name"/>
	    </xsl:element>
	    <xsl:element name="td">
	      <xsl:if test="count(/descendant::camt:TxDtls[camt:RltdPties/camt:Cdtr/camt:Nm = $str_name]) &lt; 2">
		<xsl:for-each select="/descendant::camt:TxDtls[camt:RltdPties/camt:Cdtr/camt:Nm = $str_name]/camt:RmtInf/camt:Ustrd">
		  <xsl:if test="position() &gt; 1">
		    <!-- <xsl:element name="br"/> -->
		    <xsl:text> </xsl:text>
		  </xsl:if>
		  <xsl:value-of select="string(.)"/>
		</xsl:for-each>
	      </xsl:if>
	    </xsl:element>
	  </xsl:element>
	</xsl:for-each>
	
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
<xsl:template name="CREATESTYLE">
    <xsl:element name="style">

body,table {
  background-color:#ffffff;
  font-family: Arial,sans-serif;
  /* font-family:Courier; */
  font-size:12px;
  margin: 5px 5px 5px 5px;
}

/* settings for tables
 */

table {
  width: 95%;
  border-collapse: collapse;
  empty-cells:show;
  margin-left:auto;
  margin-right:auto;
  border: 1px solid grey;
}

tr {
}

/* data cells */
td {
  border: 1px solid grey;
  vertical-align:top;
  padding: 5px;
  }
.empty {
  margin-bottom:0px;
}

/* header cells */
th {
  border: 1px solid grey;
  margin-bottom:0px;
  text-align:left;
  background-color:#d9d9d9;
  color:#000000;
  font-weight:bold;
}
th.header {
  margin-bottom:0px;
  text-align:left;
  background-color:#d9d9d9;
  font-weight:bold;
}
   </xsl:element>
 </xsl:template>

 <xsl:template match="text()|@*"/>
    
</xsl:stylesheet>
