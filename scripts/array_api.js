#!/usr/bin/env node

/**
* @license MIT
*
* Copyright (c) 2021 Python Data APIs Consortium.
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

var join = require( 'path' ).join;
var readJSON = require( '@stdlib/fs/read-json' ).sync;
var ARRAY_API = require( './../data/raw/array_api.json' );


// VARIABLES //

var LIBRARIES = [
	'numpy',
	'cupy',
	'dask',
	'jax',
	'mxnet',
	'pytorch',
	'sparse',
	'tensorflow'
];
var PREFIXES = {
	'numpy': 'numpy._array_api.', // 'numpy.',
	'cupy': 'cupy.',
	'dask': '',
	'jax': '',
	'mxnet': 'mxnet.ndarray.',
	'pytorch': 'torch.',
	'sparse': '',
	'tensorflow': 'tf.'
};
var FOPTS = {
	'encoding': 'utf8'
};


// MAIN //

/**
* Main execution sequence.
*
* @private
*/
function main() {
	var counts;
	var fpath;
	var alias;
	var name;
	var data;
	var out;
	var tmp;
	var key;
	var fcn;
	var o;
	var i;
	var j;
	var k;

	counts = {
		'name': 'Total APIs: '+ARRAY_API.length
	};
	for ( j = 0; j < LIBRARIES.length; j++ ) {
		key = LIBRARIES[ j ];

		// TODO: remove once https://github.com/numpy/numpy/pull/18585 is merged; here, we mark with an asterisk to indicate that this is in-progress...
		if ( key === 'numpy' ) {
			key += '<sup>*</sup>';
		}
		counts[ key ] = 0;
	}
	out = [];
	for ( i = 0; i < ARRAY_API.length; i++ ) {
		name = ARRAY_API[ i ];
		tmp = {
			'name': name
		};
		for ( j = 0; j < LIBRARIES.length; j++ ) {
			key = LIBRARIES[ j ];
			if ( key === 'numpy' ) {
				// For NumPy, we base the data off a WIP PR: https://github.com/numpy/numpy/pull/18585
				fpath = join( __dirname, '..', 'data', 'raw', key+'_array_api.json' );
			} else {
				fpath = join( __dirname, '..', 'data', 'raw', key+'.json' );
			}
			data = readJSON( fpath, FOPTS );
			if ( data instanceof Error ) {
				throw data;
			}
			alias = PREFIXES[ key ] + name;
			for ( k = 0; k < data.length; k++ ) {
				o = data[ k ];
				if ( o.name === alias ) {
					// TODO: remove once https://github.com/numpy/numpy/pull/18585 is merged; here, we mark with an asterisk to indicate that this is in-progress...
					if ( key === 'numpy' ) {
						key += '<sup>*</sup>';
					}
					tmp[ key ] = '&#128640'; // '&#128588'; // '&#128013'; // '&#128077;';
					counts[ key ] += 1;
					break;
				}
			}
			if ( k === data.length ) {
				// TODO: remove once WIP PR https://github.com/numpy/numpy/pull/18585 is merged:
				if ( key === 'numpy' ) {
					key += '<sup>*</sup>';
				}
				tmp[ key ] = '';
			}
		}
		out.push( tmp );
	}
	out.push( counts );

	// Print the data as JSON to stdout:
	console.log( JSON.stringify( out, null, 2 ) );
}

main();
