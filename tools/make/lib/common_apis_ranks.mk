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

# Define the output file path for common API rank data as JSON:
COMMON_APIS_RANKS_JSON_OUT ?= $(DATA_DIR)/common_apis_ranks.json

# Define the output file path for common API rank data as CSV:
COMMON_APIS_RANKS_CSV_OUT ?= $(DATA_DIR)/common_apis_ranks.csv

# Define the output file path for viewing common API rank data as an HTML table:
COMMON_APIS_RANKS_HTML_OUT ?= $(DOCS_DIR)/common_apis_ranks.html


# RULES #

#/
# Generates a JSON file which ranks common APIs (as determined by a threshold).
#
# @private
#/
$(COMMON_APIS_RANKS_JSON_OUT): $(COMMON_APIS_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/common_apis_ranks.js > $(COMMON_APIS_RANKS_JSON_OUT)

#/
# Generates a CSV file which ranks common APIs (as determined by a threshold).
#
# @private
#/
$(COMMON_APIS_RANKS_CSV_OUT): $(COMMON_APIS_RANKS_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/json2csv.js $(COMMON_APIS_RANKS_JSON_OUT) > $(COMMON_APIS_RANKS_CSV_OUT)

#/
# Generates HTML assets for viewing threshold rank data.
#
# @private
#/
$(COMMON_APIS_RANKS_HTML_OUT): $(COMMON_APIS_RANKS_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/html_table.js $(COMMON_APIS_RANKS_JSON_OUT) --title="NumPy Common APIs Ranks" > $(COMMON_APIS_RANKS_HTML_OUT)

#/
# Generates data assets.
#
# @example
# make common-apis-ranks
#/
common-apis-ranks: $(COMMON_APIS_RANKS_JSON_OUT) $(COMMON_APIS_RANKS_CSV_OUT) $(COMMON_APIS_RANKS_HTML_OUT)

.PHONY: common-apis-ranks

#/
# Opens an HTML table in a web browser.
#
# @example
# make view-common-apis-ranks
#/
view-common-apis-ranks: $(COMMON_APIS_RANKS_HTML_OUT)
	$(QUIET) $(OPEN) $(COMMON_APIS_RANKS_HTML_OUT)

.PHONY: view-common-apis-ranks

#/
# Removes build artifacts.
#
# @example
# make clean-common-apis-ranks
#/
clean-common-apis-ranks: clean-common-apis-ranks-data clean-common-apis-ranks-docs

.PHONY: clean-common-apis-ranks

#/
# Removes generated datasets.
#
# @example
# make clean-common-apis-ranks-data
#/
clean-common-apis-ranks-data:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_APIS_RANKS_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_APIS_RANKS_CSV_OUT)

.PHONY: clean-common-apis-ranks-data

#/
# Removes generated documentation.
#
# @example
# make clean-common-apis-ranks-docs
#/
clean-common-apis-ranks-docs:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_APIS_RANKS_HTML_OUT)

.PHONY: clean-common-apis-ranks-docs
