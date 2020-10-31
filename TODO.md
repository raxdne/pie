
# TODO PIE

## Web UI

### Calendar

REQ: removal of days from calendar

Navigation with Tabs

TEST: [jQuery Calendar and Date Picker Plugins](http://www.tripwiremagazine.com/2012/11/jquery-calendar-date-pickers.html)

REQ: embedd calendar into pie text

### Text

REQ: structure as mindmap (3D.js)

REQ: content statistics (chars, words, histogram)

REQ: local images in fig.

Tag cloud

TEST: w3m + Emacs as HTML to text renderer

REQ: concurrent access (file locking?)

REQ: PDF generator
- Plain text → PIE XML → xsl:fo → PDF
- documentation with PDF printing from Browser via FreePDF

### Dir

REQ: upload of files

REQ: search and search index (tipue?)
- „?cxp=search&name=ABC.txt“
- „?cxp=search&pattern=DEF“

### Editor

REQ: syntax highlighting for PIE text in ACE

REQ: common shortcuts

### Database UI

CSS

jquery-tablesorter

### Gallery

REQ: improved comment feature for images (HTML-Editor?) 

REQ: post verbose dir XML in Cgigallery.* cause error informations of image files

Navigation
- recursive gallery
- Thumbnail gallery of all images
- Links to other Images (like slides)
- access via index number instead filename (s. Playlist)

### Test

TODO: 2020-10-30 add test files for
-  .mmap and .xmmap
- docx
- ...

plan
- document
  - create
    - from Template
  - view
    - layout
  - switch
  - edit
    - ACE
  - visualize
    - Tree
    - TreeMap
    - Mindmap
    - ...
  - navigate
  - search
  - reload
  - open
    - path
    - xpath
  - update
    - table of content
    - tags
    - links
    - list of contacts
  - setTop
  - resetTop
- context dropdown menu
- date selector
- events
  - onload
- mobile UI
  - mobile jQuery
  - browser-jquery-mobile
    - update
    - Navigation in calendars
- RMB Menu on links (Copy etc)
- [RMB Menu (s. "PiejQMenu.js")](contrib\pie\browser-jquery\)
  - ace Editor
- "Document"
  - logic
    - xpath
      - tags are not empty
    - pattern
    - pattern + xpath
    - structure
  - layout
  - xsl
    - LibreOffice
    - OpenOffice
      - odt
      - ods
      - odp
    - MS Office
      - 2013
      - 2016
      - 365 (+ Kompatibilitätsmodus)
        - docx
          - namespace conflicts when docx contains strict openxml (s. "pie/xsl/plain/docx2txt.xsl")
        - docm
        - pptx
        - xlsx
        - xlsm
    - MindManager
      - libz or xmlzipio
    - Freemind
- "Directory"
- "Archive"
- "Database"

TODO: update non-js cxp files of browser-cgi
- tabs

TODO: update to HTML5 standard
- modern CSS

TODO: cleanup "browser-cgi\PieTransformations.xml"

## Web runtime

TODO: download commands for requiered modules (git or wget in build/prepare-cmake.sh ?)

TODO: generic Apache HTTPD configurations

CGI security

TEST: `<cxp:xhtml><html><body><pre><cxp:plain name="/tmp/test.txt">`

## pie.el (Emacs Lisp)

TODO: redesign package

TODO: create separate menue
- Show structure
- Clean buffers
- Text
- Presentation
- Project plan
- Todo list
- Calendar
- Mindmap
- Key words
- edit/execute Cxp
- pie2txt
- txt2pie

## XSL-Code

TODO: improv pie2latex.xsl
- slideshow
- article

[URL-encoding: Spaces ... s. ](http://skew.org/xml/stylesheets/url-encode/)

TODO: extend pie2vcf.xsl

TODO: update pie2md.xsl
- [Markdown format](https://www.markdownguide.org/basic-syntax/)

TODO: update „pptx2txt.xsl“

xlsx2pie.xsl
- concatenate all "xl\worksheets\sheet*.xml"

## CXP code

TODO: line2pie.cxp line-oriented import

Presentation

TEST: xml\config-presentation.cxp

TEST: xml\config-article.cxp

TODO: improve presentation layout
  - Layouts
  - Logo, Copyright, Farben, Schrift
  - stepwise mode
  - test of "Impress.js"

## Ideas

REQ: Multilangual texts and mindmaps

[sourceforge.net > Projects > Fo2odf](http://sourceforge.net/projects/fo2odf/)

[opendocumentformat.org > Developers](http://www.opendocumentformat.org/developers/)

[odf-converter.sourceforge.net](http://odf-converter.sourceforge.net/)

[Compare http://johnmacfarlane.net/pandoc/](http://johnmacfarlane.net/pandoc/)
- huge binary
- layout-oriented

["pie2s5.xsl" S5 (Simple Standards-Based Slide Show System)](https://en.wikipedia.org/wiki/S5_)

[Semantic web](http://microformats.org/wiki/microformats2)

<https://en.wikipedia.org/wiki/ReStructuredText>

Project drafting

pie2nroff.xsl
- man pages etc
- or info pages

TODO: Timeline (Journal) parse directory, import all content regarding time markup

Serial letter
- cxp with each/from
  - fixed, argv
  - XML + XSL
  - sqlite

- XSLT with document(XML)

