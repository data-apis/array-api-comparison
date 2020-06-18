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

var resolve = require( 'path' ).resolve;
var readJSON = require( '@stdlib/fs/read-json' ).sync;
var isNumber = require( '@stdlib/assert/is-number' ).isPrimitive;
var hasOwnProp = require( '@stdlib/assert/has-own-property' );
var objectKeys = require( '@stdlib/utils/keys' );
var floor = require( '@stdlib/math/base/special/floor' );
var array2iterator = require( '@stdlib/array/to-iterator' );
var iterVariance = require( '@stdlib/stats/iter/variance' );


// FUNCTIONS //

/**
* Comparison function for sorting in descending order.
*
* @private
* @param {Object} a - first value
* @param {Object} b - second value
* @returns {number} integer indicating sort order
*/
function descending( a, b ) {
	if ( a.value < b.value ) {
		return 1;
	}
	if ( a.value > b.value ) {
		return -1;
	}
	return 0;
}

/**
* Comparison function for sorting in ascending order.
*
* @private
* @param {Object} a - first value
* @param {Object} b - second value
* @returns {number} integer indicating sort order
*/
function ascending( a, b ) {
	if ( a.count > b.count ) {
		return -1;
	}
	if ( a.count < b.count ) {
		return 1;
	}
	if ( a.median < b.median ) {
		return -1;
	}
	if ( a.median > b.median ) {
		return 1;
	}
	if ( a.variance < b.variance ) {
		return -1;
	}
	if ( a.variance > b.variance ) {
		return 1;
	}
	return 0;
}

/**
* Ranks method usage for a specified library.
*
* @private
* @param {Array<Object>} arr - array to rank
* @param {string} lib - library on which to rank
* @returns {Array<number>} sort permutation
*/
function rank( arr, lib ) {
	var tmp;
	var i;

	tmp = [];
	for ( i = 0; i < arr.length; i++ ) {
		tmp.push({
			'value': arr[ i ].counts[ lib ],
			'index': i
		});
	}
	tmp.sort( descending );
	for ( i = 0; i < arr.length; i++ ) {
		tmp[ i ] = tmp[ i ].index;
	}
	return tmp;
}

/**
* Comparison function for sorting in ascending order.
*
* @private
* @param {number} a - first value
* @param {number} b - second value
* @returns {number} integer indicating sort order
*/
function ascendingNumeric( a, b ) {
	if ( a < b ) {
		return -1;
	}
	if ( a > b ) {
		return 1;
	}
	return 0;
}

/**
* Sorts a ranked array based on the median rank across libraries.
*
* @private
* @param {Array<Object>} arr - array to sort
* @returns {Array<Object>} sorted array
*/
function sort( arr ) {
	var keys;
	var tmp;
	var N;
	var n;
	var r;
	var d;
	var m;
	var i;
	var j;
	var k;

	keys = objectKeys( arr[ 0 ] );
	N = keys.length;

	tmp = [];
	r = [];
	for ( i = 0; i < arr.length; i++ ) {
		d = arr[ i ];
		r.length = 0;
		for ( j = 0; j < N; j++ ) {
			k = keys[ j ];
			if ( isNumber( d[ k ] ) ) {
				r.push( d[ k ] );
			}
		}
		n = r.length / 2;
		if ( n === 0 ) {
			tmp.push({
				'count': r.length,
				'median': 1.0 / 0.0,
				'variance': NaN,
				'ref': d
			});
			continue;
		}
		// Compute the median...
		r.sort( ascendingNumeric );
		k = floor( n );
		if ( n === k ) {
			// Even length...
			m = ( r[ k-1 ] + r[ k ] ) / 2.0;
		} else {
			// Odd length...
			m = r[ k ];
		}
		tmp.push({
			'count': r.length,
			'median': m,
			'variance': iterVariance( array2iterator( r ) ),
			'ref': d
		});
	}
	// Sort the input array based on the median rank...
	tmp.sort( ascending );
	for ( i = 0; i < arr.length; i++ ) {
		arr[ i ] = tmp[ i ].ref;
	}
	return arr;
}


// MAIN //

/**
* Main execution sequence.
*
* @private
*/
function main() {
	var fpath;
	var fopts;
	var data;
	var list;
	var libs;
	var keys;
	var hash;
	var tmp;
	var cnt;
	var out;
	var idx;
	var d;
	var i;
	var j;
	var k;

	fopts = {
		'encoding': 'utf8'
	};
	// Load the intersection data...
	fpath = resolve( __dirname, '..', 'data', 'intersection.json' );
	list = readJSON( fpath, fopts );
	if ( list instanceof Error ) {
		console.error( list.message );
		return;
	}
	// Convert the list into a hash...
	hash = {};
	for ( i = 0; i < list.length; i++ ) {
		hash[ list[i].numpy ] = {};
	}

	// Load the record data...
	fpath = resolve( __dirname, '..', 'data', 'vendor', 'record.json' );
	data = readJSON( fpath, fopts );
	if ( data instanceof Error ) {
		console.error( data.message );
		return;
	}
	// Combine the record data with the intersection list...
	libs = {};
	for ( i = 0; i < data.length; i++ ) {
		d = data[ i ];
		if ( !hasOwnProp( libs, d.library ) ) {
			libs[ d.library ] = {
				'total': 0
			};
		}
		if ( hasOwnProp( hash, d.function ) ) {
			cnt = parseInt( d.count, 10 );
			hash[ d.function ][ d.library ] = cnt;
			libs[ d.library ][ d.function ] = cnt;
			libs[ d.library ].total += cnt;
		}
	}
	keys = objectKeys( libs ).sort();

	// Normalize library counts and fill in any missing record data...
	for ( i = 0; i < list.length; i++ ) {
		d = hash[ list[i].numpy ];
		for ( j = 0; j < keys.length; j++ ) {
			k = keys[ j ];
			if ( hasOwnProp( d, k ) ) {
				d[ k ] /= libs[ k ].total;
			} else {
				d[ k ] = 0;
			}
		}
	}
	// Convert the hash to a JSON array...
	out = [];
	for ( i = 0; i < list.length; i++ ) {
		out.push({
			'name': list[ i ].numpy,
			'counts': hash[ list[i].numpy ],
			'rank': {}
		});
	}
	// For each library, rank the APIs...
	for ( i = 0; i < keys.length; i++ ) {
		k = keys[ i ];
		idx = rank( out, k );
		for ( j = 0; j < idx.length; j++ ) {
			tmp = out[ idx[j] ];
			if ( tmp.counts[ k ] > 0 ) {
				tmp.rank[ k ] = j + 1;
			} else {
				tmp.rank[ k ] = null;
			}
		}
	}
	// Generate the final output JSON...
	for ( i = 0; i < list.length; i++ ) {
		tmp = {
			'numpy': list[ i ].numpy
		};
		for ( j = 0; j < keys.length; j++ ) {
			k = keys[ j ];
			if ( out[ i ].rank[ k ] === null ) {
				tmp[ k ] = '-';
			} else {
				tmp[ k ] = out[ i ].rank[ k ];
			}
		}
		out[ i ] = tmp;
	}
	// Lastly, sort the JSON based on the median rank...
	out = sort( out );

	// Print the result:
	console.log( JSON.stringify( out ) );
}

main();
