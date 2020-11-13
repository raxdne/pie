#
# (p) 2020 A. Tenbusch
#

# make code snippets for different usages of cxproc and filex

#.EXPORT_ALL_VARIABLES

%.html: %.txt 
	filex $< | xsltproc ../xml/xsl/html/pie2html.xsl - > $@

%.md: %.odt
#	cxproc $< | xsltproc ../xml/xsl/html/pie2html.xsl - > $@


