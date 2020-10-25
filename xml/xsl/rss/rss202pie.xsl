<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" version="1.0">
	<xsl:output method="xml" encoding="UTF-8"/>
	<!--  -->
	<xsl:variable name="entry_max" select="-1"/>
	<!--  -->
	<xsl:variable name="flag_description" select="false()"/>
	<xsl:template match="/">
		<xsl:element name="pie">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="rss">
		<xsl:element name="section">
			<xsl:for-each select="child::channel">
				<xsl:element name="h">
					<xsl:element name="link">
						<xsl:attribute name="href">
							<xsl:value-of select="child::link"/>
						</xsl:attribute>
						<xsl:value-of select="child::title"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="list">
					<xsl:attribute name="enum">yes</xsl:attribute>
					<xsl:for-each select="child::item[$entry_max &lt; 0 or position() &lt;= $entry_max]">
						<xsl:element name="p">
							<xsl:element name="link">
								<xsl:attribute name="href">
									<xsl:value-of select="child::link"/>
								</xsl:attribute>
								<xsl:value-of select="child::title"/>
							</xsl:element>
							<xsl:if test="$flag_description">
								<xsl:text>  </xsl:text>
								<xsl:value-of select="child::description"/>
							</xsl:if>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
