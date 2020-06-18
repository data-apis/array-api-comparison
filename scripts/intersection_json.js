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
var replace = require( '@stdlib/string/replace' );


// VARIABLES //

var LIBRARIES = [
	'numpy',
	'cupy',
	'dask.array',
	'jax',
	'mxnet',
	'pytorch'
];


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
	var out;
	var cnt;
	var d;
	var i;
	var j;

	fpath = resolve( _dirname, '..', 'data', 'join.json' );
	fopts = {
		'encoding': 'utf8'
	};
	data = readJSON( fpath, fopts );
	if ( data instanceof Error ) {
		console.error( data.message );
		return;
	}
	out = [];
	for ( i = 0; i < data.length; i++ ) {
		d = data[ i ];
		cnt = 0;
		for ( j = 0; j < LIBRARIES.length; j++ ) {
			if ( d[ LIBRARIES[j] ] ) {
				cnt += 1;
			}
		}
		if ( cnt === LIBRARIES.length ) {
			out.push( replace( d[ 'numpy' ], /^numpy\./, '' ) );
		}
	}
	// Print the list as JSON to stdout:
	console.log( JSON.stringify( out ) );
}

main();
