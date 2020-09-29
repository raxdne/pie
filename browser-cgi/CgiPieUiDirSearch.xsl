<?xml version="1.0"?>
<xsl:stylesheet xmlns:cxp="http://www.tenbusch.info/cxproc" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../xsl/html/PieHtml.xsl"/>
  <xsl:variable name="file_css" select="'/pie/non-js/CgiPieUi.css'"/>
<!--  -->
  <xsl:variable name="flag_header" select="true()"/>
<!--  -->
  <xsl:variable name="dir_prefix" select="''"/>
<!--  -->
  <xsl:variable name="str_path" select="''"/>
  <xsl:variable name="length_link" select="-1"/>
  <xsl:output method="html" encoding="UTF-8"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="body">
        <form method="post">
          <input type="hidden" name="cxp" value="PieUiDirSearchResult"/>
          <input type="hidden" name="path" value="{$str_path}"/>
          <table class="unlined" cellspacing="20" cellpadding="10">
            <tbody>
              <tr>
                <th colspan="2"><input type="submit" value="Search"/> in current directory for</th>
              </tr>
              <tr>
                <td>files containing</td>
                <td>
                  <input class="additor" name="needle" type="text" size="30" value=""/>
                </td>
              </tr>
              <tr>
                <td>files named</td>
                <td>
                  <input class="additor" name="patternname" type="text" size="30" value="^.+(pie|txt|cal|mm)$"/>
                </td>
              </tr>
            </tbody>
          </table>
        </form>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
