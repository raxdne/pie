
* Personal Information Environment (PIE)

Framework for text >>development<< and Information Management
especially for XML and GNU Emacs enthusiast.

** Concept of PIE

*** software

- use of Pareto rule: with 20% of code for 80% fulfilment of needs ->
  keep it simple

- people with XML experience (or interest) and GNU Emacs (When I have
  to write a longer text, I like to improve and extend the XSL code
  at the same time ;-)

- use of popular (free) tools

-- GNU Emacs (my favorite environment, emacs lisp glue included)

-- Freemind

-- graphviz

-- web browsers (Mozilla Firefox, MS IE)

-- LaTeX, PDFLaTeX

- portability!!

-- platform independency (all used tools)

-- file based -> enrypted recursive copy or sync of directory possible
   (no database server)

- API usable for

-- command line frontends

-- own XML scripts and

-- web based applications

*** text processing

- simple markup only for a good plain text readability (Editor, E-Mail)

- single Source

*** text >>development<<

- different views on one document: Structure, Article, Presentation, Calendar

-- a structure view (Tree, Mindmap, >>Mindtree<<)

-- a search tool with context informations

- >>rapid prototyping<< of documents using mindmaps (oriented on
  structure not layout)

- comment or skip regions without deleting them

- possible steps

++ brainstorming

++ write a draft

++ details

++ print structure in a >>mindtree<< -> brainstorming

++ complete the text with notes

++ print a _simple_ layout (like typewriter)

++ corrections

++ finish the article (-> LaTeX -> PDF)

++ derive a slide show from same text (HTML)

** Examples

** Frontends

*** CGI

*** Command line

** HISTORY

- begin at 1997 with an AWK script, later porting to PERL script

- at the end a 120 pages thesis in the simple Text format

- new tasks like Todo list, Journal, project planning

- awful PERL script, create a better implementation

