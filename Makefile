
PACKAGE=ani-intermediate

REPORT = sample-ani-report-final.tex

PDF = ${REPORT:%.tex=%.pdf}

WD = $(shell pwd)
CURRDIR = $(notdir ${WD})


all:  ${PDF}


%.pdf: ${REPORT}
	pdflatex $<
	- bibtex $*
	pdflatex $<
	- makeindex -s gind.ist -o $*.ind $*.idx
	- makeindex -s gglo.ist -o $*.gls $*.glo
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do pdflatex $<; done


clean:
	$(RM) *.log *.aux \
	*.glo *.idx *.toc *.tbc \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls *.sty *.ist \
	*.dvi *.ps *.thm *.tgz *.zip

distclean: clean
	$(RM) $(PDF)

#
# Archive for the distribution. Includes typeset documentation
#
archive:  all clean
	cd ..; \
	tar -czvf $(PACKAGE).tgz  --exclude 'debug*' \
	--exclude '*~' --exclude '*.tgz' --exclude '*.zip'  \
	--exclude CVS $(CURRDIR); \
	mv $(PACKAGE).tgz $(CURRDIR); \
	cd $(CURRDIR)

zip:  all clean
	cd ..; \
	zip -r  $(PACKAGE).zip $(CURRDIR) \
	-x 'debug*' -x '*~' -x '*.tgz' -x '*.zip' -x CVS -x 'CVS/*'; \
	mv $(PACKAGE).zip $(CURRDIR); \
	cd $(CURRDIR)

watch:
	latexmk -pdflatex="$(LATEX) %O %S" -pdf -dvi- -ps- -interaction=nonstopmode -synctex=1 -pvc $(REPORT)

