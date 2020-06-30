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

# Define the output file path for common API top K data as JSON:
LIB_TOP_K_COMMON_JSON_OUT ?= $(DATA_DIR)/lib_top_k_common.json

# Define the output file path for common API top K data as CSV:
LIB_TOP_K_COMMON_CSV_OUT ?= $(DATA_DIR)/lib_top_k_common.csv

# Define the output file path for viewing common API top K data as an HTML table:
LIB_TOP_K_COMMON_HTML_OUT ?= $(DOCS_DIR)/lib_top_k_common.html


# RULES #

#/
# Generates a JSON file containing the top K common APIs for various libraries.
#
# @private
#/
$(LIB_TOP_K_COMMON_JSON_OUT): $(COMMON_APIS_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/lib_top_k_common_json.js > $(LIB_TOP_K_COMMON_JSON_OUT)

#/
# Generates a CSV file containing the top K common APIs for various libraries.
#
# @private
#/
$(LIB_TOP_K_COMMON_CSV_OUT): $(LIB_TOP_K_COMMON_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/json2csv.js $(LIB_TOP_K_COMMON_JSON_OUT) > $(LIB_TOP_K_COMMON_CSV_OUT)

#/
# Generates HTML assets for viewing top K data.
#
# @private
#/
$(LIB_TOP_K_COMMON_HTML_OUT): $(LIB_TOP_K_COMMON_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/html_table.js $(LIB_TOP_K_COMMON_JSON_OUT) --title="Top K Common APIs" > $(LIB_TOP_K_COMMON_HTML_OUT)

#/
# Generates data assets computing the top K common APIs for various libraries.
#
# @example
# make lib-top-k-common
#/
lib-top-k-common: $(LIB_TOP_K_COMMON_JSON_OUT) $(LIB_TOP_K_COMMON_CSV_OUT) $(LIB_TOP_K_COMMON_HTML_OUT)

.PHONY: lib-top-k-common

#/
# Opens an HTML table showing the top K common APIs in a web browser.
#
# @example
# make view-lib-top-k-common
#/
view-lib-top-k-common: $(LIB_TOP_K_COMMON_HTML_OUT)
	$(QUIET) $(OPEN) $(LIB_TOP_K_COMMON_HTML_OUT)

.PHONY: view-lib-top-k-common

#/
# Removes build artifacts.
#
# @example
# make clean-lib-top-k-common
#/
clean-lib-top-k-common: clean-lib-top-k-common-data clean-lib-top-k-common-data-docs

.PHONY: clean-lib-top-k-common

#/
# Removes generated top K common datasets.
#
# @example
# make clean-lib-top-k-common-data
#/
clean-lib-top-k-common-data:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(LIB_TOP_K_COMMON_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(LIB_TOP_K_COMMON_CSV_OUT)

.PHONY: clean-lib-top-k-common-data

#/
# Removes generated documentation.
#
# @example
# make clean-lib-top-k-common-docs
#/
clean-lib-top-k-common-docs:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(LIB_TOP_K_COMMON_HTML_OUT)

.PHONY: clean-lib-top-k-common-docs
