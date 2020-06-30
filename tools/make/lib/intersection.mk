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
INTERSECTION_JSON_OUT ?= $(DATA_DIR)/intersection.json

# Define the output file path for API intersection data as CSV:
INTERSECTION_CSV_OUT ?= $(DATA_DIR)/intersection.csv

# Define the output file path for viewing API intersection data as an HTML table:
INTERSECTION_HTML_OUT ?= $(DOCS_DIR)/intersection.html


# RULES #

#/
# Generates a JSON file containing the intersection of library APIs.
#
# @private
#/
$(INTERSECTION_JSON_OUT): $(JOIN_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/intersection_json.js > $(INTERSECTION_JSON_OUT)

#/
# Generates a CSV file containing the intersection of library APIs.
#
# @private
#/
$(INTERSECTION_CSV_OUT): $(INTERSECTION_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/json2csv.js $(INTERSECTION_JSON_OUT) > $(INTERSECTION_CSV_OUT)

#/
# Generates HTML assets for viewing intersection data.
#
# @private
#/
$(INTERSECTION_HTML_OUT): $(INTERSECTION_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/html_table.js $(INTERSECTION_JSON_OUT) --title="API Intersection" > $(INTERSECTION_HTML_OUT)

#/
# Generates data assets.
#
# @example
# make intersection
#/
intersection: $(INTERSECTION_JSON_OUT) $(INTERSECTION_CSV_OUT) $(INTERSECTION_HTML_OUT)

.PHONY: intersection

#/
# Opens an HTML table in a web browser.
#
# @example
# make view-intersection
#/
view-intersection: $(INTERSECTION_HTML_OUT)
	$(QUIET) $(OPEN) $(INTERSECTION_HTML_OUT)

.PHONY: view-intersection

#/
# Removes build artifacts.
#
# @example
# make clean-intersection
#/
clean-intersection: clean-intersection-data clean-intersection-docs

.PHONY: clean-intersection

#/
# Removes generated datasets.
#
# @example
# make clean-intersection-data
#/
clean-intersection-data:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(INTERSECTION_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(INTERSECTION_CSV_OUT)

.PHONY: clean-intersection-data

#/
# Removes generated documentation.
#
# @example
# make clean-intersection-docs
#/
clean-intersection-docs:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(INTERSECTION_HTML_OUT)

.PHONY: clean-intersection-docs
