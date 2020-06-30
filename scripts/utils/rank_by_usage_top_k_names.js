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

var hasOwnProp = require( '@stdlib/assert/has-own-property' );
var objectKeys = require( '@stdlib/utils/keys' );
var replace = require( '@stdlib/string/replace' );
var RECORD_DATA = require( './../../data/vendor/record.json' );


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
	if ( a.rank === null ) {
		return 1;
	}
	if ( b.rank === null ) {
		return -1;
	}
	if ( a.rank < b.rank ) {
		return -1;
	}
	if ( a.rank > b.rank ) {
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


// MAIN //

/**
* Ranks the top `K` APIs (by name) from a provided list of NumPy APIs.
*
* @private
* @param {Array<string>} list - list of NumPy APIs
* @param {number} [K=list.length] - number of APIs to rank
* @returns {Array<Object} sorted JSON array based on relative usage
*/
function rankTopK( list, K ) {
	var libs;
	var keys;
	var hash;
	var tmp;
	var cnt;
	var out;
	var idx;
	var K;
	var d;
	var o;
	var i;
	var j;
	var k;

	K = K || list.length;

	// Convert the list into a hash...
	hash = {};
	for ( i = 0; i < list.length; i++ ) {
		hash[ list[ i ] ] = {};
	}

	// Combine the record data with the intersection list...
	libs = {};
	for ( i = 0; i < RECORD_DATA.length; i++ ) {
		d = RECORD_DATA[ i ];
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
	// Extract the API rankings for each library...
	tmp = {};
	for ( i = 0; i < list.length; i++ ) {
		d = out[ i ];
		for ( j = 0; j < keys.length; j++ ) {
			k = keys[ j ];
			if ( !tmp[ k ] ) {
				tmp[ k ] = [];
			}
			tmp[ k ].push({
				'rank': d.rank[ k ],
				'name': d.name
			});
		}
	}
	// Sort the rankings in ascending order...
	out = tmp;
	for ( j = 0; j < keys.length; j++ ) {
		k = keys[ j ];
		out[ k ].sort( ascending );
	}
	// Extract only the API names...
	for ( j = 0; j < keys.length; j++ ) {
		k = keys[ j ];
		tmp = out[ k ];
		for ( i = 0; i < tmp.length; i++ ) {
			if ( tmp[ i ].rank === null ) {
				tmp[ i ] = '-';
			} else {
				tmp[ i ] = replace( tmp[ i ].name, /^numpy\./, '' ); // remove any `numpy.` prefix
			}
		}
	}
	// Retain only the top `K` most commonly used APIs...
	for ( j = 0; j < keys.length; j++ ) {
		tmp = out[ keys[ j ] ];
		tmp.length = ( tmp.length > K ) ? K : tmp.length;
	}
	// Transform into a JSON array...
	tmp = [];
	for ( i = 0; i < K; i++ ) {
		o = {};
		o.numpy = 'numpy.';
		for ( j = 0; j < keys.length; j++ ) {
			k = keys[ j ];
			o[ k ] = out[ k ][ i ];
		}
		tmp.push( o );
	}
	out = tmp;

	// Return the result...
	return out;
}


// EXPORTS //

module.exports = rankTopK;
