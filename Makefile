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

# Verbosity:
ifndef VERBOSE
	QUIET := @
else
	QUIET :=
endif

# Instruct make to warn us when we use an undefined variable (e.g., misspellings).
MAKEFLAGS += --warn-undefined-variables

# Define the default target:
.DEFAULT_GOAL := all

# Define the `SHELL` variable to avoid issues on systems where the variable may be inherited from the environment.
#
# ## Notes
#
# -   We use `bash` so that we can use `pipefail`.
#
# [1]: https://www.gnu.org/prep/standards/html_node/Makefile-Basics.html#Makefile-Basics
# [2]: http://clarkgrubb.com/makefile-style-guide
SHELL := bash

# Define shell flags.
#
# ## Notes
#
# -   `.SHELLFLAGS` was introduced in GNU Make 3.82 and has no effect on the version of GNU Make installed on Mac OS X, which is 3.81.
# -   The `-e` flag causes `bash` to exit immediately if a `bash` executed command fails.
# -   The `-u` flag causes `bash` to exit with an error message if a variable is accessed without being defined.
# -   The `pipefail` option specifies that, if any of the commands in a pipeline fail, the entire pipeline fails. Otherwise the return value of a pipeline is the return value of the last command.
# -   The `-c` flag is in the default value of `.SHELLFLAGS`, which must be preserved, as this is how `make` passes the script to be executed to `bash`.
#
.SHELLFLAGS := -eu -o pipefail -c

# Remove targets if its recipe fails.
#
# ## Notes
#
# -   Mentioning this target anywhere in a Makefile prevents a user from re-running make and using an incomplete or invalid target.
# -   When debugging, it may be necessary to comment this line out so the incomplete or invalid target can be inspected.
#
# [1]: https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
.DELETE_ON_ERROR:

# Remove all the default suffixes, preferring to define all rules explicitly.
#
# [1]: https://www.gnu.org/software/make/manual/html_node/Suffix-Rules.html#Suffix-Rules
# [2]: https://www.gnu.org/software/make/manual/html_node/Suffix-Rules.html#Suffix-Rules
.SUFFIXES:

# Determine the OS:
#
# [1]: https://en.wikipedia.org/wiki/Uname#Examples
# [2]: http://stackoverflow.com/a/27776822/2225624
OS ?= $(shell uname)
ifneq (, $(findstring MINGW,$(OS)))
	OS := WINNT
else
ifneq (, $(findstring MSYS,$(OS)))
	OS := WINNT
else
ifneq (, $(findstring CYGWIN,$(OS)))
	OS := WINNT
else
ifneq (, $(findstring Windows_NT,$(OS)))
	OS := WINNT
endif
endif
endif
endif

# Determine the filename:
this_file := $(lastword $(MAKEFILE_LIST))

# Determine the absolute path of the Makefile (see http://blog.jgc.org/2007/01/what-makefile-am-i-in.html):
this_dir := $(dir $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

# Remove the trailing slash:
this_dir := $(patsubst %/,%,$(this_dir))

# Define the root project directory:
ROOT_DIR ?= $(this_dir)

# Define the directory for documentation:
DOCS_DIR ?= $(ROOT_DIR)/docs

# Define the directory for data:
DATA_DIR ?= $(ROOT_DIR)/data

# Define the directory for scripts:
SCRIPTS_DIR ?= $(ROOT_DIR)/scripts

# Define the path to the root `package.json`:
ROOT_PACKAGE_JSON ?= $(ROOT_DIR)/package.json

# Define the top-level directory containing node module dependencies:
NODE_MODULES ?= $(ROOT_DIR)/node_modules

# Define the delete command:
DELETE ?= -rm
DELETE_FLAGS ?= -rf

# Define the command for `node`:
NODE ?= node

# Define the command for `npm`:
NPM ?= npm

# Determine the `open` command:
ifeq ($(OS), Darwin)
	OPEN ?= open
else
	OPEN ?= xdg-open
endif
# TODO: add Windows command

# Define the output file path for combined join data as JSON:
JOIN_JSON_OUT ?= $(DATA_DIR)/join.json

# Define the output file path for combined join data as CSV:
JOIN_CSV_OUT ?= $(DATA_DIR)/join.csv

# Define the output file path for viewing join data as an HTML table:
JOIN_HTML_OUT ?= $(DOCS_DIR)/join.html


# Define the output file path for API intersection data as JSON:
INTERSECTION_JSON_OUT ?= $(DATA_DIR)/intersection.json

# Define the output file path for API intersection data as CSV:
INTERSECTION_CSV_OUT ?= $(DATA_DIR)/intersection.csv

# Define the output file path for viewing API intersection data as an HTML table:
INTERSECTION_HTML_OUT ?= $(DOCS_DIR)/intersection.html


# Define the output file path for common API data as JSON:
COMMON_APIS_JSON_OUT ?= $(DATA_DIR)/common_apis.json

# Define the output file path for common API data as CSV:
COMMON_APIS_CSV_OUT ?= $(DATA_DIR)/common_apis.csv

# Define the output file path for viewing common API data as an HTML table:
COMMON_APIS_HTML_OUT ?= $(DOCS_DIR)/common_apis.html


# Define the output file path for API complement data as JSON:
COMPLEMENT_JSON_OUT ?= $(DATA_DIR)/complement.json

# Define the output file path for API complement data as CSV:
COMPLEMENT_CSV_OUT ?= $(DATA_DIR)/complement.csv

# Define the output file path for viewing API complement data as an HTML table:
COMPLEMENT_HTML_OUT ?= $(DOCS_DIR)/complement.html


# Define the output file path for API intersection rank data as JSON:
INTERSECTION_RANKS_JSON_OUT ?= $(DATA_DIR)/intersection_ranks.json

# Define the output file path for API intersection rank data as CSV:
INTERSECTION_RANKS_CSV_OUT ?= $(DATA_DIR)/intersection_ranks.csv

# Define the output file path for viewing API intersection rank data as an HTML table:
INTERSECTION_RANKS_HTML_OUT ?= $(DOCS_DIR)/intersection_ranks.html


# Define the output file path for common API rank data as JSON:
COMMON_APIS_RANKS_JSON_OUT ?= $(DATA_DIR)/common_apis_ranks.json

# Define the output file path for common API rank data as CSV:
COMMON_APIS_RANKS_CSV_OUT ?= $(DATA_DIR)/common_apis_ranks.csv

# Define the output file path for viewing common API rank data as an HTML table:
COMMON_APIS_RANKS_HTML_OUT ?= $(DOCS_DIR)/common_apis_ranks.html


# RULES #

#/
# Default target.
#
# @example
# make
#
# @example
# make all
#/
all: install join intersection intersection-ranks common-apis common-apis-ranks complement

.PHONY: all

#/
# Installs project dependencies.
#
# @example
# make install
#/
install: install-node

.PHONY: install

#/
# Install node module dependencies.
#
# @example
# make install-node
#/
install-node:
	$(QUIET) $(NPM) install

.PHONY: install-node

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
# Generates data assets computing the intersection of library APIs.
#
# @example
# make intersection
#/
intersection: $(INTERSECTION_JSON_OUT) $(INTERSECTION_CSV_OUT) $(INTERSECTION_HTML_OUT)

.PHONY: intersection

#/
# Generates a JSON file which ranks the intersection of library APIs.
#
# @private
#/
$(INTERSECTION_RANKS_JSON_OUT): $(INTERSECTION_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/intersection_ranks.js > $(INTERSECTION_RANKS_JSON_OUT)

#/
# Generates a CSV file which ranks the intersection of library APIs.
#
# @private
#/
$(INTERSECTION_RANKS_CSV_OUT): $(INTERSECTION_RANKS_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/json2csv.js $(INTERSECTION_RANKS_JSON_OUT) > $(INTERSECTION_RANKS_CSV_OUT)

#/
# Generates HTML assets for viewing intersection rank data.
#
# @private
#/
$(INTERSECTION_RANKS_HTML_OUT): $(INTERSECTION_RANKS_JSON_OUT)
	$(QUIET) $(NODE) $(SCRIPTS_DIR)/html_table.js $(INTERSECTION_RANKS_JSON_OUT) --title="NumPy Intersection Ranks" > $(INTERSECTION_RANKS_HTML_OUT)

#/
# Generates data assets computing the ranks of the intersection of library APIs.
#
# @example
# make intersection-ranks
#/
intersection-ranks: $(INTERSECTION_RANKS_JSON_OUT) $(INTERSECTION_RANKS_CSV_OUT) $(INTERSECTION_RANKS_HTML_OUT)

.PHONY: intersection-ranks

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
# Generates data assets computing common APIs (as determined by a threshold).
#
# @example
# make common-apis
#/
common-apis: $(COMMON_APIS_JSON_OUT) $(COMMON_APIS_CSV_OUT) $(COMMON_APIS_HTML_OUT)

.PHONY: common-apis

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
# Generates data assets computing the ranks of common APIs (as determined by a threshold).
#
# @example
# make common-apis-ranks
#/
common-apis-ranks: $(COMMON_APIS_RANKS_JSON_OUT) $(COMMON_APIS_RANKS_CSV_OUT) $(COMMON_APIS_RANKS_HTML_OUT)

.PHONY: common-apis-ranks

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
# Generates data assets computing the complement of the library API intersection.
#
# @example
# make complement
#/
complement: $(COMPLEMENT_JSON_OUT) $(COMPLEMENT_CSV_OUT) $(COMPLEMENT_HTML_OUT)

.PHONY: complement

#/
# Generates API documentation.
#
# @example
# make docs
#/
docs: $(JOIN_HTML_OUT) $(INTERSECTION_HTML_OUT) $(INTERSECTION_RANKS_HTML_OUT) $(COMPLEMENT_HTML_OUT)

.PHONY: docs

#/
# Opens API HTML tables in a web browser.
#
# @example
# make view-docs
#/
view-docs: view-join view-intersection view-intersection-ranks view-common-apis view-common-apis-ranks view-complement

.PHONY: view-docs

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
# Opens an HTML table showing the API intersection in a web browser.
#
# @example
# make view-intersection
#/
view-intersection: $(INTERSECTION_HTML_OUT)
	$(QUIET) $(OPEN) $(INTERSECTION_HTML_OUT)

.PHONY: view-intersection

#/
# Opens an HTML table showing the API intersection ranks in a web browser.
#
# @example
# make view-intersection-ranks
#/
view-intersection-ranks: $(INTERSECTION_RANKS_HTML_OUT)
	$(QUIET) $(OPEN) $(INTERSECTION_RANKS_HTML_OUT)

.PHONY: view-intersection-ranks

#/
# Opens an HTML table showing a common API subset in a web browser.
#
# @example
# make view-common-apis
#/
view-common-apis: $(COMMON_APIS_HTML_OUT)
	$(QUIET) $(OPEN) $(COMMON_APIS_HTML_OUT)

.PHONY: view-common-apis

#/
# Opens an HTML table showing the ranks of a common API subset in a web browser.
#
# @example
# make view-common-apis-ranks
#/
view-common-apis-ranks: $(COMMON_APIS_RANKS_HTML_OUT)
	$(QUIET) $(OPEN) $(COMMON_APIS_RANKS_HTML_OUT)

.PHONY: view-common-apis-ranks

#/
# Opens an HTML table showing all APIs which are not in the API intersection in a web browser.
#
# @example
# make view-complement
#/
view-complement: $(COMPLEMENT_HTML_OUT)
	$(QUIET) $(OPEN) $(COMPLEMENT_HTML_OUT)

.PHONY: view-complement

#/
# Runs the project's cleanup sequence.
#
# @example
# make clean
#/
clean: clean-node clean-data clean-docs

.PHONY: clean

#/
# Removes node module dependencies.
#
# @example
# make clean-node
clean-node:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(NODE_MODULES)

.PHONY: clean-node

#/
# Removes generated join datasets.
#
# @example
# make clean-data-join
#/
clean-data-join:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(JOIN_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(JOIN_CSV_OUT)

.PHONY: clean-data-join

#/
# Removes generated intersection datasets.
#
# @example
# make clean-data-intersection
#/
clean-data-intersection:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(INTERSECTION_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(INTERSECTION_CSV_OUT)

.PHONY: clean-data-intersection

#/
# Removes generated intersection ranks datasets.
#
# @example
# make clean-data-intersection-ranks
#/
clean-data-intersection-ranks:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(INTERSECTION_RANKS_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(INTERSECTION_RANKS_CSV_OUT)

.PHONY: clean-data-intersection-ranks

#/
# Removes generated threshold datasets.
#
# @example
# make clean-data-common-apis
#/
clean-data-common-apis:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_APIS_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_APIS_CSV_OUT)

.PHONY: clean-data-common-apis

#/
# Removes generated threshold ranks datasets.
#
# @example
# make clean-data-common-apis-ranks
#/
clean-data-common-apis-ranks:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_APIS_RANKS_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_APIS_RANKS_CSV_OUT)

.PHONY: clean-data-common-apis-ranks

#/
# Removes generated complement datasets.
#
# @example
# make clean-data-complement
#/
clean-data-complement:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMPLEMENT_JSON_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMPLEMENT_CSV_OUT)

.PHONY: clean-data-complement

#/
# Removes generated datasets.
#
# @example
# make clean-data
#/
clean-data: clean-data-join clean-data-intersection clean-data-intersection-ranks clean-data-common-apis clean-data-common-apis-ranks clean-data-complement

.PHONY: clean-data

#/
# Removes generated documentation.
#
# @example
# make clean-docs
#/
clean-docs:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(JOIN_HTML_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(INTERSECTION_HTML_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(INTERSECTION_RANKS_HTML_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_APIS_HTML_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMMON_APIS_RANKS_HTML_OUT)
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(COMPLEMENT_HTML_OUT)

.PHONY: clean-docs

#/
# Prints the runtime value of a `Makefile` variable.
#
# ## Notes
#
# -   The rule uses the following format:
#
#     ```bash
#     $ make inspect.<variable>
#     ```
#
# @example
# make inspect.ROOT_DIR
#/
inspect.%:
	$(QUIET) echo '$*=$($*)'

#/
# Asserts that a `Makefile` variable is set.
#
# ## Notes
#
# -   The rule uses the following format:
#
#     ```bash
#     $ make assert.<variable>
#     ```
#
# -   If a variable is **not** set, the recipe exits with a non-zero exit code.
#
# @example
# make assert.ROOT_DIR
#/
assert.%:
	$(QUIET) if [[ "${${*}}" = "" ]]; then \
		echo "\nError: You must set the environment variable: ${*}.\n"; \
		exit 1; \
	fi
