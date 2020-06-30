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
COMPLEMENT_JSON_OUT ?= $(DATA_DIR)/complement.json

# Define the output file path for API complement data as CSV:
COMPLEMENT_CSV_OUT ?= $(DATA_DIR)/complement.csv

# Define the output file path for viewing API complement data as an HTML table:
COMPLEMENT_HTML_OUT ?= $(DOCS_DIR)/complement.html


# RULES #

#/
# Generates a JSON file containing the complement of the library API intersection.
#
# @private
#/
$(COMPLEMENT_JSON_OUT): $(JOIN_JSON_OUT) $(INTERSECTION_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/complement_json.js > $(COMPLEMENT_JSON_OUT)

#/
# Generates a CSV file containing the complement of the library API intersection.
#
# @private
#/
$(COMPLEMENT_CSV_OUT): $(COMPLEMENT_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/json2csv.js $(COMPLEMENT_JSON_OUT) > $(COMPLEMENT_CSV_OUT)

#/
# Generates HTML assets for viewing complement data.
#
# @private
#/
$(COMPLEMENT_HTML_OUT): $(COMPLEMENT_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/html_table.js $(COMPLEMENT_JSON_OUT) --title="Non-Universal APIs" > $(COMPLEMENT_HTML_OUT)

#/
# Generates data assets.
#
# @example
# make complement
#/
complement: $(COMPLEMENT_JSON_OUT) $(COMPLEMENT_CSV_OUT) $(COMPLEMENT_HTML_OUT)

.PHONY: complement

#/
# Opens an HTML table in a web browser.
#
# @example
# make view-complement
#/
view-complement: $(COMPLEMENT_HTML_OUT)
	$(QUIET) $(OPEN) $(COMPLEMENT_HTML_OUT)

.PHONY: view-complement

#/
# Removes build artifacts.
#
# @example
# make clean-complement
#/
clean-complement: clean-complement-data clean-complement-docs

.PHONY: clean-complement

#/
# Removes generated datasets.
#
# @example
# make clean-complement-data
#/
clean-complement-data:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMPLEMENT_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMPLEMENT_CSV_OUT)

.PHONY: clean-complement-data

#/
# Removes generated documentation.
#
# @example
# make clean-complement-docs
#/
clean-complement-docs:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMPLEMENT_HTML_OUT)

.PHONY: clean-complement-docs
