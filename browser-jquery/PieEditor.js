
//
//
//
function getToolsStr(strNameEditor) {

    var strResult = '<p style="font-size:150%">';

    strResult += '<a onclick="' + 'insertDate(' + strNameEditor + ')' + '" title="Insert picked date.">&#x1F4C5;</a> ';

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
	} else if (objInfo.mime.match(/^application\/(pie\+xml|cxp\+xml|mm\+xml)$/i)) {
	    putsConsole('XML Format ' + objInfo.mime + ' OK');
	    flagXML = true;
	} else if (objInfo.mime.match(/^text\//i)) {
	    putsConsole('Text Format ' + objInfo.mime + ' OK');
	} else {
	    objEditor.setValue('No editable format recognized: "' + objInfo.mime + '"');
	    return;
	}
	
	requestContent = $.ajax({
	    url: '/' + urlParams.get('path'),
	    type: 'GET',
	    encoding: urlParams.get('encoding'),
	    dataType: 'text',
	    cache: false
	});

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
	    //} else if (flagXML) {
	    //	strEvent = 'javascript:saveXpath(editor,\'' + urlParams.get('path') + '\')';
	    } else {
		strEvent = 'javascript:saveText(editor,\'' + urlParams.get('path') + '\')';
	    }
	    objEditor.setReadOnly(false);

	    $('#strContent').before('<a onclick="' + strEvent + '" title="Save the editor content.">&#x1F4BE;</a>');

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

	    // TODO: improve error handling
	});
    });

    requestMeta.fail(function( jqXHR, textStatus ) {
	objEditor.setValue( 'Request meta failed: ' + textStatus );
    });

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
    }, {showWeek: true, showButtonPanel: false, dateFormat: "yy-mm-dd"});
    // TODO: calendarType: 'week', calendarSize: 3, showWeek: true, firstSelectDay: 1, showButtonPanel: false, returnFormat: 'iso8601'
}


//
// 
//
function _saveXpath(objEditor,strPath,strXpath) {

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
	type: 'POST',
	data: {
	    path: strPath,
	    cxp: 'SaveContentXml',
	    strContent: objEditor.getValue()
	},
	dataType: 'text',
	success: function (response){
            putsConsole( "Data saved: " + response);
	    $('#flagChange').append("|");
	    objEditor.focus();
	},
	error: function (jqXHR,textStatus,errorThrown){
    	    alert( 'Request failed: ' + textStatus);
	    //$('#strValue').append('<hr/>' + textStatus);
	    $('#flagChange').append("\\");
	    objEditor.focus();
	},
	cache: false
    });
}

//
// 
//
function evalScript(objEditor) {

    var request = $.ajax({
	type: 'POST',
	data: {
	    cxp: 'EvalScript',
	    strContent: objEditor.getValue()
	},
	dataType: 'text',
	success: function (response){
	    $('#strValue').append('<hr/>' + response);
	    objEditor.focus();
	},
	error: function (jqXHR,textStatus,errorThrown){
    	    alert( 'Request failed: ' + textStatus);
	    //$('#strValue').append('<hr/>' + textStatus);
	    objEditor.focus();
	},
	cache: false
    });
}

//
// 
//
function formatMarkdown(objEditor) {

    var request = $.ajax({
	type: 'POST',
	data: {
	    cxp: 'FormatMarkdown',
	    strContent: objEditor.getValue()
	},
	dataType: 'html',
	success: function (response){
	    $('#strValue').append('<hr/>' + response);
	    objEditor.focus();
	},
	error: function (jqXHR,textStatus,errorThrown){
    	    alert( 'Request failed: ' + textStatus);
	    //$('#strValue').append('<hr/>' + textStatus);
	    objEditor.focus();
	},
	cache: false
    });
}

//
// 
//
function formatPlain(objEditor) {

    var request = $.ajax({
	type: 'POST',
	data: {
	    cxp: 'FormatPlain',
	    strContent: objEditor.getValue()
	},
	dataType: 'text',
	success: function (response){
	    $('#strValue').append('<pre>' + response + '</pre>');
	    objEditor.focus();
	},
	error: function (jqXHR,textStatus,errorThrown){
    	    alert( 'Request failed: ' + textStatus);
	    //$('#strValue').append('<hr/>' + textStatus);
	    objEditor.focus();
	},
	cache: false
    });
}

