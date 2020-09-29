////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// new Class Pie (p) 2011..2015 A. Tenbusch
//
// - set, get and check values of a Pie object
// - build XSL strings for transformation of server document
//
// - no modification of document object
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//
// constructor
//
function Pie (strLocator, strXpath) {

    if (strLocator != undefined) {
	this.strLocator = strLocator;
	if (this.strLocator.match(/\.mm$/)) {
	    this.strType = 'mm';
	} else {
	    this.strType = 'pie';
	}
    }

    this.strXpath = strXpath;

    this.readFormValues();
    putsConsole(this);
}


//
//
//
Pie.prototype.setReplace = function (flagArg) {

    this.flagReplace = flagArg;
}


//
//
//
Pie.prototype.getLocator = function () {

    return this.strLocator;
}


//
// try to set the inputs according to 'objectArg' (maps object to inputs)
//
Pie.prototype.setValues = function (strName) {

    var strHeader = '';
    var elementH = document.getElementById('header');

    var strDate = '';
    var elementDate = document.getElementById('datepicker');

    var strT = '';
    var elementT = document.getElementById('p') || document.getElementById('pre') || document.getElementById('import');

    this.strName = strName;

    if (this.strHeader == undefined || this.strHeader == null || this.strHeader == '') {
	// there is no header property at this
    } else {
	strHeader = this.strHeader;
    }

    if (this.strP == undefined || this.strP == null || this.strP == '') {
    } else {
	strT = ((strT.length > 0) ? (strT + '\n') : '') + this.strP;
    }

    if (this.strPre == undefined || this.strPre == null || this.strPre == '') {
    } else {
	strT = ((strT.length > 0) ? (strT + '\n') : '') + this.strPre;
    }

    if (this.strImport == undefined || this.strImport == null || this.strImport == '') {
    } else {
	strT = ((strT.length > 0) ? (strT + '\n') : '') + this.strImport;
    }

    if (elementH && elementT) {
	elementH.value = strHeader;
	elementT.value = strT;
    } else if (elementH) {
	elementH.value = ((strHeader.length > 0) ? strHeader : '') + ((strT.length > 0) ? (' ' + strT) : '');
    } else if (elementT) {
	elementT.value = ((strHeader.length > 0) ? strHeader : '') + ((strT.length > 0) ? ('\n' + strT) : '');
    } else {
    }

    if (this.strDate == undefined || this.strDate == null || this.strDate == '') {
    } else if (elementDate == undefined || elementDate == null) {
    } else if (this.strName == 'task' || this.strName == 'target') {
	elementDate.value = this.strDate;
    }
}


//
// returns an object containing the checked values of inputs
//
Pie.prototype.readFormValues = function () {

    var elementT;

    // TODO: handle XML violations!

    elementT = document.getElementById('selection');
    if (elementT == undefined || elementT == null || elementT.selectedIndex==undefined || elementT.selectedIndex==null) {
	// ignore this
    } else {
	this.strName = elementT.options[elementT.selectedIndex].text;
    }

    elementT = document.getElementById('relation');
    if (elementT == undefined || elementT == null || elementT.selectedIndex==undefined || elementT.selectedIndex==null) {
	// ignore this
    } else {
	this.strRelation = elementT.options[elementT.selectedIndex].text;
    }

    elementT = document.getElementById('header');
    if (elementT == undefined || elementT == null || elementT.value==undefined || elementT.value==null || elementT.value=='') {
	// ignore this
    } else {
	this.strHeader = elementT.value;
    }

    elementT = document.getElementById('datepicker');
    if (elementT == undefined || elementT == null || elementT.value==undefined || elementT.value==null || elementT.value=='') {
	// ignore this
    } else if (true) { // TODO: Date.isOK(elementT.value)
	this.strDate = elementT.value;
    } else {
	// ignore this
    }

    elementT = document.getElementById('flag_done');
    if (elementT == undefined || elementT == null) {
	// ignore this
    } else {
	this.flagDone = elementT.checked;
    }

    elementT = document.getElementById('effort');
    if (elementT == undefined || elementT == null || elementT.value==undefined || elementT.value==null || elementT.value=='') {
	// ignore this
    } else {
	this.strEffort = elementT.value;
    }

    elementT = document.getElementById('impact');
    if (elementT == undefined || elementT == null
	|| elementT.selectedIndex == undefined || elementT.selectedIndex == null
	|| elementT.options == undefined || elementT.options == null || elementT.options.length < 1
	|| elementT.options[elementT.selectedIndex] == undefined || elementT.options[elementT.selectedIndex] == null
	|| elementT.options[elementT.selectedIndex].text == '') {
	// ignore this
    } else {
	this.strImpact = elementT.options[elementT.selectedIndex].text;
    }

    elementT = document.getElementById('p');
    if (elementT == undefined || elementT == null || elementT.value==undefined || elementT.value==null || elementT.value=='') {
	// ignore this
    } else {
	this.strP = elementT.value.replace(/[\t\n\r ]+/g,' ');
    }

    elementT = document.getElementById('import');
    if (elementT == undefined || elementT == null || elementT.value==undefined || elementT.value==null || elementT.value=='') {
	// ignore this
    } else {
	this.strImport = elementT.value;
    }

    elementT = document.getElementById('pre');
    if (elementT == undefined || elementT == null || elementT.value==undefined || elementT.value==null || elementT.value=='') {
	// ignore this
    } else {
	this.strPre = elementT.value;
    }

    this.arrContact = new Array();
    elementT = document.getElementById('input_contact');
    if (elementT == undefined || elementT == null || elementT.value==undefined || elementT.value==null || elementT.value=='') {
	// ignore this
    } else {
	var arrT = elementT.value.replace(/[\/;\t ]+/g,',').split(',');
	for (var i=0; i<arrT.length; i++) {
	    var strT = arrT[i].replace(/[^a-zA-ZüÜöÖäÄ0-9_\-]+/g,'');
	    if (strT.length) {
		this.arrContact.push(strT.toLowerCase());
	    }
	}
    }

    elementT = document.getElementById('list_contact');
    if (elementT == undefined || elementT == null
	|| elementT.selectedIndex == undefined || elementT.selectedIndex == null
	|| elementT.options == undefined || elementT.options == null || elementT.options.length < 1
	|| elementT.options[elementT.selectedIndex] == undefined || elementT.options[elementT.selectedIndex] == null
	|| elementT.options[elementT.selectedIndex].text == '') {
	// ignore this
    } else {
	for (var i=0; i<elementT.options.length; i++) {
	    if (elementT.options[i].selected) {
		this.arrContact.push(elementT.options[i].text);
	    }
	}
    }

    this.arrTag = new Array();
    elementT = document.getElementById('input_tag');
    if (elementT == undefined || elementT == null || elementT.value==undefined || elementT.value==null || elementT.value=='') {
	// ignore this
    } else {
	var arrT = elementT.value.replace(/[\/;\t ]+/g,',').split(',');
	for (var i=0; i<arrT.length; i++) {
	    var strT = arrT[i].replace(/[^a-zA-ZüÜöÖäÄ0-9_\-]+/g,'');
	    if (strT.length) {
		this.arrTag.push(strT.toLowerCase());
	    }
	}
    }

    elementT = document.getElementById('list_tag');
    if (elementT == undefined || elementT == null
	|| elementT.selectedIndex == undefined || elementT.selectedIndex == null
	|| elementT.options == undefined || elementT.options == null || elementT.options.length < 1
	|| elementT.options[elementT.selectedIndex] == undefined || elementT.options[elementT.selectedIndex] == null
	|| elementT.options[elementT.selectedIndex].text == '') {
	// ignore this
    } else {
	for (var i=0; i<elementT.options.length; i++) {
	    if (elementT.options[i].selected) {
		this.arrTag.push(elementT.options[i].text);
	    }
	}
    }
}


//
// 
//
Pie.prototype.toStringXslAdd = function () {

    var Today = new Date();
    var strResult = '';
    var nodeElement = '';
    var elementTemplate = '';

    if (this.strName=='section' || this.strName=='task' || this.strName=='target') {

	if (this.strHeader == undefined) {
	    alert('Please insert header in ' + this.strName + ' form!');
	    return undefined;
	}

	var strAttrDate = '';
	if (this.strDate != undefined) {
	    if (this.strType == 'mm') {		
		strAttrDate = 
		    '<xsl:element name="attribute">' +
		    '<xsl:attribute name="NAME">' +
		    '<xsl:text>date</xsl:text>' +
		    '</xsl:attribute>' +
		    '<xsl:attribute name="VALUE">' +
		    '<xsl:text>' + getXmlConformStr(this.strDate) + '</xsl:text>' +
		    '</xsl:attribute>' +
		    '</xsl:element>';

		if (this.flagDone) {
		    strAttrDate += 
			'<xsl:element name="icon">' +
			'<xsl:attribute name="BUILTIN">' +
			'<xsl:text>button_ok</xsl:text>' +
			'</xsl:attribute>' +
			'</xsl:element>';
		}
	    } else {		
		strAttrDate = '<xsl:attribute name="' + (this.flagDone ? 'done' : 'date') + '">' +
		    '<xsl:text>' + getXmlConformStr(this.strDate) + '</xsl:text>' +
		    '</xsl:attribute>';
	    }		
	}

	var strAttrImpact = '';
	if (this.strImpact != undefined) {
	    if (this.strType == 'mm') {
		strAttrImpact = '<xsl:element name="attribute">' +
		    '<xsl:attribute name="NAME">' +
		    '<xsl:text>impact</xsl:text>' +
		    '</xsl:attribute>' +
		    '<xsl:attribute name="VALUE">' +
		    '<xsl:text>' + getXmlConformStr(this.strImpact) + '</xsl:text>' +
		    '</xsl:attribute>' +
		    '</xsl:element>';
	    } else {		
		strAttrImpact = '<xsl:attribute name="impact">' +
		    '<xsl:text>' + getXmlConformStr(this.strImpact) + '</xsl:text>' +
		    '</xsl:attribute>';
	    }
	}

	var strAttrAssignee = '';
	var strAttrEffort = '';
	var strP = '';
	var strContact = '';
	var strTag = '';
	var strIcon = '';
	var strFont = '';

	if (this.strName=='section') {
	    this.flagUpdate = true;

	    strFont = '<xsl:element name="font">' +
		'<xsl:attribute name="BOLD">' +
		'<xsl:text>true</xsl:text>' +
		'</xsl:attribute>' +
		'<xsl:attribute name="SIZE">' +
		'<xsl:text>12</xsl:text>' +
		'</xsl:attribute>' +
		'</xsl:element>';

	    if (this.arrContact != undefined && this.arrContact.length == 1) {
		if (this.strType == 'mm') {
		    strAttrAssignee = '<xsl:element name="attribute">' +
			'<xsl:attribute name="NAME">' +
			'<xsl:text>assignee</xsl:text>' +
			'</xsl:attribute>' +
			'<xsl:attribute name="VALUE">' +
			'<xsl:text>' + getXmlConformStr(this.arrContact[0]) + '</xsl:text>' +
			'</xsl:attribute>' +
			'</xsl:element>';
		} else {		
		    strAttrAssignee = strAttrAssignee.concat('<xsl:attribute name="assignee">' +
							     '<xsl:text>' + getXmlConformStr(this.arrContact[0]) + '</xsl:text>' +
							     '</xsl:attribute>');
		}
	    }
	} else {

	    if (this.strName=='task') {
		strIcon = '<xsl:element name="icon">' +
			'<xsl:attribute name="BUILTIN">' +
			'<xsl:text>list</xsl:text>' +
			'</xsl:attribute>' +
			'</xsl:element>';
	    } else if (this.strName=='traget') {
	    }

	    if (this.strEffort != undefined) {
		if (this.strType == 'mm') {
		    strAttrEffort = '<xsl:element name="attribute">' +
			'<xsl:attribute name="NAME">' +
			'<xsl:text>effort</xsl:text>' +
			'</xsl:attribute>' +
			'<xsl:attribute name="VALUE">' +
			'<xsl:text>' + getXmlConformStr(this.strEffort) + '</xsl:text>' +
			'</xsl:attribute>' +
			'</xsl:element>';
		} else {		
		    strAttrEffort = '<xsl:attribute name="effort">' +
			'<xsl:text>' + getXmlConformStr(this.strEffort) + '</xsl:text>' +
			'</xsl:attribute>';
		}
	    }

	    if (this.strP != undefined) {
		if (this.strType == 'mm') {
		    strP = '<xsl:element name="node">' +
			'<xsl:attribute name="TEXT">' +
			'<xsl:text>' + getXmlConformStr(this.strP) + '</xsl:text>' +
			'</xsl:attribute>' +
			'</xsl:element>';
		} else {		
		    strP = '<xsl:element name="p">' +
			'<xsl:text>' + getXmlConformStr(this.strP) + '</xsl:text>' +
			'</xsl:element>';
		}
	    }

	    if (this.arrContact != undefined && this.arrContact.length > 0) {
		for (var i=0; i < this.arrContact.length; i++) {
		    if (this.strType == 'mm') {
			strContact = strContact.concat('<xsl:element name="node">' +
						       '<xsl:attribute name="TEXT">' +
						       '<xsl:text>' + getXmlConformStr(this.arrContact[i]) + '</xsl:text>' +
						       '</xsl:attribute>' +
						       '<xsl:element name="icon">' +
						       '<xsl:attribute name="BUILTIN">' +
						       '<xsl:text>male1</xsl:text>' +
						       '</xsl:attribute>' +
						       '</xsl:element>' +
						       '</xsl:element>');
		    } else {		
			strContact = strContact.concat('<xsl:element name="contact">' +
						       '<xsl:attribute name="idref">' +
						       '<xsl:text>' + getXmlConformStr(this.arrContact[i]) + '</xsl:text>' +
						       '</xsl:attribute>' +
						       '</xsl:element>');
		    }
		}
	    }
	}

	if (this.arrTag != undefined && this.arrTag.length > 0) {
	    for (var i=0; i < this.arrTag.length; i++) {
		if (this.strType == 'mm') {
		    // TODO
		} else {		
		    strTag = strTag.concat('<xsl:element name="tag">' +
					   '<xsl:text>' + this.arrTag[i] + '</xsl:text>' +
					   '</xsl:element>');
		}
	    }
	}
	
	if (this.strType == 'mm') {
	    nodeElement = '<xsl:element name="node">' +
		'<xsl:attribute name="CREATED">' +
		'<xsl:text>' + Today.getTime() + '</xsl:text>' +
		'</xsl:attribute>' +
		'<xsl:attribute name="TEXT">' +
		'<xsl:text>' + getXmlConformStr(this.strHeader) + '</xsl:text>' +
		'</xsl:attribute>' +
		// '<xsl:element name="attribute">' +
		// '<xsl:attribute name="NAME">' +
		// '<xsl:text>' + 'class' + '</xsl:text>' +
		// '</xsl:attribute>' +
		// '<xsl:attribute name="VALUE">' +
		// '<xsl:text>' + this.strName + '</xsl:text>' +
		// '</xsl:attribute>' +
		// '</xsl:element>' +
		strAttrAssignee +
		strAttrDate +
		strAttrEffort +
		strAttrImpact +
		strIcon +
		strFont +
		strP +
		strContact +
		strTag +
		'</xsl:element>';
	} else {		
	    nodeElement = '<xsl:element name="' + this.strName + '">' +
		'<xsl:attribute name="origin">' +
		'<xsl:text>' + Today.getInput() + '</xsl:text>' +
		'</xsl:attribute>' +
		strAttrAssignee +
		strAttrDate +
		strAttrEffort +
		strAttrImpact +
		'<xsl:element name="h">' +
		'<xsl:text>' + getXmlConformStr(this.strHeader) + '</xsl:text>' +
		'</xsl:element>' +
		strP +
		strContact +
		strTag +
		'</xsl:element>';
	}

    } else if (this.strName=='p') {
	if (this.strP == undefined || this.strP.length < 1) {
	    alert('Nothing to add');
	    return '';
	} else {
	    if (this.strType == 'mm') {
		nodeElement = '<xsl:element name="node">' +
		    '<xsl:attribute name="TEXT">' +
		    '<xsl:text>' + getXmlConformStr(this.strP) + '</xsl:text>' +
		    '</xsl:attribute>' +
		    '</xsl:element>';
	    } else {		
		nodeElement = '<xsl:element name="' + this.strName + '">' +
		    '<xsl:text>' + getXmlConformStr(this.strP) + '</xsl:text>' +
		    '</xsl:element>';
	    }
	}
    } else if (this.strName=='pre') {
	if (this.strPre == undefined || this.strPre.length < 1) {
	    alert('Nothing to add');
	    return '';
	} else {
	    if (this.strType == 'mm') {
		nodeElement = '<xsl:element name="node">' +
		    '<xsl:attribute name="TEXT">' +
		    '<xsl:text>' + getXmlConformStr(this.strPre) + '</xsl:text>' +
		    '</xsl:attribute>' +
		    '<xsl:element name="font">' +
		    '<xsl:attribute name="NAME">' +
		    '<xsl:text>Monospaced</xsl:text>' +
		    '</xsl:attribute>' +
		    '<xsl:attribute name="SIZE">' +
		    '<xsl:text>12</xsl:text>' +
		    '</xsl:attribute>' +
		    '</xsl:element>' +
		    '</xsl:element>';
	    } else {		
		nodeElement = '<xsl:element name="' + this.strName + '">' +
		    '<xsl:text>' + getXmlConformStr(this.strPre) + '</xsl:text>' +
		    '</xsl:element>';
	    }
	}
    } else if (this.strName=='tag') {
	if (this.arrTag != undefined && this.arrTag.length > 0) {
	    for (var i=0, nodeElement=''; i < this.arrTag.length; i++) {
		if (this.strType == 'mm') {
		    // TODO
		} else {		
		    nodeElement = nodeElement.concat('<xsl:if test="count(tag[. = \'' + this.arrTag[i] + '\']) &lt; 1">' +
						     '<xsl:element name="tag">' +
						     '<xsl:text>' + this.arrTag[i] + '</xsl:text>' +
						     '</xsl:element>' +
						     '</xsl:if>');
		}
	    }
	}
    } else if (this.strName=='import') {
	if (this.strImport == undefined || this.strImport.length < 1) {
	    alert('Nothing to add');
	    return '';
	} else {
	    if (this.strType == 'mm') {
		nodeElement = '<xsl:element name="node">' +
		    '<xsl:attribute name="TEXT">' +
		    '<xsl:text>' + getXmlConformStr(this.strImport) + '</xsl:text>' +
		    '</xsl:attribute>' +
		    '<xsl:element name="font">' +
		    '<xsl:attribute name="NAME">' +
		    '<xsl:text>Monospaced</xsl:text>' +
		    '</xsl:attribute>' +
		    '<xsl:attribute name="SIZE">' +
		    '<xsl:text>12</xsl:text>' +
		    '</xsl:attribute>' +
		    '</xsl:element>' +
		    '</xsl:element>';
	    } else {		
		nodeElement = '<xsl:element name="' + this.strName + '">' +
		    '<xsl:text>' + getXmlConformStr(this.strImport) + '</xsl:text>' +
		    '</xsl:element>';
	    }
	}
    } else {
	alert('Unknown element "' + this.strName + '"');
	return '';
    }

    if (this.strRelation=='sibling') {
	elementTemplate = '<xsl:template match="' + this.strXpath + '">' +
	    '<xsl:copy-of select="." />' +
	    nodeElement +
	    '</xsl:template>';
    } else { // child by default
	elementTemplate = '<xsl:template match="' + this.strXpath + '">' +
	    '<xsl:element name="{name()}">' +
	    '<xsl:copy-of select="attribute::*"/>' +
	    '<xsl:copy-of select="child::*"/>' +
	    nodeElement +
	    '</xsl:element>' +
	    '</xsl:template>';
    }

    var elementTemplateDefault = '<xsl:template match="@*|*">' +
	'<xsl:copy>' +
	'<xsl:apply-templates select="@*|node()"/> ' +
	'</xsl:copy>' +
	'</xsl:template>';

    var strResult = '<?xml version="1.0" encoding="UTF-8"?>' + 
	'<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
	'<xsl:output method="xml" encoding="UTF-8"/>' +
	// '<!-- Apply to file ' + this.strPath + ' -->' +
	elementTemplate +
	elementTemplateDefault +
	'</xsl:stylesheet>';

    return strResult;
}


//
// 
//
Pie.prototype.editXslString = function () {

    alert('TODO');
}


//
// returns a XSL-String to set date attribute to the given XPath element in PIE document
//
Pie.prototype.toStringXslDate = function (strDate) {

    if (strDate == undefined || strDate == '') {
	strDate = 1;
    }

    var strResult;
    if (this.strType == 'mm') {
	strResult = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
            '<xsl:output method="xml" encoding="UTF-8"/>' +
            '<xsl:template match="' + this.strXpath + '">' +
            '<xsl:element name="{name()}">' +
            '<xsl:copy-of select="@*"/>' +
            '<xsl:copy-of select="*[not(self::attribute[@NAME=\'date\'])]"/>' +
            '<xsl:element name="attribute">' +
            '<xsl:attribute name="NAME">' + 'date' + '</xsl:attribute>' +
            '<xsl:attribute name="VALUE">' + strDate + '</xsl:attribute>' +
            '</xsl:element>' +
            '</xsl:element>' +
            '</xsl:template>' +
            '<xsl:template match="@*|node()|comment()">' +
            '<xsl:copy>' +
            '<xsl:apply-templates select="@*|node()|comment()"/>' +
            '</xsl:copy>' +
            '</xsl:template>' +
            '</xsl:stylesheet>';
    } else {
	strResult = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
            '<xsl:output method="xml" encoding="UTF-8"/>' +
            '<xsl:template match="' + this.strXpath + '">' +
            '<xsl:element name="{name()}">' +
            '<xsl:copy-of select="@*"/>' +
            '<xsl:attribute name="date">' + strDate + '</xsl:attribute>' +
            '<xsl:copy-of select="node()"/>' +
            '</xsl:element>' +
            '</xsl:template>' +
            '<xsl:template match="@*|node()|comment()">' +
            '<xsl:copy>' +
            '<xsl:apply-templates select="@*|node()|comment()"/>' +
            '</xsl:copy>' +
            '</xsl:template>' +
            '</xsl:stylesheet>';
    }

    return strResult;
}


//
// returns a XSL-String to set done attribute to the given XPath element in PIE document
//
Pie.prototype.toStringXslDone = function (strDate) {

    if (strDate == undefined || strDate == '') {
	strDate = 1;
    }

    var strResult;
    if (this.strType == 'mm') {
	strResult = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
            '<xsl:output method="xml" encoding="UTF-8"/>' +
            '<xsl:template match="' + this.strXpath + '">' +
            '<xsl:element name="{name()}">' +
            '<xsl:copy-of select="@*"/>' +
            '<xsl:copy-of select="*[not(self::attribute[@NAME=\'done\'])]"/>' +
            '<xsl:element name="icon">' +
            '<xsl:attribute name="BUILTIN">button_ok</xsl:attribute>' +
            '</xsl:element>' +
            '<xsl:element name="attribute">' +
            '<xsl:attribute name="NAME">' + 'done' + '</xsl:attribute>' +
            '<xsl:attribute name="VALUE">' + strDate + '</xsl:attribute>' +
            '</xsl:element>' +
            '</xsl:element>' +
            '</xsl:template>' +
            '<xsl:template match="@*|node()|comment()">' +
            '<xsl:copy>' +
            '<xsl:apply-templates select="@*|node()|comment()"/>' +
            '</xsl:copy>' +
            '</xsl:template>' +
            '</xsl:stylesheet>';
    } else {
	strResult = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
            '<xsl:output method="xml" encoding="UTF-8"/>' +
            '<xsl:template match="' + this.strXpath + '">' +
            '<xsl:element name="{name()}">' +
            '<xsl:copy-of select="@*"/>' +
            '<xsl:attribute name="done">' + strDate + '</xsl:attribute>' +
            '<xsl:copy-of select="node()"/>' +
            '</xsl:element>' +
            '</xsl:template>' +
            '<xsl:template match="@*|node()|comment()">' +
            '<xsl:copy>' +
            '<xsl:apply-templates select="@*|node()|comment()"/>' +
            '</xsl:copy>' +
            '</xsl:template>' +
            '</xsl:stylesheet>';
    }

    return strResult;
}


//
// returns a XSL-String to set done attribute to the given XPath element in PIE document
//
Pie.prototype.setAttrXslString = function (strXpath,strAttrName,strAttrValue) {

    var strElement;

    if (strXpath == undefined || strXpath == '') {
	strXpath = this.strXpath;
    }

    if (strAttrValue == undefined) {
	// delete named attribute
        strElement =
	    '<xsl:element name="{name()}">' +
            '<xsl:copy-of select="@*[not(name()=\'' + strAttrName + '\')]"/>' +
            '<xsl:copy-of select="node()"/>' +
            '</xsl:element>';
    }
    else if (strAttrName == 'date') {
	// delete done attribute and set date attribute
        strElement =
	    '<xsl:element name="{name()}">' +
            '<xsl:copy-of select="@*[not(name()=\'done\')]"/>' +
            '<xsl:attribute name="' + strAttrName + '">' + strAttrValue + '</xsl:attribute>' +
            '<xsl:copy-of select="node()"/>' +
            '</xsl:element>';
    }
    else {
	// set value of named attribute
        strElement =
	    '<xsl:element name="{name()}">' +
            '<xsl:copy-of select="@*"/>' +
            '<xsl:attribute name="' + strAttrName + '">' + strAttrValue + '</xsl:attribute>' +
            '<xsl:copy-of select="node()"/>' +
            '</xsl:element>';
    }

    var strResult =
	'<?xml version="1.0" encoding="UTF-8"?>' +
        '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
        '<xsl:output method="xml" encoding="UTF-8"/>' +
        '<xsl:template match="' + strXpath + '">' +
        strElement  +
        '</xsl:template>' +
        '<xsl:template match="@*|node()|comment()">' +
        '<xsl:copy>' +
        '<xsl:apply-templates select="@*|node()|comment()"/>' +
        '</xsl:copy>' +
        '</xsl:template>' +
        '</xsl:stylesheet>';

    return strResult;
}


//
// returns a XSL-String to remove the given XPath element in PIE document
//
Pie.prototype.toStringXslRemove = function (strXpath) {

    if (strXpath == undefined || strXpath == '') {
	strXpath = this.strXpath;
    }

    var strResult;
    if (this.strType == 'mm') {
	strResult = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
            '<xsl:output method="xml" encoding="UTF-8"/>' +
            '<xsl:template match="' + strXpath + '">' +
            '<xsl:element name="{name()}">' +
            '<xsl:copy-of select="@*"/>' +
            '<xsl:copy-of select="*[not(self::icon[@BUILTIN=\'button_cancel\'])]"/>' +
            '<xsl:element name="icon">' +
            '<xsl:attribute name="BUILTIN">button_cancel</xsl:attribute>' +
            '</xsl:element>' +
            '</xsl:element>' +
            '</xsl:template>' +
            '<xsl:template match="@*|node()|comment()">' +
            '<xsl:copy>' +
            '<xsl:apply-templates select="@*|node()|comment()"/>' +
            '</xsl:copy>' +
            '</xsl:template>' +
            '</xsl:stylesheet>';
    } else {
	strResult = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
            '<xsl:output method="xml" encoding="UTF-8"/>' +
            '<xsl:template match="' + strXpath + '">' +
            '<xsl:element name="{name()}">' +
            '<xsl:copy-of select="@*"/>' +
            '<xsl:attribute name="valid">no</xsl:attribute>' +
            '<xsl:copy-of select="node()"/>' +
            '</xsl:element>' +
            '</xsl:template>' +
            '<xsl:template match="@*|node()|comment()">' +
            '<xsl:copy>' +
            '<xsl:apply-templates select="@*|node()|comment()"/>' +
            '</xsl:copy>' +
            '</xsl:template>' +
            '</xsl:stylesheet>';
    }

    return strResult;
}


//
// returns a XSL-String to clone the given XPath element in PIE document
//
Pie.prototype.toStringXslClone = function (strXpath) {

    if (strXpath == undefined || strXpath == '') {
	strXpath = this.strXpath;
    }

    var strResult = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
            '<xsl:output method="xml" encoding="UTF-8"/>' +
            '<xsl:template match="' + strXpath + '">' +
            '<xsl:copy-of select="."/>' +
            '<xsl:copy-of select="."/>' +
            '</xsl:template>' +
            '<xsl:template match="@*|node()|comment()">' +
            '<xsl:copy>' +
            '<xsl:apply-templates select="@*|node()|comment()"/>' +
            '</xsl:copy>' +
            '</xsl:template>' +
            '</xsl:stylesheet>';

    return strResult;
}

