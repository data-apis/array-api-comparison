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

# Define the output file path for API complement data as JSON:
METHOD_COMPLEMENT_JSON_OUT ?= $(DATA_DIR)/method_complement.json

# Define the output file path for API complement data as CSV:
METHOD_COMPLEMENT_CSV_OUT ?= $(DATA_DIR)/method_complement.csv

# Define the output file path for viewing API complement data as an HTML table:
METHOD_COMPLEMENT_HTML_OUT ?= $(DOCS_DIR)/method_complement.html


# RULES #

#/
# Generates a JSON file containing the complement of the library API intersection.
#
# @private
#/
$(METHOD_COMPLEMENT_JSON_OUT): $(METHOD_JOIN_JSON_OUT) $(METHOD_INTERSECTION_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/method_complement_json.js > $(METHOD_COMPLEMENT_JSON_OUT)

#/
# Generates a CSV file containing the complement of the library API intersection.
#
# @private
#/
$(METHOD_COMPLEMENT_CSV_OUT): $(METHOD_COMPLEMENT_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/json2csv.js $(METHOD_COMPLEMENT_JSON_OUT) > $(METHOD_COMPLEMENT_CSV_OUT)

#/
# Generates HTML assets for viewing complement data.
#
# @private
#/
$(METHOD_COMPLEMENT_HTML_OUT): $(METHOD_COMPLEMENT_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/html_table.js $(METHOD_COMPLEMENT_JSON_OUT) --title="Non-Universal Methods" > $(METHOD_COMPLEMENT_HTML_OUT)

#/
# Generates data assets.
#
# @example
# make method-complement
#/
method-complement: $(METHOD_COMPLEMENT_JSON_OUT) $(METHOD_COMPLEMENT_CSV_OUT) $(METHOD_COMPLEMENT_HTML_OUT)

.PHONY: method-complement

#/
# Opens an HTML table in a web browser.
#
# @example
# make view-method-complement
#/
view-method-complement: $(METHOD_COMPLEMENT_HTML_OUT)
	$(QUIET) $(OPEN) $(METHOD_COMPLEMENT_HTML_OUT)

.PHONY: view-method-complement

#/
# Removes build artifacts.
#
# @example
# make clean-method-complement
#/
clean-method-complement: clean-method-complement-data clean-method-complement-docs

.PHONY: clean-method-complement

#/
# Removes generated datasets.
#
# @example
# make clean-method-complement-data
#/
clean-method-complement-data:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(METHOD_COMPLEMENT_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(METHOD_COMPLEMENT_CSV_OUT)

.PHONY: clean-method-complement-data

#/
# Removes generated documentation.
#
# @example
# make clean-method-complement-docs
#/
clean-method-complement-docs:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(METHOD_COMPLEMENT_HTML_OUT)

.PHONY: clean-method-complement-docs
