<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cxp="http://www.tenbusch.info/cxproc" version="1.0">
  <xsl:output method="xml"/>
  <xsl:template match="/">
    <xsl:element name="pie">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="cxp:info">
    <xsl:element name="section">
      <xsl:element name="h">PIE</xsl:element>
      <xsl:for-each select="cxp:program[1]">
        <xsl:element name="section">
          <xsl:element name="h">
            <xsl:element name="link">
              <xsl:attribute name="href">
                <xsl:value-of select="@ns"/>
              </xsl:attribute>
              <xsl:value-of select="@name"/>
            </xsl:element>
            <xsl:value-of select="concat(' (',cxp:source/@version,')')"/>
          </xsl:element>
          <xsl:element name="p">
            <xsl:value-of select="concat('Compiled on ',cxp:compilation/@platform,' at ',cxp:compilation/@date,' as ','&quot;',cxp:compilation/@lang,'&quot;')"/>
	    <xsl:if test="cxp:compilation/@experimental = 'yes'">
	      <xsl:text>, with experimental features</xsl:text>
	    </xsl:if>
	    <xsl:if test="cxp:compilation/@debug = 'yes'">
	      <xsl:text>, with debugging information</xsl:text>
	    </xsl:if>
	    <xsl:text>.</xsl:text>
          </xsl:element>
          <xsl:element name="p">Required libs</xsl:element>
          <xsl:element name="list">
            <xsl:for-each select="cxp:lib">
              <xsl:element name="p">
                <xsl:element name="link">
                  <xsl:attribute name="href">
                    <xsl:value-of select="@ns"/>
                  </xsl:attribute>
                  <xsl:value-of select="@name"/>
                </xsl:element>
                <xsl:value-of select="concat(' (',@version,')')"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
	  <xsl:if test="cxp:option[@select='yes']">
            <xsl:element name="p">Optional libs</xsl:element>
            <xsl:element name="list">
              <xsl:for-each select="cxp:option[@select='yes']">
		<xsl:element name="p">
                  <xsl:element name="link">
                    <xsl:attribute name="href">
                      <xsl:value-of select="@ns"/>
                    </xsl:attribute>
                    <xsl:value-of select="@name"/>
                  </xsl:element>
                  <xsl:value-of select="concat(' (',@version,')')"/>
		</xsl:element>
              </xsl:for-each>
            </xsl:element>
	  </xsl:if>
	  <xsl:if test="cxp:module[@select='yes']">
            <xsl:element name="p">Optional modules</xsl:element>
            <xsl:element name="list">
              <xsl:for-each select="cxp:module[@select='yes']">
		<xsl:element name="p">
                  <xsl:element name="link">
                    <xsl:attribute name="href">
                      <xsl:value-of select="@ns"/>
                    </xsl:attribute>
                    <xsl:value-of select="@name"/>
                  </xsl:element>
                  <xsl:value-of select="concat(' (',@version,')')"/>
		</xsl:element>
              </xsl:for-each>
            </xsl:element>
	  </xsl:if>
        </xsl:element>
      </xsl:for-each>
      <xsl:element name="section">
        <xsl:element name="h">Web UI</xsl:element>
        <xsl:element name="list">
          <xsl:element name="p">
            <xsl:element name="link">
              <xsl:attribute name="href">http://jQuery.com/</xsl:attribute>
              <xsl:text>jQuery</xsl:text>
            </xsl:element>
          </xsl:element>
          <xsl:element name="p">
            <xsl:element name="link">
              <xsl:attribute name="href">http://jQueryui.com/</xsl:attribute>
              <xsl:text>jQuery UI</xsl:text>
            </xsl:element>
          </xsl:element>
          <xsl:element name="p">
            <xsl:element name="link">
              <xsl:attribute name="href">https://jquerymobile.com/</xsl:attribute>
              <xsl:text>jQuery Mobile</xsl:text>
            </xsl:element>
          </xsl:element>
          <xsl:element name="p">
            <xsl:element name="link">
              <xsl:attribute name="href">https://mottie.github.io/tablesorter/docs/</xsl:attribute>
              <xsl:text>jQuery tablesorter</xsl:text>
            </xsl:element>
          </xsl:element>
          <xsl:element name="p">
            <xsl:element name="link">
              <xsl:attribute name="href">https://github.com/swisnl/jQuery-contextMenu</xsl:attribute>
              <xsl:text>jQuery contextMenu</xsl:text>
            </xsl:element>
            <xsl:text/>
          </xsl:element>
          <xsl:element name="p">
            <xsl:element name="link">
              <xsl:attribute name="href">https://github.com/raxdne/pie</xsl:attribute>
              <xsl:text>PIE</xsl:text>
            </xsl:element>
          </xsl:element>
	</xsl:element>
      </xsl:element>
      <xsl:for-each select="cxp:runtime">
        <xsl:if test="cxp:env[@name = 'SERVER_SOFTWARE' and not(@select = '')]">
          <xsl:element name="section">
            <xsl:element name="h">Web Server</xsl:element>
            <xsl:element name="list">
              <xsl:element name="p">
                <xsl:element name="link">
                  <xsl:attribute name="href">?</xsl:attribute>
		  <xsl:text>Runtime environment</xsl:text>
		</xsl:element>
              </xsl:element>
              <xsl:element name="p">
                <xsl:value-of select="concat('System time at ',cxp:env[@name='SERVER_NAME']/@select,': ',cxp:date/@year,'-',cxp:date/@month,'-',cxp:date/@day,' ',cxp:date/@hour,':',cxp:date/@minute,':',cxp:date/@second)"/>
              </xsl:element>
              <xsl:for-each select="cxp:env[@name = 'SERVER_SOFTWARE']">
                <xsl:element name="p">
                  <xsl:value-of select="@select"/>
                  <xsl:choose>
                    <xsl:when test="contains(@select,'Apache')">
                      <xsl:text>: </xsl:text>
                      <xsl:element name="link">
                        <xsl:attribute name="href">/server-info</xsl:attribute>
                        <xsl:text>Info</xsl:text>
                      </xsl:element>
                      <xsl:text> / </xsl:text>
                      <xsl:element name="link">
                        <xsl:attribute name="href">/server-status</xsl:attribute>
                        <xsl:text>Status</xsl:text>
                      </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                  </xsl:otherwise>
                  </xsl:choose>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
