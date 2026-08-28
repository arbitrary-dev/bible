.PHONY: all bible clean

VERSION := 0.2

all: bible-$(VERSION).pdf bible-$(VERSION)b.pdf

%-$(VERSION).pdf: %.tex
	lualatex --jobname=$(basename $@) "\def\Version{$(VERSION)} \input{$<}" \
	&& rm -f $(basename $@).{log,aux,out}

%b.pdf: %.pdf
	pdfjam --nup 4x2 --outfile $@   \
		--paper a4paper --landscape \
		$< $(shell ./gen-pages.sh 64)

	# Update versions for latest PDF downloads
	sed -i -E "s/[0-9]+\.[0-9]+(\.[0-9]+|)/$(VERSION)/g" README.md
