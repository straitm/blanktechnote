# From the manual: "Usually when a command fails, if it has changed
# the target file at all, the file is corrupted and cannot be used--or
# at least it is not completely updated. Yet the file's timestamp says
# that it is now up to date, so the next time make runs, it will not
# try to update that file. The situation is just the same as when the
# command is killed by a signal; see section Interrupting or Killing
# make. So generally the right thing to do is to delete the target file
# if the command fails after beginning to change the file. make will do
# this if .DELETE_ON_ERROR appears as a target. This is almost always
# what you want make to do, but it is not historical practice; so for
# compatibility, you must explicitly request it."
.DELETE_ON_ERROR:

all: blanktechnote.pdf

figures=

tables=

name=blanktechnote

$(name).pdf: $(name).bib $(name).tex Makefile commands.tex $(figures)
	@echo Checking for duplicated words
	@./dups.sh
	@echo pdflatex for note pass 1
	@if ! pdflatex -interaction=errorstopmode -halt-on-error $(name).tex &> tmp; then \
      cat tmp; false;\
    else\
      true;\
    fi
	@echo bibtex for note pass 2
	@if ! bibtex $(name) &> tmp; then cat tmp; false; fi
	@echo pdflatex for note pass 2
	@if ! pdflatex -interaction=errorstopmode -halt-on-error $(name).tex &> tmp; then \
      cat tmp; false;\
    else\
      true;\
    fi
	@echo pdflatex for note pass 3
	@if ! pdflatex -interaction=errorstopmode -halt-on-error $(name).tex &> tmp; then \
      cat tmp; false;\
    else\
      grep -iEA1 'warning|undefined|hbox|rerun ' tmp;\
      true;\
    fi


clean:
	rm -f $(name).toc $(name).pdf $(name).aux $(name).log \
        $(name).spl $(name).nav $(name).bbl $(name).blg \
		    $(name).snm $(name).out \
			  commands.aux \
        tmp* texput.log $(figures)
