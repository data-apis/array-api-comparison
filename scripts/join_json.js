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
var readDir = require( '@stdlib/fs/read-dir' ).sync;
var readJSON = require( '@stdlib/fs/read-json' ).sync;
var extname = require( '@stdlib/utils/extname' );
var keyBy = require( '@stdlib/utils/key-by' );
var objectKeys = require( '@stdlib/utils/keys' );
var hasOwnProp = require( '@stdlib/assert/has-own-property' );
var replace = require( '@stdlib/string/replace' );
var json2csv = require( './utils/json2csv.js' );


// FUNCTIONS //

/**
* Returns a callback which returns a value assigned to a specified property.
*
* @private
* @param {string} prop - property name
* @returns {Function} callback
*/
function keyByCallback( prop ) {
	return onValue;

	/**
	* Returns a value assigned to a specified property.
	*
	* @private
	* @param {Object} value - collection value
	* @returns {string} property value
	*/
	function onValue( value ) {
		return value[ prop ];
	}
}


// MAIN //

/**
* Main execution sequence.
*
* @private
*/
function main() {
	var prefix;
	var files;
	var dpath;
	var fpath;
	var fopts;
	var data;
	var libs;
	var keys;
	var tmp;
	var ext;
	var ref;
	var out;
	var r;
	var f;
	var l;
	var i;
	var j;
	var k;

	fopts = {
		'encoding': 'utf8'
	};

	// Load NumPy data:
	fpath = resolve( __dirname, '..', 'data', 'raw', 'numpy.json' );
	ref = readJSON( fpath, fopts );
	if ( ref instanceof Error ) {
		console.error( ref.message );
		return;
	}
	// Convert NumPy data to a hash table:
	ref = keyBy( ref, keyByCallback( 'name' ) );

	// Load the individual join data:
	dpath = resolve( __dirname, '..', 'data', 'joins' );
	files = readDir( dpath );
	libs = [ 'numpy' ];
	for ( i = 0; i < files.length; i++ ) {
		f = files[ i ];
		ext = extname( f );
		if ( ext !== '.json' ) {
			continue;
		}
		fpath = resolve( dpath, f );
		data = readJSON( fpath, fopts );
		if ( data instanceof Error ) {
			console.error( data.message );
			continue;
		}
		// We assume the naming convention `XXXXXX_numpy.json` where `XXXXXX` corresponds to the library name:
		l = f.split( '_numpy.' )[ 0 ];
		if ( l === 'dask' ) {
			l += '.array';
		}
		libs.push( l );

		// We assume that the prefix convention, if present, matches the library name:
		if ( l === 'pytorch' ) {
			prefix = 'torch';
		} else if ( l === 'tensorflow' ) {
			prefix = 'tf';
		} else {
			prefix = l;
		}

		for ( j = 0; j < data.length; j++ ) {
			tmp = data[ j ];
			if ( tmp.numpy ) {
				if ( !hasOwnProp( ref, tmp.numpy ) ) {
					console.error( 'Unrecognized NumPy API: %s. File: %s.', tmp.numpy, f );
					continue;
				}
				r = ref[ tmp.numpy ];
				if ( !hasOwnProp( r, '__join__' ) ) {
					r.__join__ = {};
				}
				r.__join__[ l ] = replace( tmp.name, prefix+'.', '' ); // replace any library name prefixes (e.g., `torch.add` => `add`)
			}
		}
	}
	// Generate a hash table mapping each NumPy interface to its equivalent in other libraries...
	keys = objectKeys( ref ).sort();
	out = [];
	for ( i = 0; i < keys.length; i++ ) {
		k = keys[ i ];
		r = ref[ k ].__join__;
		tmp = {};
		for ( j = 0; j < libs.length; j++ ) {
			l = libs[ j ];
			if ( l === 'numpy' ) {
				tmp[ l ] = k;
			} else if ( hasOwnProp( r, l ) ) {
				tmp[ l ] = r[ l ];
			} else {
				tmp[ l ] = '';
			}
		}
		out.push( tmp );
	}
	// Print the table to stdout:
	console.log( JSON.stringify( out ) );
}

main();
