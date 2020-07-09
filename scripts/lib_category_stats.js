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

var pluck = require( '@stdlib/utils/pluck' );
var pickBy = require( '@stdlib/utils/pick-by' );
var objectKeys = require( '@stdlib/utils/keys' );
var hasOwnProp = require( '@stdlib/assert/has-own-property' );
var rankTopK = require( './utils/rank_by_usage_top_k_names.js' );
var stats = require( './utils/numpy_category_stats.js' );
var DATA = require( './../data/raw/numpy.json' );


/**
* Filters category statistics for top-level categories.
*
* @private
* @param {string} key - property name
* @param {*} value - property value
* @returns {boolean} boolean indicating whether to copy a property to a new object
*/
function predicate( key ) {
	return key.split( ':' ).length === 1;
}


// MAIN //

/**
* Main execution sequence.
*
* @private
*/
function main() {
	var keys;
	var libs;
	var list;
	var data;
	var cats;
	var out;
	var lib;
	var tmp;
	var o;
	var i;
	var j;
	var k;

	// Extract a list of NumPy APIs:
	list = pluck( DATA, 'name' );

	// Rank the list of NumPy APIs based on relative usage:
	data = rankTopK( list, 100, true );

	// Get the list of downstream libraries:
	libs = objectKeys( data[ 0 ] );

	// For each library, compute category statistics:
	cats = {};
	out = {};
	for ( i = 0; i < libs.length; i++ ) {
		lib = libs[ i ];
		if ( lib === 'numpy' ) {
			continue;
		}
		// Extract a list of NumPy APIs:
		list = pluck( data, lib );

		// Prefix each API:
		for ( j = 0; j < list.length; j++ ) {
			list[ j ] = 'numpy.' + list[ j ];
		}
		// Compute category statistics:
		tmp = stats( list );

		// Keep only the top-level categories:
		tmp = pickBy( tmp, predicate );

		// Get the list of categories:
		keys = objectKeys( tmp );

		// Update the list of all categories:
		for ( j = 0; j < keys.length; j++ ) {
			cats[ keys[ j ] ] = true;
		}
		// Assign the category results to the output object:
		out[ lib ] = tmp;
	}
	cats = objectKeys( cats ).sort();

	// Set missing categories to zero:
	for ( i = 0; i < libs.length; i++ ) {
		lib = libs[ i ];
		if ( lib === 'numpy' ) {
			continue;
		}
		tmp = out[ lib ];
		for ( j = 0; j < cats.length; j++ ) {
			if ( !hasOwnProp( tmp, cats[ j ] ) ) {
				tmp[ cats[ j ] ] = 0;
			}
		}
	}
	// Convert results to a JSON array:
	tmp = out;
	out = [];
	for ( i = 0; i < cats.length; i++ ) {
		k = cats[ i ];
		o = {};
		o.category = k;
		for ( j = 0; j < libs.length; j++ ) {
			lib = libs[ j ];
			if ( lib === 'numpy' ) {
				continue;
			}
			o[ lib ] = tmp[ lib ][ k ];
		}
		out.push( o );
	}
	// Print the result:
	console.log( JSON.stringify( out ) );
}

main();
