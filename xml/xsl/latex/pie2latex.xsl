<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="PieLatex.xsl"/>

  <xsl:variable name="file_css" select="'file:///H:/opt/cxproc/contrib/pie/html/pie.css'"/>
<!-- file:///H:/opt/cxproc/contrib/pie/html/ -->
  <xsl:variable name="file_ref" select="'../../tmp/TodoContactTable.html'"/>
  <!-- cancel tree -->
  <xsl:variable name="flag_tree" select="false()"/>
  <!--  -->
  <xsl:variable name="flag_header" select="true()"/>
  <!--  -->
  <xsl:variable name="flag_fig" select="true()"/>
  <!--  -->
  <xsl:variable name="length_link" select="-1"/>

  <xsl:output method="text" encoding="utf-8"/>

  <xsl:template match="/">
    <xsl:text>
%\documentclass[8pt,landscape]{article}

%% https://en.wikibooks.org/wiki/LaTeX/

%\usepackage[a4paper,includeheadfoot,margin=0.5cm]{geometry}

%\usepackage[utf8]{inputenc} %% https://tex.stackexchange.com/questions/13067/utf8x-vs-utf8-inputenc
%\usepackage[T1]{fontenc}
%\usepackage{ngerman} %% https://www.namsu.de/Extra/pakete/German.html
%\usepackage[pdftex]{hyperref} %% http://www2.washjeff.edu/users/rhigginbottom/latex/resources/lecture09.pdf

%\begin{document}
    </xsl:text>
    <xsl:if test="pie//section[1]/h">
      <xsl:value-of select="concat('\title{',normalize-space(pie//section[1]/h),'}',$newline)"/>
      <xsl:value-of select="$newline"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>
  %%\input{m.tex}

%\end{document}
    </xsl:text>
  </xsl:template>

</xsl:stylesheet>
