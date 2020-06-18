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

// MODULES //

var resolve = require( 'path' ).resolve;
var readJSON = require( '@stdlib/fs/read-json' ).sync;
var parseJSON = require( '@stdlib/utils/parse-json' );
var CLI = require( '@stdlib/tools/cli' );
var stdin = require( '@stdlib/process/read-stdin' );
var createTable = require( './utils/html_table.js' );


// MAIN //

/**
* Main execution sequence.
*
* @private
* @returns {void}
*/
function main() {
	var fopts;
	var flags;
	var args;
	var data;
	var cli;

	// Create a command-line interface:
	cli = new CLI({
		'options': {
			'string': [
				'title'
			]
		}
	});
	// Get any provided command-line options:
	flags = cli.flags();

	// Get any provided command-line arguments:
	args = cli.args();

	// Check if we are receiving data from `stdin`...
	if ( !process.stdin.isTTY ) {
		return stdin( onRead );
	}
	// Read a JSON file:
	fopts = {
		'encoding': 'utf8'
	};
	data = readJSON( args[ 0 ], fopts );
	if ( data instanceof Error ) {
		return cli.error( data );
	}
	console.log( createTable( data, flags.title || '' ) );

	/**
	* Callback invoked upon reading from `stdin`.
	*
	* @private
	* @param {(Error|null)} error - error object
	* @param {Buffer} data - data
	* @returns {void}
	*/
	function onRead( error, data ) {
		if ( error ) {
			return cli.error( error );
		}
		data = parseJSON( data.toString() );
		console.log( createTable( data, flags.title || '' ) );
	}
}

main();
