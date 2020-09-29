<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="xml"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="pie">
    <xsl:element name="{name()}">
    <xsl:element name="vcard">
      <xsl:attribute name="id">
        <xsl:value-of select="translate(substring-after(p[starts-with(.,'N')],':'),';, ','___')"/>
      </xsl:attribute>
      <xsl:apply-templates select="p[starts-with(.,'N')]"/>
      <xsl:apply-templates select="p[starts-with(.,'BDAY')]"/>
      <xsl:apply-templates select="p[starts-with(.,'ADR')]"/>
      <xsl:element name="phone">
        <xsl:apply-templates select="p[starts-with(.,'TEL')]"/>
      </xsl:element>
      <xsl:element name="mail">
        <xsl:apply-templates select="p[starts-with(.,'EMAIL')]"/>
      </xsl:element>
    </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p[substring-before(.,':')='ADR;HOME']">
    <xsl:element name="address">
      <xsl:value-of select="substring-after(.,':')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p[substring-before(.,':')='N']">
    <xsl:variable name="str_value" select="substring-after(.,':')"/>
    <xsl:element name="name">
      <xsl:value-of select="substring-before($str_value,';')"/>
    </xsl:element>
    <xsl:element name="firstname">
      <xsl:choose>
        <xsl:when test="contains(substring-after($str_value,';'),';')">
          <xsl:value-of select="substring-before(substring-after($str_value,';'),';')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring-after($str_value,';')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    <xsl:choose>
      <xsl:when test="substring-after(substring-after(substring-after($str_value,';'),';'),';')='Frau'">
        <xsl:element name="gender">w</xsl:element>
      </xsl:when>
      <xsl:when test="substring-after(substring-after(substring-after($str_value,';'),';'),';')='Herr'">
        <xsl:element name="gender">m</xsl:element>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="p[substring-before(.,':')='BDAY']">
    <xsl:element name="birthday">
      <xsl:value-of select="substring-after(.,':')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p[substring-before(.,':')='TEL;CELL;VOICE']">
    <xsl:element name="mobile">
      <xsl:value-of select="substring-after(.,':')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p[substring-before(.,':')='TEL;HOME;VOICE']">
    <xsl:element name="private">
      <xsl:value-of select="substring-after(.,':')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p[substring-before(.,':')='TEL;WORK;VOICE']">
    <xsl:element name="work">
      <xsl:value-of select="substring-after(.,':')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p[substring-before(.,':')='TITLE']">
    <xsl:element name="p">
      <xsl:value-of select="substring-after(.,':')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p[substring-before(.,':')='EMAIL;PREF;INTERNET']">
    <xsl:element name="private">
      <xsl:value-of select="substring-after(.,':')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*"/>

</xsl:stylesheet>
