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

# Define the output file path for API intersection data as JSON:
METHOD_INTERSECTION_JSON_OUT ?= $(DATA_DIR)/method_intersection.json

# Define the output file path for API intersection data as CSV:
METHOD_INTERSECTION_CSV_OUT ?= $(DATA_DIR)/method_intersection.csv

# Define the output file path for viewing API intersection data as an HTML table:
METHOD_INTERSECTION_HTML_OUT ?= $(DOCS_DIR)/method_intersection.html


# RULES #

#/
# Generates a JSON file containing the intersection of library APIs.
#
# @private
#/
$(METHOD_INTERSECTION_JSON_OUT): $(METHOD_JOIN_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/method_intersection_json.js > $(METHOD_INTERSECTION_JSON_OUT)

#/
# Generates a CSV file containing the intersection of library APIs.
#
# @private
#/
$(METHOD_INTERSECTION_CSV_OUT): $(METHOD_INTERSECTION_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/json2csv.js $(METHOD_INTERSECTION_JSON_OUT) > $(METHOD_INTERSECTION_CSV_OUT)

#/
# Generates HTML assets for viewing intersection data.
#
# @private
#/
$(METHOD_INTERSECTION_HTML_OUT): $(METHOD_INTERSECTION_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/html_table.js $(METHOD_INTERSECTION_JSON_OUT) --title="Method Intersection" > $(METHOD_INTERSECTION_HTML_OUT)

#/
# Generates data assets.
#
# @example
# make method-intersection
#/
method-intersection: $(METHOD_INTERSECTION_JSON_OUT) $(METHOD_INTERSECTION_CSV_OUT) $(METHOD_INTERSECTION_HTML_OUT)

.PHONY: method-intersection

#/
# Opens an HTML table in a web browser.
#
# @example
# make view-method-intersection
#/
view-method-intersection: $(METHOD_INTERSECTION_HTML_OUT)
	$(QUIET) $(OPEN) $(METHOD_INTERSECTION_HTML_OUT)

.PHONY: view-method-intersection

#/
# Removes build artifacts.
#
# @example
# make clean-method-intersection
#/
clean-method-intersection: clean-method-intersection-data clean-method-intersection-docs

.PHONY: clean-method-intersection

#/
# Removes generated datasets.
#
# @example
# make clean-method-intersection-data
#/
clean-method-intersection-data:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(METHOD_INTERSECTION_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(METHOD_INTERSECTION_CSV_OUT)

.PHONY: clean-method-intersection-data

#/
# Removes generated documentation.
#
# @example
# make clean-method-intersection-docs
#/
clean-method-intersection-docs:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(METHOD_INTERSECTION_HTML_OUT)

.PHONY: clean-method-intersection-docs
