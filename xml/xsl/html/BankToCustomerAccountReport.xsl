<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:camt="urn:iso:std:iso:20022:tech:xsd:camt.052.001.06">

  <!--  (p) 2021 A. Tenbusch raxdne@web.de -->
  
  <!-- https://www.iso20022.org/iso-20022-message-definitions  camt.052.001.09 BankToCustomerAccountReportV09 -->

  <xsl:output method="html" encoding="UTF-8" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"/>

  <xsl:decimal-format name="f1" grouping-separator="," decimal-separator="."/>
  
  <xsl:key name="list-unique" match="camt:Ntry" use="concat(camt:BookgDt/camt:Dt,'|',camt:Sts,'|',camt:Amt,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Cdtr/camt:Nm,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Dbtr/camt:Nm)"/> <!--  -->

  <xsl:key name="list-by-name" match="camt:Nm" use="text()"/>

  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
	<xsl:choose>
          <xsl:when test="dir|file|pie/dir|pie/file">
	    <xsl:call-template name="BOOKGLIST"/>
	    <xsl:call-template name="NMLIST"/>
          </xsl:when>
          <xsl:when test="transformYYY">
            <xsl:apply-templates select="document(/transform/@a)/*"/>
          </xsl:when>
	  <xsl:when test="camt:Document">
	    <xsl:call-template name="BOOKGLIST"/>
	    <xsl:call-template name="NMLIST"/>
	    <xsl:for-each select="camt:BkToCstmrAcctRpt/camt:GrpHdr">
	      <xsl:element name="p">
		<xsl:value-of select="concat(camt:MsgId,' ',camt:CreDtTm,' ',camt:MsgRcpt/camt:Nm)"/>
	      </xsl:element>
	    </xsl:for-each>
	  </xsl:when>
	  <xsl:otherwise>
	    <!-- invalid elements -->
          </xsl:otherwise>
	</xsl:choose>
      </xsl:element>
    </xsl:element>
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
	<xsl:apply-templates select="camt:RmtInf"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="camt:RmtInf">
    <xsl:variable name="str_lines">
      <xsl:for-each select="camt:Ustrd">
	<xsl:value-of select="string(.)"/>
      </xsl:for-each>
    </xsl:variable>
    <!--
    <xsl:element name="pre">
      <xsl:for-each select="camt:Ustrd">
	<xsl:value-of select="string(.)"/>
	<xsl:element name="br"/>
      </xsl:for-each>
    </xsl:element>
    -->
    <xsl:element name="span">
      <xsl:value-of select="substring($str_lines,1,3*64)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="BOOKGLIST">
    <xsl:variable name="int_lines">
      <xsl:value-of select="count(/descendant::camt:Ntry[generate-id(.) = generate-id(key('list-unique',concat(camt:BookgDt/camt:Dt,'|',camt:Sts,'|',camt:Amt,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Cdtr/camt:Nm,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Dbtr/camt:Nm)))])"/>
    </xsl:variable>
    <xsl:element name="table">
      <xsl:attribute name="id">
	<xsl:text>bookgtable</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="class">
	<xsl:text>tablesorter</xsl:text>
      </xsl:attribute>
      <xsl:element name="thead">
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
      </xsl:element>
      <xsl:element name="tbody">
	<xsl:apply-templates select="/descendant::camt:Ntry[generate-id(.) = generate-id(key('list-unique',concat(camt:BookgDt/camt:Dt,'|',camt:Sts,'|',camt:Amt,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Cdtr/camt:Nm,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Dbtr/camt:Nm)))]">
          <xsl:sort order="descending" select="camt:BookgDt/camt:Dt"/>
	</xsl:apply-templates>
	<xsl:if test="false()">
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
	      <xsl:value-of select="concat('=SUM(C2:C',$int_lines + 1,')')"/>
	    </xsl:element>
	    <xsl:element name="td">
	      <xsl:value-of select="concat('=SUM(D2:D',$int_lines + 1,')')"/>
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
	</xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="NMLIST">
    <xsl:element name="table">
      <xsl:attribute name="id">
	<xsl:text>nmtable</xsl:text> <!-- TODO: handle multiple tables -->
      </xsl:attribute>
      <xsl:attribute name="class">
	<xsl:text>tablesorter</xsl:text>
      </xsl:attribute>
      <xsl:element name="thead">
	<xsl:element name="tr">
	  <xsl:element name="td">
	    <xsl:text>#</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Amt</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Amt</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Diff</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Nm</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Cnt</xsl:text>
	  </xsl:element>
	  <xsl:element name="th">
	    <xsl:text>Nm</xsl:text>
	  </xsl:element>
	</xsl:element>
      </xsl:element>
      <xsl:element name="tbody">
	<xsl:for-each select="descendant::camt:Nm[generate-id() = generate-id(key('list-by-name', .))]">
	  <xsl:sort select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
	  <xsl:variable name="str_name">
	    <xsl:value-of select="."/>
	  </xsl:variable>
	  <xsl:variable name="int_count">
	    <xsl:value-of select="count(/descendant::camt:Ntry[generate-id(.) = generate-id(key('list-unique',concat(camt:BookgDt/camt:Dt,'|',camt:Sts,'|',camt:Amt,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Cdtr/camt:Nm,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Dbtr/camt:Nm))) and camt:NtryDtls/camt:TxDtls[camt:RltdPties/descendant::camt:Nm = $str_name]])"/>
	  </xsl:variable>
	  <xsl:variable name="sum_dbtr" select="sum(/descendant::camt:Ntry[generate-id(.) = generate-id(key('list-unique',concat(camt:BookgDt/camt:Dt,'|',camt:Sts,'|',camt:Amt,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Cdtr/camt:Nm,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Dbtr/camt:Nm))) and camt:NtryDtls/camt:TxDtls[camt:RltdPties/camt:Dbtr/camt:Nm = $str_name]]/camt:Amt)"/>
	  <xsl:variable name="sum_cdtr" select="sum(/descendant::camt:Ntry[generate-id(.) = generate-id(key('list-unique',concat(camt:BookgDt/camt:Dt,'|',camt:Sts,'|',camt:Amt,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Cdtr/camt:Nm,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Dbtr/camt:Nm))) and camt:NtryDtls/camt:TxDtls[camt:RltdPties/camt:Cdtr/camt:Nm = $str_name]]/camt:Amt)"/>
	  <xsl:element name="tr">
	    <xsl:element name="td">
	      <xsl:value-of select="position()"/>
	    </xsl:element>
	    <xsl:element name="td">
	      <xsl:attribute name="align">right</xsl:attribute>
	      <xsl:value-of select="format-number($sum_dbtr,'#,##0.00','f1')"/>
	    </xsl:element>
	    <xsl:element name="td">
	      <xsl:attribute name="align">right</xsl:attribute>
	      <xsl:value-of select="format-number($sum_cdtr,'#,##0.00','f1')"/>
	    </xsl:element>
	    <xsl:element name="td">
	      <xsl:attribute name="align">right</xsl:attribute>
	      <xsl:value-of select="format-number($sum_dbtr - $sum_cdtr,'#,##0.00','f1')"/>
	    </xsl:element>
	    <xsl:element name="td">
	      <xsl:value-of select="$str_name"/>
	    </xsl:element>
	    <xsl:element name="td">
	      <xsl:value-of select="$int_count"/>
	    </xsl:element>
	    <xsl:element name="td">
	      <xsl:choose>
		<xsl:when test="$int_count = 1">
		  <xsl:apply-templates select="/descendant::camt:Ntry[generate-id(.) = generate-id(key('list-unique',concat(camt:BookgDt/camt:Dt,'|',camt:Sts,'|',camt:Amt,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Cdtr/camt:Nm,'|',camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Dbtr/camt:Nm))) and camt:NtryDtls/camt:TxDtls[camt:RltdPties/descendant::camt:Nm = $str_name]]/camt:NtryDtls/camt:TxDtls/camt:RmtInf" />
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:element>
	  </xsl:element>
	</xsl:for-each>
	
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="HEADER">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta http-equiv="cache-control" content="no-cache"/>
  <meta http-equiv="pragma" content="no-cache"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <xsl:element name="title">
    <xsl:value-of select="node[1]/@TEXT"/>
  </xsl:element>
  <style type="text/css">
body {
  font-family: Arial,sans-serif;
  font-size:12px;
}

pre {
  margin: 2px 2px 2px 2px;
}
  </style>
  <link rel="stylesheet" href="/jquery/tablesorter/css/theme.blue.css"/>
  <script src="/jquery/jquery.js" type="text/javascript">//</script>
  <script src="/jquery/tablesorter/js/jquery.tablesorter.js" type="text/javascript">//</script>

<script type="text/javascript">
  $(function() {

  // initial sort set using sortList option
  $("#bookgtable").tablesorter({
    theme : 'blue',
    widgets: ["filter"],
    widgetOptions : {
      filter_ignoreCase : true
    }
    // sort on the first column and second column in ascending order
    //sortList: [[0,0],[1,0]]
  });

  // initial sort set using data-sortlist attribute (see HTML below)
  $("#nmtable").tablesorter({
    theme : 'blue',
    widgets: ["filter"],
    widgetOptions : {
      filter_ignoreCase : true
    }
   });

  });
  
</script>
</head>    
  </xsl:template>

  <xsl:template match="text()|@*"/>
    
</xsl:stylesheet>
