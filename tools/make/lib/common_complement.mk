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

# Define the output file path for common API complement data as JSON:
COMMON_COMPLEMENT_JSON_OUT ?= $(DATA_DIR)/common_complement.json

# Define the output file path for common API complement data as CSV:
COMMON_COMPLEMENT_CSV_OUT ?= $(DATA_DIR)/common_complement.csv

# Define the output file path for viewing common API complement data as an HTML table:
COMMON_COMPLEMENT_HTML_OUT ?= $(DOCS_DIR)/common_complement.html


# RULES #

#/
# Generates a JSON file containing the complement of common APIs.
#
# @private
#/
$(COMMON_COMPLEMENT_JSON_OUT): $(JOIN_JSON_OUT) $(COMMON_APIS_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/common_complement_json.js > $(COMMON_COMPLEMENT_JSON_OUT)

#/
# Generates a CSV file containing the complement of common APIs.
#
# @private
#/
$(COMMON_COMPLEMENT_CSV_OUT): $(COMMON_COMPLEMENT_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/json2csv.js $(COMMON_COMPLEMENT_JSON_OUT) > $(COMMON_COMPLEMENT_CSV_OUT)

#/
# Generates HTML assets for viewing complement data.
#
# @private
#/
$(COMMON_COMPLEMENT_HTML_OUT): $(COMMON_COMPLEMENT_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/html_table.js $(COMMON_COMPLEMENT_JSON_OUT) --title="Non-Universal APIs (common)" > $(COMMON_COMPLEMENT_HTML_OUT)

#/
# Generates data assets.
#
# @example
# make common-complement
#/
common-complement: $(COMMON_COMPLEMENT_JSON_OUT) $(COMMON_COMPLEMENT_CSV_OUT) $(COMMON_COMPLEMENT_HTML_OUT)

.PHONY: common-complement

#/
# Opens an HTML table in a web browser.
#
# @example
# make view-common-complement
#/
view-common-complement: $(COMMON_COMPLEMENT_HTML_OUT)
	$(QUIET) $(OPEN) $(COMMON_COMPLEMENT_HTML_OUT)

.PHONY: view-common-complement

#/
# Removes build artifacts.
#
# @example
# make clean-common-complement
#/
clean-common-complement: clean-common-complement-data clean-common-complement-docs

.PHONY: clean-common-complement

#/
# Removes generated datasets.
#
# @example
# make clean-common-complement-data
#/
clean-common-complement-data:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_COMPLEMENT_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_COMPLEMENT_CSV_OUT)

.PHONY: clean-common-complement-data

#/
# Removes generated documentation.
#
# @example
# make clean-common-complement-docs
#/
clean-common-complement-docs:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_COMPLEMENT_HTML_OUT)

.PHONY: clean-common-complement-docs
