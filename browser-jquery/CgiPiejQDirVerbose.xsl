<?xml version="1.0"?>
<xsl:stylesheet xmlns:cxp="http://www.tenbusch.info/cxproc" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:rpt="http://openoffice.org/2005/report" xmlns:rdfa="http://docs.oasis-open.org/opendocument/meta/rdfa#" xmlns:office="http://openoffice.org/2000/office" xmlns:style="http://openoffice.org/2000/style" xmlns:text="http://openoffice.org/2000/text" xmlns:table="http://openoffice.org/2000/table" xmlns:draw="http://openoffice.org/2000/drawing" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:meta="http://openoffice.org/2000/meta" xmlns:number="http://openoffice.org/2000/datastyle" xmlns:svg="http://www.w3.org/2000/svg" xmlns:chart="http://openoffice.org/2000/chart" xmlns:dr3d="http://openoffice.org/2000/dr3d" xmlns:form="http://openoffice.org/2000/form" xmlns:script="http://openoffice.org/2000/script" xmlns:ap="http://schemas.mindjet.com/MindManager/Application/2003" version="1.0">
  <!--  -->
  <xsl:variable name="str_cxp_default" select="'PiejQDefault'"/>
  <!--  -->
  <xsl:variable name="str_frame" select="'piemain'"/>
  <!--  -->
  <xsl:variable name="write" select="'yes'"/>
  <xsl:output method="html" encoding="UTF-8"/>
  <xsl:template match="/pie">
    <xsl:element name="html">
      <xsl:element name="body">
        <xsl:element name="table">
	  <xsl:attribute name="id">
	    <xsl:text>localTable</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="class">
	    <xsl:text>tablesorter</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="border">
	    <xsl:text>0</xsl:text>
	  </xsl:attribute>
          <xsl:element name="thead">
            <xsl:element name="tr">
              <xsl:element name="th">Title</xsl:element>
              <xsl:element name="th">File name</xsl:element>
              <xsl:element name="th">Edit</xsl:element>
              <xsl:element name="th">Meta</xsl:element>
              <xsl:element name="th">Byte</xsl:element>
              <xsl:element name="th">MTime</xsl:element>
              <xsl:element name="th">MIME</xsl:element>
              <xsl:element name="th">Archive</xsl:element>
              <xsl:element name="th">Cache</xsl:element>
              <xsl:element name="th">Trash</xsl:element>
	    </xsl:element>
	  </xsl:element>
          <xsl:element name="tbody">
            <xsl:apply-templates select="descendant::file[@urlname and not(ancestor::archive)]">
              <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
            </xsl:apply-templates>
	  </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="file">
    <!--  -->
    <xsl:variable name="str_path">
      <xsl:for-each select="ancestor::dir[@urlname and not(@name = '.')]">
	<xsl:if test="@urlprefix">
	  <xsl:value-of select="concat(@urlprefix,'/')" />
	</xsl:if>
	<xsl:value-of select="concat(@urlname,'/')" />
      </xsl:for-each>
      <xsl:value-of select="@urlname" />
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
      </xsl:when>

      <xsl:when test="contains(@type,'audio') and not(@error)">
        <!-- use id3 tags -->
        <xsl:element name="tr">
          <xsl:element name="td">
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
          <xsl:element name="td">
            <xsl:attribute name="class">ui-dir-file</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="class">cxp</xsl:attribute>
              <xsl:attribute name="target">
		<xsl:value-of select="$str_frame"/>
              </xsl:attribute>
              <xsl:attribute name="href">
		<xsl:value-of select="concat('?path=',$str_path)"/>
              </xsl:attribute>
              <xsl:value-of select="$str_path"/>
            </xsl:element>
          </xsl:element>
	</xsl:element>
      </xsl:when>

      <xsl:when test="contains(@type,'application/zip') or contains(@type,'application/x-iso9660-image') or contains(@type,'application/x-tar')">
        <xsl:variable name="file_header">
          <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:element name="tr">
          <xsl:element name="td">
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
          <xsl:element name="td">
            <xsl:attribute name="class">ui-dir-file</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="target">
		<xsl:value-of select="$str_frame"/>
              </xsl:attribute>
              <xsl:attribute name="title">
		<xsl:value-of select="@name"/>
              </xsl:attribute>
              <xsl:attribute name="href">
		<xsl:value-of select="concat('/',$str_path)"/>
              </xsl:attribute>
              <xsl:value-of select="@name"/>
            </xsl:element>
          </xsl:element>	  
	  </xsl:element>
        <xsl:apply-templates select="child::archive/descendant::file[@name]">
          <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="name()"/>
          <xsl:sort order="ascending" data-type="text" case-order="lower-first" select="@name"/>
          <xsl:with-param name="path_prefix">
	    <xsl:value-of select="$str_path"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>

      <xsl:otherwise>
        <xsl:element name="tr">
          <xsl:element name="td">
            <!-- dynamic content using cxproc -->
            <xsl:attribute name="class">ui-dir-file</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="class">cxp</xsl:attribute>
              <xsl:attribute name="target">
                <xsl:value-of select="$str_frame"/>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:choose>
                  <xsl:when test="contains(@type,'image') and exif/size">
                    <!-- all images -->
                    <xsl:value-of select="concat(@name,' (',exif/size/@col,'x',exif/size/@row,'): ',exif/comment/@value)"/>
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
		  <xsl:when test="@ext='html'">
                    <xsl:value-of select="concat('/',$str_path)"/>
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
                <xsl:when test="@ext='pie' or @ext='txt' or @ext='html' or @ext='odt'">
                  <!--  -->
                  <xsl:choose>
                    <xsl:when test="pie/section[1]/h">
                      <xsl:value-of select="pie/section[1]/h"/>
                    </xsl:when>
                    <xsl:when test="pie/section[1]/section[1]/h">
                      <xsl:value-of select="pie/section[1]/section[1]/h"/>
                    </xsl:when>
                    <xsl:when test="pie//p[1]">
                      <xsl:value-of select="pie//p[1]"/>
                    </xsl:when>
                    <xsl:otherwise>
		      <xsl:value-of select="substring-before(@name,'.')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="translate(substring-before(@name,'.'),'_-','  ')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
	  </xsl:element>
	  <xsl:element name="td">
	    <xsl:element name="a">
              <xsl:attribute name="href">
		<xsl:value-of select="concat('/',$str_path)"/>
	      </xsl:attribute>
	      <xsl:value-of select="concat(@name,'')"/>
	    </xsl:element>
	  </xsl:element>
	  <xsl:element name="td">
	    <xsl:if test="@ext='pie' or @ext='mm' or @ext='cxp' or starts-with(@type,'text')">
	      <xsl:element name="a">
		<xsl:attribute name="class">cxp</xsl:attribute>
		<xsl:attribute name="title">
		  <xsl:value-of select="@name"/>
		</xsl:attribute>
		<xsl:attribute name="href">
		  <xsl:value-of select="concat('?','path=',$str_path,'&amp;','cxp=PiejQEditor')"/>
		</xsl:attribute>
		<xsl:text>[Edit]</xsl:text>
	      </xsl:element>
	    </xsl:if>
	  </xsl:element>
	  <xsl:element name="td">
	    <xsl:element name="a">
	      <xsl:attribute name="class">cxp</xsl:attribute>
	      <xsl:attribute name="title">
		<xsl:value-of select="@name"/>
	      </xsl:attribute>
	      <xsl:attribute name="href">
		<xsl:value-of select="concat('?','path=',$str_path,'&amp;','cxp=PiejQFormat')"/>
	      </xsl:attribute>
	      <xsl:text>[Meta]</xsl:text>
	    </xsl:element>
	  </xsl:element>
	  <xsl:element name="td">
	    <xsl:value-of select="@size"/>
	  </xsl:element>
	  <xsl:element name="td">
	    <xsl:value-of select="@mtime2"/>
	  </xsl:element>
	  <xsl:element name="td">
	    <xsl:value-of select="@type"/>
	  </xsl:element>
	  <xsl:element name="td">
	    <xsl:element name="a">
	      <xsl:attribute name="class">cxp</xsl:attribute>
	      <xsl:attribute name="title">
		<xsl:value-of select="@name"/>
	      </xsl:attribute>
	      <xsl:attribute name="href">
		<xsl:value-of select="concat('?','path=',$str_path,'&amp;','cxp=Archive')"/>
	      </xsl:attribute>
	      <xsl:text>[Archive]</xsl:text>
	    </xsl:element>
	  </xsl:element>
	  <xsl:element name="td">
	    <xsl:element name="a">
	      <xsl:attribute name="class">cxp</xsl:attribute>
	      <xsl:attribute name="title">
		<xsl:value-of select="@name"/>
	      </xsl:attribute>
	      <xsl:attribute name="href">
		<xsl:value-of select="concat('?','path=',$str_path,'&amp;','cxp=Cache')"/>
	      </xsl:attribute>
	      <xsl:text>[Cache]</xsl:text>
	    </xsl:element>
	  </xsl:element>
	  <xsl:element name="td">
	    <xsl:element name="a">
	      <xsl:attribute name="class">cxp</xsl:attribute>
	      <xsl:attribute name="title">
		<xsl:value-of select="@name"/>
	      </xsl:attribute>
	      <xsl:attribute name="href">
		<xsl:value-of select="concat('?','path=',$str_path,'&amp;','cxp=Trash')"/>
	      </xsl:attribute>
	      <xsl:text>[Trash]</xsl:text>
	    </xsl:element>
	  </xsl:element>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
