# Rolf Niepraschk, 2016-02-05, Rolf.Niepraschk@gmx.de

.SUFFIXES : .dtx .ins .tex .ltx .dvi .ps .pdf .eps

MAIN = pict2e

LATEX = pdflatex
TEX = tex

VERSION = $(shell awk '/ProvidesPackage/ {print $$2}' $(MAIN).dtx)

DIST_DIR = $(MAIN)
DIST_FILES = README.md manifest.txt $(MAIN).ins $(MAIN).dtx $(MAIN).pdf \
             p2e-drivers.dtx p2e-drivers.pdf
ARCHNAME = $(MAIN)-$(VERSION).zip

all : $(MAIN).sty $(MAIN).pdf p2e-drivers.pdf

$(MAIN).sty : $(MAIN).dtx
	$(TEX) $(basename $<).ins

$(MAIN).pdf : $(MAIN).dtx $(MAIN).sty

%.pdf : %.dtx
	$(LATEX) $<
	if ! test -f $(basename $<).glo ; then touch $(basename $<).glo; fi
	if ! test -f $(basename $<).idx ; then touch $(basename $<).idx; fi
	makeindex -s gglo.ist -t $(basename $<).glg -o $(basename $<).gls \
		$(basename $<).glo
	makeindex -s gind.ist -t $(basename $<).ilg -o $(basename $<).ind \
		$(basename $<).idx
	$(LATEX) $<
	$(LATEX) $<

dist : $(DIST_FILES)
	mkdir -p $(DIST_DIR)
	cp -p $+ $(DIST_DIR)
	zip $(ARCHNAME) -r $(DIST_DIR)
	rm -rf $(DIST_DIR)

clean :
	$(RM) *.aux *.log *.glg *.glo *.gls *.idx *.ilg *.ind *.toc

veryclean : clean
	$(RM) $(MAIN).pdf p2e-drivers.pdf $(MAIN).cls $(ARCHNAME)

debug :
	@echo $(ARCHNAME)
