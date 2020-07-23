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
var RECORD_DATA = require( './../../data/vendor/record.json' );
var METHODS_TO_FUNCTIONS = require( './../../data/raw/numpy_methods_to_functions.json' );
var libraries = require( './downstream_libraries.js' );
var dealias = require( './numpy_dealias.js' );


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
* Sorts a ranked array using a [Borda count][1] variant called the Dowdall System.
*
* ## Notes
*
* -   The basic idea is that voting systems can provide a mechanism for ranking APIs based on downstream library usage. How downstream libraries "vote" is by usage. The more heavily an API is used, the higher a downstream library's voting preference for that API. So while a downstream library never fills in a traditional ballot indicating its assessment of API importance, we empirically infer such an assessment by how heavily it relies on a given API.
*
* [1]: https://en.wikipedia.org/wiki/Borda_count
*
* @private
* @param {Array<Object>} arr - array to sort
* @returns {Array<Object>} sorted array
*/
function sort( arr ) {
	var keys;
	var tmp;
	var pts;
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
	for ( i = 0; i < arr.length; i++ ) {
		d = arr[ i ];

		// Award voting "points" to each API...
		pts = 0.0;
		for ( j = 0; j < N; j++ ) {
			k = keys[ j ];
			if ( isNumber( d[ k ] ) ) {
				// Fractional weighting based on a harmonic progression (see https://en.wikipedia.org/wiki/Positional_voting)...
				pts += 1.0 / d[ k ];
			}
		}
		o = {};
		o.ref = d;
		o.value = pts;

		tmp.push( o );
	}
	// Sort the input array based on awarded points...
	tmp.sort( descending );
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
	// Get the list of downstream libraries:
	keys = libraries();

	// Convert the provided list into a hash...
	hash = {};
	for ( i = 0; i < list.length; i++ ) {
		tmp = {};
		for ( j = 0; j < keys.length; j++ ) {
			tmp[ keys[ j ] ] = 0;
		}
		hash[ list[ i ] ] = tmp;
	}
	// Initialize an object for recording per library function counts...
	libs = {};
	for ( i = 0; i < keys.length; i++ ) {
		libs[ keys[ i ] ] = {
			'total': 0
		};
	}
	// Combine the record data with the provided API list...
	for ( i = 0; i < RECORD_DATA.length; i++ ) {
		d = RECORD_DATA[ i ];
		lib = d.library;
		fcn = d.function;
		if ( bool && hasOwnProp( mthd2fcn, fcn ) ) {
			fcn = mthd2fcn[ fcn ] || fcn;
		}
		fcn = dealias( fcn );
		if ( hasOwnProp( hash, fcn ) ) {
			cnt = parseInt( d.count, 10 );
			hash[ fcn ][ lib ] += cnt;

			tmp = libs[ lib ];
			if ( hasOwnProp( tmp, fcn ) ) {
				tmp[ fcn ] += cnt;
			} else {
				tmp[ fcn ] = cnt;
			}
			libs[ lib ].total += cnt;
		}
	}
	// Normalize library counts...
	for ( i = 0; i < list.length; i++ ) {
		d = hash[ list[ i ] ];
		for ( j = 0; j < keys.length; j++ ) {
			k = keys[ j ];
			if ( hasOwnProp( d, k ) && libs[ k ].total > 0 ) {
				d[ k ] /= libs[ k ].total;
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

		// For each API, extract its rank for each library...
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
	// Lastly, sort the JSON array in rank order...
	out = sort( out );

	return out;
}


// EXPORTS //

module.exports = rankByUsage;
