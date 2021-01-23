
//
//
//
function getToolsStr(strNameEditor) {

    var strResult = '<p style="font-size:150%">';

    strResult += '<a onclick="' + 'insertDate(' + strNameEditor + ')' + '" title="Insert picked date.">'
     	+ '<img src="/pie/icons/x-office-calendar.png" title="Insert picked date"/>'
     	+ '</a> ';

    var strUTF = '✔ ✘ „“ ‚‘ “” () [] {} ‒ ← ↑ → ↓ ↔ ↕ ↖ ↗ ↘ ↙ ⇐ ⇑ ⇒ ⇓ ⇔ ⇕ ⇖ ⇗ ⇘ ⇙ ⇚ ⇛'; // UTF-8 characters to show,

    var arrUTF = strUTF.split(/ +/);

    for (var i=0; i < arrUTF.length; i++) {
	strResult += '<a onclick="'
	    + 'javascript:insertString(editor,\'' + arrUTF[i] + '\')' + '">' + arrUTF[i] + '</a> ';
    }

    strResult += '<a target="_blank" href="http://de.wikipedia.org/wiki/Portal:Unicode">W</a>';

    strResult += '</p>';

    return strResult;
}


//
//
//
function addShortcuts(objEditor,strPath) {

    objEditor.commands.addCommand({
	name: 'mySaveCommand',
	bindKey: {win: 'Ctrl-S',  mac: 'Command-S'},
	exec: function(objEditor) {
	    saveText(objEditor,strPath);
	},
	readOnly: false // false if this command should not apply in readOnly mode
    });

    // https://ace.c9.io/demo/keyboard_shortcuts.html
    objEditor.commands.addCommand({
	name: "showKeyboardShortcuts",
	bindKey: {win: "Ctrl-Alt-h", mac: "Command-Alt-h"},
	exec: function(objEditor) {
            ace.config.loadModule("ace/ext/keybinding_menu", function(module) {
		module.init(objEditor);
		objEditor.showKeyboardShortcuts()
            })
	}
    });

}


//
//
//
function requestContent(objEditor,strQuery) {

    // TODO: update to URLSearchParams()
    
    var urlParams = new URLSearchParams(document.location.search);

    objEditor.setValue("Loading " + urlParams.get('path') + (urlParams.has('xpath') ? urlParams.get('xpath') : ''));
    objEditor.setReadOnly(true);

    var urlParamsMeta = urlParams;
    //urlParamsMeta.delete('cxp');
    urlParamsMeta.set('cxp','MetaJson');
    //putsConsole( "Meta URL: " + urlParamsMeta.toString());
    
    var requestMeta = $.getJSON('?' + urlParamsMeta.toString());

    requestMeta.done( function(objInfo) {
	var requestContent;
	var flagXML = false;
	var flagXPath = false;

	putsConsole('Info loaded');

	if (objInfo.mime == undefined || objInfo.mime == '') {
	    objEditor.setValue('No format information got!');
	    return;
	} else if (objInfo.mime.match(/^application\/(cxp\+xml|pie\+xml|mm\+xml)$/i)) {
	    putsConsole('XML Format "' + objInfo.mime + ' OK');
	    flagXML = true;
	} else if (objInfo.mime.match(/^text\//i)) {
	    putsConsole('Text Format "' + objInfo.mime + ' OK');
	} else {
	    objEditor.setValue('No editable format recognized: "' + objInfo.mime + '"');
	    return;
	}

	if (flagXML) {
	    // TODO: disable content caching
	    if (urlParams.has('xpath')) {
		requestContent = $.ajax({
		    url: '/cxproc/exe',
		    type: 'GET',
		    data: {path: urlParams.get('path'),
			   xpath: urlParams.get('xpath'),
			   encoding: urlParams.get('encoding'),
			   r: Math.random()},
		    dataType: 'text'
		});
	    } else {
		requestContent = $.ajax({
		    url: '/cxproc/exe',
		    type: 'GET',
		    data: {path: urlParams.get('path'),
			   encoding: urlParams.get('encoding'),
			   r: Math.random()},
		    dataType: 'text'
		});
	    }
	} else {
	    requestContent = $.ajax({
		url: '/' + urlParams.get('path'),
		type: 'GET',
		data: {r: Math.random()},
		dataType: 'text'
	    });
	}

	//
	requestContent.done(function( strContent ) {
	    var strEvent;

	    putsConsole( "Data Loaded");
	    if (flagXML) {
	        // remove XML declaration for editor
	        //objEditor.setValue(strContent.replace(/^<\?xml [^>]+>[\n\r]*/i, ''));
	        objEditor.setValue(strContent);
	        objEditor.getSession().setMode("ace/mode/xml");
	    } else {
	        objEditor.setValue(strContent);
	        if (objInfo.mime.match(/text\/markdown/i)) {
	            putsConsole('Text Format "' + objInfo.mime + ' OK');
	            objEditor.getSession().setMode("ace/mode/markdown");
	        }
	    }
	    objEditor.scrollToLine(0, false, false);
	    objEditor.clearSelection();
	    objEditor.focus();

	    if (objInfo.write == undefined || objInfo.write == false) {
		$('#strContent').before(' <b>' + '!!! File ' + urlParams.get('path') + ' is READONLY !!!' + '</b>');
		return;
	    } else if (flagXML) {
		strEvent = 'javascript:saveXpath(editor,\'' + urlParams.get('path') + '\')';
	    } else {
		strEvent = 'javascript:saveText(editor,\'' + urlParams.get('path') + '\')';
	    }
	    objEditor.setReadOnly(false);

	    $('#strContent').before('<a onclick="' + strEvent + '" title="Save the editor content.">'
     				    + '<img src="/pie/icons/document-save.png" title="Save"/>'
     				    + '</a>');

	    $('#strContent').before(' <b>' + urlParams.get('path') + (urlParams.has('xpath') ? urlParams.get('xpath') : '') + '</b>');

	    // indicator for content changes (TODO: change to a variable with change event?)
	    $('#strContent').before(' <a id="flagChange">|</a>');
	    objEditor.on("change", function(e) {
		$('#flagChange').append("*");
	    });

	});

	requestContent.fail(function( jqXHR, textStatus ) {
	    objEditor.setValue( 'Request failed: ' + textStatus );
	    // TODO: save editor content in cache?
	});
    });

    requestMeta.fail(function( jqXHR, textStatus ) {
	objEditor.setValue( 'Request meta failed: ' + textStatus );
    });

}


//
// 
//
function pieCleanup() {

    putsConsole("Cleanup DOM: " + window.document.URL);

    $('*[class="context-menu-list context-menu-root"]').remove();
    $('span.htag:contains(@)').remove(); // anonymizing content
    $('head > link, script, #toc, #tags, #links, #context-menu-layer').remove();
    //$('*').removeAttr("style");
    $('*').removeAttr("class").removeAttr("id").removeAttr("name");
    // TODO: remove jQuery handling at all (RMB etc) $('*').unbind(); ???

    //var blobDOM = new Blob([document.documentElement.outerHTML], {type: 'text/html'});
    //var URL = window.URL.createObjectURL(blobDOM);

    //$('a#someID').attr({target: '_blank', href  : URL});
    //putsConsole("Blob: " + URL); 
    //window.open(URL);
    // chrome://blob-internals
}

//
//
//
function insertString(objEditor,strArg) {
    putsConsole("String: " + strArg); 
    objEditor.insert(' ' + strArg + ' ');
    objEditor.focus();
}


//
//
//
function insertDate(objEditor) {
    $('#content').datepicker( "dialog", new Date(), function(strDate) {
	putsConsole("Date: " + strDate); 
	objEditor.insert(strDate);
	objEditor.focus();
    }, { showWeek: true, showButtonPanel: false, dateFormat: "yymmdd"});
}


//
// 
//
function saveXpath(objEditor,strPath,strXpath) {

    var request;

    if (objEditor.getValue() == '') {
	putsConsole( "Delete content at " + strPath);
    } else if ( ! validateXML(objEditor.getValue())) {
	$('#flagChange').append("X");
	objEditor.focus();
	return;
    } else {
	putsConsole( "Save content to '" + strPath + "'");
    }

    if (strXpath == undefined || strXpath == '' || strXpath == '/') {
	request = $.ajax({
	    url: '/cxproc/exe',
	    type: 'POST',
	    data: {path: strPath, cxp: 'SaveContentXml', strContent: objEditor.getValue()}
	});
    } else {
	var elementTemplate = '<xsl:template match="' + strXpath + '">' +
	    objEditor.getValue() +
	    '</xsl:template>';

	var elementTemplateDefault = '<xsl:template match="@*|*">' +
	    '<xsl:copy>' +
	    '<xsl:apply-templates select="@*|node()"/> ' +
	    '</xsl:copy>' +
	    '</xsl:template>';

	var strResult = '<?xml version="1.0" encoding="UTF-8"?>' + 
	    '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
	    '<xsl:output method="xml" encoding="UTF-8"/>' +
	    elementTemplate +
	    elementTemplateDefault +
	    '</xsl:stylesheet>';

	//putsConsole(strResult);

	request = $.ajax({
	    url: '/cxproc/exe',
	    type: 'POST',
	    data: {path: strPath, cxp: 'ApplyXsl', strContent: strResult}
	});
    }

    request.done(function( msg ) {
	if (msg == undefined || msg != 'OK') {
    	    alert( 'Request failed: ' + msg);
	} else {
            putsConsole( "Data saved: " + msg);
	    $('#flagChange').append("|");
	}
	objEditor.focus();
    });

    request.fail(function( jqXHR, textStatus ) {
    	alert( 'Request failed: ' + textStatus );
	$('#flagChange').append("\\");
	objEditor.focus();
    });

}

//
// 
//
function saveText(objEditor,strPath) {

    if (strPath == undefined || strPath == '' || strPath == '/') {
	putsConsole( "No path value '" + strPath + "'");
	objEditor.focus();
	return;
    } else if (objEditor.getValue() == '') {
	putsConsole( "Delete content at " + strPath);
    } else {
	putsConsole( "Save content to '" + strPath + "'");
    }

    var request = $.ajax({
	url: '/cxproc/exe',
	type: 'POST',
	data: {path: strPath, cxp: 'SaveContentXml', strContent: objEditor.getValue()}
    });

    request.done(function( msg ) {
	if (msg == undefined || msg != 'OK') {
    	    alert( 'Request failed: ' + msg);
	} else {
            putsConsole( "Data saved: " + msg);
	    $('#flagChange').append("|");
	}
	objEditor.focus();
    });

    request.fail(function( jqXHR, textStatus ) {
    	alert( 'Request failed: ' + textStatus);
	$('#flagChange').append("\\");
	objEditor.focus();
    });
}

//
// s. http://stackoverflow.com/questions/22581345/click-button-copy-to-clipboard-using-jquery
// https://www.lucidchart.com/techblog/2014/12/02/definitive-guide-copying-pasting-javascript/
//
function callbackLink(key, options) {
    
    //alert( 'Request: ' + key);

    var strURL = options.$trigger.attr("href");
    putsConsole( "Selected URL: " + strURL);

    if (key == 'view') {
	window.location.assign(strURL);
    } else if (key == 'open') {
	window.open(strURL);
    } else {
	// http://stackoverflow.com/questions/400212/how-do-i-copy-to-the-clipboard-in-javascript/30810322#30810322

	putsConsole(options.$trigger.text());
	options.$selected.select();
	var succeed;
	try {
    	    succeed = document.execCommand("copy");
	    // BUG: 
	    if (succeed) {
		putsConsole( "Copy succeeded");
	    }
	} catch(e) {
	    putsConsole( "Copy failed");
	}
    }
}

//
// 
//
function callbackSection(key, options) {

    var urlParams = new URLSearchParams(document.location.search);
	
    var arrLocator = RFC1738Decode(options.$trigger.attr("name")).split(/:/);
    //putsConsole( "trigger.attr: " + options.$trigger.attr("name"));

    var m = "clicked: " + key;
    putsConsole(m); 

    urlParams.delete('hl');
    if (key == 'view') {
	urlParams.delete('pattern');
	urlParams.set('cxp','PiejQDefault');
	window.location.assign('?' + urlParams.toString());
    } else if (key == 'frame') { // scope

	if (arrLocator[0] == undefined || arrLocator[0] == '') {
	    putsConsole( "No valid file locator found: " + options.$trigger.attr("name"));
	} else {
	    urlParams.set('path',arrLocator[0]);
	}

	if (arrLocator[1] == undefined || arrLocator[1] == '') {
	    if (arrLocator[2] == undefined || arrLocator[2] == '') {
		putsConsole( "No valid global XPath found: " + options.$trigger.attr("name"));
	    } else {
		urlParams.set('xpath',arrLocator[2]);
	    }
	} else {
	    urlParams.set('xpath',arrLocator[1]); // BUG: file internal XPath
	}

	urlParams.delete('pattern');
	urlParams.set('cxp','PiejQDefault');
	window.open('?' + urlParams.toString());
    } else if (key == 'hide') {
	options.$trigger.parent().parent().parent().css({'display': 'none'});
    } else if (key == 'top') {
	
	if (arrLocator[2] == undefined || arrLocator[2] == '') {
	    putsConsole( "No valid global XPath found: " + options.$trigger.attr("name"));
	} else {
	    urlParams.set('xpath',arrLocator[2]);
	}
	window.location.assign('?' + urlParams.toString());
	
    } else if (key == 'up') {
	urlParams.set('xpath',urlParams.get('xpath').replace(/\/[^\/]+$/,''));
	window.location.assign('?' + urlParams.toString());
    }
}


//
// 
//
function callbackTask(key, options) {

    var urlParams = new URLSearchParams(document.location.search);
    
    urlParams.delete('hl');
    if (key == 'view') {
	urlParams.delete('pattern');
	urlParams.set('cxp','PiejQDefault');
	urlParams.set('xpath',urlParams.get('xpath').replace(/\/[^\/]+$/,'')); // BUG: file internal XPath
	window.location.assign('?' + urlParams.toString());
    } else if (key == 'frame') {
	urlParams.delete('pattern');
	window.open('?' + urlParams.toString());
    } else if (key == 'hide') {
	var classParentSelected = $('.context-menu-active').parent().attr('class').replace(/ *context-menu-active/,'');

	putsConsole('Hide all elements of class: ' + classParentSelected);
	$('.' + classParentSelected).hide();
    } else {

	var arrLocator = RFC1738Decode(options.$trigger.attr("name")).split(/:/);
	//putsConsole( "trigger.attr: " + options.$trigger.attr("name"));

	if (arrLocator[0] == undefined || arrLocator[0] == '') {
	    putsConsole( "No valid file locator found: " + options.$trigger.attr("name"));
	} else {
	    urlParams.set('path',arrLocator[0]);
	}

	if (arrLocator[1] == undefined || arrLocator[1] == '') {
	    putsConsole( "No valid XPath found: " + options.$trigger.attr("name"));
	} else {
	    urlParams.set('xpath',arrLocator[1]); // BUG: file internal XPath
	}

	if (key == 'top') {
	} else if (key == 'up') {
	    urlParams.set('xpath',urlParams.get('xpath').replace(/\/[^\/]+$/,''));
	}
	window.location.assign('?' + urlParams.toString());
    }
}


//
// 
//
function callbackContent(key, options) {
    
    if (key == 'frame') {
	window.open(window.location);
    } else if (key == 'cleanup') {
	pieCleanup();
    } else if (key == 'toc') {
	if ($('#toc').css('display') == 'block') {
	    $('#toc').css({'display': 'none'});
	} else {
	    $('#toc').css({'display': 'block'});
	}
	$(window).scrollTop(0);
    } else if (key == 'tags') {
	//putsConsole( "CSS: " + $('#tags').css('display'));
	if ($('#tags').css('display') == 'block') {
	    $('#tags').css({'display': 'none'});
	} else {
	    $('#tags').css({'display': 'block'});
	    $(window).scrollTop(0);
	}
    } else if (key == 'link') {
	$('#links').css({'display': 'block'});
    } else if (key == 'contextYear') {
	switchContext('year');
    } else if (key == 'contextMonth') {
	switchContext('month');
    } else if (key == 'contextWeek') {
	switchContext('week');
    } else if (key == 'context') {
	switchContext();
    } else if (key == 'contextNext') {
	goNext();
    } else if (key == 'contextPrev') {
	goPrev();
    } else {
	var urlParams = new URLSearchParams(document.location.search);
	var strHashNew = '';

	urlParams.delete('hl');
	
	if (urlParams.has('path')) {
	    urlParams.set('path',urlParams.get('path').replace(/([\\]|%5C)/g,'/'));
	}

	if (key == 'reload') {
	} else if (key == 'layout') {
	    urlParams.delete('tag');
	    urlParams.delete('xpath');
	    urlParams.delete('pattern');
	    urlParams.set('cxp','PiejQDefault');
	} else if (key == 'editor') {
	    urlParams.delete('tag');
	    urlParams.delete('xpath');
	    urlParams.delete('pattern');
	    urlParams.set('cxp','PiejQEditor');
	} else {

	    if (key == 'calendar') {
		urlParams.set('cxp','PiejQCalendar');
		strHashNew = '#yesterday';
	    } else if (key == 'calendar_month') {
		//window.location.assign(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQCalendar').concat('&context=month'));
	    } else if (key == 'selection') {
		selection = window.getSelection();
		strSelect = selection.toString();
		urlParams.set('pattern',"descendant::*[contains(child::text(),'" + strSelect + "')]");
		urlParams.set('hl',strSelect);
	    } else if (key == 'search') {
		selection = window.getSelection();
		strSelect = selection.toString();
		urlParams.set('cxp','PiejQDirSearchResult');
		urlParams.set('needle', strSelect);
		urlParams.set('path', '');
	    } else if (key == 'todo') {
		urlParams.set('cxp','PiejQTodo');
	    } else if (key == 'todocalendar') {
		urlParams.set('cxp','PiejQTodoCalendar');
	    } else if (key == 'todomatrix') {
		urlParams.set('cxp','PiejQTodoMatrix');
	    } else if (key == 'todocontact') {
		urlParams.set('cxp','PiejQTodoContact');
	    } else if (key == 'treemap') {
		urlParams.set('cxp','PiejQTodoTreemap');
	    } else if (key == 'presentation') {
		urlParams.set('cxp','PresentationIndex');
	    } else {
		urlParams.set('cxp','PiejQFormat');
	    }
	    //urlParams.delete('hl');
	}
	
	var strQuery = '?' + urlParams.toString();

	putsConsole('New URL: ' + strQuery + strHashNew);
	window.location.assign(strQuery + strHashNew);
    }
}
		    
// 
$(function(){

    var urlParams = new URLSearchParams(document.location.search);

    if (urlParams.get('path').match(/\.(pie|mm|md|cxp|cal|txt|csv)$/i)) {

	if (urlParams.get('cxp').match(/calendar/i)) {

	    $.contextMenu({
		selector: '#content', 
		trigger: 'right',
		position: function(opt, x, y) {opt.$menu.css({top: y, left: x});},
		autoHide: true,
		callback: callbackContent,
		items: {
		    "document": {name: "Document", icon: "document"},
		    "sep1": "---------",
		    "reload": {name: "Reload", icon: "reload"},
		    "editor": {name: "Editor", icon: "edit"},
		    "sep2": "---------",
		    "contextYear": {name: "Context Year", icon: "link"},
		    "contextMonth": {name: "Context Month", icon: "link"},
		    "contextWeek": {name: "Context Week", icon: "link"},
		    "sep3": "---------",
		    "contextNext": {name: "Next", icon: "link"},
		    "contextPrev": {name: "Prev", icon: "link"},
		    "sep4": "---------",
		    "toc": {name: "Table of Content", icon: "toc"},
		    "tags": {name: "Tag cloud", icon: "tags"},
		    "link": {name: "Link list", icon: "link"},
		    "sep5": "---------",
		    "layout": {name: "Layout", icon: ""},
		    "calendar": {name: "Calendar", icon: ""},
		    "todo": {name: "Todo", icon: ""},
		    "todocalendar": {name: "TodoCalendar", icon: ""},
		    "todomatrix": {name: "TodoMatrix", icon: ""},
		    "treemap": {name: "Treemap", icon: ""},
		    "presentation": {name: "Presentation", icon: ""}
		}
	    });
	    
	} else {
	    $.contextMenu({
		selector: '#content', 
		trigger: 'right',
		position: function(opt, x, y) {opt.$menu.css({top: y, left: x});},
		autoHide: true,
		callback: callbackContent,
		items: {
		    "document": {name: "Document", icon: "document"},
		    "sep1": "---------",
		    "reload": {name: "Reload", icon: "reload"},
		    "editor": {name: "Editor", icon: "edit"},
		    "frame": {name: "Scope", icon: ""},
		    "cleanup": {name: "Cleanup", icon: ""},
		    //"sep2": "---------",
		    //"contextYear": {name: "Context Year", icon: "link"},
		    //"contextMonth": {name: "Context Month", icon: "link"},
		    //"sep3": "---------",
		    //"contextNext": {name: "Next", icon: "link"},
		    //"contextPrev": {name: "Prev", icon: "link"},
		    "sep4": "---------",
		    "toc": {name: "Table of Content", icon: "toc"},
		    "tags": {name: "Tag cloud", icon: "tags"},
		    "selection": {name: "Tag selection", icon: "tags"},
		    "search": {name: "Search selection", icon: "tags"},
		    "link": {name: "Link list", icon: "link"},
		    "sep5": "---------",
		    "layout": {name: "Layout", icon: ""},
		    "calendar": {name: "Calendar", icon: ""},
		    //"calendar_month": {name: "CalendarMonth", icon: ""},
		    "todo": {name: "Todo", icon: ""},
		    "todocalendar": {name: "TodoCalendar", icon: ""},
		    "todomatrix": {name: "TodoMatrix", icon: ""},
		    "treemap": {name: "Treemap", icon: ""},
		    "presentation": {name: "Presentation", icon: ""}
		}
	    });
	}

	$.contextMenu({
	    selector: '.context-menu-section', 
	    trigger: 'right',
	    position: function(opt, x, y) {opt.$menu.css({top: y, left: x});},
	    autoHide: true,
	    callback: callbackSection,
	    items: {
		"section": {name: "Section", icon: "section"},
		"sep1": "---------",
		//"view": {name: "View", icon: "view"},
		"frame": {name: "Scope", icon: ""},
		"up": {name: "Up", icon: "hide"},
		"top": {name: "Top", icon: "hide"},
		"hide": {name: "Hide", icon: "hide"}
	    }
	});

	$.contextMenu({
	    selector: '.context-menu-task', 
	    trigger: 'right',
	    position: function(opt, x, y) {opt.$menu.css({top: y, left: x});},
	    autoHide: true,
	    callback: callbackTask,
	    items: {
		"task": {name: "Task", icon: "task"},
		"sep1": "---------",
		"up": {name: "Up", icon: "hide"},
		"top": {name: "Top", icon: "hide"},
		"hide": {name: "Hide", icon: "hide"}
	    }
	});
	
    } else {

	// non-editable format
	
	$.contextMenu({
	    selector: '#content', 
	    trigger: 'right',
	    position: function(opt, x, y) {opt.$menu.css({top: y, left: x});},
	    autoHide: true,
	    callback: callbackContent,
	    items: {
		"document": {name: "Document", icon: "document"},
		//"sep1": "---------",
		"reload": {name: "Reload", icon: "reload"},
		//"editor": {name: "Editor", icon: "edit"},
		"cleanup": {name: "Cleanup", icon: ""},
		"sep2": "---------",
		"toc": {name: "Table of Content", icon: "toc"},
		"tags": {name: "Tag cloud", icon: "tags"},
		"selection": {name: "Tag selection", icon: "tags"},
		"search": {name: "Search selection", icon: "tags"},
		"link": {name: "Link list", icon: "link"},
		"sep3": "---------",
		"layout": {name: "Layout", icon: ""},
		"calendar": {name: "Calendar", icon: ""},
		"todo": {name: "Todo", icon: ""},
		"todocalendar": {name: "TodoCalendar", icon: ""},
		"todomatrix": {name: "TodoMatrix", icon: ""},
		"treemap": {name: "Treemap", icon: ""},
		// TODO: "mindmap": {name: "Mindmap", icon: ""},
		"presentation": {name: "Presentation", icon: ""}
	    }
	});

	$.contextMenu({
	    selector: '.context-menu-section', 
	    trigger: 'right',
	    position: function(opt, x, y) {opt.$menu.css({top: y, left: x});},
	    autoHide: true,
	    callback: callbackSection,
	    items: {
		"section": {name: "Section", icon: "section"},
		"sep1": "---------",
		//"view": {name: "View", icon: "view"},
		"frame": {name: "Scope", icon: ""},
		"up": {name: "Up", icon: "hide"},
		"top": {name: "Top", icon: "hide"},
		"hide": {name: "Hide", icon: "hide"}
	    }
	});

	$.contextMenu({
	    selector: '.context-menu-task', 
	    trigger: 'right',
	    position: function(opt, x, y) {opt.$menu.css({top: y, left: x});},
	    autoHide: true,
	    callback: callbackTask,
	    items: {
		"task": {name: "Task", icon: "task"},
		"sep1": "---------",
		//"up": {name: "Up", icon: "hide"},
		//"top": {name: "Top", icon: "hide"},
		"hide": {name: "Hide", icon: "hide"}
	    }
	});
	
    }

});
