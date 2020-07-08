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
var variance = require( '@stdlib/stats/base/variance' );
var mediansorted = require( '@stdlib/stats/base/mediansorted' );
var PINF = require( '@stdlib/constants/math/float64-pinf' );
var RECORD_DATA = require( './../../data/vendor/record.json' );
var METHODS_TO_FUNCTIONS = require( './../../data/raw/numpy_methods_to_functions.json' );


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
	// Sort values having greater counts (i.e., used by more libraries) to lower indices...
	if ( a.count > b.count ) {
		return -1;
	}
	if ( a.count < b.count ) {
		return 1;
	}
	// Sort values with a lower median rank (where "lower" means *more* common) to lower indices...
	if ( a.median < b.median ) {
		return -1;
	}
	if ( a.median > b.median ) {
		return 1;
	}
	// Sort values with a more "consistent" median rank to lower indices...
	if ( a.variance < b.variance ) {
		return -1;
	}
	if ( a.variance > b.variance ) {
		return 1;
	}
	return 0;
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
* Ranks API usage for a specified library.
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
	var r;
	var d;
	var o;
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
		// Sort in ascending order...
		r.sort( ascendingNumeric );

		// Compute statistics...
		o = {};
		o.ref = d;
		o.count = r.length;
		o.median = ( r.length ) ? mediansorted( r.length, r, 1, 0 ) : PINF;
		o.variance = variance( r.length, 1, r, 1, 0 );

		tmp.push( o );
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
* Ranks a list of NumPy APIs according to their relative usage.
*
* @private
* @param {Array<string>} list - list of NumPy APIs
* @param {boolean} [bool=false] - boolean indicating whether to account for equivalent method usage when computing ranks
* @returns {Array<Object>} sorted JSON array based on median relative usage rank
*/
function rankByUsage( list, bool ) {
	var mthd2fcn;
	var libs;
	var keys;
	var hash;
	var tmp;
	var cnt;
	var out;
	var idx;
	var lib;
	var fcn;
	var d;
	var i;
	var j;
	var k;

	// If we should account for method usage, construct a hash mapping NumPy method names to equivalent top-level functions...
	if ( bool ) {
		mthd2fcn = {};
		for ( i = 0; i < METHODS_TO_FUNCTIONS.length; i++ ) {
			d = METHODS_TO_FUNCTIONS[ i ];
			mthd2fcn[ d.method ] = d.function;
		}
	}
	// Convert the list into a hash...
	hash = {};
	for ( i = 0; i < list.length; i++ ) {
		hash[ list [ i ] ] = {};
	}
	// Combine the record data with the provided API list...
	libs = {};
	for ( i = 0; i < RECORD_DATA.length; i++ ) {
		d = RECORD_DATA[ i ];
		lib = d.library;
		if ( !hasOwnProp( libs, lib ) ) {
			libs[ lib ] = {
				'total': 0
			};
		}
		fcn = d.function;
		if ( bool && hasOwnProp( mthd2fcn, fcn ) ) {
			fcn = mthd2fcn[ fcn ] || fcn;
		}
		if ( hasOwnProp( hash, fcn ) ) {
			cnt = parseInt( d.count, 10 );
			hash[ fcn ][ lib ] = cnt;
			libs[ lib ][ fcn ] = cnt;
			libs[ lib ].total += cnt;
		}
	}
	keys = objectKeys( libs ).sort();

	// Normalize library counts and fill in any missing record data...
	for ( i = 0; i < list.length; i++ ) {
		d = hash[ list[ i ] ];
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
			'name': list[ i ],
			'counts': hash[ list[ i ] ],
			'rank': {}
		});
	}
	// For each library, rank the APIs...
	for ( i = 0; i < keys.length; i++ ) {
		k = keys[ i ];
		idx = rank( out, k );
		for ( j = 0; j < idx.length; j++ ) {
			tmp = out[ idx[ j ] ];
			if ( tmp.counts[ k ] > 0 ) {
				tmp.rank[ k ] = j + 1;
			} else {
				tmp.rank[ k ] = null;
			}
		}
	}
	// Generate the final output JSON array...
	for ( i = 0; i < list.length; i++ ) {
		tmp = {
			'numpy': list[ i ]
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

	return out;
}


// EXPORTS //

module.exports = rankByUsage;
