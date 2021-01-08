.PHONY: all clean

S = website-src

T = public_html

NEEDS = $(T)/index.html \
        $(T)/masters-research.html \
        $(T)/vpd-et.html \
        $(T)/ccm.html \
        $(T)/causality.html \
        $(T)/dot/cloud-aerosol.png \
        $(T)/dot/ccope.png \
        $(T)/fig/naiveCloudSunlight.png \
        $(T)/fig/cloudSunlight.png \
        $(T)/writing.html \
        $(T)/eaee-ta-resources.html \
        $(T)/eaee-ta-resources-workshop-version.html \
        $(T)/climate-school.html \
        $(T)/cv/massmann-cv.html \
        $(T)/cv/massmann-cv.pdf

PANDOC = sed 's/\.md/\.html/g' | pandoc -s -c "http://www.columbia.edu/~akm2203/pandoc.css" --from markdown --to html5

HOME_LINK = sed -z 's/---\n\(.*\n\)*---\n/&\n[{Back to Home}](index.html)\n/'

define add_comments
$(HOME_LINK) | { cat - ;  printf "\n---------------\n\n### [Post comments]($(1))\n\nI am too technologically illiterate to set up a comment system on this page, but comments and questions are very welcome and encouraged through Github's issue system: [just click here]($(1))! (I know it's kind of a hack but it should work well enough.)\n" ; } | $(PANDOC)
endef

all : $(NEEDS)
	+$(MAKE) -C extras/teacher-learner-wellbeing
	cp -r extras/teacher-learner-wellbeing/public_html $(T)/teacher-learner-wellbeing

$(T)/index.html : $(S)/index.md Makefile # still working here
	cat $< | $(PANDOC) > $@

$(T)/causality.html : $(S)/causality.md Makefile
	cat $< | $(call add_comments,https://github.com/massma/website/issues/1) > $@

$(T)/ccm.html : $(S)/ccm.md Makefile
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
