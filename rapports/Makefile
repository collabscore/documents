

all:  rapport-inter.pdf

%.pdf: %.tex
	pdflatex   -shell-escape $*.tex
	pdflatex   -shell-escape $*.tex
	mv  $*.pdf PDF/
	make clean


clean:
	\rm -f *.vrb *.aux *.bbl *.blg *.dvi *.log *.ps *.snm *.out *.nav *.toc *~ *.pdf *.pyg* *.mtc* *.maf
	rm -Rf _minted*
