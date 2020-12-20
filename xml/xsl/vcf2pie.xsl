<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">

	<xsl:output method="xml"/>

	<xsl:template match="/">
		<xsl:element name="pie">
			<xsl:apply-templates/>
			<xsl:call-template name="AB2"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="properties">
		<xsl:element name="section">
			<xsl:element name="h">
				<xsl:apply-templates select="n/text"/>
			</xsl:element>
			<xsl:element name="table">
				<xsl:element name="tr">
					<xsl:element name="th">
						<xsl:attribute name="colspan">2</xsl:attribute>
						<xsl:for-each select="child::n/child::text">
							<xsl:value-of select="concat(text(),' ')"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
				<xsl:for-each select="child::*">
					<xsl:element name="tr">
						<xsl:element name="td">
							<xsl:value-of select="name()"/>
							<xsl:for-each select="child::parameters/child::type">
								<xsl:value-of select="concat(', ',text())"/>
							</xsl:for-each>
						</xsl:element>
						<xsl:element name="td">
							<xsl:value-of select="child::text"/>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template name="AB">
		<xsl:element name="table">
			<xsl:for-each select="descendant::vcard/child::properties">
				<xsl:element name="tr">
					<xsl:element name="th">
						<xsl:attribute name="colspan">2</xsl:attribute>
						<xsl:for-each select="child::n/child::text">
							<xsl:value-of select="concat(text(),' ')"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
				<xsl:for-each select="child::*">
					<xsl:element name="tr">
						<xsl:element name="td">
							<xsl:value-of select="name()"/>
							<xsl:for-each select="child::parameters/child::type">
								<xsl:value-of select="concat(', ',text())"/>
							</xsl:for-each>
						</xsl:element>
						<xsl:element name="td">
							<xsl:value-of select="child::text"/>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template name="AB2">
		<xsl:element name="table">
			<xsl:for-each select="descendant::vcard/child::properties">
				<xsl:element name="tr">
					<xsl:element name="td">
						<xsl:for-each select="child::n/child::text">
							<xsl:if test="string-length() &gt; 0 and position() &gt; 1">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:value-of select="text()"/>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="td">
						<xsl:for-each select="child::org/child::text">
							<xsl:if test="string-length() &gt; 0 and position() &gt; 1">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:value-of select="text()"/>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="td">
						<xsl:for-each select="child::title/child::text">
							<xsl:if test="string-length() &gt; 0 and position() &gt; 1">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:value-of select="text()"/>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="td">
						<xsl:for-each select="child::tel">
							<xsl:if test="string-length(child::text) &gt; 0 and position() &gt; 1">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:element name="link">
								<xsl:attribute name="href">
									<xsl:value-of select="concat('tel:',translate(child::text,'- /',''))"/>
								</xsl:attribute>
								<xsl:value-of select="child::text"/>
							</xsl:element>
							<xsl:value-of select="concat(' (',child::parameters/child::type[1],')')"/>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="td">
						<xsl:for-each select="child::email/child::text">
							<xsl:if test="string-length() &gt; 0 and position() &gt; 1">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:element name="link">
								<xsl:attribute name="href">
									<xsl:value-of select="concat('mailto:',text())"/>
								</xsl:attribute>
								<xsl:value-of select="text()"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
