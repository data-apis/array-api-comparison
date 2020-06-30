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

# Define the root tools directory:
TOOLS_DIR ?= $(ROOT_DIR)/tools

# Define the directory containing the entry point for Makefile dependencies:
TOOLS_MAKE_DIR ?= $(TOOLS_DIR)/make

# Define the subdirectory containing Makefile dependencies:
TOOLS_MAKE_LIB_DIR ?= $(TOOLS_MAKE_DIR)/lib

# Define the path to the root `package.json`:
ROOT_PACKAGE_JSON ?= $(ROOT_DIR)/package.json

# Define the top-level directory containing node module dependencies:
NODE_MODULES ?= $(ROOT_DIR)/node_modules


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
all: install docs

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
# Generates API documentation.
#
# @example
# make docs
#/
docs: join intersection intersection-ranks common-apis common-apis-ranks complement lib-top-k-common

.PHONY: docs

#/
# Opens API HTML tables in a web browser.
#
# @example
# make view-docs
#/
view-docs: view-join view-intersection view-intersection-ranks view-common-apis view-common-apis-ranks view-complement view-lib-top-k-common

.PHONY: view-docs

#/
# Runs the project's cleanup sequence.
#
# @example
# make clean
#/
clean: clean-node clean-data clean-docs

.PHONY: clean

#/
# Removes generated datasets.
#
# @example
# make clean-data
#/
clean-data: clean-join-data clean-intersection-data clean-intersection-ranks-data clean-common-apis-data clean-common-apis-ranks-data clean-complement-data clean-lib-top-k-common-data

.PHONY: clean-data

#/
# Removes generated documentation.
#
# @example
# make clean-docs
#/
clean-docs: clean-join-docs clean-intersection-docs clean-intersection-ranks-docs clean-complement-docs clean-common-apis-docs clean-common-apis-ranks-docs clean-lib-top-k-common-docs

.PHONY: clean-docs


# DEPENDENCIES #

include $(TOOLS_MAKE_DIR)/Makefile
