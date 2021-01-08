<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!--  -->
  <xsl:variable name="nl">
    <xsl:text>
</xsl:text>
  </xsl:variable>
  <xsl:key name="listevents" match="*[@date and not(@done)]" use="@idref"/>
  <xsl:decimal-format name="f1" grouping-separator="." decimal-separator=","/>
  <xsl:output encoding="UTF-8" method="text"/>

  <xsl:template match="/">
    <xsl:for-each select="//*[@date and not(@done) and generate-id(.) = generate-id(key('listevents',@idref))]">
      <xsl:call-template name="EVENT">
	<xsl:with-param name="str_idref" select="@idref"/>
      </xsl:call-template>  
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="EVENT">
    <xsl:param name="str_idref" select="''"/>
    <xsl:for-each select="//*[@idref = $str_idref]">
      <!-- switch to event context -->
      <xsl:call-template name="VEVENT"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="VEVENT">
    <!--  -->
    <xsl:choose>
      <xsl:when test="self::task">
	<xsl:value-of select="concat('SUMMARY:',translate(normalize-space(h),':','-'),$nl)"/>
      </xsl:when>
      <xsl:when test="self::p">
	<xsl:value-of select="concat('SUMMARY:',translate(normalize-space(.),':','-'),$nl)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('SUMMARY:',translate(.,':','-'),$nl)"/>
      </xsl:otherwise>
    </xsl:choose>

<xsl:if test="@hstr">
  <xsl:value-of select="concat('DESCRIPTION:',translate(@hstr,':','-'),$nl)"/>
</xsl:if>

<xsl:value-of select="concat('DTSTAMP:',parent::col/parent::day/parent::month/parent::year/attribute::ad,parent::col/parent::day/parent::month/attribute::nr,parent::col/parent::day/attribute::om,'T','000000Z',$nl)"/>
    <xsl:value-of select="concat('CREATED:',parent::col/parent::day/parent::month/parent::year/attribute::ad,parent::col/parent::day/parent::month/attribute::nr,parent::col/parent::day/attribute::om,'T','000000Z',$nl)"/>
    <xsl:choose>
      <xsl:when test="@hour">
    <xsl:value-of select="concat('DTSTART;TZID=Europe/Berlin:',parent::col/parent::day/parent::month/parent::year/attribute::ad,parent::col/parent::day/parent::month/attribute::nr,parent::col/parent::day/attribute::om,'T',format-number(@hour,'00','f1'),format-number(@minute,'00','f1'),format-number(@second,'00','f1'),$nl)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('DTSTART;VALUE=DATE:',parent::col/parent::day/parent::month/parent::year/attribute::ad,parent::col/parent::day/parent::month/attribute::nr,parent::col/parent::day/attribute::om,$nl)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="@hour-end">
    <xsl:value-of select="concat('DTEND;TZID=Europe/Berlin:',parent::col/parent::day/parent::month/parent::year/attribute::ad,parent::col/parent::day/parent::month/attribute::nr,parent::col/parent::day/attribute::om,'T',format-number(@hour-end,'00','f1'),format-number(@minute-end,'00','f1'),format-number(@second-end,'00','f1'),$nl)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('DTEND;VALUE=DATE:',parent::col/parent::day/parent::month/parent::year/attribute::ad,parent::col/parent::day/parent::month/attribute::nr,parent::col/parent::day/attribute::om,$nl)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
