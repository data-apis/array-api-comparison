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

var pick = require( '@stdlib/utils/pick' );
var LIBRARIES = require( './../etc/libraries.json' );
var JOIN = require( './../data/join.json' );
var COMMON_APIS = require( './../data/common_apis.json' );


// MAIN //

/**
* Main execution sequence.
*
* @private
*/
function main() {
	var out;
	var d;
	var i;
	var j;

	out = [];
	for ( i = 0; i < JOIN.length; i++ ) {
		d = JOIN[ i ];

		// Check if the API is among the list of common APIs (if so, skip it)....
		for ( j = 0; j < COMMON_APIS.length; j++ ) {
			if ( d.numpy === COMMON_APIS[ j ].numpy ) {
				break;
			}
		}
		if ( j === COMMON_APIS.length ) {
			out.push( pick( d, LIBRARIES ) );
		}
	}
	// Print the list as JSON to stdout:
	console.log( JSON.stringify( out ) );
}

main();
