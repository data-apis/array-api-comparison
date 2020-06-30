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

# Define the output file path for combined join data as JSON:
JOIN_JSON_OUT ?= $(DATA_DIR)/join.json

# Define the output file path for combined join data as CSV:
JOIN_CSV_OUT ?= $(DATA_DIR)/join.csv

# Define the output file path for viewing join data as an HTML table:
JOIN_HTML_OUT ?= $(DOCS_DIR)/join.html


# RULES #

#/
# Generates a JSON file combining individual library join data.
#
# @private
#/
$(JOIN_JSON_OUT):
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/join_json.js > $(JOIN_JSON_OUT)

#/
# Generates a CSV file combining individual library join data.
#
# @private
#/
$(JOIN_CSV_OUT): $(JOIN_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/json2csv.js $(JOIN_JSON_OUT) > $(JOIN_CSV_OUT)

#/
# Generates HTML assets for viewing join data.
#
# @private
#/
$(JOIN_HTML_OUT): $(JOIN_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/html_table.js $(JOIN_JSON_OUT) --title="Array API Comparison" > $(JOIN_HTML_OUT)

#/
# Generates data assets combining individual join data.
#
# @example
# make join
#/
join: $(JOIN_JSON_OUT) $(JOIN_CSV_OUT) $(JOIN_HTML_OUT)

.PHONY: join

#/
# Opens an HTML table showing all API data in a web browser.
#
# @example
# make view-join
#/
view-join: $(JOIN_HTML_OUT)
	$(QUIET) $(OPEN) $(JOIN_HTML_OUT)

.PHONY: view-join

#/
# Removes build artifacts.
#
# @example
# make clean-join
#/
clean-join: clean-join-data clean-join-docs

.PHONY: clean-join

#/
# Removes generated join datasets.
#
# @example
# make clean-join-data
#/
clean-join-data:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(JOIN_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(JOIN_CSV_OUT)

.PHONY: clean-join-data

#/
# Removes generated documentation.
#
# @example
# make clean-join-docs
#/
clean-join-docs:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(JOIN_HTML_OUT)

.PHONY: clean-join-docs
