
//
//
//
function requestContent(objEditor,strQuery) {

    // TODO: update to URLSearchParams()
    
    var arrQuery = splitToArray(RFC1738Decode(strQuery));
    var requestMeta;
    var strHTML = '<a onclick="' + 'insertDate(editor)' + '" title="Insert picked date.">'
     				    + '<img src="/pie/icons/x-office-calendar.png" title="Insert picked date"/>'
     				    + '</a> ';

    var strUTF = '✔ ✘ „“ ‚‘ “” () [] {} ‒ ← ↑ → ↓ ↔ ↕ ↖ ↗ ↘ ↙ ⇐ ⇑ ⇒ ⇓ ⇔ ⇕ ⇖ ⇗ ⇘ ⇙ ⇚ ⇛'; // UTF-8 characters to show,

    var arrUTF = strUTF.split(/ +/);
    for (var i=0; i < arrUTF.length; i++) {
	strHTML += '<a onclick="'
	    + 'javascript:insertString(editor,\'' + arrUTF[i] + '\')' + '">' + arrUTF[i] + '</a> ';
    }

//    var arrSnippets = [{id:'task', code:'<task><h></h></task>', offset:-5},
//		       {id:'section', code:'<section><h></h></section>', offset:-5}];
    
    objEditor.setValue("Loading " + arrQuery['path'] + (arrQuery['xpath'] != undefined ? arrQuery['xpath'] : ''));
    objEditor.setReadOnly(true);

    requestMeta = $.getJSON(strQuery.replace(/&(amp;)*cxp=PiejQEditor/i,'&cxp=MetaJson'));

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
	    flagXPath = arrQuery['xpath'] != undefined;
	    if (flagXPath) {
		requestContent = $.ajax({
		    url: '/cxproc/exe',
		    type: 'GET',
		    data: {path: arrQuery['path'],
			   xpath: arrQuery['xpath'],
			   encoding: arrQuery['encoding'],
			   r: Math.random()},
		    dataType: 'text'
		});
	    } else {
		requestContent = $.ajax({
		    url: '/cxproc/exe',
		    type: 'GET',
		    data: {path: arrQuery['path'],
			   encoding: arrQuery['encoding'],
			   r: Math.random()},
		    dataType: 'text'
		});
	    }
	} else {
	    requestContent = $.ajax({
		url: '/' + arrQuery['path'],
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
		$('#strContent').before(' <b>' + '!!! File ' + arrQuery['path'] + ' is READONLY !!!' + '</b>');
		return;
	    } else if (flagXPath) {
		strEvent = 'javascript:saveXpath(editor,\'' + arrQuery['path'] + '\',\'' + arrQuery['xpath'] + '\')';
	    } else if (flagXML) {
		strEvent = 'javascript:saveXpath(editor,\'' + arrQuery['path'] + '\')';
	    } else {
		strEvent = 'javascript:saveText(editor,\'' + arrQuery['path'] + '\')';
	    }
	    objEditor.setReadOnly(false);

	    $('#strContent').before('<a onclick="' + strEvent + '" title="Save the editor content.">'
     				    + '<img src="/pie/icons/document-save.png" title="Save"/>'
     				    + '</a>');

	    $('#strContent').before(' <b>' + arrQuery['path'] + (arrQuery['xpath'] == undefined ? '' : arrQuery['xpath']) + '</b>');

	    // indicator for content changes (TODO: change to a variable with change event?)
	    $('#strContent').before(' <a id="flagChange">|</a>');
	    objEditor.on("change", function(e) {
		$('#flagChange').append("*");
	    });

	    // if (flagXML) {
	    // 	strHTML += '<br> ';
	    // 	arrSnippets.forEach(function(obj) {
	    // 	    strHTML += '<a onclick="'
	    // 		+ 'javascript:insertString(editor,\'' + obj.code + '\')' + '">' + obj.id + '</a> ';
	    // 	});
	    // }
	    
	    $('#strContent').after('<p style="font-size:150%">' + strHTML + '<a target="_blank" href="http://de.wikipedia.org/wiki/Portal:Unicode">W</a></p>');

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
function splitToArray(strArg) {

    var arrResult = [];
    var arrURL = strArg.replace(/^.*\?/, '').split(/&(amp;)*/);

    if (arrURL == undefined) {
        putsConsole("URL error" + strArg);
    } else {
        for (var i = 0; i < arrURL.length; i++) {
            if (arrURL[i] == undefined || arrURL[i] == '') {
                putsConsole("URL error" + i);
            } else if (arrURL[i].match(/^.+=.+$/)) {
                var arrValue = arrURL[i].split(/=/);
                arrResult[arrValue[0]] = arrValue[1];
                putsConsole(arrValue[0] + ': ' + arrResult[arrValue[0]]);
            } else {
                putsConsole("URL error" + i);
            }
        }
    }
    return arrResult;
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
	putsConsole( "Save content to " + strPath);
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

    var request;

    putsConsole( "Save content to " + strPath);

    if (strPath == undefined || strPath == '' || strPath == '/') {
	putsConsole( "No path value '" + strPath + "'");
	objEditor.focus();
	return;
    } else if (objEditor.getValue() == '') {
	putsConsole( "Delete content at " + strPath);
    } else {
	putsConsole( "Save content to " + strPath);
    }

    request = $.ajax({
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

    var arrLocator = RFC1738Decode(options.$trigger.attr("name")).split(/:/);
    //putsConsole( "trigger.attr: " + options.$trigger.attr("name"));

    var strXpath;
    if (arrLocator[2] == undefined || arrLocator[2] == '') {
	putsConsole( "No valid XPath found: " + options.$trigger.attr("name"));
	//return;
    } else {
	strXpath = arrLocator[2];
    }

    var strFile = document.strFile;
    if (arrLocator[0] == undefined || arrLocator[0] == '') {
	putsConsole( "No valid file locator found: " + options.$trigger.attr("name"));
    } else {
	strFile = arrLocator[0];
    }

    var m = "clicked: " + key;
    putsConsole(m); 

    if (key == 'view') {
	window.document.viewElement(strFile,strXpath);
    } else if (key == 'frame') {
	//window.open(window.location);
	window.document.topElement(arrLocator[2],true);
    } else if (key == 'hide') {
	options.$trigger.parent().parent().parent().css({'display': 'none'});
    } else if (key == 'top') {
	window.document.topElement(arrLocator[2],false);
    } else if (key == 'up') {
	putsConsole( "Old URL: " + window.document.URL);
	if (window.document.URL.match(/xpath=/i)) {
	    var strURLNew = window.document.URL.replace(/#.*$/i,'').replace(/&xpath=[^&]*/i,'');
	    putsConsole( "Pre URL: " + strXpath);
	    strURLNew += '&xpath=' + strXpath.replace(/\/\*\[[^\]*]\]$/i,'');
	    putsConsole( "New URL: " + strURLNew);
	    window.location.assign(strURLNew);
	}
    } else {
    }
}



//
// 
//
function callbackTask(key, options) {

    var arrLocator = RFC1738Decode(options.$trigger.attr("name")).split(/:/);
    //putsConsole( "trigger.attr: " + options.$trigger.attr("name"));

    var strXpath;
    if (arrLocator[2] == undefined || arrLocator[2] == '') {
	putsConsole( "No valid XPath found: " + options.$trigger.attr("name"));
	//return;
    } else {
	strXpath = arrLocator[2];
    }

    var strFile = document.strFile;
    if (arrLocator[0] == undefined || arrLocator[0] == '') {
	putsConsole( "No valid file locator found: " + options.$trigger.attr("name"));
    } else {
	strFile = arrLocator[0];
    }
    
    var m = "clicked: " + key;
    putsConsole(m); 
    
    if (key == 'view') {
	window.document.viewElement(strFile,strXpath);
    } else if (key == 'edit') {
	var strURL = window.location.protocol + '//' + window.location.host + '/cxproc/exe?'
	    + 'path=' + strFile + '&cxp=PiejQEditor' + '&xpath=' + strXpath + '&encoding=utf-8';
	putsConsole( "New URL: " + strURL);
	window.location.assign(strURL);
    } else if (key == 'hide') {
	var classParentSelected = $('.context-menu-active').parent().attr('class').replace(/ *context-menu-active/,'');

	putsConsole('Hide all elements of class: ' + classParentSelected);
	$('.' + classParentSelected).hide();
    } else if (key == 'undone') {
	putsConsole("Delete done"); 
	window.document.setElementAttribute(strFile,strXpath,'done');
    } else if (key == 'clone') {
	window.document.cloneElement(strFile,strXpath);
	window.location.assign(window.document.URL.replace(/#.*$/,''));
    } else if (key == 'date') {
	$('#content').datepicker( "dialog", new Date(), function(strDate) {
	    putsConsole("Date: " + strDate); 
	    window.document.dateElement(strFile,strXpath,strDate);
	}, { showWeek: true, showButtonPanel: false, dateFormat: "yymmdd"}); // [10,10] [event.pageX, event.pageY]
    } else if (key == 'done') {
	$('#content').datepicker( "dialog", new Date(), function(strDate) {
	    putsConsole("Done: " + strDate); 
	    window.document.doneElement(strFile,strXpath,strDate);
	}, { showWeek: true, showButtonPanel: false, dateFormat: "yymmdd"}); // [10,10] [event.pageX, event.pageY]
    } else if (key == 'impact') {
	putsConsole("Increase Impact"); 
	window.document.setElementAttribute(strFile,strXpath,key,'1');
    } else if (key == 'hide') {
	options.$trigger.parent().parent().css({'display': 'none'});
    } else if (key == 'top') {
	window.document.topElement(arrLocator[2],false);
    } else if (key == 'up') {
	putsConsole( "Old URL: " + window.document.URL);
	if (window.document.URL.match(/xpath=/i)) {
	    var strURLNew = window.document.URL.replace(/#.*$/i,'').replace(/&xpath=[^&]*/i,'');
	    putsConsole( "Pre URL: " + strXpath);
	    strURLNew += '&xpath=' + strXpath.replace(/\/\*\[[^\]*]\]$/i,'');
	    putsConsole( "New URL: " + strURLNew);
	    window.location.assign(strURLNew);
	}
    } else if (key == 'delete') {
	window.document.removeElement(strFile,strXpath);
	//window.location.assign(window.document.URL.replace(/#.*$/,''));
    } else {
    }
}


//
// 
//
function callbackContent(key, options) {
	
    var strLocator = window.document.URL.toString().replace(/#.*$/,''); // remove current anchor reference
    
    if (key == 'reload') {
	var scroll = $(window).scrollTop();
	if (strLocator.match(/\?/)) {
	    // CGI URL
	    window.location.assign(strLocator.replace(/\&+pos=[0-9]+/,'').replace(/#.*$/,'').concat('&pos=' + scroll));
	} else {
	    // direct file URL
	    window.location.assign(strLocator.replace(/\&+pos=[0-9]+/,'').concat('?pos=' + scroll));
	}
	//window.location.reload(true);
    } else if (key == 'frame') {
	window.open(window.location);
    } else if (key == 'additor') {
	window.location.assign(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQAdditor').replace(/\&hl=[0-9_]+/i,''));
    } else if (key == 'editor') {
	window.location.assign(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQEditor'));
    } else if (key == 'cleanup') {
	pieCleanup();
    } else if (key == 'toc') {
	$('#toc').css({'display': 'block'});
	$(window).scrollTop(0);
    } else if (key == 'tags') {
	$('#tags').css({'display': 'block'});
	$(window).scrollTop(0);
    } else if (key == 'link') {
	$('#links').css({'display': 'block'});
    } else if (key == 'layout') {
	window.location.assign(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQDefault').replace(/\&(tag|xpath|pattern)=[^\&]*/g, ''));
    } else if (key == 'calendar') {
	window.location.assign(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQCalendar').concat('#yesterday'));
    } else if (key == 'calendar_month') {
	window.location.assign(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQCalendar').concat('&context=month'));
    } else if (key == 'todo') {
	window.location.assign(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQTodo'));
    } else if (key == 'ganttcalendar') {
	window.location.assign(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQGanttCalendar'));
    } else if (key == 'todocalendar') {
	window.location.assign(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQTodoCalendar').concat('#yesterday'));
    } else if (key == 'todomatrix') {
	window.location.assign(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQTodoMatrix'));
    } else if (key == 'todocontact') {
	window.location.assign(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQTodoContact'));
    } else if (key == 'treemap') {
	window.open(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQTodoTreemap'));
    } else if (key == 'presentation') {
	window.open(strLocator.replace(/PiejQ[a-z]+/i,'PresentationIndex'));
    } else if (key == 'mindmap') {
	//window.location.assign(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQMindmap'));
	alert('TODO: mindmap in Browser (DDD?)')
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
	window.location.assign(strLocator.replace(/#.*$/,'').replace(/(jQ|Ui)[a-z]+/i,'jQFormat'));
    }
}
		    
// 
$(function(){

    if (window.document.URL.match(/\.(pie|mm|cxp|cal|txt|docx|xmmap|mmap)/i)) {

	if (window.document.URL.match(/calendar/i)) {

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
		    "frame": {name: "Window", icon: ""},
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
		    // TODO: "tag":  {name: "Tag this", icon: ""},
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
		"view": {name: "View", icon: "view"},
		"up": {name: "Up", icon: "hide"},
		"top": {name: "Top", icon: "hide"},
		"frame": {name: "Scope", icon: ""},
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
		"toc": {name: "Table of Content", icon: "toc"},
		"tags": {name: "Tag cloud", icon: "tags"},
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
		"sep2": "---------",
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
	    }
	});
	
    }

});
