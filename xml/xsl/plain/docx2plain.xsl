<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" mc:Ignorable="w14 wp14">

  <!-- https://www.data2type.de/xml-xslt-xslfo/wordml -->
  
  <xsl:output method="text" encoding="UTF-8"/>
  
  <xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>
  
<xsl:variable name="newpar">
<xsl:text>

</xsl:text>
</xsl:variable>
  

  <xsl:template match="/">
    <xsl:apply-templates select="//w:document/w:body/*"/>
  </xsl:template>

  <xsl:template match="w:p">
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates/>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="w:r">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="w:t">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="w:tab">
    <xsl:value-of select="'	'"/>
  </xsl:template>

  <xsl:template match="w:br">
    <xsl:value-of select="$newpar"/>
  </xsl:template>

  <xsl:template match="w:*|wp:*|a:*"/>
  
</xsl:stylesheet>
