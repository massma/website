.PHONY: all clean

S = source

T = public_html

NEEDS = $(T)/index.html \
        $(T)/masters-research.html \
        $(T)/vpd-et.html \
        $(T)/sustainable-communities.html \
        $(T)/causality.html \
        $(T)/dot/cloud-aerosol.png \
        $(T)/dot/ccope.png \
        $(T)/fig/naiveCloudSunlight.png \
        $(T)/fig/cloudSunlight.png \
        $(T)/eaee-ta-resources-workshop-version.html \
        $(T)/cv/massmann-cv.html \
        $(T)/cv/massmann-cv.pdf


PANDOC = sed 's/\.md/\.html/g' | pandoc -s -c "http://www.columbia.edu/~akm2203/pandoc.css" --from markdown --to html5

HOME_LINK = sed -z 's/---\n\(.*\n\)*---\n/&\n[{Back to Home}](index.html)\n/'

define add_comments
$(HOME_LINK) | { cat - ;  printf "\n---------------\n\n### [Post comments]($(1))\n\nI am too technologically illiterate to set up a comment system on this page, but comments and questions are very welcome and encouraged through Github's issue system: [just click here]($(1))! (I know it's kind of a hack but it should work well enough.)\n" ; } | $(PANDOC)
endef

all : $(NEEDS)
	+$(MAKE) -C teacher-learner-wellbeing
	+$(MAKE) -C eee-grad-website
	rsync -auvX --delete teacher-learner-wellbeing/public_html/ $(T)/teacher-learner-wellbeing
	rsync -auvX --delete eee-grad-website/public_html/ $(T)/eee-grad-website
ifneq ($(wildcard eee-grad-admissions/.*),)
	+$(MAKE) -C eee-grad-admissions
	rsync -auvX --delete eee-grad-admissions/public_html/ $(T)/eee-grad-admissions
endif


$(T)/index.html : $(S)/index.md Makefile # still working here
	cat $< | $(PANDOC) > $@

$(T)/causality.html : $(S)/causality.md Makefile
	cat $< | $(call add_comments,https://github.com/massma/website/issues/1) > $@

$(T)/ccc.html : $(S)/ccc.md Makefile
	cat $< | $(call add_comments,https://github.com/massma/website/issues/2) > $@

$(T)/vpd-et.html : $(S)/vpd-et.md Makefile
	cat $< | $(call add_comments,https://github.com/massma/website/issues/3) > $@

$(T)/%.html : $(S)/%.md Makefile
	cat $< | $(HOME_LINK) | $(PANDOC) > $@

$(T)/dot/%.png : $(S)/dot/%.dot Makefile
	dot -o $@ -Tpng $<

$(T)/fig/%.png : $(S)/fig/%.png Makefile
	cp $< $@

$(T)/cv/massmann-cv.pdf : $(S)/cv/massmann-cv.org $(S)/cv/mycv.sty Makefile
	emacs $< --batch -f org-latex-export-to-pdf --kill
	mv $(S)/cv/massmann-cv.pdf $@

$(T)/cv/massmann-cv.html : $(S)/cv/massmann-cv.org $(S)/cv/mycv.sty Makefile
	emacs $< --batch --eval "(progn (setq org-export-with-section-numbers nil) (setq org-html-validation-link nil))" -f org-html-export-to-html --kill
	mv $(S)/cv/massmann-cv.html $@

clean :
	rm -rf $(NEEDS)
