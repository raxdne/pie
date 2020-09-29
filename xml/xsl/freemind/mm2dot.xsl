<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="../Utils.xsl"/>

  <xsl:output method='text'/>
  <xsl:variable name="l_max" select="40"/>

<xsl:template match="/map">
<xsl:text>
digraph pkg2 {
overlap=&quot;false&quot;;
splines=&quot;true&quot;;
//Damping=&quot;0.5&quot;;
//ratio = &quot;fill&quot;;
fontsize = &quot;8&quot;
fontname = &quot;Helvetica&quot;
</xsl:text>

<xsl:text>

node [
  fontname = &quot;Helvetica&quot;
  //fixedsize= &quot;true&quot;
  shape = &quot;plaintext&quot;
  //fontsize = &quot;9&quot;
  color = &quot;white&quot;
];

edge [
  dir=&quot;none&quot;
  color=&quot;grey&quot;
];

</xsl:text>
<!--
<xsl:for-each select="//node[@TEXT and not(@TEXT='')]">
  <xsl:value-of select="concat(generate-id(.),' [','label=','&quot;',substring(normalize-space(@TEXT),1,$l_max),'&quot;','];',$newline)"/>
</xsl:for-each>
<xsl:value-of select="concat('',$newline)"/>
-->
<xsl:apply-templates/>
<xsl:text>
}

</xsl:text>
</xsl:template>


<xsl:template match="node">
  <xsl:if test="parent::node">
    <!-- <xsl:value-of select="concat(generate-id(.),' -> ',generate-id(parent::node),';',$newline)"/> -->
    <xsl:value-of select="concat('&quot;',substring(normalize-space(@TEXT),1,$l_max),'&quot;',' -> ','&quot;',substring(normalize-space(parent::node/@TEXT),1,$l_max),'&quot;',';',$newline)"/>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="*|text()|comment()"/>
</xsl:stylesheet>
