var Animated = function() {

	this.counter = 0;
	this.allElems = [];
	var _this = this;

	function isScrolledIntoView(docViewTop, docViewBottom, elemObj) {
	    

	    var elemTop = elemObj[1];
	    var elemBottom = elemObj[2];

	    return ((elemBottom <= docViewBottom) && (elemTop >= docViewTop));
	}

	function setFadeTimeout(remove, add, delay, elem) {
		setTimeout(function(){
			$(elem).delay(delay).removeClass(remove).addClass(add);
		}, delay);
	}

	function runFadeIn(remove, add, timeDelay, counter) {
		var elems = _this.allElems[counter];
		var delay = 0;
		var docViewTop = $(window).scrollTop();
	    var docViewBottom = docViewTop + $(window).height();
	    var indices = [];

		for (var i = 0; i < elems.length; i++) {

			var elemObj = elems[i];
			console.log(elemObj[1] + ", " + elemObj[2]);
			console.log(elemObj[0]);
			if (isScrolledIntoView(docViewTop, docViewBottom, elemObj)) {

				setFadeTimeout(remove, add, delay, elemObj[0]);
				delay = delay + timeDelay;
				indices.push(i);
			}
		}

		indices.reverse(); //so splice works
		for (var j = 0; j < indices.length; j++) {
			var index = indices[j];
			_this.allElems[counter].splice(index, 1);
		}
	}

	this.add = function(customClass, animateClass, dict) {		
		var timeDelay = 200;
		var counter = _this.counter;

		if (dict != undefined) {
			if (dict.timeDelay != undefined) {
				timeDelay = dict.timeDelay;
			}
		}

		$(document).on("ready", function(){
			var elems = $("." + customClass);
			_this.allElems[counter] = [];
			
			for (var i = 0; i < elems.length; i++) {
				var elem = elems[i];
				var elemTop = $(elem).offset().top;
		    	var elemBottom = elemTop + $(elem).height();

				_this.allElems[counter].push([ elem, elemTop, elemBottom ]);
			}

			runFadeIn(customClass, animateClass, timeDelay, counter);

			$(document).scroll(function(e) {
				runFadeIn(customClass, animateClass, timeDelay, counter);
			} );
		});

		_this.counter = _this.counter + 1;
	}
};

/**
*   @example
*  	var animate = new Animated();
*   animate.add("customClass", "animated animateCSSClass", {
*   	timeDelay: 150 //delay in ms, default: 200
*   }); 											//dictionary param is optional
*
*   <div class="preanimated customClass"></div> //before animation
*   <div class="animated animateCSSClass"></div> //after animation
*/
