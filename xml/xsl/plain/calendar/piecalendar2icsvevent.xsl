<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!--  -->
  <xsl:key name="listentries" match="task[@date and (@effort or @impact) and not(@done)]" use="@idref"/>
  <xsl:decimal-format name="f1" grouping-separator="." decimal-separator=","/>
  <xsl:output encoding="UTF-8" method="text"/>
  <xsl:template match="/">
    <xsl:text>BEGIN:VCALENDAR
METHOD:PUBLISH
VERSION:2.0
PRODID:-//CXPROC PIE Calendar//DE
</xsl:text>
    <xsl:for-each select="/calendar/year/month/day/col/task[generate-id(.) = generate-id(key('listentries',@idref))]">
      <xsl:variable name="str_idref" select="@idref"/>
      <xsl:apply-templates select="/calendar/year/month/day/col/task[@idref = $str_idref and parent::col/parent::day/@diff &gt; -180]"/>
    </xsl:for-each>
    <xsl:text>END:VCALENDAR
</xsl:text>
  </xsl:template>
  <xsl:template match="task">
    <xsl:text>
BEGIN:VEVENT
CLASS:PUBLIC
</xsl:text>
    <xsl:value-of select="concat('SUMMARY:',@hstr,normalize-space(h),'&#10;')"/>
    <!--  -->
    <xsl:value-of select="concat('DTSTART:',parent::col/parent::day/parent::month/parent::year/attribute::ad,parent::col/parent::day/parent::month/attribute::nr,parent::col/parent::day/attribute::om,'T000000&#10;')"/>
    <xsl:text>END:VEVENT
</xsl:text>
  </xsl:template>
</xsl:stylesheet>
