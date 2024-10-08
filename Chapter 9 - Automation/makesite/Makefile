PAGES = pages
OUTPUT = output

SOURCE_FILES = $(wildcard $(PAGES)/*.html)
DEST_FILES = $(patsubst $(PAGES)/%.html, $(OUTPUT)/%.html, $(SOURCE_FILES))

build: $(DEST_FILES)

$(OUTPUT)/%.html : $(PAGES)/%.html
	@echo "Creating $@ from $<"
	@mkdir -p $(dir $@)
	@cat template/header.html $< template/footer.html > $@.tmp
	@sed s/@DATE@/"$(shell date "+%B %d, %Y")"/ $@.tmp > $@
	@rm $@.tmp

clean:
	@rm -rf $(OUTPUT)

copy:
	@rsync -v -r --update $(DEST_FILES) sloth@192.168.99.101:~/$(DEST_FILES)
