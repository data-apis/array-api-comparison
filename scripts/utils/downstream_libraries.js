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
var RECORD_DATA = require( './../../data/vendor/record.json' );


// VARIABLES //

var LIBRARIES;


// MAIN //

/**
* Returns the list of downstream libraries found in the record data.
*
* @private
* @returns {Array<string>} list of libraries
*/
function libraries() {
	var tmp;
	var i;
	if ( LIBRARIES ) {
		return LIBRARIES.slice();
	}
	tmp = {};
	for ( i = 0; i < RECORD_DATA.length; i++ ) {
		tmp[ RECORD_DATA[ i ].library ] = true;
	}
	LIBRARIES = objectKeys( tmp ).sort();
	return LIBRARIES;
}


// EXPORTS //

module.exports = libraries;
