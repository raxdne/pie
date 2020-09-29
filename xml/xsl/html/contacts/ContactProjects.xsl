<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- Table with projects and contacts -->
  <xsl:import href="../../Utils.xsl"/>
  <xsl:import href="../PieHtml.xsl"/>

  <xsl:variable name="file_css" select="'pie.css'"/>

  <xsl:output encoding="UTF-8" method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" media-type="text/html"/>
  <xsl:key name="listprojects" match="section[@pid and (not(@state) or @state &lt; 2)]" use="@pid"/><!-- and @assignee='Muller' -->
  <xsl:key name="listcontacts" match="contact[ancestor::section[@pid] and @idref]" use="@idref"/><!-- TODO: include all @assignee -->
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER">
	<xsl:with-param name="list_js" select="'/jquery/jquery.js,/jquery/tablesorter/jquery.tablesorter.js'"/>
      </xsl:call-template>
      <xsl:element name="body">
	<script type="text/javascript">$(document).ready(function() { $("#contactTable").tablesorter(); } );</script> 
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="pie">
    <xsl:element name="table">
      <xsl:attribute name="id">contactTable</xsl:attribute>
      <xsl:attribute name="class">tablesorter</xsl:attribute>
      <xsl:element name="thead">
        <xsl:element name="tr">
          <xsl:element name="th">
            <xsl:value-of select="''"/>
          </xsl:element>
          <xsl:element name="th">
            <xsl:value-of select="@ad"/>
          </xsl:element>
          <xsl:element name="th">
            <xsl:value-of select="'Project'"/>
          </xsl:element>
          <xsl:element name="th">
            <xsl:value-of select="'assignee'"/>
          </xsl:element>
          <xsl:element name="th">
            <xsl:value-of select="'state'"/>
          </xsl:element>
          <xsl:for-each select="descendant::contact[generate-id(.) = generate-id(key('listcontacts',@idref))]">
            <xsl:sort order="ascending" select="@idref"/>
            <xsl:element name="th">
              <xsl:element name="div">
                <xsl:attribute name="class">
                  <xsl:value-of select="'contact'"/>
                </xsl:attribute>
                <xsl:value-of select="@idref"/>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
      <xsl:element name="tbody">
        <xsl:for-each select="descendant::section[generate-id(.) = generate-id(key('listprojects',@pid))]">
          <xsl:variable name="node_project" select="self::node()"/>
          <xsl:variable name="str_class">
            <xsl:choose>
              <xsl:when test="@class">
                <xsl:value-of select="@class"/>
              </xsl:when>
              <xsl:when test="@impact">
                <xsl:value-of select="'gantt-high'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'gantt'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:call-template name="PROJECT">
            <xsl:with-param name="str_pid" select="@pid"/>
            <xsl:with-param name="str_class" select="$str_class"/>
            <xsl:with-param name="node_project" select="$node_project"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="PROJECT">
    <xsl:param name="node_project"/>
    <xsl:param name="str_class"/>
    <xsl:param name="str_pid"/>
    <xsl:element name="tr">
      <xsl:element name="td">
        <xsl:attribute name="align">right</xsl:attribute>
        <xsl:value-of select="concat(position(),'.')"/>
      </xsl:element>
      <xsl:element name="td">
        <xsl:attribute name="class">
          <xsl:value-of select="$str_class"/>
        </xsl:attribute>
        <xsl:value-of select="$str_pid"/>
      </xsl:element>
      <xsl:element name="td">
        <xsl:for-each select="$node_project">
	  <xsl:element name="span">
            <xsl:call-template name="MENUSET"/>
            <xsl:value-of select="h"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
      <xsl:element name="td">
        <xsl:value-of select="$node_project/attribute::assignee"/>
      </xsl:element>
      <xsl:element name="td">
        <xsl:value-of select="$node_project/attribute::state"/>
      </xsl:element>
      <xsl:for-each select="/descendant::contact[generate-id(.) = generate-id(key('listcontacts',@idref))]">
        <xsl:sort order="ascending" select="@idref"/>
        <xsl:variable name="str_idref" select="@idref"/>
        <xsl:variable name="int_idref" select="count($node_project/descendant::contact[@idref = $str_idref])"/>
        <xsl:element name="td">
          <xsl:choose>
            <xsl:when test="$node_project/@assignee = $str_idref">
              <xsl:attribute name="class">
                <xsl:value-of select="$str_class"/>
              </xsl:attribute>
              <xsl:value-of select="'&#x25C6;'"/>
            </xsl:when>
            <xsl:when test="$int_idref &gt; 10">
              <xsl:attribute name="class">
                <xsl:value-of select="$str_class"/>
              </xsl:attribute>
              <xsl:value-of select="'&#x25C7;'"/>
            </xsl:when>
            <xsl:when test="$int_idref &gt; 0">
              <xsl:attribute name="class">
                <xsl:value-of select="$str_class"/>
              </xsl:attribute>
              <xsl:value-of select="'&#x25C8;'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="' '"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:for-each>
      <!--
      <xsl:element name="td">
        <xsl:for-each select="/descendant::contact[generate-id(.) = generate-id(key('listcontacts',@idref))]">
          <xsl:sort order="ascending" select="@idref"/>
          <xsl:variable name="str_idref" select="@idref"/>
          <xsl:variable name="int_idref" select="count($node_project/descendant::contact[@idref = $str_idref])"/>
          <xsl:if test="$int_idref &gt; 0">
            <xsl:value-of select="concat($str_idref,'; ')"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:element>
      -->
    </xsl:element>
  </xsl:template>
  <xsl:template match="*"/>
</xsl:stylesheet>
