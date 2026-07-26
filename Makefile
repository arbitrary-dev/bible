.PHONY: all bible clean

VERSION := 0.1

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
		$< 16,1,14,3,12,5,10,7   \
		$< 4,13,2,15,8,9,6,11     \
		$< 32,17,30,19,28,21,26,23 \
		$< 20,29,18,31,24,25,22,27

	# Update versions for latest PDF downloads
	sed -i -E "s/[0-9]+\.[0-9]+(\.[0-9]+|)/$(VERSION)/g" README.md
