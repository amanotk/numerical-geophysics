# -*- Makefile -*-

PANDOC		= pandoc
#PANDOC_FLAGS	= -s -t latex -f markdown+hard_line_breaks -F pandoc-crossref \
#	-M "crossrefYaml=crossref_config.yaml" --bibliography reference.bib
PANDOC_FLAGS	= -s -t latex -f markdown+hard_line_breaks
LATEX		= platex
LATEX_FLAGS	=
DVIPDFM		= dvipdfmx
DVIPDFM_FLAGS	= -f noto.map

default: report.pdf

report.pdf : report.md template.tex
	$(PANDOC) $(PANDOC_FLAGS) --template template.tex $< -o $(basename $<).tex
	$(LATEX) $(LATEX_OPTS) $(basename $<).tex
	$(LATEX) $(LATEX_OPTS) $(basename $<).tex
	$(DVIPDFM) $(DVIPDFM_FLAGS) $(basename $<).dvi

clean:
	rm -fr *.dvi *.aux *.out *.log *.toc
