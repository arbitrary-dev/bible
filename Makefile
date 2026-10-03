VERSION := 0.3

BUILD_DIR := build

all: bible booklet

.PHONY: all bible booklet clean

bible:   bible-$(VERSION).pdf
booklet: bible-$(VERSION)b.pdf

%-$(VERSION).pdf: %.tex *.tex
	mkdir -p $(BUILD_DIR) \
	&& lualatex --output-directory=$(BUILD_DIR) --jobname=$(basename $@) \
		"\def\Version{$(VERSION)} \input{$<}" \
	&& rm $(BUILD_DIR)/*.{aux,log,out}

%b.pdf: %.pdf
	mkdir -p $(BUILD_DIR)  \
	&& cd $(BUILD_DIR)     \
	&& PAGES=$$( awk -F'[ (]' '/Output written on/ {print $$6}' $*.log )  \
	&& PAGES=$$(../gen-pages.sh $$PAGES)                                  \
	&& pdfjam --nup 4x2 --outfile $@  \
		--paper a4paper --landscape   \
		$< $$PAGES

	# Update versions for latest PDF downloads
	sed -i -E "s/[0-9]+\.[0-9]+(\.[0-9]+|)/$(VERSION)/g" README.md

clean:
	find $(BUILD_DIR) -type f ! -name "*$(VERSION)*.pdf" -delete
