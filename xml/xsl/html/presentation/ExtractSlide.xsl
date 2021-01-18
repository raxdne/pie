<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
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
  <xsl:import href="../PieHtml.xsl"/>
  <xsl:output method="html" omit-xml-declaration="no" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="file:///tmp/dummy.dtd" encoding="UTF-8"/>
  <!-- normalized name of plain input file -->
  <xsl:variable name="file_norm"></xsl:variable>
  <!-- name of plain input file -->
  <xsl:variable name="file_plain" select="translate($file_norm,'\','/')"/>
  <!--  -->
  <xsl:variable name="nr_slide" select="0"/>
  <xsl:variable name="name_slide" select="'slide'"/>
  <xsl:variable name="file_css" select="'presentation.css'"/>
  <xsl:variable name="file_js" select="''"/>
  <xsl:variable name="flag_form" select="false()"/>
  <xsl:variable name="flag_agenda" select="false()"/>
  <xsl:variable name="flag_title" select="false()"/>
  <xsl:variable name="flag_toc" select="false()"/>
  <xsl:variable name="flag_icons" select="false()"/>
  <xsl:variable name="flag_timer" select="false()"/>
  <xsl:variable name="flag_navigation" select="true()"/>
  <xsl:variable name="flag_search" select="false()"/>
  <xsl:variable name="flag_search_result" select="false()"/>
  <xsl:variable name="str_xpath" select="'/'"/>
  <xsl:variable name="type" select="''"/>
  <xsl:variable name="level_hidden" select="0"/>
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:call-template name="HEADER"/>
      <xsl:element name="body">
        <xsl:choose>
          <xsl:when test="$flag_title">
            <xsl:call-template name="title"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$flag_navigation">
              <xsl:call-template name="navigation"/>
              <xsl:element name="hr"/>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$flag_agenda or $flag_toc">
                <xsl:call-template name="agenda"/>
              </xsl:when>
              <xsl:when test="$flag_search">
                <xsl:call-template name="form_search"/>
              </xsl:when>
              <xsl:when test="$flag_search_result">
                <xsl:call-template name="form_search"/>
                <hr/>
                <xsl:call-template name="form_search_result"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="main"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not($file_js = '')">
          <xsl:element name="script">
            <xsl:attribute name="language">JavaScript</xsl:attribute>
            <xsl:attribute name="type">text/javascript</xsl:attribute>
            <xsl:attribute name="src">
              <xsl:value-of select="$file_js"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="navigation">
    <!-- navigation area -->
    <xsl:variable name="count_slides" select="count(//section[@class='slide'])"/>
    <xsl:element name="table">
      <xsl:attribute name="width">100%</xsl:attribute>
      <xsl:attribute name="cellspacing">4</xsl:attribute>
      <xsl:element name="tbody">
        <xsl:element name="tr">
          <xsl:element name="td">
            <xsl:attribute name="class">nav</xsl:attribute>
            <xsl:attribute name="align">right</xsl:attribute>
            <!--  -->
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:choose>
                  <xsl:when test="$flag_form">
                    <xsl:value-of select="concat('?cxp=PresentationAgenda','&amp;','path=',$file_plain)"/>
                    <xsl:if test="not($str_xpath='/')">
                      <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$name_slide"/>
                    <xsl:text>-agenda</xsl:text>
                    <xsl:text>.html</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:text>Agenda</xsl:text>
              </xsl:attribute>
              <xsl:if test="$flag_agenda">
                <xsl:attribute name="class">large</xsl:attribute>
              </xsl:if>
              <xsl:element name="b">
                <xsl:text>&#x2800;A&#x2800;</xsl:text>
              </xsl:element>
            </xsl:element>
            <xsl:text> / </xsl:text>
            <!-- slide numbers -->
            <xsl:for-each select="//section[@class='slide']">
              <xsl:element name="a">
                <xsl:choose>
                  <xsl:when test="position()=$nr_slide and not($flag_agenda) and not($flag_toc)">
                    <xsl:attribute name="class">large</xsl:attribute>
                    <xsl:value-of select="position()"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="href">
                      <xsl:choose>
                        <xsl:when test="$flag_form">
                          <xsl:value-of select="concat('?cxp=PresentationSlide','&amp;','i=',position(),'&amp;','path=',$file_plain)"/>
                          <xsl:if test="not($str_xpath='/')">
                            <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                          </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$name_slide"/>
                          <xsl:text>-</xsl:text>
                          <xsl:value-of select="position()"/>
                          <xsl:text>.html</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="normalize-space(concat(parent::section/h,', ',h))"/>
                    </xsl:attribute>
                    <xsl:value-of select="position()"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
              <xsl:text> </xsl:text>
              <xsl:if test="count(following-sibling::section[@class='slide']) &lt; 1">
                <xsl:text>/ </xsl:text>
              </xsl:if>
            </xsl:for-each>
            <!--  -->
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:choose>
                  <xsl:when test="$flag_form">
                    <xsl:value-of select="concat('?cxp=PresentationIndex','&amp;','path=',$file_plain)"/>
                    <xsl:if test="not($str_xpath='/')">
                      <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$name_slide"/>
                    <xsl:text>-toc.html</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:text>Index</xsl:text>
              </xsl:attribute>
              <xsl:if test="$flag_toc">
                <xsl:attribute name="class">large</xsl:attribute>
              </xsl:if>
              <xsl:element name="b">
                <xsl:text>&#x2800;I&#x2800;</xsl:text>
              </xsl:element>
            </xsl:element>
            <xsl:text> </xsl:text>
          </xsl:element>
          <xsl:element name="td">
	    <xsl:attribute name="class">nav</xsl:attribute>
            <xsl:attribute name="width">150</xsl:attribute>
            <!-- navigation symbols -->
            <xsl:choose>
              <xsl:when test="$flag_search or $flag_search_result or $flag_agenda or $flag_toc or $nr_slide=1">
                <!-- BACK empty -->
                <xsl:element name="a">
                  <xsl:choose>
                    <xsl:when test="$flag_icons">
                      <img src="leer.png"/>
                    </xsl:when>
                    <xsl:otherwise>
		      <xsl:attribute name="class">hidden</xsl:attribute>
                      <xsl:text>&#x21D0;</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <!-- BACK arrow -->
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:choose>
                      <xsl:when test="$flag_form">
                        <xsl:value-of select="concat('?cxp=PresentationSlide','&amp;','i=',$nr_slide - 1,'&amp;','path=',$file_plain)"/>
                        <xsl:if test="not($str_xpath='/')">
                          <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$name_slide"/>
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="$nr_slide - 1"/>
                        <xsl:text>.html</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="$flag_icons">
                      <img src="zurueck.png" alt="Vorhergehende Folie"/>
                    </xsl:when>
                    <xsl:otherwise>
		      <xsl:attribute name="class">nav</xsl:attribute>
                      <xsl:text>&#x21D0;</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
            <!-- UP arrow -->
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:choose>
                  <xsl:when test="$flag_form">
                    <xsl:choose>
                      <xsl:when test="$flag_agenda or $flag_toc">
                        <xsl:value-of select="concat('?cxp=PresentationTitle','&amp;','path=',$file_plain)"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="concat('?cxp=PresentationAgenda','&amp;','path=',$file_plain)"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="not($str_xpath='/')">
                      <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="$flag_agenda or $flag_toc">
                        <xsl:text>index</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$name_slide"/>
                        <xsl:text>-agenda</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>.html</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:choose>
                <xsl:when test="$flag_icons">
                  <img src="raus.png" alt="Verlassen"/>
                </xsl:when>
                <xsl:otherwise>
		  <xsl:attribute name="class">nav</xsl:attribute>
                  <xsl:text>&#x21D1;</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
            <xsl:text> </xsl:text>
            <xsl:choose>
              <xsl:when test="$flag_search or $flag_search_result or $flag_agenda or $flag_toc or $nr_slide=$count_slides">
                <!-- NEXT empty -->
                <xsl:element name="a">
                  <xsl:choose>
                    <xsl:when test="$flag_icons">
                      <img src="leer.png"/>
                    </xsl:when>
                    <xsl:otherwise>
		      <xsl:attribute name="class">hidden</xsl:attribute>
                      <xsl:text>&#x21D2;</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <!-- NEXT arrow -->
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:choose>
                      <xsl:when test="$flag_form">
                        <xsl:value-of select="concat('?cxp=PresentationSlide','&amp;','i=',$nr_slide + 1,'&amp;','path=',$file_plain)"/>
                        <xsl:if test="not($str_xpath='/')">
                          <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$name_slide"/>
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="$nr_slide + 1"/>
                        <xsl:text>.html</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="$flag_icons">
                      <img src="weiter.png" alt="Nächste Folie"/>
                    </xsl:when>
                    <xsl:otherwise>
		      <xsl:attribute name="class">nav</xsl:attribute>
                      <xsl:text>&#x21D2;</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
        <!-- parent section header -->
        <xsl:element name="tr">
          <xsl:element name="td">
            <xsl:attribute name="class">nav</xsl:attribute>
            <xsl:attribute name="colspan">1</xsl:attribute>
            <xsl:attribute name="align">right</xsl:attribute>
            <xsl:choose>
              <xsl:when test="$nr_slide &gt; 0">
                <xsl:for-each select="//section[@class='slide']">
                  <xsl:if test="position()=$nr_slide">
                    <xsl:value-of select="../h"/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text> </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <xsl:element name="td">
            <xsl:attribute name="align">right</xsl:attribute>
            <xsl:if test="not($flag_form)">
              <!-- Script -->
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="$name_slide"/>
                  <xsl:text>-script.html</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="target">
                  <xsl:text>_blank</xsl:text>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="$flag_icons">
                    <img src="script.png" alt="Script"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:element name="b">
                      <xsl:text>#</xsl:text>
                    </xsl:element>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:if>
            <xsl:if test="not($flag_form) and $flag_search">
              <!-- FIND -->
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="$name_slide"/>
                  <xsl:text>-search.html</xsl:text>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="$flag_icons">
                    <img src="search.png" alt="Finden"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>?</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:if>
            <xsl:if test="not($flag_form)">
              <!-- folder -->
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:text>.</xsl:text>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="$flag_icons">
                    <img src="folder.png" alt="Verzeichnis"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>?</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:if>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="main">
    <!-- main area -->
    <xsl:for-each select="//section[@class='slide']">
      <xsl:if test="position()=$nr_slide">
        <xsl:element name="center">
          <xsl:element name="table">
            <xsl:attribute name="width">80%</xsl:attribute>
            <xsl:attribute name="cellpadding">10</xsl:attribute>
            <!-- <xsl:attribute name="onclick">//showNext();</xsl:attribute> -->
            <xsl:element name="tbody">
              <xsl:element name="tr">
                <xsl:element name="th">
                  <xsl:attribute name="class">slide</xsl:attribute>
		  <xsl:call-template name="ADDSTYLE"/>
                  <xsl:apply-templates select="h"/>
                </xsl:element>
              </xsl:element>
              <!--  -->
              <xsl:element name="tr">
                <xsl:element name="td">
                  <xsl:attribute name="align">left</xsl:attribute>
                  <xsl:attribute name="id">content</xsl:attribute>
                  <xsl:apply-templates select="*[not(name()='h')]"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="agenda">
    <!-- agenda slide -->
    <xsl:element name="center">
      <xsl:element name="table">
        <xsl:attribute name="width">80%</xsl:attribute>
        <xsl:attribute name="cellspacing">4</xsl:attribute>
        <xsl:element name="tbody">
          <xsl:element name="tr">
            <xsl:element name="th">
              <!-- presentation title -->
              <xsl:attribute name="class">toc</xsl:attribute>
              <xsl:attribute name="colspan">2</xsl:attribute>
              <xsl:value-of select="/pie/section/h"/>
            </xsl:element>
          </xsl:element>
          <!-- section titles -->
          <xsl:for-each select="/pie/section/section[child::section[@class='slide']]">
            <xsl:element name="tr">
              <xsl:element name="td">
                <xsl:attribute name="align">center</xsl:attribute>
                <xsl:attribute name="colspan">2</xsl:attribute>
                <xsl:element name="b">
		  <xsl:call-template name="ADDSTYLE"/>
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      <xsl:choose>
                        <xsl:when test="$flag_form">
                          <xsl:value-of select="concat('?cxp=PresentationSlide','&amp;','i=',count(preceding-sibling::section/section[@class='slide'])+1,'&amp;','path=',$file_plain)"/>
                          <xsl:if test="not($str_xpath='/')">
                            <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                          </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$name_slide"/>
                          <xsl:text>-</xsl:text>
                          <xsl:value-of select="count(preceding-sibling::section/section[@class='slide'])+1"/>
                          <xsl:text>.html</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="h"/>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:if test="$flag_toc">
              <!-- slide titles -->
              <xsl:for-each select="section[@class='slide']">
                <xsl:variable name="i_slide" select="count(parent::section/preceding-sibling::section/section[@class='slide']) + count(preceding-sibling::section[@class='slide']) + 1"/>
                <xsl:element name="tr">
                  <xsl:element name="td">
		    <xsl:choose>
                      <xsl:when test="contains(child::h,'&#x23F0;') or contains(child::h,'&#x2615;')">
			<xsl:attribute name="align">right</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
			<xsl:attribute name="align">left</xsl:attribute>
                      </xsl:otherwise>
		    </xsl:choose>
                    <xsl:element name="a">
		      <xsl:call-template name="ADDSTYLE"/>
                      <xsl:attribute name="href">
                        <xsl:choose>
                          <xsl:when test="$flag_form">
                            <xsl:value-of select="concat('?cxp=PresentationSlide','&amp;','i=',$i_slide,'&amp;','path=',$file_plain)"/>
                            <xsl:if test="not($str_xpath='/')">
                              <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                            </xsl:if>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="$name_slide"/>
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="$i_slide"/>
                            <xsl:text>.html</xsl:text>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:attribute>
                      <xsl:value-of select="h"/>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="td">
                    <xsl:attribute name="align">right</xsl:attribute>
                    <xsl:value-of select="$i_slide"/>
                  </xsl:element>
                  <xsl:if test="$flag_timer">
                    <xsl:element name="td">
                      <xsl:attribute name="align">right</xsl:attribute>
                      <xsl:choose>
			<xsl:when test="contains(child::h,'&#x23F0;')"> <!-- separator -->
			  <xsl:variable name="int_seconds">
			    <xsl:choose>
                              <xsl:when test="@duration">
				<xsl:value-of select="sum(preceding::section[@class='slide' and @duration]/attribute::duration) + @duration"/>
                              </xsl:when>
                              <xsl:otherwise>
				<xsl:value-of select="sum(preceding::section[@class='slide' and @duration]/attribute::duration)"/>
                              </xsl:otherwise>
			    </xsl:choose>
			  </xsl:variable>
			  <xsl:element name="b">
			  <xsl:value-of select="floor($int_seconds div 3600)"/>
			  <xsl:text>:</xsl:text>
			  <xsl:value-of select="format-number(floor(($int_seconds mod 3600) div 60),'##00')"/>
			  <xsl:text>:</xsl:text>
			  <xsl:value-of select="format-number(($int_seconds mod 60),'##00')"/>
			  <xsl:text> h</xsl:text>
			  </xsl:element>
			</xsl:when>
			<xsl:otherwise>
			  <xsl:value-of select="floor(@duration div 60)"/>
			  <xsl:text>:</xsl:text>
			  <xsl:value-of select="format-number((@duration mod 60),'##00')"/>
			  <xsl:text> min</xsl:text>
			</xsl:otherwise>
                      </xsl:choose>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="title">
    <!-- presentation title page -->
    <xsl:element name="center">
      <xsl:element name="table">
        <xsl:attribute name="width">80%</xsl:attribute>
        <xsl:attribute name="cellspacing">4</xsl:attribute>
        <xsl:element name="tbody">
          <xsl:element name="tr">
            <xsl:element name="th">
              <!-- presentation title -->
              <xsl:attribute name="class">toc</xsl:attribute>
              <xsl:attribute name="colspan">1</xsl:attribute>
              <xsl:attribute name="height">300</xsl:attribute>
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:choose>
                    <xsl:when test="$flag_form">
                      <xsl:value-of select="concat('?cxp=PresentationAgenda','&amp;','path=',$file_plain)"/>
                      <xsl:if test="not($str_xpath='/')">
                        <xsl:value-of select="concat('&amp;','xpath=',$str_xpath)"/>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$name_slide"/>
                      <xsl:text>-agenda</xsl:text>
                      <xsl:text>.html</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="/pie/section/h"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
          <xsl:element name="tr">
            <xsl:element name="th">
              <!-- presentation author -->
              <xsl:element name="a">
                <xsl:value-of select="/pie/author"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
          <xsl:element name="tr">
            <xsl:element name="td">
              <!-- presentation date -->
              <xsl:value-of select="/pie/date"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="form_search">
    <!-- search form page -->
    <xsl:element name="script">
      <xsl:attribute name="language">JavaScript</xsl:attribute>
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      <xsl:attribute name="src">tipue_set.js</xsl:attribute>
    </xsl:element>
    <xsl:element name="script">
      <xsl:attribute name="language">JavaScript</xsl:attribute>
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      <xsl:attribute name="src">tipue.js</xsl:attribute>
    </xsl:element>
    <form method="get" name="tipue" action="presentation-search-result.html">
      <p>
        <xsl:text>Text-Suche </xsl:text>
        <input type="text" name="d" class="field"/>
        <input type="submit" value="OK" class="button"/>
      </p>
    </form>
  </xsl:template>
  <xsl:template name="form_search_result">
    <!-- search form result page -->
    <script language="JavaScript" type="text/javascript">tip_query()</script>
    <div class="main">
      <script language="JavaScript" type="text/javascript">tip_header()</script>
      <p/>
      <script language="JavaScript" type="text/javascript">tip_out()</script>
      <script language="JavaScript" type="text/javascript">tip_footer()</script>
    </div>
  </xsl:template>
</xsl:stylesheet>
