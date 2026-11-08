VERSION := 0.3

BUILD_DIR := build

all: bible booklet

.PHONY: all bible booklet clean

bible: bible.tex *.tex
	mkdir -p $(BUILD_DIR)
	lualatex --output-directory=$(BUILD_DIR) --jobname=$@-$(VERSION)  \
		"\def\Version{$(VERSION)} \input{$<}"

booklet: bible
	mkdir -p $(BUILD_DIR)  \
	&& cd $(BUILD_DIR)     \
	&& PAGES=$$( awk -F'[ (]' '/Output written on/ {print $$6}' bible-$(VERSION).log )  \
	&& PAGES=$$(../gen-pages.sh $$PAGES)                                                \
	&& pdfjam --nup 4x2 --outfile $@-$(VERSION).pdf  \
		--paper a4paper --landscape                  \
		bible-$(VERSION).pdf $$PAGES                 \
	&& rm -f *.{aux,log,out}

mark-cut.pdf: bible
	mkdir -p $(BUILD_DIR)
	pdfjam --papersize 7.425cm,10.5cm --no-landscape  \
		$(BUILD_DIR)/bible-$(VERSION).pdf 65-104 -o $(BUILD_DIR)/$@

mark: mark-cut.pdf
	mkdir -p $(BUILD_DIR)
	pdfjam --nup 4x2 --outfile $(BUILD_DIR)/$@-$(VERSION)b.pdf  \
		--paper a4paper --landscape                             \
		mark-cut.pdf $$(cat layout-40sign.txt | tr -d '\n')

clean:
	find $(BUILD_DIR) -type f ! -name "*$(VERSION)*.pdf" -delete
