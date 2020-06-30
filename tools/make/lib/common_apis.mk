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

# Define the output file path for common API data as JSON:
COMMON_APIS_JSON_OUT ?= $(DATA_DIR)/common_apis.json

# Define the output file path for common API data as CSV:
COMMON_APIS_CSV_OUT ?= $(DATA_DIR)/common_apis.csv

# Define the output file path for viewing common API data as an HTML table:
COMMON_APIS_HTML_OUT ?= $(DOCS_DIR)/common_apis.html


# RULES #

#/
# Generates a JSON file containing common APIs (as determined by a threshold).
#
# @private
#/
$(COMMON_APIS_JSON_OUT): $(JOIN_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/common_apis_json.js > $(COMMON_APIS_JSON_OUT)

#/
# Generates a CSV file containing common APIs (as determined by a threshold).
#
# @private
#/
$(COMMON_APIS_CSV_OUT): $(COMMON_APIS_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/json2csv.js $(COMMON_APIS_JSON_OUT) > $(COMMON_APIS_CSV_OUT)

#/
# Generates HTML assets for viewing common API data.
#
# @private
#/
$(COMMON_APIS_HTML_OUT): $(COMMON_APIS_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/html_table.js $(COMMON_APIS_JSON_OUT) --title="Common APIs" > $(COMMON_APIS_HTML_OUT)

#/
# Generates data assets.
#
# @example
# make common-apis
#/
common-apis: $(COMMON_APIS_JSON_OUT) $(COMMON_APIS_CSV_OUT) $(COMMON_APIS_HTML_OUT)

.PHONY: common-apis

#/
# Opens an HTML table in a web browser.
#
# @example
# make view-common-apis
#/
view-common-apis: $(COMMON_APIS_HTML_OUT)
	$(QUIET) $(OPEN) $(COMMON_APIS_HTML_OUT)

.PHONY: view-common-apis

#/
# Removes build artifacts.
#
# @example
# make clean-common-apis
#/
clean-common-apis: clean-common-apis-data clean-common-apis-docs

.PHONY: clean-common-apis

#/
# Removes generated datasets.
#
# @example
# make clean-common-apis-data
#/
clean-common-apis:-data
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_APIS_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_APIS_CSV_OUT)

.PHONY: clean-common-apis-data

#/
# Removes generated documentation.
#
# @example
# make clean-common-apis-docs
#/
clean-common-apis-docs:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_APIS_HTML_OUT)

.PHONY: clean-common-apis-docs
