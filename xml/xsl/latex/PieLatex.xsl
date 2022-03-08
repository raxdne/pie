<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../Utils.xsl"/>
  <xsl:variable name="flag_fig" select="true()"/>

  <xsl:template match="section">
    <xsl:choose>
      <xsl:when test="child::h">
        <xsl:choose>
          <xsl:when test="count(ancestor::section) &lt; 3">
            <xsl:text>\</xsl:text>
            <xsl:for-each select="ancestor::section">
              <xsl:text>sub</xsl:text>
            </xsl:for-each>
            <xsl:text>section{</xsl:text>
            <xsl:apply-templates select="h"/>
            <xsl:text>}</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="h"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$newline"/>
        <xsl:value-of select="$newline"/>
        <xsl:apply-templates select="*[not(name(.) = 'h')]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="task">
    <xsl:choose>
      <xsl:when test="name(parent::node()) = 'list'">
	<!-- list item -->
        <xsl:text>\item </xsl:text>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>\texttt{</xsl:text>
    <xsl:call-template name="FORMATTASKPREFIX"/>
    <xsl:text>}</xsl:text>
    <xsl:apply-templates select="h"/>
    <xsl:call-template name="FORMATIMPACT"/>
    <xsl:value-of select="concat('',$newpar)"/>
    <xsl:apply-templates select="*[not(name()='h')]"/>
  </xsl:template>

  <xsl:template match="list">
    <xsl:value-of select="$newline"/>
    <xsl:if test="child::node()">
      <xsl:choose>
        <xsl:when test="@enum = 'yes'">
          <!-- numerated list -->
          <xsl:text>\begin{enumerate}</xsl:text>
          <xsl:value-of select="$newline"/>
          <xsl:apply-templates/>
          <xsl:text>\end{enumerate}</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- para -->
          <xsl:text>\begin{itemize}</xsl:text>
          <xsl:value-of select="$newline"/>
          <xsl:apply-templates/>
          <xsl:text>\end{itemize}</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="link">
    <xsl:choose>
      <xsl:when test="@href">
        <!--  -->
        <xsl:text>\href{</xsl:text>
        <xsl:value-of select="@href"/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- name -->
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="htag|tag">
    <xsl:text>\underline{</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="b|u|i|em|strong|tt">
    <xsl:choose>
      <xsl:when test="name() = 'em'">
        <xsl:text>\textit</xsl:text>
      </xsl:when>
      <xsl:when test="name() = 'strong'">
        <xsl:text>\textbf</xsl:text>
      </xsl:when>
      <xsl:when test="name() = 'tt'">
        <xsl:text>\texttt</xsl:text>
      </xsl:when>
      <xsl:when test="name() = 'b'">
        <xsl:text>\textbf</xsl:text>
      </xsl:when>
      <xsl:when test="name() = 'u'">
        <xsl:text>\underline</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\textit</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>{</xsl:text>
     <xsl:apply-templates/>
    <xsl:text>} </xsl:text>
  </xsl:template>

  <xsl:template match="p">
    <xsl:value-of select="$newline"/>
    <xsl:choose>
      <xsl:when test="name(parent::node()) = 'list'">
        <!-- list item -->
        <xsl:text>\item </xsl:text>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <!-- para -->
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="pre">
    <xsl:text>\begin{verbatim}</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>\end{verbatim}</xsl:text>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="table">
    <xsl:value-of select="$newline"/>
    <xsl:text>\begin{center}</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>\begin{tabular}{|</xsl:text>
    <xsl:for-each select="tr[1]/*">
      <xsl:text>l|</xsl:text>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates/>
    <xsl:text>\end{tabular}</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>\end{center}</xsl:text>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="tr">
    <xsl:if test="name(*[1]) = 'th'">
    <xsl:value-of select="concat('\hline',$newline)"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:value-of select="concat('\\',$newline,'\hline',$newline)"/>
  </xsl:template>

  <xsl:template match="th">
    <xsl:if test="position() &gt; 1">
      <xsl:text> &amp; </xsl:text>
    </xsl:if>
    <xsl:text>\textbf{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="td">
    <xsl:if test="position() &gt; 1">
      <xsl:text> &amp; </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="fig">
    <xsl:if test="$flag_fig and child::*">
      <xsl:text>\begin{figure}</xsl:text>
      <xsl:value-of select="$newline"/>
      <xsl:apply-templates/>
      <xsl:if test="h">
        <xsl:text>\label{</xsl:text>
        <xsl:apply-templates select="h"/>
        <xsl:text>}</xsl:text>
      </xsl:if>
      <xsl:text>\end{figure}</xsl:text>
      <xsl:value-of select="$newline"/>
      <xsl:value-of select="$newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="meta|t"/>

</xsl:stylesheet>
