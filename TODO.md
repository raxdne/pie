
# TODO "Personal Information Environment (PIE)"

## Documentation

TODO: update Documentation #v1 ++

## Web UI

REQ: adapt RMB menu to current path context (e.g. no Editor on MS Office files) #v1 ✔

TODO: update non-javascript UI (s. <browser-cgi>) #v1
- tabs

TODO: update to HTML5 standard
- modern CSS

TODO: cleanup "browser-cgi\PieTransformations.xml"

TODO: consolidate use of cxp:variable
- "file_norm|file_plain" ✔
- flag_form

### Calendar

BUG: Navigation using `PiejQMenu.js` (s. `pie/browser-jquery/TestPieDate.html`)  #v1 ++

- remove `PieDate.js` and improve `PieCalendar.js`

### Text

BUG: use of flocator/fxpath for “Scope” #v1 ++ ✔

BUG: flocator/fxpath for “Scope” in DOCX etc #v1 ++
- xml/pie[@context="abc.docx"]/import

BUG: filtering using tags which contain '#' char #v1 ++ ✔

REQ: structure as mindmap (3D.js) #v2
- text visualization using Data-Driven Documents (tree etc)

REQ: content statistics (chars, words, histogram)

REQ: local images in fig.

REQ: Tag cloud ✔ 

REQ: concurrent access (file locking?)

REQ: PDF generator
- Plain text → PIE XML → xsl:fo → PDF
- documentation with PDF printing from Browser via FreePDF

REQ: RMB Menu “Hide” for same class ✔
- task

BUG: “Cleanup” makes DONE to TODO without CSS
- use UTF-8 markup

### Dir

REQ: upload of files

REQ: search and search index (tipue?)  #v1 ++
- `?cxp=search&name=ABC.txt`
- `?cxp=search&pattern=DEF`

### Editor

REQ: syntax highlighting for PIE text in ACE  #v1 ++

REQ: common shortcuts  #v1 ++

[Comparison of JavaScript-based source code editors](http://en.wikipedia.org/wiki/Comparison_of_JavaScript-based_source_code_editors)

[webodf](http://webodf.org/)

[Leo](https://github.com/leo-editor) is a PIM, IDE and outliner that accelerates the work flow of programmers, authors and web designers.

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

TODO: 2020-10-30 add neutral test files for #v1
-  .mmap and .xmmap
- docx (different compatibility levels)
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

TODO: improve pie2latex.xsl
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

w3m + Emacs as HTML to text renderer

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

## Inspiration

[impress.js](https://github.com/impress/impress.js/): It’s a presentation tool inspired by the idea behind
prezi.com #v2 ++

[S5 -- Simple Standards-Based Slide Show System](https://meyerweb.com/eric/tools/s5/) ++

[Rednotebook](http://rednotebook.sourceforge.net/) is a desktop journal

[Rainlendar](http://www.rainlendar.net/)  is a customizable calendar application which stays out of your way
but keeps all your important events and tasks always visible on your desktop. 

[Mallard](http://projectmallard.org/) is a markup language that makes it easier for you to create better documentation.

[Remember the Milk](http://www.rememberthemilk.com/)

[Fo2odf](https://sourceforge.net/projects/fo2odf/)

[opendocumentformat.org](http://www.opendocumentformat.org/developers/)

[Pandoc](http://johnmacfarlane.net/pandoc/)
- huge binary
- layout-oriented

[Semantic web](http://microformats.org/wiki/microformats2) ++

[reStructuredText](https://en.wikipedia.org/wiki/ReStructuredText) (RST, ReST, or reST) is a file format for textual data used primarily in the Python programming language community for technical documentation.
