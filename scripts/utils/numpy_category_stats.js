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
var numpy2category = require( './numpy2category.js' );


// MAIN //

/**
* Returns category statistics for a provided a Numpy API list.
*
* @private
* @param {Array<string>} list - list of NumPy APIs
* @returns {Object} category statistics
*/
function stats( list ) {
	var keys;
	var out;
	var cat;
	var tmp;
	var i;

	keys = [];
	out = {};
	for ( i = 0; i < list.length; i++ ) {
		cat = numpy2category( list[ i ] );
		if ( cat === null ) {
			cat = '(unknown)';
		}
		if ( hasOwnProp( out, cat ) ) {
			out[ cat ] += 1;
		} else {
			out[ cat ] = 1;
		}
		tmp = cat.split( ':' );
		if ( tmp.length > 1 ) {
			if ( hasOwnProp( out, tmp[ 0 ] ) ) {
				out[ tmp[ 0 ] ] += 1;
			} else {
				out[ tmp[ 0 ] ] = 1;
			}
			keys.push( tmp[ 0 ] );
		}
		keys.push( cat );
	}
	// Sort category keys...
	tmp = out;
	keys.sort();
	out = {};
	for ( i = 0; i < keys.length; i++ ) {
		out[ keys[ i ] ] = tmp[ keys[ i ] ];
	}

	return out;
}


// EXPORTS //

module.exports = stats;
