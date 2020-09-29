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
	$('#tags').css({'display': 'block'});
    }
    
    if (urlParams.has('hl')) {
	// TODO: use clolor index for multiple selections (s. markTextStrRecursive)
	$('span:contains(' + urlParams.get('hl') + ')').toggleClass('highlight',true);
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
    $('*.htag,*.htag-todo,*.htag-done,*.htag-test,*.htag-bug,*.htag-req,*.htag-target').on('click change', function (event) {
	var strElement = 't';
	var strPattern;
	var strValue;

	if (event.target instanceof HTMLInputElement) {
	    strValue = event.target.value;
	} else {
	    var strClass = event.target.getAttribute("class");

	    if (strClass.match(/^htag-.+/)) { // map combined class name to usable tag
	        strValue = strClass.replace(/^htag-/, '#');
	    } else {
	        strValue = event.target.innerText;
	    }
	}
	
	var urlParamsTag = new URLSearchParams(document.location.search);
	
	if (urlParamsTag.has('pattern')) {
	    strPattern = urlParamsTag.get('pattern');
	} else { // no previous pattern
	    strPattern = '';
	}
	putsConsole('Old pattern: ' + strPattern);
	
	if (strValue == undefined || strValue == '') {
	    putsConsole('Empty');
	} else if (strPattern == strValue) {
	    putsConsole('No update (same value)');
	} else { // something selected
	    var strPatternNew;
	    var strUrlNew;

	    putsConsole('New pattern: ' + strValue);
	    strPatternNew = strElement + "[contains(text(),'" + strValue + "')]";

	    if (event.ctrlKey) {
	        putsConsole(strValue + '<CRTL>' + ' logical OR');
		if (strPattern == '') {
		    // no combination
		} else {
		    strPatternNew = '(' + strPattern + ' or ' + strPatternNew + ')';
		}
	    } else if (event.altKey) {
	        putsConsole(strValue + '<ALT>' + ' logical AND');
		if (strPattern == '') {
		    // no combination
		} else {
		    strPatternNew = '(' + strPattern + ' and ' + strPatternNew + ')';
		}
	    } else if (event.shiftKey) {
	        putsConsole(strValue + '<SHIFT>' + ' logical AND NOT');
		if (strPattern == '') {
		    strPatternNew = 'not(' + strPatternNew + ')'; // BUG: 
		} else {
		    strPatternNew = '(' + strPattern + ' and not(' + strPatternNew + '))';
		}
	    }

	    urlParamsTag.set('pattern',strPatternNew);
	    urlParamsTag.set('hl',strValue);

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
		node.style.backgroundColor = this.arrColorMarker[this.intColorIndex];
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
document.upElement = function (strXpath, fNew) {
    
    var urlParams = new URLSearchParams(document.location.search);

    // window.location.hash = '';
    putsConsole( "Old URL: " + window.document.URL);
	
    if (urlParams.has('xpath')) {
	urlParams.set('xpath',urlParams.get('xpath').replace(/\/\*\[[^\]*]\]$/i,''));
    } else {
	urlParams.set('xpath',strXpath.replace(/\/\*\[[^\]*]\]$/i,''));
    }
    urlParams.delete('hl');

    var strQuery = urlParams.toString();
    if (strQuery == '') {
	strUrlNew = window.location.pathname;
    } else {
	strUrlNew = window.location.pathname + '?' + strQuery;
    }

    putsConsole('New URL: ' + strUrlNew);
    window.location.assign(strUrlNew);
}


//
// 
//
document.topElement = function (strXpath, fNew) {

    var urlParams = new URLSearchParams(window.location.search);
    
    if (strXpath == undefined || strXpath == '') {
	urlParams.delete('xpath');
    } else {
	urlParams.set('xpath',strXpath);
    }

    urlParams.delete('hl');
 
    var strUrlNew = window.location.pathname + '?' + urlParams.toString();

    putsConsole('New Top: ' + strUrlNew);

    if (fNew) {
	window.open(strUrlNew);
    } else {
	window.location.assign(strUrlNew);
    }
}


//
// reload document with parent anchor
//
document.topElementNew = function (strLocator, strXpath) {
    
    if (strLocator != undefined) {
	var urlParams = new URLSearchParams();
	
	urlParams.set('cxp','PiejQDefault');
	
	if (strXpath != undefined) {
	    urlParams.set('xpath',strXpath);
	}

	window.location.assign('?' + urlParams.toString());
    }
    
    // TODO: highlight according div element
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


//
// reload document with parent anchor
//
document.viewElement = function (strLocator, strXpath) {

    var urlParams = new URLSearchParams(window.location.search);
    
    if (strLocator == undefined || strLocator == '') {
	urlParams.delete('path');
    } else {
	urlParams.set('path',strLocator);
    }

    if (strXpath == undefined || strXpath == '') {
	urlParams.delete('xpath');
    } else {
	urlParams.set('xpath',strXpath);
    }

    urlParams.set('cxp','PiejQDefault');
    urlParams.set('hl',mapXpathToLabel(strXpath));
 
    var strUrlNew = window.location.pathname + '?' + urlParams.toString();

    putsConsole('New URL: ' + strUrlNew);

    window.location.hash = mapXpathToLabel(strXpath.replace(/\/[^\/]+$/,''));

    window.location.assign(strUrlNew);

    // TODO: highlight according div element
}


document.addEventListener("DOMContentLoaded", document.createUI, false);
