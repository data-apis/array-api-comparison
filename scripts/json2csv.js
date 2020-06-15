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

var objectKeys = require( '@stdlib/utils/keys' );
var replace = require( '@stdlib/string/replace' );


// MAIN //

/**
* Converts a JSON array to a CSV string.
*
* @private
* @param {Array<Object>} arr - JSON array
* @returns {string} CSV string
*/
function json2csv( arr ) {
	var headers;
	var out;
	var tmp;
	var N;
	var M;
	var o;
	var v;
	var i;
	var j;

	out = '';
	if ( arr.length === 0 ) {
		return out;
	}
	headers = objectKeys( arr[ 0 ] );
	N = headers.length;
	for ( i = 0; i < N; i++ ) {
		out += headers[ i ];
		if ( i < N-1 ) {
			out += ',';
		}
	}
	out += '\r\n';

	M = arr.length;
	for ( i = 0; i < M; i++ ) {
		o = arr[ i ];
		tmp = '';
		for ( j = 0; j < N; j++ ) {
			v = o[ headers[ j ] ];
			v = replace( v, ',', '\\,' );
			v = replace( v, '"', '""' );
			tmp += '"' + v + '"';
			if ( j < N-1 ) {
				tmp += ',';
			}
		}
		out += tmp + '\r\n';
	}
	return out;
}


// EXPORTS //

module.exports = json2csv;
