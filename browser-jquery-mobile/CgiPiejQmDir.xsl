<?xml version="1.0"?>
<xsl:stylesheet xmlns:cxp="http://www.tenbusch.info/cxproc" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:rpt="http://openoffice.org/2005/report" xmlns:rdfa="http://docs.oasis-open.org/opendocument/meta/rdfa#" xmlns:office="http://openoffice.org/2000/office" xmlns:style="http://openoffice.org/2000/style" xmlns:text="http://openoffice.org/2000/text" xmlns:table="http://openoffice.org/2000/table" xmlns:draw="http://openoffice.org/2000/drawing" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:meta="http://openoffice.org/2000/meta" xmlns:number="http://openoffice.org/2000/datastyle" xmlns:svg="http://www.w3.org/2000/svg" xmlns:chart="http://openoffice.org/2000/chart" xmlns:dr3d="http://openoffice.org/2000/dr3d" xmlns:form="http://openoffice.org/2000/form" xmlns:script="http://openoffice.org/2000/script" xmlns:ap="http://schemas.mindjet.com/MindManager/Application/2003" version="1.0">
  <!-- \todo combined refactoring CgiPieUiDir -->
  <xsl:import href="../xml/xsl/html/PieHtmlMobile.xsl"/>
  <!--
     s. https://demos.jquerymobile.com/1.4.5/
  -->
  <xsl:variable name="path" select="''"/>
  <!--  -->
  <xsl:variable name="flag_gallery" select="false()"/>
  <!--  -->
  <xsl:variable name="length_link" select="15"/>
  <!--  -->
  <xsl:variable name="str_cxp_default" select="'PiejQmDefault'"/>
  <!--  -->
  <xsl:variable name="write" select="'yes'"/>
  <xsl:output method="html" encoding="UTF-8"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="body">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="pie">
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
    <xsl:choose>
      <xsl:when test="$flag_gallery">
        <!-- gallery mode -->
        <xsl:call-template name="PIEDIRGALLERY">
          <xsl:with-param name="path_prefix">
            <xsl:value-of select="$str_path_top"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="div">
          <xsl:element name="div">
            <xsl:attribute name="data-role">page</xsl:attribute>
            <xsl:attribute name="id">p0</xsl:attribute>
            <xsl:element name="div">
              <xsl:attribute name="data-role">header</xsl:attribute>
              <xsl:attribute name="data-add-back-btn">false</xsl:attribute>
              <xsl:element name="h1">
                <xsl:value-of select="dir/@name"/>
              </xsl:element>
            </xsl:element>
            <xsl:element name="div">
              <xsl:attribute name="data-role">content</xsl:attribute>
              <xsl:element name="div">
                <xsl:attribute name="data-role">listview</xsl:attribute>
                <xsl:apply-templates select="dir/*[name()='dir' or name()='file']">
                  <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="name()"/>
                  <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
                  <xsl:with-param name="path_prefix">
                    <xsl:value-of select="$str_path_top"/>
                  </xsl:with-param>
                </xsl:apply-templates>
              </xsl:element>
            </xsl:element>
            <xsl:call-template name="PIEDIRNAVIGATION">
              <xsl:with-param name="path_prefix">
                <xsl:value-of select="$str_path_top"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
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
      <xsl:when test="@hidden = 'yes'"/>
      <xsl:when test="@read='no' or @execute='no' or @error"/>
      <xsl:when test="@name = 'tmp' or @name = 'temp' or @name = 'Temp'"/>
      <xsl:when test="starts-with(@name,'_')"/>
      <xsl:when test="not(@name = '')">
        <xsl:element name="li">
          <xsl:attribute name="data-icon">gear</xsl:attribute>
          <xsl:element name="a">
            <!-- the sub directories are links -->
            <xsl:choose>
              <xsl:when test="@read='no' or @execute='no' or @error">
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PiejQmDir')"/>
                  <xsl:if test="@write='no'">
                    <xsl:value-of select="concat('&amp;','write=no')"/>
                  </xsl:if>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="@name"/>
          </xsl:element>
        </xsl:element>
        <xsl:apply-templates select="dir|file">
          <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="name()"/>
          <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="info/track"/>
          <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
          <xsl:with-param name="path_prefix">
            <xsl:value-of select="$str_path_top"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
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
      <xsl:when test="contains(@type,'error') or @error or @read='no'"/>
      <!--
      <xsl:when test="@name = 'index.htm' or @name = 'index.html'">
        <xsl:element name="li">

          <xsl:element name="a">
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="$file_name"/>
            </xsl:attribute>
            <xsl:value-of select="@name"/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      -->
      <xsl:when test="contains(@type,'audio')">
        <!-- use id3 tags -->
        <xsl:element name="li">
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="concat('/',$str_path)"/>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="info/*">
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
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PieUiSqlite')"/>
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
      <xsl:when test="contains(@type,'application/zip')">
        <xsl:variable name="file_header">
          <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:element name="li">
          <xsl:element name="a">
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
      <xsl:when test="contains(@type,'image')">
        <!-- all images -->
        <xsl:element name="li">
          <xsl:element name="a">
            <xsl:attribute name="rel">external</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="concat('/',$str_path)"/>
            </xsl:attribute>
            <xsl:value-of select="@name"/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="@ext='docx' or @ext='txt' or @ext='md' or @ext='mm' or @ext='mmap' or @ext='xmmap' or @ext='xmind' or @ext='pie' or @ext='cxp' or @ext='vcf' or @ext='csv' or @ext='ics' or @ext='odt' or @ext='sxw' or @ext='ods' or @ext='sxc' or (contains(@type,'image') and image)">
        <!-- dynamic content using cxproc -->
        <xsl:choose>
          <xsl:when test="@ext='cxp' and not(cxp:make/cxp:description)">
            <!-- ignore cxp files without description -->
          </xsl:when>
          <xsl:when test="@ext='pie' and pie[@class='shortcuts']">
            <!-- list of links in shortcut file -->
            <xsl:copy-of select="pie//script"/>
            <xsl:for-each select="pie//*[(name()='link' or (name()='p' and not(child::*))) and not(parent::*[@valid='no']) and not(@valid='no')]">
              <xsl:element name="li">
                <xsl:element name="a">
                  <xsl:copy-of select="@id"/>
                  <xsl:copy-of select="@href"/>
                  <xsl:value-of select="."/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <!-- single link to named file -->
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:choose>
                    <xsl:when test="contains(@type,'image') or @ext = 'jpg' or @ext = 'png'">
                      <!-- all images -->
                      <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=image')"/>
                    </xsl:when>
                    <xsl:when test="@ext='ics'">
                      <!-- edit form for this type of files -->
                      <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=PiejQCalendar')"/>
                    </xsl:when>
                    <xsl:when test="@ext='txt' or @ext='md' or @ext='mm' or @ext='pie' or @ext='log' or @ext='vcf' or @ext='mm' or @ext='mmap' or @ext='xmmap' or @ext='xmind' or @ext='docx' or @ext='pptx' or @ext='xlsx' or @ext='odt' or @ext='ods' or @ext='odp' or @ext='csv'">
                      <!--  or @ext='html' -->
                      <xsl:value-of select="concat('?path=',$str_path,'&amp;','cxp=',$str_cxp_default)"/>
                    </xsl:when>
                    <xsl:when test="@ext='cxp'">
                      <xsl:value-of select="concat('/',$str_path)"/>
                      <xsl:if test="false() and cxp:make/cxp:description/@anchor">
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
                        <xsl:value-of select="cxp:make/cxp:description"/>
                      </xsl:when>
                      <xsl:when test="make/description">
                        <xsl:value-of select="make/description"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="substring-before(@name,concat('.',@ext))"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="@ext='pie' or @ext='txt' or @ext='html'">
                    <!--  -->
                    <xsl:choose>
                      <xsl:when test="pie/section[1]/h">
                        <xsl:value-of select="substring(pie/section[1]/h,1,50)"/>
                      </xsl:when>
                      <xsl:when test="pie//p[1]">
                        <xsl:value-of select="substring(pie//p[1],1,50)"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="substring-before(@name,concat('.',@ext))"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="translate(substring(substring-before(@name,concat('.',@ext)),1,50),'_-','  ')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="true()">
        <!--  default: absolute direct link  -->
        <xsl:element name="li">
          <xsl:element name="a">
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
  <xsl:template name="PIEDIRNAVIGATION">
    <!--  -->
    <xsl:param name="path_prefix" select="''"/>
    <xsl:element name="div">
      <xsl:attribute name="data-role">footer</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="data-role">navbar</xsl:attribute>
        <xsl:element name="ul">
          <xsl:element name="li">
            <xsl:element name="a">
              <xsl:attribute name="data-icon">home</xsl:attribute>
              <xsl:attribute name="onclick">
                <xsl:text>javascript:window.location.assign('?cxp=PiejQmDir');</xsl:text>
              </xsl:attribute>
              <xsl:text>Home</xsl:text>
            </xsl:element>
          </xsl:element>
          <xsl:element name="li">
            <xsl:element name="a">
              <xsl:attribute name="data-icon">grid</xsl:attribute>
              <xsl:attribute name="onclick">
                <xsl:value-of select="concat('javascript:window.location.assign(','&quot;','?path=',$path_prefix,'&amp;','cxp=PiejQmGallery','&quot;',');')"/>
              </xsl:attribute>
              <xsl:text>Gallery</xsl:text>
            </xsl:element>
          </xsl:element>
	  <!--
          <xsl:element name="li">
            <xsl:element name="a">
              <xsl:attribute name="data-icon">grid</xsl:attribute>
              <xsl:attribute name="onclick">
                <xsl:value-of select="concat('javascript:window.location.assign(','&quot;','?path=',$path_prefix,'&amp;','cxp=PlayList','&quot;',');')"/>
              </xsl:attribute>
              <xsl:text>Playlist</xsl:text>
            </xsl:element>
          </xsl:element>
	  -->
          <xsl:element name="li">
            <xsl:element name="a">
              <xsl:attribute name="data-icon">action</xsl:attribute>
              <xsl:attribute name="onclick">
                <xsl:value-of select="concat('javascript:window.location.assign(','&quot;','?path=',$path_prefix,'&amp;','cxp=PieUiDir','&quot;',');')"/>
              </xsl:attribute>
              <xsl:text>Desktop</xsl:text>
            </xsl:element>
          </xsl:element>	  
          <xsl:element name="li">
            <xsl:element name="a">
              <xsl:attribute name="data-icon">info</xsl:attribute>
              <xsl:attribute name="href">
                <xsl:value-of select="concat('?','cxp=PieUiPowered')"/>
              </xsl:attribute>
              <xsl:text>Powered by ...</xsl:text>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="PIEDIRGALLERY">
    <!--  -->
    <xsl:param name="path_prefix" select="''"/>
    <script type="text/javascript">$(document).ready(function() {$('.swipebox').swipebox();});</script>
    <xsl:element name="div">
      <xsl:for-each select="//file[contains(@type,'image') and not(@error) and @size &gt; 0]">
        <xsl:variable name="str_path">
          <xsl:for-each select="ancestor::dir[@urlname]">
            <xsl:if test="@urlprefix">
              <xsl:value-of select="concat('/',@urlprefix)"/>
            </xsl:if>
            <xsl:value-of select="concat('/',@urlname)"/>
          </xsl:for-each>
          <xsl:value-of select="concat('/',@urlname)"/>
        </xsl:variable>
        <xsl:element name="a">
          <xsl:attribute name="class">swipebox</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$str_path"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="concat('',@name)"/>
          </xsl:attribute>
          <xsl:element name="img">
            <xsl:attribute name="src">
              <xsl:value-of select="$str_path"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:value-of select="concat('',@name)"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
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
