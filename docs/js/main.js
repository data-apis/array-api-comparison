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

/**
* Modified from <https://tympanus.net/codrops/2014/01/09/sticky-table-headers-columns/>.
*
* @private
*/
$(function main() {
	var $w = $( window );

	/**
	* Callback invoked upon finding a `<table>` element.
	*
	* @private
	* @returns {void}
	*/
	function onTable() {
		var $t = $( this );
		if ( $t.find( 'thead' ).length === 0 || $t.find( 'th' ).length === 0 ) {
			return;
		}
		// Clone `<thead>`:
		var $thead = $t.find( 'thead' ).clone();
		var $col = $t.find( 'thead, tbody' ).clone();

		// Wrap table:
		$t.addClass( 'sticky-enabled' ).css({ 'margin': 0, 'width': '100%' }).wrap( '<div class="sticky-wrap" />' );
		if ( $t.hasClass( 'overflow-y' ) ) {
			$t.removeClass( 'overflow-y' ).parent().addClass( 'overflow-y' );
		}
		// Create a new sticky table head (basic):
		$t.after('<table class="sticky-thead" />');

		// If `<tbody>` contains `<th>`, then we create sticky column and intersect (advanced):
		if ( $t.find( 'tbody th' ).length > 0 ) {
			$t.after( '<table class="sticky-col" /><table class="sticky-intersect" />' );
		}

		// Cache element references:
		var $stickyHead = $t.siblings('.sticky-thead');
		var $stickyCol = $t.siblings('.sticky-col');
		var $stickyIntersect = $t.siblings('.sticky-intersect');
		var $stickyWrap = $t.parent('.sticky-wrap');

		$stickyHead.append( $thead );
		$stickyCol.append( $col ).find( 'thead th:gt(0)' ).remove().end().find( 'tbody td' ).remove();
		$stickyIntersect.html( '<thead><tr><th>' + $t.find( 'thead th:first-child' ).html() + '</th></tr></thead>' );

		setWidths();
		$t.parent( '.sticky-wrap' ).scroll( $.throttle( 15, onScroll ) );
		$w.load( setWidths ).resize( $.debounce( 250, onResize ) ).scroll( $.throttle( 15, repositionStickyHead ) );

		return;

		/**
		* Sets sticky table element dimensions.
		*
		* @private
		*/
		function setWidths() {
			$t.find( 'thead th' ).each( setHeadingWidth ).end().find( 'tr' ).each( setRowHeight );

			// Set width of sticky table head:
			$stickyHead.width( $t.width() );

			// Set width of sticky table column:
			$stickyCol.find( 'th' ).add( $stickyIntersect.find( 'th' ) ).width( $t.find( 'thead th' ).width() );
		}

		/**
		* Callback invoked to set a table heading width.
		*
		* @private
		* @param {number} i - index
		*/
		function setHeadingWidth( i ) {
			var $el = $( this );
			$stickyHead.find( 'th' ).eq( i ).width( $el.width() );
		}

		/**
		* Callback invoked to set a table row height.
		*
		* @private
		* @param {number} i - index
		*/
		function setRowHeight( i ) {
			var $el = $( this );
			$stickyCol.find( 'tr' ).eq( i ).height( $el.height() );
		}

		/**
		* Repositions a stick table head.
		*
		* @private
		*/
		function repositionStickyHead() {
			var allowance;
			var st;
			var t;

			// Return value of calculated allowance:
			var allowance = calcAllowance();

			// Check if wrapper parent is overflowing along the y-axis:
			if( $t.height() > $stickyWrap.height() ) {
				// If it is overflowing (advanced layout), position sticky header based on wrapper `scrollTop()`:
				if( $stickyWrap.scrollTop() > 0 ) {
					// When top of wrapping parent is out of view...
					$stickyHead.add( $stickyIntersect ).css({
						'opacity': 1,
						'top': $stickyWrap.scrollTop()
					});
				} else {
					// When top of wrapping parent is in view...
					$stickyHead.add( $stickyIntersect ).css({
						'opacity': 0,
						'top': 0
					});
				}
			} else {
				// If it is not overflowing (basic layout), position sticky header based on viewport `scrollTop`:
				st = $w.scrollTop();
				t = $t.offset().top;
				if ( st > t && st < t+$t.outerHeight()-allowance ) {
					// When top of viewport is in the table itself...
					$stickyHead.add( $stickyIntersect ).css({
						'opacity': 1,
						'top': st - t
					});
				} else {
					// When top of viewport is above or below table...
					$stickyHead.add( $stickyIntersect ).css({
						'opacity': 0,
						'top': 0
					});
				}
			}
		}

		/**
		* Repositions a stick table column.
		*
		* @private
		*/
		function repositionStickyCol() {
			if ( $stickyWrap.scrollLeft() > 0 ) {
				// When left of wrapping parent is out of view...
				$stickyCol.add( $stickyIntersect ).css({
					'opacity': 1,
					'left': $stickyWrap.scrollLeft()
				});
			} else {
				// When left of wrapping parent is in view...
				$stickyCol.css({ 'opacity': 0 }).add( $stickyIntersect ).css({ 'left': 0 });
			}
		}

		/**
		* Calculates table height allowance.
		*
		* @private
		* @returns {number} allowed height
		*/
		function calcAllowance() {
			var a = 0;
			var b;

			// Calculate allowance:
			$t.find( 'tbody tr:lt(3)' ).each( onRow );

			// Set fail safe limit (last three rows might be too tall; set arbitrary limit at 0.25 of viewport height, or you can use an arbitrary pixel value):
			b = $w.height() * 0.25;
			if ( a > b ) {
				a = b;
			}

			// Add the height of sticky header:
			a += $stickyHead.height();

			return a;

			function onRow() {
				a += $( this ).height();
			}
		}

		/**
		* Callback invoked upon page scroll.
		*
		* @private
		*/
		function onScroll() {
			repositionStickyHead();
			repositionStickyCol();
		}

		/**
		* Callback invoked upon resizing a page.
		*
		* @private
		*/
		function onResize() {
			setWidths();
			repositionStickyHead();
			repositionStickyCol();
		}
	}

	$( 'table' ).each( onTable );
});
