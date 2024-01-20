
//
// 
//
function pieCleanup() {

    putsConsole("Cleanup DOM: " + window.document.URL);

    $('*[class="context-menu-list context-menu-root"]').off();
    //$('span.htag:contains(@)').remove(); // anonymizing content
    $('head > link, script, #toc, #tags, #links, #context-menu-layer, ul.context-menu-root').remove();
    //$('*').removeAttr("style");
    $('*').removeAttr("class").removeAttr("id").removeAttr("name");
    // TODO: remove jQuery handling at all (RMB etc) $('*').unbind(); ???

    // https://quantumwarp.com/kb/articles/59-javascript/664-removing-or-replacing-a-css-stylesheet-with-javascript-jquery
    //$('head').append('<link href="/mycustom.css" rel="stylesheet" id="newcss" />');
    //$('link[href="/pie/html/pie.css"]').remove();
    
    //var blobDOM = new Blob([document.documentElement.outerHTML], {type: 'text/html'});
    //var URL = window.URL.createObjectURL(blobDOM);

    //$('a#someID').attr({target: '_blank', href  : URL});
    //putsConsole("Blob: " + URL); 
    //window.open(URL);
    // chrome://blob-internals
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
    var strXPathBlock;
    var strXPathGlobal;
    var strLocator;
	
    var m = "clicked: " + key;
    putsConsole(m); 

    if (options.$trigger == undefined || options.$trigger.attr("name") == undefined) {
	putsConsole('Element not defined');
	return;
    }
    
    [strLocator,strXPathBlock,strXPathGlobal] = RFC1738Decode(options.$trigger.attr("name")).split(/:/);

    urlParams.delete('hl');
    if (key == 'view') {
	urlParams.delete('pattern');
	urlParams.set('cxp','PiejQDefault');
	window.location.assign('?' + urlParams.toString());
    } else if (key == 'selection') {
	selection = window.getSelection();
	strSelect = selection.toString().replace(/^\s+/,'').replace(/\s+$/,'');
	urlParams.set('pattern',"child::*[contains(child::text(),'" + strSelect + "')]");
	//urlParams.set('re',strSelect);
	urlParams.set('hl',strSelect);
	window.location.assign('?' + urlParams.toString());
    } else if (key == 'google') {
	selection = window.getSelection();
	strSelect = selection.toString().replace(/^\s+/,'+').replace(/\s+$/,'');
	if (confirm('open "https://www.google.de/search?q=' + strSelect + '"')) {
	    window.open('https://www.google.de/search?q=' + strSelect);
	}
    } else if (key == 'translate') {
	selection = window.getSelection();
	strSelect = selection.toString().replace(/^\s+/,'+').replace(/\s+$/,'');
	if (confirm('Translate "' + strSelect + '"?')) {
	    window.open('https://www.deepl.com/translator#de/en/' + strSelect);
	}
    } else if (key == 'frame') { // scope
	urlParams.delete('pattern');
	urlParams.delete('re');
	if (strXPathBlock == '') {
	    if (strXPathGlobal == '') {
		if (strLocator == '') {
		    // empty
		} else {
		    urlParams.delete('xpath');
		    urlParams.set('path',strLocator);
		}
	    } else {
		// global XPath defined, keep path
		urlParams.set('xpath','/descendant-or-self::*[@xpath = "' + strXPathGlobal + '"]');
	    }
	} else {
	    if (strLocator == '') {
		// empty
	    } else {
		// new path and XPath for block defined
		urlParams.set('path',strLocator);
		urlParams.set('xpath','/descendant-or-self::*[@bxpath = "' + strXPathBlock + '"]');
		urlParams.set('cxp','PiejQDefault');
	    }
	}
	window.open('?' + urlParams.toString());
	//window.location.assign('?' + urlParams.toString());
    } else if (key == 'hide') {
	options.$trigger.parent().parent().css({'display': 'none'});
    } else if (key == 'up') {
	urlParams.set('xpath','/descendant-or-self::*[@bxpath = "' + strXPathBlock.replace(/\/[^\/]+$/,'') + '"]');
	window.location.assign('?' + urlParams.toString());
    }
}


//
// 
//
function callbackContent(key, options) {
    
    var urlParams = new URLSearchParams(document.location.search);
    var strHashNew = '';

    urlParams.delete('hl');
    //urlParams.delete('re');
    
    if (key == 'frame') {
	window.open(window.location);
    } else if (key == 'cleanup') {
	pieCleanup();
    } else if (key == 'popout') {
	window.open('?' + urlParams.toString());
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
    } else if (key == 'selection') {
	selection = window.getSelection();
	if (selection == undefined || selection.toString() == '') {
	    putsConsole('Nothing selected');
	    strSelect = $('input:text').val();
	    // TODO: use submit()
	} else {
	    strSelect = selection.toString().replace(/^\s+/,'').replace(/\s+$/,'');
	}
	urlParams.set('pattern',"child::*[contains(child::text(),'" + strSelect + "')]");
	//urlParams.set('re',strSelect);
	urlParams.set('hl',strSelect);
	window.location.assign('?' + urlParams.toString());
    } else if (key == 'link') {
	$('#links').css({'display': 'block'});
    } else if (key == 'google') {
	selection = window.getSelection();
	strSelect = selection.toString().replace(/^\s+/,'+').replace(/\s+$/,'');
	if (confirm('open "https://www.google.de/search?q=' + strSelect + '"')) {
	    window.open('https://www.google.de/search?q=' + strSelect);
	}
    } else if (key == 'translate') {
	selection = window.getSelection();
	strSelect = selection.toString().replace(/^\s+/,'+').replace(/\s+$/,'');
	if (confirm('Translate "' + strSelect + '"?')) {
	    window.open('https://www.deepl.com/translator#de/en/' + strSelect);
	}
    } else {

	// actions to change the URL
	
	urlParams.delete('context');

	if (urlParams.has('path')) {
	    urlParams.set('path',urlParams.get('path').replace(/([\\]|%5C)/g,'/'));
	}
	
	if (key == 'reload') {
	    // 
	} else if (key == 'contextYear') {
	    urlParams.set('context','year');
	} else if (key == 'contextMonth') {
	    urlParams.set('context','month');
	} else if (key == 'contextWeek') {
	    urlParams.set('context','week');
	} else if (key == 'layout') {
	    urlParams.delete('tag');
	    urlParams.delete('xpath');
	    urlParams.delete('pattern');
	    urlParams.delete('re');
	    urlParams.set('cxp','PiejQDefault');
	} else if (key == 'editor') {
	    urlParams.delete('tag');
	    urlParams.delete('xpath');
	    urlParams.delete('pattern');
	    urlParams.delete('re');
	    urlParams.set('cxp','PiejQEditor');
	} else if (key == 'calendar') {
	    urlParams.set('cxp','PiejQCalendar');
	    strHashNew = '#yesterday';
	} else if (key == 'calendar_month') {
	    //window.location.assign(strLocator.replace(/(jQ|Ui)[a-z]+/i,'jQCalendar').concat('&context=month'));
	} else if (key == 'selection') {
	    selection = window.getSelection();
	    strSelect = selection.toString().replace(/^\s+/,'').replace(/\s+$/,'');
	    urlParams.set('pattern',"child::*[contains(child::text(),'" + strSelect + "')]");
	    //urlParams.set('re',strSelect);
	    urlParams.set('hl',strSelect);
	} else if (key == 'search') {
	    selection = window.getSelection();
	    strSelect = selection.toString();
	    urlParams.delete('pattern');
	    urlParams.delete('re');
	    urlParams.delete('path'); // search in all files of this site
	    urlParams.set('cxp','PiejQDirSearchResult');
	    urlParams.set('needle', strSelect);
	} else if (key == 'backlog') {
	    urlParams.set('cxp','PiejQBacklog');
	} else if (key == 'kanban') {
	    urlParams.set('cxp','PiejQKanban');
	} else if (key == 'todo') {
	    urlParams.set('cxp','PiejQTodo');
	} else if (key == 'todocalendar') {
	    urlParams.set('cxp','PiejQTodoCalendar');
	    urlParams.set('context','month');
	    strHashNew = '#today';
	} else if (key == 'todomatrix') {
	    urlParams.set('cxp','PiejQTodoMatrix');
	} else if (key == 'todocontact') {
	    urlParams.set('cxp','PiejQTodoContact');
	} else if (key == 'treemap') {
	    urlParams.set('cxp','PiejQTodoTreemap');
	} else if (key == 'presentation') {
	    urlParams.set('cxp','PresentationIndex');
	    window.open('?' + urlParams.toString());
	} else {
	    urlParams.set('cxp','PiejQFormat');
	}
	
	var strQuery = '?' + urlParams.toString();

	putsConsole('New URL: ' + strQuery + strHashNew);
	window.location.assign(strQuery + strHashNew);
    }
}
		    
// 
$(function(){

    // TODO: exclude 'a' elements from context menu or delete binding (keep default menu)
    // $("a").contextmenu().off();
    // $('a').off('contextmenu');
    // $('a[class="context-menu-list context-menu-root"]').off();

    var urlParams = new URLSearchParams(document.location.search);

    if (urlParams.get('path') == undefined || urlParams.get('path').match(/\.(pie|mm|md|cxp|txt|csv)$/i)) {

	if (urlParams.get('cxp') != undefined && urlParams.get('cxp').match(/PiejQCalendar/i)) {

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
		    //"sep3": "---------",
		    //"contextNext": {name: "Next", icon: "link"},
		    //"contextPrev": {name: "Prev", icon: "link"},
		    "sep4": "---------",
		    //"toc": {name: "Table of Content", icon: "toc"},
		    //"tags": {name: "Tag cloud", icon: "tags"},
		    //"link": {name: "Link list", icon: "link"},
		    //"sep5": "---------",
		    "layout": {name: "Layout", icon: ""},
		    "calendar": {name: "Calendar", icon: ""},
		    "backlog": {name: "Backlog", icon: ""},
		    "kanban": {name: "Kanban", icon: "tags"},
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
		    "popout": {name: "Pop out", icon: ""},
		    "frame": {name: "Scope", icon: ""},
		    "cleanup": {name: "Erase Format", icon: ""},
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
		    "translate": {name: "Translate selection", icon: "tags"},
		    "google": {name: "Google selection", icon: "tags"},
		    "link": {name: "Link list", icon: "link"},
		    "sep5": "---------",
		    "layout": {name: "Layout", icon: ""},
		    "calendar": {name: "Calendar", icon: ""},
		    //"calendar_month": {name: "CalendarMonth", icon: ""},
		    "backlog": {name: "Backlog", icon: ""},
		    "kanban": {name: "Kanban", icon: "tags"},
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
		"selection": {name: "Tag selection", icon: "tags"},
		"translate": {name: "Translate selection", icon: "tags"},
		"google": {name: "Google selection", icon: "tags"},
		"frame": {name: "Scope", icon: ""},
		"sep2": "---------",
		"up": {name: "Up", icon: "hide"},
//		"top": {name: "Top", icon: "hide"},
		"hide": {name: "Hide", icon: "hide"}
	    }
	});

	$.contextMenu({
	    selector: '.context-menu-task', 
	    trigger: 'right',
	    position: function(opt, x, y) {opt.$menu.css({top: y, left: x});},
	    autoHide: true,
	    callback: callbackSection,
	    items: {
		"task": {name: "Task", icon: "task"},
		"sep1": "---------",
		"selection": {name: "Tag selection", icon: "tags"},
		"translate": {name: "Translate selection", icon: "tags"},
		"google": {name: "Google selection", icon: "tags"},
		"frame": {name: "Scope", icon: ""},
		"sep2": "---------",
		"up": {name: "Up", icon: "hide"},
//		"top": {name: "Top", icon: "hide"},
		"hide": {name: "Hide", icon: "hide"}
	    }
	});
	
    } else {

	// non-editable format
	
	if (urlParams.get('cxp') != undefined && urlParams.get('cxp').match(/PiejQCalendar/i)) {

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
		    "popout": {name: "Pop out", icon: ""},
		    "sep2": "---------",
		    "contextYear": {name: "Context Year", icon: "link"},
		    "contextMonth": {name: "Context Month", icon: "link"},
		    "contextWeek": {name: "Context Week", icon: "link"},
		    //"sep3": "---------",
		    //"contextNext": {name: "Next", icon: "link"},
		    //"contextPrev": {name: "Prev", icon: "link"},
		    //"sep4": "---------",
		    //"toc": {name: "Table of Content", icon: "toc"},
		    //"tags": {name: "Tag cloud", icon: "tags"},
		    //"link": {name: "Link list", icon: "link"},
		    "sep5": "---------",
		    "layout": {name: "Layout", icon: ""},
		    "calendar": {name: "Calendar", icon: ""},
		    "backlog": {name: "Backlog", icon: ""},
		    "kanban": {name: "Kanban", icon: "tags"},
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
		    //"sep1": "---------",
		    "reload": {name: "Reload", icon: "reload"},
		    //"editor": {name: "Editor", icon: "edit"},
		    "popout": {name: "Pop out", icon: ""},
		    "cleanup": {name: "Erase Format", icon: ""},
		    "sep2": "---------",
		    "toc": {name: "Table of Content", icon: "toc"},
		    "tags": {name: "Tag cloud", icon: "tags"},
		    "selection": {name: "Tag selection", icon: "tags"},
		    "search": {name: "Search selection", icon: "tags"},
		    "translate": {name: "Translate selection", icon: "tags"},
		    "google": {name: "Google selection", icon: "tags"},
		    "link": {name: "Link list", icon: "link"},
		    "sep3": "---------",
		    "layout": {name: "Layout", icon: ""},
		    "calendar": {name: "Calendar", icon: ""},
		    "backlog": {name: "Backlog", icon: ""},
		    "kanban": {name: "Kanban", icon: "tags"},
		    "todo": {name: "Todo", icon: ""},
		    "todocalendar": {name: "TodoCalendar", icon: ""},
		    "todomatrix": {name: "TodoMatrix", icon: ""},
		    "treemap": {name: "Treemap", icon: ""},
		    // TODO: "mindmap": {name: "Mindmap", icon: ""},
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
		"selection": {name: "Tag selection", icon: "tags"},
		"translate": {name: "Translate selection", icon: "tags"},
		"google": {name: "Google selection", icon: "tags"},
		"frame": {name: "Scope", icon: ""},
		"sep2": "---------",
		"up": {name: "Up", icon: "hide"},
//		"top": {name: "Top", icon: "hide"},
		"hide": {name: "Hide", icon: "hide"}
	    }
	});

	$.contextMenu({
	    selector: '.context-menu-task', 
	    trigger: 'right',
	    position: function(opt, x, y) {opt.$menu.css({top: y, left: x});},
	    autoHide: true,
	    callback: callbackSection,
	    items: {
		"task": {name: "Task", icon: "task"},
		"sep1": "---------",
		"selection": {name: "Tag selection", icon: "tags"},
		"translate": {name: "Translate selection", icon: "tags"},
		"google": {name: "Google selection", icon: "tags"},
		"frame": {name: "Scope", icon: ""},
		"sep2": "---------",
		"up": {name: "Up", icon: "hide"},
//		"top": {name: "Top", icon: "hide"},
		"hide": {name: "Hide", icon: "hide"}
	    }
	});
	
    }

});
