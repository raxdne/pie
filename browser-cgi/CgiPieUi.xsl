<?xml version="1.0"?>
<xsl:stylesheet xmlns:cxp="http://www.tenbusch.info/cxproc" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- ID of sub tab -->
  <xsl:variable name="sub" select="''"/>
  <!--  -->
  <xsl:variable name="write" select="'yes'"/>
  <!-- URL name of plain input path -->
  <xsl:variable name="str_path" select="''"/>
  <!--  -->
  <xsl:variable name="str_xpath" select="'/'"/>
  <!--  -->
  <xsl:variable name="str_type" select="''"/>
  <!--  -->
  <xsl:variable name="flag_sub" select="false()"/>
  <!--  -->
  <xsl:variable name="str_frame" select="'piemain'"/>
  <!--  -->
  <xsl:variable name="flag_header" select="false()"/>
  <!--  -->
  <xsl:variable name="str_url" select="concat('?cxp=PieUiDefault','&amp;','path=',$str_path)"/>
  <xsl:output method="html" omit-xml-declaration="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="file:///tmp/dummy.dtd"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:choose>
        <xsl:when test="$flag_header">
          <xsl:element name="head">
            <xsl:call-template name="HEADER"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="body">
            <xsl:choose>
              <xsl:when test="$str_type = 'inode/directory'">
                <xsl:choose>
                  <xsl:when test="$flag_sub">
                    <xsl:call-template name="SUBTABSDIR"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="TABSDIR"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="$flag_sub">
                    <xsl:call-template name="SUBTABS"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="TABS"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <xsl:template name="HEADER">
    <xsl:element name="meta">
      <xsl:attribute name="http-equiv">cache-control</xsl:attribute>
      <xsl:attribute name="content">no-cache</xsl:attribute>
    </xsl:element>
    <xsl:element name="meta">
      <xsl:attribute name="http-equiv">pragma</xsl:attribute>
      <xsl:attribute name="content">no-cache</xsl:attribute>
    </xsl:element>
    <xsl:element name="link">
      <xsl:attribute name="rel">stylesheet</xsl:attribute>
      <xsl:attribute name="type">text/css</xsl:attribute>
      <xsl:attribute name="href">/pie/html/pie.css</xsl:attribute>
    </xsl:element>
    <xsl:element name="link">
      <xsl:attribute name="rel">stylesheet</xsl:attribute>
      <xsl:attribute name="type">text/css</xsl:attribute>
      <xsl:attribute name="href">/pie/non-js/CgiPieUi.css</xsl:attribute>
    </xsl:element>
    <xsl:element name="title">
      <xsl:value-of select="concat('PIE: ',$str_path)"/>
    </xsl:element>
  </xsl:template>
  <xsl:template name="TABSDIR">
    <!-- -->
    <!-- list of UI tabs -->
    <xsl:element name="ul">
      <xsl:attribute name="class">ui-tabs</xsl:attribute>
      <!-- tab Template -->
      <xsl:element name="li">
        <xsl:attribute name="class">ui-tab</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$sub='new'">
            <xsl:attribute name="id">ui-tab-active</xsl:attribute>
            <xsl:text>New</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="a">
              <xsl:choose>
		<xsl:when test="$write='no'">
		  <!-- no link if there is no write permission -->
		</xsl:when>
		<xsl:otherwise>
		  <xsl:attribute name="href">
                    <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PieUiTemplate','&amp;','sub=new')"/>
		  </xsl:attribute>
		</xsl:otherwise>
              </xsl:choose>
              <xsl:text>New</xsl:text>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <!-- tab Dir -->
      <xsl:element name="li">
        <xsl:attribute name="class">ui-tab</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$sub='dir'">
            <xsl:attribute name="id">ui-tab-active</xsl:attribute>
            <xsl:text>Dir</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PiejQDirDir','&amp;','sub=dir')"/>
              </xsl:attribute>
              <xsl:text>Dir</xsl:text>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <!-- tab Search -->
      <xsl:element name="li">
        <xsl:attribute name="class">ui-tab</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$sub='search'">
            <xsl:attribute name="id">ui-tab-active</xsl:attribute>
            <xsl:text>Search</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PieUiDirSearch','&amp;','sub=search')"/>
              </xsl:attribute>
              <xsl:text>Search</xsl:text>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <!-- tab Format -->
      <xsl:element name="li">
        <xsl:attribute name="class">ui-tab</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$sub='format'">
            <xsl:attribute name="id">ui-tab-active</xsl:attribute>
            <xsl:text>Format</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PieUiDirFormat','&amp;','sub=format')"/>
              </xsl:attribute>
              <xsl:text>Format</xsl:text>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <!-- Dir path -->
      <xsl:element name="li">
        <xsl:attribute name="class">ui-file</xsl:attribute>
        <xsl:element name="a">
          <xsl:value-of select="$str_path"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="TABS">
    <!-- -->
    <!-- list of UI tabs -->
    <xsl:element name="ul">
      <xsl:attribute name="class">ui-tabs</xsl:attribute>
      <!-- tab Layout -->
      <xsl:element name="li">
        <xsl:attribute name="class">ui-tab</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$sub='' or $sub='default'">
            <xsl:attribute name="id">ui-tab-active</xsl:attribute>
            <xsl:text>Layout</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="concat($str_url,'&amp;','sub=default')"/>
                <xsl:if test="not($str_xpath='/')">
                  <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                </xsl:if>
                <xsl:if test="$write='no'">
                  <xsl:value-of select="concat('&amp;','write=no')"/>
                </xsl:if>
              </xsl:attribute>
              <xsl:text>Layout</xsl:text>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <!-- tab Special -->
      <xsl:element name="li">
        <xsl:attribute name="class">ui-tab</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$sub='special' or $sub='calendar' or $sub='todo' or $sub='todoCalendar' or $sub='todoMatrix' or $sub='todoContact'">
            <xsl:attribute name="id">ui-tab-active</xsl:attribute>
            <xsl:text>Special</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PieUi','&amp;','sub=special')"/>
                <xsl:if test="not($str_xpath='/')">
                  <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                </xsl:if>
              </xsl:attribute>
              <xsl:text>Special</xsl:text>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <!-- tab Format -->
      <xsl:element name="li">
        <xsl:attribute name="class">ui-tab</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$sub='format' or $sub='freemind'">
            <xsl:attribute name="id">ui-tab-active</xsl:attribute>
            <xsl:text>Format</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PieUiFormat','&amp;','sub=format')"/>
                <xsl:if test="not($str_xpath='/')">
                  <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                </xsl:if>
              </xsl:attribute>
              <xsl:text>Format</xsl:text>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <!-- TODO: tab Meta ? -->
      <!-- TODO: tab Version -->
      <!-- File link -->
      <xsl:element name="li">
        <xsl:attribute name="class">ui-file</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="title">
            <xsl:value-of select="concat('?',/pie/file/@mtime)"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="concat('?file=',$str_path)"/>
            <xsl:if test="not($str_xpath='/')">
              <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
            </xsl:if>
          </xsl:attribute>
          <xsl:value-of select="concat($str_path,$str_xpath)"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="SUBTABS">
    <!-- Sub tabs -->
    <xsl:element name="ul">
      <xsl:choose>
        <xsl:when test="$sub='special' or $sub='calendar' or $sub='todo' or $sub='todoCalendar' or $sub='todoMatrix' or $sub='todoContact'">
          <!-- Sub tabs Special -->
          <xsl:attribute name="class">ui-tabs-sub</xsl:attribute>
          <xsl:element name="li">
            <xsl:attribute name="class">ui-tab-sub</xsl:attribute>
            <xsl:choose>
              <xsl:when test="$sub='calendar'">
                <xsl:attribute name="id">ui-tab-active</xsl:attribute>
                <xsl:element name="a">
                  <xsl:text>Calendar</xsl:text>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PieUiCalendar','&amp;','sub=calendar')"/>
                    <xsl:if test="not($str_xpath='/')">
                      <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                    </xsl:if>
                    <xsl:value-of select="concat('','#yesterday')"/>
                  </xsl:attribute>
                  <xsl:text>Calendar</xsl:text>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <!-- -->
          <xsl:element name="li">
            <xsl:attribute name="class">ui-tab-sub</xsl:attribute>
            <xsl:choose>
              <xsl:when test="$sub='todo'">
                <xsl:attribute name="id">ui-tab-active</xsl:attribute>
                <xsl:element name="a">
                  <xsl:text>Todo</xsl:text>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PieUiTodo','&amp;','sub=todo')"/>
                    <xsl:if test="not($str_xpath='/')">
                      <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                    </xsl:if>
                  </xsl:attribute>
                  <xsl:text>Todo</xsl:text>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <!-- -->
          <xsl:element name="li">
            <xsl:attribute name="class">ui-tab-sub</xsl:attribute>
            <xsl:choose>
              <xsl:when test="$sub='todoCalendar'">
                <xsl:attribute name="id">ui-tab-active</xsl:attribute>
                <xsl:element name="a">
                  <xsl:text>TodoCalendar</xsl:text>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PieUiTodoCalendar','&amp;','sub=todoCalendar')"/>
                    <xsl:if test="not($str_xpath='/')">
                      <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                    </xsl:if>
                    <xsl:value-of select="concat('','#yesterday')"/>
                  </xsl:attribute>
                  <xsl:text>TodoCalendar</xsl:text>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <!-- -->
          <xsl:element name="li">
            <xsl:attribute name="class">ui-tab-sub</xsl:attribute>
            <xsl:choose>
              <xsl:when test="$sub='todoMatrix'">
                <xsl:attribute name="id">ui-tab-active</xsl:attribute>
                <xsl:element name="a">
                  <xsl:text>TodoMatrix</xsl:text>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PieUiTodoMatrix','&amp;','sub=todoMatrix')"/>
                    <xsl:if test="not($str_xpath='/')">
                      <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                    </xsl:if>
                  </xsl:attribute>
                  <xsl:text>TodoMatrix</xsl:text>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <!-- -->
          <xsl:element name="li">
            <xsl:attribute name="class">ui-tab-sub</xsl:attribute>
            <xsl:choose>
              <xsl:when test="$sub='todoContact'">
                <xsl:attribute name="id">ui-tab-active</xsl:attribute>
                <xsl:element name="a">
                  <xsl:text>TodoContact</xsl:text>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PieUiTodoContact','&amp;','sub=todoContact')"/>
                    <xsl:if test="not($str_xpath='/')">
                      <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                    </xsl:if>
                  </xsl:attribute>
                  <xsl:text>TodoContact</xsl:text>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <!-- -->
          <xsl:element name="li">
            <xsl:attribute name="class">ui-tab-sub</xsl:attribute>
            <xsl:choose>
              <xsl:when test="$sub='presentation'">
                <xsl:attribute name="id">ui-tab-active</xsl:attribute>
                <xsl:element name="a">
                  <xsl:text>Presentation</xsl:text>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="a">
                  <xsl:attribute name="target">_blank</xsl:attribute>
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PresentationIndex')"/>
                    <xsl:if test="not($str_xpath='/')">
                      <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                    </xsl:if>
                  </xsl:attribute>
                  <xsl:text>Presentation</xsl:text>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <!-- -->
          <xsl:element name="li">
            <xsl:attribute name="class">ui-tab-sub</xsl:attribute>
            <xsl:choose>
              <xsl:when test="$sub='mindmap'">
                <xsl:attribute name="id">ui-tab-active</xsl:attribute>
                <xsl:element name="a">
                  <xsl:text>Mindmap</xsl:text>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="a">
                  <xsl:attribute name="target"><xsl:value-of select="$str_frame"/></xsl:attribute>
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat('?name=',$str_path,'&amp;','cxp=FreemindViewer')"/>
                    <xsl:if test="not($str_xpath='/')">
                      <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                    </xsl:if>
                  </xsl:attribute>
                  <xsl:text>Mindmap</xsl:text>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <!-- Sub tabs  -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    <!-- context menu, hidden by default -->
    <div style="display:none; position: absolute;" id="contextMenu">
      <table width="80px">
	<tbody>
	  <tr>
	    <td onclick="javascript:this.ownerDocument.GoMenu(event);" class="ContextItem">Top</td>
	  </tr>
	  <tr>
	    <td onclick="javascript:this.ownerDocument.GoMenu(event);" class="ContextItem">View</td>
	  </tr>
	  <tr>
	    <td onclick="javascript:this.ownerDocument.GoMenu(event);" class="ContextItem">Date</td>
	  </tr>
	  <tr>
	    <td onclick="javascript:this.ownerDocument.GoMenu(event);" class="ContextItem">Done</td>
	  </tr>
	  <tr>
	    <td onclick="javascript:this.ownerDocument.GoMenu(event);" class="ContextItem">Reopen</td>
	  </tr>
	  <tr>
	    <td onclick="javascript:this.ownerDocument.GoMenu(event);" class="ContextItem">Edit</td>
	  </tr>
	  <tr>
	    <td onclick="javascript:this.ownerDocument.GoMenu(event);" class="ContextItem">Delete</td>
	  </tr>
	</tbody>
      </table>
    </div>
  </xsl:template>

  <xsl:template name="SUBTABSDIR">
    <xsl:choose>
      <xsl:when test="$sub='search'">
      </xsl:when>
      <xsl:otherwise>
        <!-- Sub tabs -->
        <xsl:element name="ul">
          <!-- There are Links on Tab Format only -->
          <xsl:attribute name="class">ui-menu</xsl:attribute>
          <xsl:element name="ul">
            <!-- -->
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="target">_blank</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('/',$str_path)"/>
                </xsl:attribute>
                <xsl:text>Open Server directory</xsl:text>
              </xsl:element>
            </xsl:element>
            <!-- -->
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="target">_blank</xsl:attribute>
		<!--
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=DirZip')"/>
                </xsl:attribute>
		-->
                <xsl:text>Zip Server directory</xsl:text>
              </xsl:element>
            </xsl:element>
            <!-- -->
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="target">_blank</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=DiskUsage')"/>
                </xsl:attribute>
                <xsl:text>DiskUsage</xsl:text>
              </xsl:element>
            </xsl:element>
            <!-- -->
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="target"><xsl:value-of select="$str_frame"/></xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=DirCalendar','&amp;','depth=10','#yesterday')"/>
                </xsl:attribute>
                <xsl:text>Calendar</xsl:text>
              </xsl:element>
            </xsl:element>
            <!-- -->
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="target"><xsl:value-of select="$str_frame"/></xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=DirSitemap')"/>
                </xsl:attribute>
                <xsl:text>Sitemap</xsl:text>
              </xsl:element>
            </xsl:element>
            <!-- -->
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="target">_blank</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PiejQMerge','&amp;','frame=800x800','&amp;','depth=1')"/>
                </xsl:attribute>
                <xsl:text>Merge</xsl:text>
              </xsl:element>
              <xsl:text> all PIE files in current directory (*.pie, *.txt, *.mm, *.jpg, *.png).</xsl:text>
            </xsl:element>
            <!-- -->
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="target">_blank</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=Wallpaper','&amp;','frame=600x600','&amp;','depth=1')"/>
                </xsl:attribute>
                <xsl:text>Wallpaper of</xsl:text>
              </xsl:element>
              <xsl:text> all Image files in current directory.</xsl:text>
            </xsl:element>
            <!-- -->
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="target">_blank</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PlayList')"/>
                </xsl:attribute>
                <xsl:text>Play Audio Directory</xsl:text>
              </xsl:element>
            </xsl:element>
            <!-- -->
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="target">_blank</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=gallery')"/>
                </xsl:attribute>
                <xsl:text>Show Gallery Directory</xsl:text>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
