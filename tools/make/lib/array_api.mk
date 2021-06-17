#/
# @license MIT
#
# Copyright (c) 2021 Python Data APIs Consortium.
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

# Define the output file path for API compliance data as JSON:
ARRAY_API_JSON_OUT ?= $(DATA_DIR)/array_api.json

# Define the output file path for API compliance data as CSV:
ARRAY_API_CSV_OUT ?= $(DATA_DIR)/array_api.csv

# Define the output file path for viewing API compliance data as an HTML table:
ARRAY_API_HTML_OUT ?= $(DOCS_DIR)/array_api.html


# RULES #

#/
# Generates a JSON file containing the compliance of library APIs.
#
# @private
#/
$(ARRAY_API_JSON_OUT): $(JOIN_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/array_api.js > $(ARRAY_API_JSON_OUT)

#/
# Generates a CSV file containing the compliance of library APIs.
#
# @private
#/
$(ARRAY_API_CSV_OUT): $(ARRAY_API_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/json2csv.js $(ARRAY_API_JSON_OUT) > $(ARRAY_API_CSV_OUT)

#/
# Generates HTML assets for viewing compliance data.
#
# @private
#/
$(ARRAY_API_HTML_OUT): $(ARRAY_API_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/html_table.js $(ARRAY_API_JSON_OUT) --title="Array API Function Name Compliance" > $(ARRAY_API_HTML_OUT)

#/
# Generates data assets.
#
# @example
# make array-api
#/
array-api: $(ARRAY_API_JSON_OUT) $(ARRAY_API_CSV_OUT) $(ARRAY_API_HTML_OUT)

.PHONY: array-api

#/
# Opens an HTML table in a web browser.
#
# @example
# make view-array-api
#/
view-array-api: $(ARRAY_API_HTML_OUT)
	$(QUIET) $(OPEN) $(ARRAY_API_HTML_OUT)

.PHONY: view-array-api

#/
# Removes build artifacts.
#
# @example
# make clean-array-api
#/
clean-array-api: clean-array-api-data clean-array-api-docs

.PHONY: clean-array-api

#/
# Removes generated datasets.
#
# @example
# make clean-array-api-data
#/
clean-array-api-data:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(ARRAY_API_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(ARRAY_API_CSV_OUT)

.PHONY: clean-array-api-data

#/
# Removes generated documentation.
#
# @example
# make clean-array-api-docs
#/
clean-array-api-docs:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(ARRAY_API_HTML_OUT)

.PHONY: clean-array-api-docs
