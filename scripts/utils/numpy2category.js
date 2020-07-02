#!/usr/bin/env node

/**
* @license MIT
*
* Copyright (c) 2020 Python Data APIs Consortium.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

'use strict';

// MODULES //

var keyBy = require( '@stdlib/utils/key-by' );
var hasOwnProp = require( '@stdlib/assert/has-own-property' );
var CATEGORIES = require( './../../data/raw/numpy_categories.json' );


// VARIABLES //

var HASH = keyBy( CATEGORIES, hashFcn );


// FUNCTIONS //

/**
* Hash function for converting the category data into a lookup table.
*
* @private
* @param {Object} value - collection value
* @param {number} idx - index
* @returns {string} hash value
*/
function hashFcn( value ) {
	return value.name;
}


// MAIN //

/**
* Returns the category associated with a specified NumPy API.
*
* @private
* @param {string} name - NumPy API name
* @returns {(null|string)} associated category
*/
function numpy2category( name ) {
	var out;
	var o;
	if ( !hasOwnProp( HASH, name ) ) {
		return null;
	}
	o = HASH[ name ];
	if ( o.category === '' ) {
		return '(other)';
	}
	out = o.category;
	if ( o.subcategory ) {
		out += ':' + o.subcategory;
	}
	return out;
}


// EXPORTS //

module.exports = numpy2category;
