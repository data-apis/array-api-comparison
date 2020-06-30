#/
# @license MIT
#
# Copyright (c) 2020 Python Data APIs Consortium.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#/

# VARIABLES #

# Define the output file path for API intersection rank data as JSON:
INTERSECTION_RANKS_JSON_OUT ?= $(DATA_DIR)/intersection_ranks.json

# Define the output file path for API intersection rank data as CSV:
INTERSECTION_RANKS_CSV_OUT ?= $(DATA_DIR)/intersection_ranks.csv

# Define the output file path for viewing API intersection rank data as an HTML table:
INTERSECTION_RANKS_HTML_OUT ?= $(DOCS_DIR)/intersection_ranks.html


# RULES #

#/
# Generates a JSON file which ranks the intersection of library APIs.
#
# @private
#/
$(INTERSECTION_RANKS_JSON_OUT): $(INTERSECTION_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/intersection_ranks.js > $(INTERSECTION_RANKS_JSON_OUT)

#/
# Generates a CSV file which ranks the intersection of library APIs.
#
# @private
#/
$(INTERSECTION_RANKS_CSV_OUT): $(INTERSECTION_RANKS_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/json2csv.js $(INTERSECTION_RANKS_JSON_OUT) > $(INTERSECTION_RANKS_CSV_OUT)

#/
# Generates HTML assets for viewing intersection rank data.
#
# @private
#/
$(INTERSECTION_RANKS_HTML_OUT): $(INTERSECTION_RANKS_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/html_table.js $(INTERSECTION_RANKS_JSON_OUT) --title="NumPy Intersection Ranks" > $(INTERSECTION_RANKS_HTML_OUT)

#/
# Generates data assets.
#
# @example
# make intersection-ranks
#/
intersection-ranks: $(INTERSECTION_RANKS_JSON_OUT) $(INTERSECTION_RANKS_CSV_OUT) $(INTERSECTION_RANKS_HTML_OUT)

.PHONY: intersection-ranks

#/
# Opens an HTML table in a web browser.
#
# @example
# make view-intersection-ranks
#/
view-intersection-ranks: $(INTERSECTION_RANKS_HTML_OUT)
	$(QUIET) $(OPEN) $(INTERSECTION_RANKS_HTML_OUT)

.PHONY: view-intersection-ranks

#/
# Removes build artifacts.
#
# @example
# make clean-intersection-ranks
#/
clean-intersection-ranks: clean-intersection-ranks-data clean-intersection-ranks-docs

.PHONY: clean-intersection-ranks

#/
# Removes generated datasets.
#
# @example
# make clean-intersection-ranks-data
#/
clean-intersection-ranks-data:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(INTERSECTION_RANKS_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(INTERSECTION_RANKS_CSV_OUT)

.PHONY: clean-intersection-ranks-data

#/
# Removes generated documentation.
#
# @example
# make clean-intersection-ranks-docs
#/
clean-intersection-ranks-docs:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(INTERSECTION_RANKS_HTML_OUT)

.PHONY: clean-intersection-ranks-docs
