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

var RE_EOL = require( '@stdlib/regexp/eol' );


// MAIN //

/**
* Converts a CSV string to a JSON array.
*
* @private
* @param {string} csv - CSV string
* @returns {Array<Object>} JSON array
*/
function csv2json( csv ) {
	var nfields;
	var fields;
	var nrows;
	var rows;
	var out;
	var r;
	var o;
	var i;
	var j;

	out = [];
	rows = csv.split( RE_EOL );
	nrows = rows.length;
	if ( nrows === 0 ) {
		return out;
	}
	// We assume that the first row is a header row:
	fields = rows[ 0 ].split( ',' );
	nfields = fields.length;

	for ( i = 1; i < nrows; i++ ) {
		r = rows[ i ];
		if ( r === '' ) {
			continue;
		}
		// We assume simple CSV rows:
		r = r.substring( 1, r.length-1 ).split( '","' );

		// Assemble the data object...
		o = {};
		for ( j = 0; j < nfields; j++ ) {
			o[ fields[ j ] ] = r[ j ];
		}
		// Append to the output data array:
		out.push( o );
	}
	return out;
}


// EXPORTS //

module.exports = csv2json;
