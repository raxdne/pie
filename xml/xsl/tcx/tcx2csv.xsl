<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tcx="http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2" xmlns:tcxx="http://www.garmin.com/xmlschemas/ActivityExtension/v2" version="1.0">
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:variable name="str_nl">
    <xsl:text>
</xsl:text>
  </xsl:variable>
  <xsl:variable name="str_sep">
    <xsl:text>;</xsl:text>
  </xsl:variable>
  <xsl:template match="/|pie|file|dir">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tcx:TrainingCenterDatabase|tcx:Activities">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tcx:Activity">
    <xsl:value-of select="concat($str_nl,tcx:Id,$str_sep,$str_sep,$str_sep,@Sport,$str_nl)"/>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tcx:Lap">
    <xsl:value-of select="concat($str_nl,@StartTime,$str_sep,$str_sep,$str_sep,tcx:DistanceMeters,$str_sep,tcx:TotalTimeSeconds,$str_nl,$str_nl)"/>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tcx:Track">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tcx:Trackpoint">
    <xsl:value-of select="concat(tcx:Time,$str_sep,tcx:DistanceMeters,$str_sep,tcx:HeartRateBpm/tcx:Value,$str_sep,tcx:Extensions/tcxx:TPX/tcxx:Speed,$str_nl)"/>
  </xsl:template>
  <xsl:template match="*|@*|text()"/>
</xsl:stylesheet>
