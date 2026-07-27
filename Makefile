.PHONY: all bible clean

VERSION := 0.1.2

all: bible-$(VERSION).pdf bible-$(VERSION)b.pdf

%-$(VERSION).pdf: %.tex
	lualatex --jobname=$(basename $@) "\def\Version{$(VERSION)} \input{$<}" \
	&& rm -f $(basename $@).{log,aux,out}

%b.pdf: %.pdf
	# --papersize have to be specified explicitly
	# since pdfpages-0.6c mistakenly enlarges page width.
	# Apparently fixed in pdfpages-0.6f.
	pdfjam --nup 4x2 --outfile $@   \
		--papersize '{210mm,297mm}' --landscape \
		$< 32,01,30,03,28,05,26,07 \
		$< 04,29,02,31,08,25,06,27 \
		$< 24,09,22,11,20,13,18,15 \
		$< 12,21,10,23,16,17,14,19

	# Update versions for latest PDF downloads
	sed -i -E "s/[0-9]+\.[0-9]+(\.[0-9]+|)/$(VERSION)/g" README.md
