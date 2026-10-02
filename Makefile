.PHONY: all bible booklet clean

VERSION := 0.3

all: bible booklet

bible:   bible-$(VERSION).pdf
booklet: bible-$(VERSION)b.pdf

%-$(VERSION).pdf: %.tex *.tex
	lualatex --jobname=$(basename $@) "\def\Version{$(VERSION)} \input{$<}"

%b.pdf: %.pdf
	PAGES=$$( awk -F'[ (]' '/Output written on/ {print $$6}' $*.log ); \
	PAGES=$$(./gen-pages.sh $$PAGES);                                  \
	pdfjam --nup 4x2 --outfile $@   \
		--paper a4paper --landscape \
		$< $$PAGES

	# Update versions for latest PDF downloads
	sed -i -E "s/[0-9]+\.[0-9]+(\.[0-9]+|)/$(VERSION)/g" README.md

clean:
	rm -f *.{aux,log,out} bible-*.pdf
