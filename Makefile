BUILD_DIR = `pwd`/build
OUT_DIR = `pwd`/out
LATEX_OPTIONS = -pdf -halt-on-error -xelatex

PACKAGE_NAME = WUSTReport
SOURCE_DIRS = Laboratory_1/
PDFBUILDS = $(addprefix $(BUILD_DIR)/, $(SOURCE_DIRS:/=.pdf))

.DEFAULT_GOAL := all

clean :
	rm -rf $(BUILD_DIR) $(OUT_DIR) \
		$(PACKAGE_NAME)/$(PACKAGE_NAME).sty $(PACKAGE_NAME)/$(PACKAGE_NAME).log
.PHONY : clean

# The report needs the figures, so `make sim` has to run again before `make`
clean-sim :
	rm -rf Laboratory_1/simulation/out Laboratory_1/images/sim_*.pdf
.PHONY : clean-sim

all : sty $(PDFBUILDS)
.PHONY : all

sty : $(PACKAGE_NAME).sty
.PHONY : sty
$(PACKAGE_NAME).sty : $(PACKAGE_NAME)/$(PACKAGE_NAME).ins $(PACKAGE_NAME)/$(PACKAGE_NAME).dtx
	mkdir -p $(BUILD_DIR)
	cd $(PACKAGE_NAME) && \
		yes | latex $(PACKAGE_NAME).ins
	cp $(PACKAGE_NAME)/$@ $(BUILD_DIR)/$@
	cp $(PACKAGE_NAME)/logo-pwr-2016.pdf $(BUILD_DIR)/logo-pwr-2016.pdf

$(PDFBUILDS) : $(BUILD_DIR)/%.pdf: sty
	mkdir -p $(BUILD_DIR)
	latexmk $(LATEX_OPTIONS) \
		-cd \
		-jobname=$* \
		-output-directory=$(BUILD_DIR) \
		$*/main
	mkdir -p $(OUT_DIR)
	cp $@ $(OUT_DIR)/$*.pdf

GROUP ?= 1
sim :
	cd Laboratory_1/simulation && python3 simulate.py --group $(GROUP)
.PHONY : sim
