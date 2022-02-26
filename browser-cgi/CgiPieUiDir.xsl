<?xml version="1.0"?>
<xsl:stylesheet xmlns:cxp="http://www.tenbusch.info/cxproc" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:rpt="http://openoffice.org/2005/report" xmlns:rdfa="http://docs.oasis-open.org/opendocument/meta/rdfa#" xmlns:office="http://openoffice.org/2000/office" xmlns:style="http://openoffice.org/2000/style" xmlns:text="http://openoffice.org/2000/text" xmlns:table="http://openoffice.org/2000/table" xmlns:draw="http://openoffice.org/2000/drawing" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:meta="http://openoffice.org/2000/meta" xmlns:number="http://openoffice.org/2000/datastyle" xmlns:svg="http://www.w3.org/2000/svg" xmlns:chart="http://openoffice.org/2000/chart" xmlns:dr3d="http://openoffice.org/2000/dr3d" xmlns:form="http://openoffice.org/2000/form" xmlns:script="http://openoffice.org/2000/script" xmlns:ap="http://schemas.mindjet.com/MindManager/Application/2003" version="1.0">
  <!--  -->
  <xsl:variable name="length_link" select="15"/>
  <!--  -->
  <xsl:variable name="str_cxp_default" select="'PieUiDefault'"/>
  <!--  -->
  <xsl:variable name="str_frame" select="'piemain'"/>
  <!--  -->
  <xsl:variable name="write" select="'yes'"/>
  <xsl:output method="html" encoding="UTF-8"/>

  <xsl:template match="/pie">
    <!-- URL encoded path names -->
    <xsl:variable name="str_path_top">
      <xsl:choose>
        <xsl:when test="dir[1]/@urlprefix and dir[1]/@urlname and not(dir[1]/@urlname = '.')">
          <xsl:value-of select="concat(dir[1]/@urlprefix,'/',dir[1]/@urlname)"/>
        </xsl:when>
        <xsl:when test="dir[1]/@urlname and not(dir[1]/@urlname = '.')">
          <xsl:value-of select="dir[1]/@urlname"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- viewable path names -->
    <xsl:variable name="str_path_top_view">
      <xsl:choose>
        <xsl:when test="dir[1]/@prefix and dir[1]/@name and not(dir[1]/@name = '.')">
          <xsl:value-of select="concat(dir[1]/@prefix,'/',dir[1]/@name)"/>
        </xsl:when>
        <xsl:when test="dir[1]/@name and not(dir[1]/@name = '.')">
          <xsl:value-of select="dir[1]/@name"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="html">
      <xsl:element name="body">
	<xsl:choose>
          <xsl:when test="child::dir/child::file[@name = 'index.cxp']">
	    <!-- there is a 'index.cxp' file, redirect to it via javascript -->
            <xsl:element name="script">
	      <xsl:value-of select="concat('document.location = &quot;/',$str_path_top,'/index.cxp&quot;;')"/>
	    </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <!--  -->
            <xsl:element name="ul">
              <xsl:attribute name="class">ui-dir</xsl:attribute>
              <xsl:element name="li">
		<xsl:attribute name="class">ui-dir-path</xsl:attribute>
		<!--  -->
		<xsl:call-template name="DIRPATHLINKS">
		  <xsl:with-param name="dir_path">
                    <xsl:value-of select="concat($str_path_top,'/')"/>
		  </xsl:with-param>
		  <xsl:with-param name="dir_path_view">
                    <xsl:value-of select="concat($str_path_top_view,'/')"/>
		  </xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="DIRACTIONS">
		  <xsl:with-param name="dir_path">
                    <xsl:value-of select="$str_path_top"/>
		  </xsl:with-param>
		</xsl:call-template>
              </xsl:element>
	      <xsl:apply-templates select="child::dir/child::*[name() = 'dir' or name() = 'file']">
		<xsl:sort order="ascending" data-type="text" case-order="lower-first" select="name()"/>
		<xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
		<xsl:with-param name="path_prefix">
		  <xsl:value-of select="$str_path_top"/>
		</xsl:with-param>
              </xsl:apply-templates>
            </xsl:element>
            <xsl:element name="p">
              <xsl:attribute name="align">right</xsl:attribute>
              <xsl:element name="a">
		<xsl:attribute name="target"><xsl:value-of select="$str_frame"/></xsl:attribute>
		<xsl:attribute name="href">
		  <xsl:value-of select="concat('?','cxp=PieUiPowered')"/>
		</xsl:attribute>
		<xsl:text>Powered by ...</xsl:text>
              </xsl:element>
            </xsl:element>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dir">
    <!--  -->
    <xsl:param name="path_prefix" select="''"/>
    <!--  -->
    <xsl:variable name="str_path">
      <xsl:choose>
        <xsl:when test="$path_prefix = ''">
          <xsl:value-of select="@urlname"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($path_prefix,'/',@urlname)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@hidden = 'yes' or @read='no' or @execute='no' or @error"/>
      <xsl:when test="@name = '' or @name = 'tmp' or @name = 'temp' or @name = 'Temp' or starts-with(@name,'_')"/>
      <xsl:otherwise>
        <xsl:element name="li">
          <xsl:attribute name="class">ui-dir</xsl:attribute>
          <xsl:element name="a">
            <!-- the sub directories are links -->
            <xsl:choose>
              <xsl:when test="@read='no' or @execute='no' or @error">
                <xsl:attribute name="class">done</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">subdir</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PieUiDir')"/>
                  <xsl:if test="@write='no'">
                    <xsl:value-of select="concat('&amp;','write=no')"/>
                  </xsl:if>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="@name"/>
            <xsl:text>/</xsl:text>
          </xsl:element>
        </xsl:element>
        <xsl:apply-templates select="dir|file">
          <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="name()"/>
          <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="info/track"/>
          <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
          <xsl:with-param name="path_prefix">
            <xsl:value-of select="$str_path"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="file">
    <!--  -->
    <xsl:param name="path_prefix" select="''"/>
    <!--  -->
    <xsl:variable name="str_path">
      <xsl:choose>
        <xsl:when test="$path_prefix = ''">
          <xsl:value-of select="@urlname"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($path_prefix,'/',@urlname)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@name = ''"/>
      <xsl:when test="@hidden = 'yes'"/>
      <xsl:when test="contains(@type,'backup') or contains(@ext,'~')"/>
      <xsl:when test="@ext='css' or @ext='sh' or @ext='pl' or @ext='xsl' or @ext='el' or @ext='bat' or @ext='lnk'"/>
      <xsl:when test="starts-with(@name,'_') or starts-with(@name,'$')"/>
      <xsl:when test="contains(@name,'#')"/>
      <xsl:when test="contains(@name,'.pie_')"/>
      <xsl:when test="starts-with(@name,'.') and not(@name = '.svn')"/>
      <xsl:when test="contains(@type,'error') or @read='no'">
        <xsl:element name="li">
          <xsl:attribute name="class">ui-dir-file</xsl:attribute>
          <xsl:element name="i">
            <xsl:element name="a">
              <xsl:attribute name="class">done</xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="concat(@type,' ',@error)"/>
              </xsl:attribute>
              <xsl:value-of select="@name"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="@name = 'index.htm' or @name = 'index.html'">
      <!--
        <xsl:element name="li">
          <xsl:attribute name="class">ui-dir-file</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="$file_name"/>
            </xsl:attribute>
            <xsl:value-of select="@name"/>
          </xsl:element>
        </xsl:element>
      -->
      </xsl:when>
      <xsl:when test="contains(@type,'audio') and not(@error)">
        <!-- use id3 tags -->
        <xsl:element name="li">
          <xsl:attribute name="class">ui-dir-file</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="class">cxp</xsl:attribute>
            <xsl:attribute name="target">
              <xsl:value-of select="$str_frame"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat('/',$str_path)"/>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="info/*">
                <xsl:attribute name="title">
                  <xsl:value-of select="concat(info/artist,' :: ',info/album,' :: ',info/track,' :: ',info/title)"/>
                </xsl:attribute>
                <xsl:value-of select="info/title"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(substring-before(@name,concat('.',@ext)),'_',' ')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="contains(@type,'sqlite')">
        <xsl:variable name="file_header">
          <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:element name="li">
          <xsl:attribute name="class">ui-dir-file</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">
              <xsl:value-of select="$str_frame"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PiejQSqlite')"/>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="string-length($file_header) &gt; 0">
                <xsl:value-of select="$file_header"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(substring-before(@name,concat('.',@ext)),'_',' ')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="contains(@type,'application/zip') or contains(@type,'application/x-iso9660-image') or contains(@type,'application/x-tar')">
        <xsl:variable name="file_header">
          <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:element name="li">
          <xsl:attribute name="class">ui-dir-file</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">
              <xsl:value-of select="$str_frame"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PiejQZip')"/>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="string-length($file_header) &gt; 0">
                <xsl:value-of select="$file_header"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(substring-before(@name,concat('.',@ext)),'_',' ')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="@ext='tcx'">
        <xsl:element name="li">
          <xsl:attribute name="class">ui-dir-file</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">
              <xsl:value-of select="$str_frame"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=Format','&amp;','b=text/csv')"/>
            </xsl:attribute>
              <xsl:value-of select="translate(substring-before(@name,concat('.',@ext)),'_',' ')"/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="@ext='fitx'">
        <xsl:element name="li">
          <xsl:attribute name="class">ui-dir-file</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">
              <xsl:value-of select="$str_frame"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=Format','&amp;','b=text/html')"/>
            </xsl:attribute>
              <xsl:value-of select="translate(substring-before(@name,concat('.',@ext)),'_',' ')"/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="@name = 'shortcuts.pie'">
        <!-- list of links in shortcut file -->
        <xsl:copy-of select="descendant::script"/>
        <!-- <xsl:element name="hr"/> -->
        <xsl:for-each select="descendant::p[not(ancestor-or-self::*[@valid='no'])]">
          <xsl:element name="li">
            <xsl:attribute name="class">ui-dir-file</xsl:attribute>
            <xsl:copy-of select="child::img[@src]"/>
	    <xsl:for-each select="child::node()|child::text()">
              <xsl:choose>
		<xsl:when test="name() = 'link'">
                  <xsl:element name="a">
		    <xsl:copy-of select="@class|@style|@title|parent::p/@class"/>
		    <xsl:attribute name="target">
		      <xsl:choose>
			<xsl:when test="@target">
                          <xsl:value-of select="@target"/>
			</xsl:when>
			<xsl:otherwise>
                          <xsl:value-of select="$str_frame"/>
			</xsl:otherwise>
		      </xsl:choose>
		    </xsl:attribute>
		    <xsl:copy-of select="@href"/>
		    <xsl:value-of select="."/>
                  </xsl:element>
		</xsl:when>
		<xsl:when test="self::text()">
		  <xsl:value-of select="."/>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
              </xsl:choose>
	    </xsl:for-each>
	  </xsl:element>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="@name = 'shortcuts.txt'">
        <!-- list of links in shortcut file -->
        <xsl:for-each select="pie//*[(name()='link' or (name()='p' and not(child::*))) and not(parent::*[@valid='no']) and not(@valid='no')]">
          <xsl:element name="li">
            <xsl:attribute name="class">ui-dir-file</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="target">
                <xsl:text>piemain</xsl:text>
	      </xsl:attribute>
              <xsl:attribute name="href">
                <xsl:choose>
                  <xsl:when test="@target">
                    <xsl:value-of select="@target"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="."/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:value-of select="substring(.,-20,100)"/>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="@ext='docx' or @ext='pptx' or @ext='odt' or @ext='ods' or @ext='odp' or @ext='txt' or @ext='md' or @ext='mm' or @ext='mmap' or @ext='xmmap' or @ext='xmind' or @ext='pie' or @ext='cxp' or @ext='log' or @ext='vcf' or @ext='csv' or @ext='ics' or (contains(@type,'image') and image) or @ext='cal' or @ext='gcal'">
        <!-- dynamic content using cxproc -->
        <!-- single link to named file -->
        <xsl:element name="li">
          <xsl:attribute name="class">ui-dir-file</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="class">cxp</xsl:attribute>
            <xsl:attribute name="target">
              <xsl:value-of select="$str_frame"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:choose>
                <xsl:when test="contains(@type,'image') and image/size">
                  <!-- all images -->
                  <xsl:value-of select="concat(@name,' (',image/size/@col,'x',image/size/@row,'): ',image/comment/@value)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@name"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:choose>
                <xsl:when test="contains(@type,'image') and child::image">
                  <!-- all images -->
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=image')"/>
                </xsl:when>
                <xsl:when test="@ext='cal' or @ext='gcal' or @ext='ics'">
                  <!-- edit form for this type of files -->
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PiejQCalendar','&amp;','sub=calendar#today')"/>
                </xsl:when>
                <xsl:when test="@ext='csv'">
                  <!--  -->
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=',$str_cxp_default)"/>
                  <!-- <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=csv')"/> -->
                </xsl:when>
                <xsl:when test="@ext='txt' or @ext='md' or @ext='mm' or @ext='pie' or @ext='log' or @ext='vcf' or @ext='mm' or @ext='mmap' or @ext='xmmap' or @ext='xmind' or @ext='docx' or @ext='pptx' or @ext='odt' or @ext='ods' or @ext='odp'">
                  <!--  or @ext='html' -->
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=',$str_cxp_default)"/>
                </xsl:when>
                <xsl:when test="@ext='cxp'">
                  <xsl:value-of select="concat('/',$str_path)"/>
                  <xsl:if test="cxp:make/cxp:description/@anchor">
                    <xsl:value-of select="concat('#',cxp:make/cxp:description/@anchor)"/>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat('?path=',$str_path)"/>
                </xsl:otherwise>
              </xsl:choose>
              <!--
                  <xsl:if test="@write='no'">
                  <xsl:value-of select="concat('&amp;','write=no')"/>
                  </xsl:if>
	      -->
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="contains(@type,'image')">
                <!-- all images -->
                <xsl:value-of select="substring-before(@name,'.')"/>
              </xsl:when>
              <xsl:when test="@ext='xmind'">
                <!-- xmap-content/sheet/topic/title -->
                <xsl:choose>
                  <xsl:when test="true()">
                    <xsl:value-of select="substring(normalize-space(descendant::*[name()='title']),1,50)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="substring-before(@name,concat('.',@ext))"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@ext='mm'">
                <!--  or @ext='html' -->
                <xsl:choose>
                  <xsl:when test="map/node[1]/@TEXT">
                    <xsl:value-of select="substring(map/node[1]/@TEXT,1,50)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="substring-before(@name,concat('.',@ext))"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@ext='mmap' or @ext='xmmap'">
                <!--  -->
                <xsl:choose>
                  <xsl:when test="ap:Map/ap:OneTopic/ap:Topic/ap:Text/@PlainText">
                    <xsl:value-of select="normalize-space(ap:Map/ap:OneTopic/ap:Topic/ap:Text/@PlainText)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="substring-before(@name,concat('.',@ext))"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@ext='cxp'">
                <!--  -->
                <xsl:choose>
                  <xsl:when test="cxp:make/cxp:description">
                    <xsl:choose>
                      <xsl:when test="cxp:make/cxp:description/@icon">
                        <xsl:element name="img">
                          <xsl:attribute name="src">
                            <xsl:value-of select="cxp:make/cxp:description/@icon"/>
                          </xsl:attribute>
                          <xsl:attribute name="title">
                            <xsl:value-of select="cxp:make/cxp:description"/>
                          </xsl:attribute>
                        </xsl:element>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="cxp:make/cxp:description"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="cxp:make/cxp:description"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="make/description">
                    <xsl:value-of select="make/description"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="substring-before(@name,concat('.',@ext))"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@ext='pie' or @ext='txt' or @ext='html' or @ext='odt' or @ext='docx' or @ext='log'">
                <!--  -->
                <xsl:choose>
                  <xsl:when test="pie//section[1]/h">
                    <xsl:value-of select="substring(pie//section[1]/h,1,50)"/>
                  </xsl:when>
                  <xsl:when test="pie//p[1]">
                    <xsl:value-of select="substring(pie//p[1],1,50)"/>
                  </xsl:when>
                  <xsl:otherwise>
		    <xsl:value-of select="translate(substring(substring-before(@name,concat('.',@ext)),1,50),'_',' ')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(substring(substring-before(@name,concat('.',@ext)),1,50),'_-','  ')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
	</xsl:element>
      </xsl:when>
      <xsl:when test="contains(@type,'json')">
        <xsl:variable name="file_header">
          <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:element name="li">
          <xsl:attribute name="class">ui-dir-file</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">
              <xsl:value-of select="$str_frame"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat('?path=',$str_path,'&amp;')"/>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="string-length($file_header) &gt; 0">
                <xsl:value-of select="$file_header"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(substring-before(@name,concat('.',@ext)),'_',' ')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="contains(@type,'sla')">
        <xsl:variable name="file_header">
          <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:element name="li">
          <xsl:attribute name="class">ui-dir-file</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="target">
              <xsl:value-of select="$str_frame"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PieUiInfo')"/>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="string-length($file_header) &gt; 0">
                <xsl:value-of select="$file_header"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(substring-before(@name,concat('.',@ext)),'_',' ')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="true()">
        <!--  default: absolute direct link  -->
        <xsl:element name="li">
          <xsl:attribute name="class">ui-dir-file</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="class">file</xsl:attribute>
            <xsl:attribute name="target">
              <xsl:value-of select="$str_frame"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:choose>
                <xsl:when test="@ext='zip' and zip/*">
                  <xsl:value-of select="concat(@name,' (',normalize-space(zip/*/@name),')')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat(@name,' ',@type,' ',@mtime2)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat('/',$str_path)"/>
            </xsl:attribute>
            <xsl:copy-of select="@type"/>
            <xsl:call-template name="LINKTEXT">
              <xsl:with-param name="str_path">
                <xsl:value-of select="@name"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <!-- ignore anything else -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="DIRACTIONS">
    <!--  -->
    <xsl:param name="dir_path" select="''"/>
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="concat('?path=',$dir_path,'&amp;','cxp=PieUiDir')"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="'Reload Dir'"/>
      </xsl:attribute>
      <xsl:text> &#x21BA;</xsl:text>
    </xsl:element>
    <xsl:element name="a">
      <xsl:attribute name="target"><xsl:value-of select="$str_frame"/></xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="concat('?path=',$dir_path,'&amp;','cxp=PiejQDirVerbose','&amp;','depth=1')"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="'Verbose Dir'"/>
      </xsl:attribute>
      <xsl:text> &#x1F4C2;</xsl:text>
    </xsl:element>
    <xsl:element name="a">
      <xsl:attribute name="target"><xsl:value-of select="$str_frame"/></xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="concat('?','cxp=GetHistory')"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="'History'"/>
      </xsl:attribute>
      <xsl:text> ☜</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template name="DIRPATHLINKS">
    <!--  -->
    <xsl:param name="dir_done" select="''"/>
    <!--  -->
    <xsl:param name="dir_path" select="''"/>
    <!--  -->
    <xsl:param name="dir_done_view" select="''"/>
    <!--  -->
    <xsl:param name="dir_path_view" select="''"/>
    <!--  -->
    <xsl:variable name="dir_current">
      <xsl:choose>
        <xsl:when test="not(contains($dir_path,'/'))">
          <xsl:value-of select="$dir_path"/>
        </xsl:when>
        <xsl:when test="contains(substring-after($dir_path,$dir_done),'/')">
          <xsl:value-of select="substring-before(substring-after($dir_path,$dir_done),'/')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring-after($dir_path,$dir_done)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--  -->
    <xsl:variable name="dir_current_view">
      <xsl:choose>
        <xsl:when test="not(contains($dir_path_view,'/'))">
          <xsl:value-of select="$dir_path_view"/>
        </xsl:when>
        <xsl:when test="contains(substring-after($dir_path_view,$dir_done_view),'/')">
          <xsl:value-of select="substring-before(substring-after($dir_path_view,$dir_done_view),'/')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring-after($dir_path_view,$dir_done_view)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$dir_path=''">
        <!--  -->
        <xsl:element name="a">
          <xsl:attribute name="target">
            <xsl:value-of select="$str_frame"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="concat('?path=/','&amp;','cxp=PiejQDirDir')"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="'Root Dir'"/>
          </xsl:attribute>
          <xsl:value-of select="'&#x21F1; '"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$dir_done=''">
        <!--  -->
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="concat('?path=','&amp;','cxp=PieUiDir')"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="'Root Dir'"/>
          </xsl:attribute>
          <xsl:value-of select="'&#x21F1; '"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <!--  -->
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="contains(substring-after($dir_path,concat($dir_done,$dir_current,'/')),'/')">
        <!-- this is a directory in $dir_path  -->
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="concat('?path=',$dir_done,$dir_current,'&amp;','cxp=PieUiDir')"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="$dir_current_view"/>
          </xsl:attribute>
          <xsl:call-template name="LINKTEXT">
            <xsl:with-param name="str_path">
              <xsl:value-of select="$dir_current_view"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:element>
        <xsl:text> / </xsl:text>
        <xsl:call-template name="DIRPATHLINKS">
          <xsl:with-param name="dir_done">
            <xsl:value-of select="concat($dir_done,$dir_current,'/')"/>
          </xsl:with-param>
          <xsl:with-param name="dir_path">
            <xsl:value-of select="$dir_path"/>
          </xsl:with-param>
          <xsl:with-param name="dir_done_view">
            <xsl:value-of select="concat($dir_done_view,$dir_current_view,'/')"/>
          </xsl:with-param>
          <xsl:with-param name="dir_path_view">
            <xsl:value-of select="$dir_path_view"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- last directory in $dir_path, it's the current one -->
        <xsl:element name="a">
          <xsl:attribute name="target">
            <xsl:value-of select="$str_frame"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="$dir_current"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="concat('?path=',$dir_done,$dir_current,'&amp;','cxp=PiejQDirDir')"/>
            <xsl:if test="$write='no'">
              <xsl:value-of select="concat('&amp;','write=no')"/>
            </xsl:if>
          </xsl:attribute>
          <xsl:call-template name="LINKTEXT">
            <xsl:with-param name="str_path">
              <xsl:value-of select="$dir_current_view"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:element>
        <xsl:text/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="LINKTEXT">
    <xsl:param name="str_path" select="''"/>
    <xsl:choose>
      <xsl:when test="$str_path = ''">
        <!-- root dir -->
        <xsl:value-of select="' . '"/>
      </xsl:when>
      <xsl:when test="string-length($str_path) &gt; $length_link">
        <!-- name is too long -->
        <xsl:value-of select="concat(substring($str_path,1,$length_link),'...')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str_path"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
