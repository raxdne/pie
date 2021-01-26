<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--

PKG2 - ProzessKettenGenerator second implementation 
Copyright (C) 1999-2006 by Alexander Tenbusch

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License 
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

-->
  <xsl:variable name="file_css" select="''"/>

<xsl:output method='html' encoding='UTF-8'/>

<xsl:variable name="str_uc_template">UC_Template.docx</xsl:variable>
<xsl:variable name="str_m_template">Method_Template.pptx</xsl:variable>
<xsl:variable name="str_tc_template">TC_Template.docx</xsl:variable>
<xsl:variable name="flag_links" select="true()"/>
<xsl:variable name="flag_attr" select="true()"/>
<xsl:variable name="flag_task" select="false()"/>
<xsl:variable name="int_depth_max" select="-1"/>
<xsl:variable name="flag_req" select="true()"/>
<xsl:variable name="flag_empty" select="false()"/>
<xsl:variable name="flag_bat" select="false()"/>
<xsl:variable name="flag_ext" select="false()"/>
<xsl:variable name="flag_unfold" select="true()"/><!-- true: @FOLD is relevant, @FOLD='true' UC nodes are ignored -->
<xsl:key name="listattributes" match="attribute[@NAME]" use="@NAME"/>
<xsl:variable name="list_attributes" select="//attribute[generate-id(.) = generate-id(key('listattributes',@NAME))]"/>
<xsl:variable name="str_pathdir" select="''"/>
<xsl:variable name="str_tag">
  <xsl:choose>
    <xsl:when test="/transform/@tag">
      <xsl:value-of select="string(/transform/@tag)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="''"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:template match="/">
  <xsl:element name="html">
    <xsl:element name="head">
      <xsl:call-template name="CREATESTYLE"/>
      <xsl:element name="title">
	<xsl:value-of select="map/node/@TEXT"/>
      </xsl:element>
    </xsl:element>
    <xsl:element name="body">
      <xsl:comment>
	<xsl:value-of select="concat('$str_tag: ', $str_tag)"/>
      </xsl:comment>
      <xsl:choose>
        <xsl:when test="transform">
          <xsl:apply-templates select="document(/transform/@a)/*"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:element>
</xsl:template>

<xsl:template match="pie|file">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="map">
  <!--  or starts-with(@TEXT,'UC') -->
  <xsl:variable name="nodeset_uclist" select="descendant::node[(starts-with(translate(@TEXT,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),'USECASE ') or starts-with(@TEXT,'Function ')) and not(ancestor-or-self::node[child::icon[contains(@BUILTIN, 'cancel')]]) and (not(ancestor-or-self::node[attribute::FOLDED = 'true']) or $flag_unfold) and ($str_tag = '' or descendant-or-self::node[contains(@TEXT,$str_tag)])]"/>
  <!--  and (child::attribute[@NAME='assignee' and contains(@VALUE,'Muller')]) -->
  <!--  and (child::attribute[@NAME='training' and contains(@VALUE,'c')]) -->
  <!-- create header -->
  <xsl:element name="h2">
    <xsl:value-of select="node/@TEXT"/>
    <xsl:if test="not($str_tag = '')">
      <xsl:value-of select="concat(' (Tag &quot;',$str_tag,'&quot;)')"/>
    </xsl:if>
  </xsl:element>
  <!--  -->
  <xsl:choose>
    <xsl:when test="count($nodeset_uclist) &gt; 0">
      <xsl:call-template name="UCTABLE">
	<xsl:with-param name="nodeset_list" select="$nodeset_uclist"/>
      </xsl:call-template>
      <xsl:element name="br"/>
      <!--  -->
      <xsl:if test="$flag_req">
	<xsl:call-template name="REQTABLE">
	  <xsl:with-param name="nodeset_list" select="$nodeset_uclist/descendant::node[starts-with(attribute::TEXT,'REQ: ') and not(child::icon[contains(@BUILTIN, 'cancel')])]"/>
	  <!--  or starts-with(parent::node/attribute::TEXT,'Postcondition') -->
	</xsl:call-template>
	<xsl:element name="br"/>
      </xsl:if>
      <!--  -->
      <xsl:call-template name="USECASES">
	<xsl:with-param name="nodeset_list" select="$nodeset_uclist"/>
      </xsl:call-template>
      <xsl:element name="br"/>
      <!--  -->
      <xsl:if test="$flag_bat">
	<xsl:call-template name="UCBAT">
	  <xsl:with-param name="nodeset_list" select="$nodeset_uclist"/>
	</xsl:call-template>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="p">Empty document</xsl:element>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="NODELIST">
  <xsl:param name="nodeset_list" />
  <!-- node with childs -->
  <xsl:for-each select="$nodeset_list">
    <xsl:choose>
      <xsl:when test="not($flag_task) and (starts-with(@TEXT,'TODO:') or starts-with(@TEXT,'DONE:'))">
	<!-- skip this categories -->
      </xsl:when>
      <xsl:when test="not($flag_req) and starts-with(@TEXT,'REQ:')">
	<!-- skip this categories -->
      </xsl:when>
      <xsl:when test="$int_depth_max &gt; -1 and count(ancestor::node) &gt; $int_depth_max">
	<!-- skip this depth -->
      </xsl:when>
      <xsl:when test="child::icon[contains(@BUILTIN, 'cancel')]">
	<!-- skip if this icon is used -->
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="li">
          <xsl:call-template name="CREATEATTRIBUTES"/>
	    <xsl:element name="a">
	      <xsl:attribute name="name">
		<xsl:value-of select="generate-id()"/>
	      </xsl:attribute>
	    </xsl:element>
          <xsl:choose>
            <xsl:when test="@LINK">
              <xsl:element name="a">
		<xsl:attribute name="href">
                  <xsl:value-of select="@LINK"/>
		</xsl:attribute>
		<xsl:value-of select="@TEXT"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="richcontent">
              <!-- <xsl:copy-of select="richcontent/html/body/img"/> -->
              <xsl:element name="img">
		<xsl:attribute name="src">
                  <xsl:value-of select="concat('/',$str_pathdir,'/',richcontent/html/body/img/@src)"/>
		</xsl:attribute>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@TEXT"/>
            </xsl:otherwise>
          </xsl:choose>
	  <xsl:if test="child::node">
            <xsl:element name="ul">
              <xsl:call-template name="NODELIST">
		<xsl:with-param name="nodeset_list" select="child::node"/>
              </xsl:call-template>
            </xsl:element>
	  </xsl:if>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template name="USECASES">
  <xsl:param name="nodeset_list" />
  <xsl:for-each select="$nodeset_list">
    <xsl:if test="$flag_empty or count(child::node) &gt; 1">
    <!-- all usecase nodes -->
    <xsl:element name="table">
      <xsl:attribute name="border">1</xsl:attribute>
      <xsl:element name="tbody">
        <xsl:element name="tr">
          <xsl:element name="th">
            <xsl:call-template name="CREATEATTRIBUTES"/>
            <xsl:attribute name="colspan">2</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="name">
                <xsl:value-of select="generate-id()"/>
              </xsl:attribute>
              <xsl:value-of select="@TEXT"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <xsl:for-each select="child::node">
          <xsl:choose>
            <xsl:when test="contains(@TEXT,'ExceptionYYY') or contains(@TEXT,'RelatedYYY')">
	      <!-- skip this categories -->
	    </xsl:when>
            <xsl:when test="starts-with(@TEXT,'Exception') and count(child::node) &gt; 1">
	      <xsl:for-each select="child::node[not(child::icon[contains(@BUILTIN,'cancel')]) and (not(attribute::FOLDED = 'true') or $flag_unfold) and (not(starts-with(attribute::TEXT,'REQ: ')) or $flag_req) and (not(starts-with(attribute::TEXT,'TODO: ')) or $flag_task)]">
		<xsl:element name="tr">
		<xsl:element name="td">
                  <xsl:value-of select="concat('Exception ',position())"/>
		</xsl:element>
		<xsl:element name="td">
		  <xsl:element name="p">
		    <xsl:call-template name="CREATEATTRIBUTES"/>
		    <xsl:element name="a">
		      <xsl:attribute name="name">
			<xsl:value-of select="generate-id()"/>
		      </xsl:attribute>
		    </xsl:element>
		    <xsl:choose>
		      <xsl:when test="@LINK">
			<xsl:element name="a">
			  <xsl:attribute name="href">
			    <xsl:value-of select="@LINK"/>
			  </xsl:attribute>
			  <xsl:value-of select="@TEXT"/>
			</xsl:element>
		      </xsl:when>
		      <xsl:otherwise>
			<xsl:value-of select="@TEXT"/>
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:element>
		  <xsl:if test="child::node">
		    <xsl:element name="ul">
		      <xsl:call-template name="NODELIST">
			<xsl:with-param name="nodeset_list" select="child::node"/>
		      </xsl:call-template>
		    </xsl:element>
		  </xsl:if>
		</xsl:element>
		</xsl:element>
	      </xsl:for-each>
            </xsl:when>
	    <xsl:otherwise>
              <xsl:element name="tr">
		<xsl:element name="td">
		  <xsl:call-template name="CREATEATTRIBUTES"/>
		  <xsl:attribute name="width">10%</xsl:attribute>
		  <xsl:value-of select="@TEXT"/>
		</xsl:element>
		<xsl:element name="td">
		  <xsl:call-template name="CREATEATTRIBUTES">
                    <xsl:with-param name="str_parent" select="'td'"/>
		  </xsl:call-template>
		    <xsl:element name="a">
		      <xsl:attribute name="name">
			<xsl:value-of select="generate-id()"/>
		      </xsl:attribute>
		    </xsl:element>
		  <xsl:choose>
		    <xsl:when test="$int_depth_max &gt; -1 and count(ancestor::node) &gt; $int_depth_max">
		      <!-- skip this depth -->
		    </xsl:when>
                    <xsl:when test="starts-with(@TEXT,'Name') or starts-with(@TEXT,'ID')">
                      <xsl:element name="b">
			<xsl:choose>
			  <xsl:when test="child::node/@TEXT">
                            <xsl:value-of select="child::node/attribute::TEXT"/>
			  </xsl:when>
			  <xsl:when test="starts-with(parent::node/@TEXT,'Function')">
                            <xsl:value-of select="substring-after(parent::node/@TEXT,'Function')"/>
			  </xsl:when>
			  <xsl:when test="starts-with(parent::node/@TEXT,'UseCase')">
                            <xsl:value-of select="substring-after(parent::node/@TEXT,'UseCase')"/>
			  </xsl:when>
			  <xsl:when test="starts-with(parent::node/@TEXT,'UC')">
                            <xsl:value-of select="substring-after(parent::node/@TEXT,'UC')"/>
			  </xsl:when>
			  <xsl:otherwise>
                            <xsl:value-of select="'UC'"/>
			  </xsl:otherwise>
			</xsl:choose>
                      </xsl:element>
                    </xsl:when>
                    <xsl:when test="(starts-with(@TEXT,'Normal') or starts-with(@TEXT,'Precondition') or starts-with(@TEXT,'Postcondition')) and count(child::node) &gt; 1">
		      <xsl:element name="ol">
			<xsl:call-template name="NODELIST">
			  <xsl:with-param name="nodeset_list" select="child::node"/>
			</xsl:call-template>
		      </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
		      <xsl:for-each select="child::node[not(child::icon[contains(@BUILTIN,'cancel')]) and (not(attribute::FOLDED = 'true') or $flag_unfold) and (not(starts-with(attribute::TEXT,'REQ: ')) or $flag_req) and (not(starts-with(attribute::TEXT,'TODO: ')) or $flag_task)]">
			<!-- top items without symbols https://wiki.selfhtml.org/wiki/CSS/Tutorials/Listen_mit_CSS_gestalten -->
			<xsl:element name="p">
			  <xsl:call-template name="CREATEATTRIBUTES"/>
			  <xsl:element name="a">
			    <xsl:attribute name="name">
			      <xsl:value-of select="generate-id()"/>
			    </xsl:attribute>
			  </xsl:element>
			  <xsl:choose>
			    <xsl:when test="@LINK">
			      <xsl:element name="a">
				<xsl:attribute name="href">
				  <xsl:value-of select="@LINK"/>
				</xsl:attribute>
				<xsl:value-of select="@TEXT"/>
			      </xsl:element>
			    </xsl:when>
			    <xsl:otherwise>
			      <xsl:value-of select="@TEXT"/>
			    </xsl:otherwise>
			  </xsl:choose>
			</xsl:element>
			<xsl:if test="child::node">
			  <xsl:element name="ul">
			    <xsl:call-template name="NODELIST">
			      <xsl:with-param name="nodeset_list" select="child::node"/>
			    </xsl:call-template>
			  </xsl:element>
			</xsl:if>
		      </xsl:for-each>
                    </xsl:otherwise>
		  </xsl:choose>
		</xsl:element>
              </xsl:element>
	    </xsl:otherwise>
	  </xsl:choose>
        </xsl:for-each>
        <!-- additional rows --> 
        <xsl:if test="$flag_ext and not(child::node[starts-with(@TEXT,'Method')])"> <!--  and count(child::node) &gt; 0 -->
          <xsl:element name="tr">
            <xsl:element name="td">
              <xsl:attribute name="width">15%</xsl:attribute>
              <xsl:value-of select="'Method (Template for QRC)'"/>
            </xsl:element>
            <xsl:element name="td">
              <xsl:element name="i">
                <xsl:value-of select="@TEXT"/>
              </xsl:element>
              <xsl:element name="ul">
                <xsl:element name="li">
                  <xsl:text>Training Manual</xsl:text>
                </xsl:element>
                <xsl:element name="li">
                  <xsl:text>Smart Cards</xsl:text>
                </xsl:element>
                <xsl:element name="li">
                  <xsl:text>User Information</xsl:text>
                </xsl:element>
                <xsl:element name="li">
                  <xsl:text>Reference Data</xsl:text>
                </xsl:element>
                <xsl:element name="li">
                  <xsl:text></xsl:text>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:if>
      </xsl:element>
    </xsl:element>
    <xsl:element name="br"/>
  </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template name="UCTABLE">
  <xsl:param name="nodeset_list" />
  <!-- node with childs -->
  <xsl:element name="table">
    <xsl:attribute name="id">
      <xsl:text>UCTable</xsl:text> <!-- TODO: handle multiple tables -->
    </xsl:attribute>
    <xsl:attribute name="class">
      <xsl:text>tablesorter</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="border">
      <xsl:text>1</xsl:text>
    </xsl:attribute>
    <xsl:element name="thead">
      <xsl:element name="tr">
        <xsl:element name="th">
          <xsl:text>Number</xsl:text>
        </xsl:element>
        <xsl:element name="th">
          <xsl:text>Id</xsl:text>
        </xsl:element>
        <xsl:element name="th">
          <xsl:value-of select="node/@TEXT"/>
        </xsl:element>
        <xsl:for-each select="$list_attributes">
          <xsl:sort select="@NAME"/>
          <xsl:element name="th">
            <xsl:value-of select="@NAME"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
    <xsl:element name="tbody">
      <xsl:for-each select="$nodeset_list">
        <xsl:sort select="attribute[@NAME='sprint']/@VALUE" data-type="number"/>
        <xsl:sort select="attribute[@NAME='impact']/@VALUE" data-type="number"/>
        <xsl:sort select="attribute[@NAME='assignee']/@VALUE"/>
        <xsl:variable name="node_usecase" select="."/>
        <xsl:element name="tr">
          <xsl:element name="td">
            <xsl:attribute name="align">right</xsl:attribute>
            <xsl:value-of select="concat(position(),'.')"/>
          </xsl:element>
          <xsl:element name="td">
            <xsl:element name="a">
              <xsl:if test="$flag_links">
                <xsl:attribute name="href">
                  <xsl:choose>
                    <xsl:when test="@LINK and starts-with(@LINK,'\\')">
                      <xsl:value-of select="concat('file://',@LINK)"/>
                    </xsl:when>
                    <xsl:when test="@LINK">
                      <xsl:value-of select="@LINK"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat('#',generate-id())"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="child::node[contains(translate(@TEXT,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'name') or contains(translate(@TEXT,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'id')]/child::node/@TEXT">
                  <xsl:value-of select="child::node[contains(translate(@TEXT,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'name') or contains(translate(@TEXT,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'id')]/child::node/@TEXT"/>
                </xsl:when>
                <xsl:when test="contains(@TEXT,': ')">
                  <xsl:value-of select="substring-before(@TEXT,': ')"/>
                </xsl:when>
                <xsl:otherwise>
                  <!-- empty ID --> 
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:element>
          <xsl:element name="td">
            <xsl:call-template name="CREATEATTRIBUTES"/>
            <xsl:value-of select="@TEXT"/>
          </xsl:element>
          <!-- fill attribute columns -->
          <xsl:for-each select="$list_attributes">
            <xsl:sort select="@NAME"/>
            <xsl:variable name="str_attribute" select="@NAME"/>
            <xsl:element name="td">
              <xsl:attribute name="align">right</xsl:attribute>
              <xsl:value-of select="$node_usecase/ancestor-or-self::node[child::attribute[@NAME = $str_attribute]][1]/child::attribute[@NAME = $str_attribute]/@VALUE"/>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:element>
</xsl:template>

<xsl:template name="REQTABLE">
  <xsl:param name="nodeset_list" />
  <!-- node with childs -->
  <xsl:element name="table">
    <xsl:attribute name="border">1</xsl:attribute>
    <xsl:element name="tbody">
      <xsl:element name="tr">
        <xsl:element name="th">
          <xsl:text>Number</xsl:text>
        </xsl:element>
        <xsl:element name="th">
          <xsl:text>Parent UseCase</xsl:text>
        </xsl:element>
        <xsl:element name="th">
          <xsl:text>Requirements</xsl:text>
        </xsl:element>
      </xsl:element>
      <xsl:for-each select="$nodeset_list">
        <xsl:element name="tr">
          <xsl:element name="td">
            <xsl:attribute name="align">right</xsl:attribute>
            <xsl:value-of select="concat(position(),'.')"/>
          </xsl:element>
          <xsl:element name="td">
            <xsl:element name="a">
              <xsl:if test="$flag_links">
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('#',generate-id())"/>
                </xsl:attribute>
              </xsl:if>
            <xsl:value-of select="ancestor::node[child::node[contains(@TEXT,'Name')]]/child::node[contains(@TEXT,'Name')]/child::node[1]/@TEXT "/>
            </xsl:element>
          </xsl:element>
          <xsl:element name="td">
            <xsl:call-template name="CREATEATTRIBUTES"/>
            <xsl:for-each select="descendant-or-self::node[@TEXT]">
              <xsl:if test="position() &gt; 1">
                <xsl:text>, </xsl:text>
              </xsl:if>
              <xsl:choose>
		<xsl:when test="starts-with(@TEXT,'REQ: ')">
		  <xsl:value-of select="substring-after(@TEXT,'REQ: ')"/>
		</xsl:when>
		<xsl:when test="starts-with(parent::node/attribute::TEXT,'Postcondition')">
		  <xsl:value-of select="@TEXT"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="concat(', ',@TEXT)"/>
		</xsl:otherwise>
	      </xsl:choose>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:element>
</xsl:template>

<xsl:template name="UCBAT">
  <xsl:param name="nodeset_list" />
  <!-- node with childs -->
  <xsl:variable name="strSep">-</xsl:variable>

  <xsl:element name="h2">
    <xsl:value-of select="concat('Kopieren für ',node/@TEXT)"/>
  </xsl:element>
  <xsl:element name="pre">
    <xsl:value-of select="concat('@chcp 1252','&#10;')"/>
    <xsl:for-each select="$nodeset_list">
      <xsl:variable name="strId">
        <xsl:choose>
          <xsl:when test="child::node[contains(@TEXT,'Name') or contains(@TEXT,'ID')]/child::node[1]/@TEXT">
            <xsl:value-of select="child::node[contains(@TEXT,'Name') or contains(@TEXT,'ID')]/child::node[1]/@TEXT"/>
          </xsl:when>
          <xsl:when test="starts-with(@TEXT,'UseCase')">
            <xsl:value-of select="translate(normalize-space(substring-after(@TEXT,'UseCase')),' /+.;-,&quot;„“?!:','________')"/>
          </xsl:when>
          <xsl:when test="starts-with(@TEXT,'UC')">
            <xsl:value-of select="translate(normalize-space(substring-after(@TEXT,'UC')),' /+.;-,&quot;„“?!:','________')"/>
          </xsl:when>
          <xsl:otherwise>
        <xsl:value-of select="translate(normalize-space(@TEXT),' /+.;-,&quot;„“?!:','________')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="strPath">
        <xsl:value-of select="'tmp'"/>
      </xsl:variable>
      <xsl:value-of select="concat('IF NOT EXIST ','&quot;',$strPath,'\nul','&quot;',' md ','&quot;',$strPath,'&quot;','&#10;')"/>
      <xsl:value-of select="concat('IF NOT EXIST ','&quot;',$strPath,'\UC',$strSep,$strId,'.docx','&quot;')"/>
      <xsl:value-of select="concat(' copy ','&quot;',$str_uc_template,'&quot;',' ','&quot;',$strPath,'\UC',$strSep,$strId,'.docx','&quot;','&#10;')"/>
      <xsl:value-of select="concat('REM IF NOT EXIST ','&quot;',$strPath,'\TC',$strSep,$strId,'.docx','&quot;')"/>
      <xsl:value-of select="concat(' copy ','&quot;',$str_tc_template,'&quot;',' ','&quot;',$strPath,'\TC',$strSep,$strId,'.docx','&quot;','&#10;')"/>
      <xsl:value-of select="concat('IF NOT EXIST ','&quot;',$strPath,'\QRC',$strSep,$strId,'.pptx','&quot;')"/>
      <xsl:value-of select="concat(' copy ','&quot;',$str_m_template,'&quot;',' ','&quot;',$strPath,'\QRC',$strSep,$strId,'.pptx','&quot;','&#10;')"/>
    </xsl:for-each>
    <xsl:value-of select="concat('pause','&#10;')"/>
  </xsl:element>
</xsl:template>

<xsl:template name="CREATEATTRIBUTES">
  <xsl:param name="str_parent" select="''"/>
  <xsl:choose>
    <xsl:when test="not($flag_attr)">
      <!-- no attributes at all -->
    </xsl:when>
    <xsl:when test="$str_parent = 'td'">
    </xsl:when>
    <xsl:when test="@BACKGROUND_COLOR or @COLOR">
      <xsl:attribute name="style">
	<xsl:if test="@BACKGROUND_COLOR and not(@BACKGROUND_COLOR = '#ffffff') and not(@BACKGROUND_COLOR = '#FFFFFF')">
          <xsl:value-of select="concat('background-color:',@BACKGROUND_COLOR,'; ')"/>
	</xsl:if>
	<xsl:if test="@COLOR">
          <xsl:value-of select="concat('color:',@COLOR,'; ')"/>
	</xsl:if>
      </xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="CREATESTYLE">
    <xsl:element name="style">
body {
  font-family:Arial,sans-serif;
}

table {
  width: 95%;
  font-size: 9pt;
  border: 1px solid grey;
  border-collapse: collapse;
  margin-left:auto;
  margin-right:auto;
}

th {
  text-align:left;
  padding:        3px 5px;
  background-color:#d9d9d9;
  font-weight:bold;
}

td {
  padding:        3px 5px;
}
    </xsl:element>
</xsl:template>

<xsl:template match="text()|comment()|node()"/>

</xsl:stylesheet>
