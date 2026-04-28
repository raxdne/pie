<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- simple XML statistics for comparison -->
  
  <xsl:output method="text"/>

  <xsl:key name="listnames" match="node()" use="name()"/>

  <xsl:template match="/">
    <xsl:for-each select="descendant::node()[generate-id(.) = generate-id(key('listnames',name()))]"> <!--  -->
      <xsl:sort select="name()"/>
      <xsl:variable name="name_str" select="name()"/>
      <xsl:value-of select="concat($name_str,': ',count(/descendant::node()[name() = $name_str]),'&#10;')"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="text()|comment()"/>

</xsl:stylesheet>
