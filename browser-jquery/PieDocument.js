////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Pie Document Javascript Code (p) 2012..2020 A. Tenbusch
//
// - all modifications of document object
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// https://developer.mozilla.org/de/docs/Web/API/URL
// https://developer.mozilla.org/de/docs/Web/API/URLSearchParams
    
//
// pseudo constructor
//
document.createUI = function () {

    this.nodeContextMenu = null;

    // analyze current URL
    var intPosScroll = 0;
    var idHighlight;

    var urlParams = new URLSearchParams(document.location.search);

    if (urlParams.has('pattern')) {
	// $('#tags').css({'display': 'block'});
    }
    
    if (urlParams.has('hl')) {
	// TODO: use clolor index for multiple selections (s. markTextStrRecursive)
	//$('span:contains(' + urlParams.get('hl') + ')').toggleClass('highlight',true);

	var strMark = '/' + urlParams.get('hl') + '/i';
	var regexpMark = eval(strMark);
 	
	putsConsole('Highlight: ' + strMark);
	this.markTextStrRecursive(null,regexpMark);
    }
    
    if (urlParams.has('pos')) {
	putsConsole('Scroll page to: ' + intPosScroll);
	$(window).scrollTop(urlParams.get('pos'));
    }
    
    //
    // 
    //
    $('#tag_reset').on('click', function (event) {

	var urlParamsReset = new URLSearchParams(window.location.search);

	urlParamsReset.delete('hl');
	urlParamsReset.delete('pattern');
	
	var strQuery = urlParamsReset.toString();
	if (strQuery == '') {
	    window.location.assign(window.location.pathname);
	} else {
	    window.location.assign(window.location.pathname + '?' + strQuery);
	}
    });

    //
    // https://stackoverflow.com/questions/16190455/how-to-detect-controlclick-in-javascript-from-an-onclick-div-attribute
    //
    $('*.tag,*.htag,*.htag-todo,*.htag-done,*.htag-test,*.htag-bug,*.htag-req,*.htag-target,span.date').on('click change', function (event) {
	var strPattern;
	var strPatternNew;

	var urlParamsTag = new URLSearchParams(document.location.search);
	
	if (urlParamsTag.has('pattern')) {
	    strPattern = urlParamsTag.get('pattern');
	} else { // no previous pattern
	    strPattern = '';
	}
	putsConsole('Old pattern: ' + strPattern);
	
	if (event.target instanceof HTMLInputElement) {
	    strPatternNew = "t[contains(text(),'" + event.target.innerText + "')]";
	} else {
	    var strClass = event.target.getAttribute("class");

	    if (strClass.match(/^htag-.+/)) { // map combined class name to usable tag
		strPatternNew = "t[contains(text(),'" + strClass.replace(/^htag-/, '#') + "')]";
	    } else if (strClass.match(/^htag$/)) {
		strPatternNew = "(tag[contains(text(),'" + event.target.innerText + "')]|htag[contains(text(),'" + event.target.innerText + "')]|t[contains(text(),'" + event.target.innerText + "')])";
	    } else if (strClass.match(/date/)) {
		var strISO = event.target.getAttribute("title");
		
		if (strISO == undefined || strISO == '') {
	            putsConsole('No ISO date found');
		} else {
		    strPatternNew = "date[contains(text(),'" + event.target.getAttribute("title") + "') or @iso = '" + event.target.getAttribute("title") + "']";
		}
	    } else {
		strPatternNew = "t[contains(text(),'" + event.target.innerText + "')]";
	    }
	}
	
	if (strPatternNew == undefined || strPatternNew == '') {
	    putsConsole('Empty');
	} else if (strPattern == strPatternNew) {
	    putsConsole('No update (same value)');
	} else { // something selected
	    var strUrlNew;

	    putsConsole('New Pattern: ' + strPatternNew);

	    if (event.ctrlKey) {
	        putsConsole('<CRTL>' + ' logical OR');
		if (strPattern == '') {
		    // no combination
		} else {
		    strPatternNew = '(' + strPattern + ' or ' + strPatternNew + ')';
		}
	    } else if (event.altKey) {
	        putsConsole('<ALT>' + ' logical AND');
		if (strPattern == '') {
		    // no combination
		} else {
		    strPatternNew = '(' + strPattern + ' and ' + strPatternNew + ')';
		}
	    } else if (event.shiftKey) {
	        putsConsole('<SHIFT>' + ' logical AND NOT');
		if (strPattern == '') {
		    strPatternNew = 'not(' + strPatternNew + ')'; // BUG: 
		} else {
		    strPatternNew = '(' + strPattern + ' and not(' + strPatternNew + '))';
		}
	    }

	    urlParamsTag.set('pattern',strPatternNew);
	    // TODO:
	    urlParamsTag.set('hl',event.target.innerText);

	    var strQuery = urlParamsTag.toString();
	    if (strQuery == '') {
		strUrlNew = window.location.pathname;
	    } else {
		strUrlNew = window.location.pathname + '?' + strQuery;
	    }

	    putsConsole('New URL: ' + strUrlNew);
	    window.location.assign(strUrlNew);
	}
    });
}


//
// 
//
document.markTextStr = function (strText) {

    var strMark = '/.*' + strText + '.*/';
    if (strMark.match(/[A-Z]/)) {
    }
    else {
	strMark = strMark + 'i';
    }
    var regexpMark = eval(strMark);
    var nodeStart = this.getElementById('content');

    if (nodeStart) {
	if (this.intColorIndex < this.arrColorMarker.length - 1) {
	    this.intColorIndex++;
	}
	this.markTextStrRecursive(nodeStart,regexpMark);
    }
    else {
	alert("No node found");
    }
}


//
// 
//
document.markTextStrRecursive = function (node,regexp) {

    var i;

    if (node == undefined || node == null) {
	node = this.documentElement;
    }
    
    for (i=0; node && i<node.childNodes.length; i++) {
	if (node.childNodes[i] && node.childNodes[i].nodeType == 3) { // Node.TEXT_NODE
	    if (node.childNodes[i].nodeValue && node.childNodes[i].nodeValue.match(regexp)) {
		//alert(node.childNodes[i].nodeValue);
		if (node.getAttribute('href') && node.getAttribute('href').match(/^javascript:markTextStr.*$/i)) {
		    node.setAttribute('href','javascript:setSearch("' + node.childNodes[i].nodeValue + '")')
		}
		// backup class value
// 		if (node.getAttribute('style')) {
// 		    node.setAttribute('bstyle',node.getAttribute('style'));
// 		}
// 		else {
// 		    node.setAttribute('bstyle','');
// 		}
		// TODO: highlight string only <div class="hl">TEST</div>
		//node.style.backgroundColor = this.arrColorMarker[this.intColorIndex];
		node.classList.add('highlight');
	    }
	}
	else if (node.childNodes[i].nodeType == 1) { // Node.ELEMENT_NODE
	    // recursive call
	    this.markTextStrRecursive(node.childNodes[i],regexp);
	}
    }
}


//
// 
//
function mapXpathToLabel(strXpath) {

    if (strXpath == undefined || strXpath == '') {
	alert('Please insert header in !');
	return undefined;
    }

    var strResult = strXpath.replace(/[\*\[\]]+/g,'').replace(/\//g,'_');

    return strResult;
}


document.addEventListener("DOMContentLoaded", document.createUI, false);
