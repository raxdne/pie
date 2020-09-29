////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Pie Additor Freemind Javascript Code (p) 2012..2020 A. Tenbusch
//
// - all additor for Freemind XML
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

document.createAdditorUI = function () {

    putsConsole('Node ' + this.getElementById('additArea'));
    var nodeParent = this.getElementById('additArea');
    if (this.idHighlight != undefined) {
	if (this.idHighlight = '0') {
	    putsConsole('Turn highlighting off');
	} else {
	    var nodeHighlight = this.getElementById(this.idHighlight);
	    if (nodeHighlight == undefined || nodeHighlight == null) {
		putsConsole('Ignoring highlight PIE element ' + this.idHighlight);
	    } else {
		putsConsole('Highlight PIE element ' + nodeHighlight);
		nodeHighlight.className = 'highlight';
	    }
	}
    } else if (nodeParent == undefined || nodeParent == null) {
	this.arrColorMarker = ['#88FF88','#88EE88','#88DD88','#88CC88','#88BB88','#88AA88','#889988','#888888','#887788'];
	this.intColorIndex = 0;
	if (this.strTag != undefined && this.strTag != '') {
	    this.markTextStr(this.strTag);
	}
	putsConsole('This is a simple display PIE document now!');
    } else {
	//
	this.nodeSelection = this.createElement('div');
	//this.nodeSelection.id = 'selection';
	nodeParent.appendChild(this.nodeSelection); // selection

	this.nodeForm = this.createElement('div');
	this.nodeForm.id = 'form';
	this.nodeForm.className = 'pieTab';
	nodeParent.appendChild(this.nodeForm); // form

	this.nodeStructure = this.createElement('div');
	this.nodeStructure.id = 'structure';
	nodeParent.appendChild(this.nodeStructure); // structure

	this.nodeSelection.appendChild(this.createPieSelection());
	this.nodeForm.appendChild(this.createPieForm('section'));
	this.updateToc();
	this.updateSelect('list_contact','GetContactsJson');
	this.updateSelect('list_tag','GetTagsJson');
	$(function() {
	    $( "#datepicker" ).datepicker();
	    $( "#datepicker" ).datepicker( "option", { showWeek: true, numberOfMonths: 3, showButtonPanel: true, dateFormat: "yymmdd"});
	});
	putsConsole('This is an additor PIE document "' + this.strFile + '" now!');
    }
}


//
//
//
document.createPieSelection = function () {

    var _this = this;

    var nodeResult = this.createElement('p');

    var nodeT = this.createElement('span');
    nodeT.className = 'pieTab';
    nodeT.appendChild(this.createTextNode('Insert a new '));
    nodeResult.appendChild(nodeT);

    var nodeSelectElement = this.createElement('select');
    nodeSelectElement.id = 'selection';
    nodeSelectElement.className = 'pieTab';

    var arrValues = ['section','task','target','p','pre','tag','import'];
    for (var i=0; i<arrValues.length; i++) {
	var nodeOption = this.createElement('option');
	if (i==0) {
	    nodeOption.setAttribute('selected','selected');
	}
	nodeOption.appendChild(this.createTextNode(arrValues[i]));
	nodeSelectElement.appendChild(nodeOption);
    }

    nodeSelectElement.onchange = function () {
	
	var strName = nodeSelectElement.options[nodeSelectElement.selectedIndex].text;
	var objSave = new Pie();
	_this.nodeForm.replaceChild(_this.createPieForm(strName),_this.nodeForm.childNodes[0]);
	_this.updateSelect('list_contact','GetContactsJson');
	_this.updateSelect('list_tag','GetTagsJson');
	objSave.setValues(strName);

	    $(function() {
		$( "#datepicker" ).datepicker();
		$( "#datepicker" ).datepicker( "option", { showWeek: true, numberOfMonths: 3, showButtonPanel: true, dateFormat: "yymmdd"});
	    });
    }

    nodeResult.appendChild(nodeSelectElement);

    nodeResult.appendChild(this.createTextNode(' as '));

    var nodeSelect = this.createElement('select');
    nodeSelect.id = 'relation';
    nodeSelect.className = 'pieTab';

    var nodeOption = this.createElement('option');
    nodeOption.appendChild(this.createTextNode('child'));

    nodeSelect.appendChild(nodeOption);

    nodeOption = this.createElement('option');
    nodeOption.appendChild(this.createTextNode('sibling'));

    nodeSelect.appendChild(nodeOption);

    nodeResult.appendChild(nodeSelect);

    return nodeResult;
}


//
//
//
document.createPieForm = function (strFormName) {

    var Today = new Date();
    var nodeResult = this.createElement('div');
    nodeResult.className = 'pieTab';

    putsConsole(strFormName);

    if (strFormName == undefined || strFormName == null || strFormName == '') {
	// ignore
    } else if (strFormName=='node') {
	nodeResult.appendChild(this.createPieFormElement('Header'));
	//nodeResult.appendChild(this.createPieFormElement('Date'));
    } else if (strFormName=='section') {
	nodeResult.appendChild(this.createPieFormElement('Header'));
	nodeResult.appendChild(this.createPieFormElement('Date'));
	nodeResult.appendChild(this.createPieFormElement('Impact'));
	nodeResult.appendChild(this.createPieFormElement('Assignee'));
	nodeResult.appendChild(this.createPieFormElement('Tag'));
    } else if (strFormName=='task') {
	nodeResult.appendChild(this.createPieFormElement('Header'));
	nodeResult.appendChild(this.createPieFormElement('Date',Today.getInput()));
	nodeResult.appendChild(this.createPieFormElement('Impact'));
	nodeResult.appendChild(this.createPieFormElement('Effort'));
	var nodeSet = this.createPieFormElement('Text');
	nodeSet.childNodes[1].id = 'p';
	nodeResult.appendChild(nodeSet);
	nodeResult.appendChild(this.createPieFormElement('Contact'));
	//this.updateSelect();
	nodeResult.appendChild(this.createPieFormElement('Tag'));
    } else if (strFormName=='target') {
	nodeResult.appendChild(this.createPieFormElement('Header'));
	nodeResult.appendChild(this.createPieFormElement('Date'));
    } else if (strFormName=='tag') {
	nodeResult.appendChild(this.createPieFormElement('Tag'));
    } else if (strFormName=='p' || strFormName=='pre' || strFormName=='import') {
	var nodeSet = this.createPieFormElement('Text');
	nodeSet.childNodes[1].id = strFormName;
	nodeResult.appendChild(nodeSet);
    } else {
	nodeResult.appendChild(this.createTextNode('Element "' + strFormName + '" not implemented!'));
    }

    return nodeResult;
}


//
// create form elements
//
document.createPieFormElement = function (strLabel,strDefault) {

    var nodeResult = this.createElement('p');

    var nodeLabel = this.createElement('span');
    nodeLabel.className = 'pieTab';
    nodeLabel.appendChild(this.createTextNode(strLabel + ' '));
    nodeResult.appendChild(nodeLabel);

    if (strLabel == 'Header') {
	var nodeInput = this.createElement('input');
	nodeInput.id = strLabel.toLowerCase();
	nodeInput.className = 'pieTab';
	nodeInput.setAttribute('size','60');
	nodeInput.setAttribute('maxlength','160');
	nodeResult.appendChild(nodeInput);
    } else if (strLabel == 'Date') {
	var nodeInput = this.createElement('input');
	nodeInput.id = 'datepicker';
	nodeInput.className = 'pieTab';
	nodeInput.setAttribute('type','text');
	nodeInput.setAttribute('size','10');
	//nodeInput.setAttribute('maxlength','15');
	if (strDefault != undefined) {
	   nodeInput.setAttribute('value', strDefault);
	}
	nodeResult.appendChild(nodeInput);

	nodeInput = this.createElement('input');
	nodeInput.id = 'flag_done';
	nodeInput.className = 'pieTab';
	nodeInput.setAttribute('type','checkbox');
	nodeResult.appendChild(nodeInput);

	nodeResult.appendChild(this.createTextNode(' done'));
    } else if (strLabel == 'Text') {
	var nodeInput = document.createElement('textarea');
	//nodeInput.id = (strId == undefined) ? 'p' : strId;
	nodeInput.className = 'pieTab';
	nodeInput.setAttribute('rows','3');
	nodeInput.setAttribute('cols','70');

	nodeResult.appendChild(nodeInput);
    } else if (strLabel == 'Effort') {
	var nodeInput = document.createElement('input');
	nodeInput.id = strLabel.toLowerCase();
	nodeInput.className = 'pieTab';
	nodeInput.setAttribute('size','5');
	nodeInput.setAttribute('maxlength','5');

	nodeResult.appendChild(nodeInput);
    } else if (strLabel == 'Contact') {
	var nodeInput = document.createElement('input');
	nodeInput.id = 'input_contact';
	nodeInput.className = 'pieTab';
	nodeInput.setAttribute('size','30');
	nodeInput.setAttribute('maxlength','40');
	nodeResult.appendChild(nodeInput);

	nodeResult.appendChild(document.createTextNode(' '));

	var nodeSelect = document.createElement('select');
	nodeSelect.id = 'list_contact';
	nodeSelect.className = 'pieTab';
	nodeSelect.multiple = 'multiple';
	nodeSelect.width = '20';
	nodeSelect.size = '4';
	nodeResult.appendChild(nodeSelect);
	//this.updateSelect();
    } else if (strLabel == 'Assignee') {
	var nodeInput = document.createElement('input');
	nodeInput.id = 'input_contact';
	nodeInput.className = 'pieTab';
	nodeInput.setAttribute('size','30');
	nodeInput.setAttribute('maxlength','40');
	nodeResult.appendChild(nodeInput);

	nodeResult.appendChild(document.createTextNode(' '));

	var nodeSelect = document.createElement('select');
	nodeSelect.id = 'list_contact';
	nodeSelect.className = 'pieTab';
	nodeResult.appendChild(nodeSelect);
	//this.updateSelect();
    } else if (strLabel == 'Impact') {
	var nodeSelect = this.createElement('select');
	nodeSelect.id = strLabel.toLowerCase();
	nodeSelect.className = 'pieTab';

	var nodeOption = this.createElement('option');
	nodeOption.appendChild(this.createTextNode(''));
	nodeOption.setAttribute('selected','selected');
	nodeSelect.appendChild(nodeOption);
	nodeOption = this.createElement('option');
	nodeOption.appendChild(this.createTextNode('1'));
	nodeSelect.appendChild(nodeOption);
	nodeOption = this.createElement('option');
	nodeOption.appendChild(this.createTextNode('2'));
	nodeSelect.appendChild(nodeOption);

	nodeResult.appendChild(nodeSelect);
    } else if (strLabel == 'Tag') {
	var nodeInput = document.createElement('input');
	nodeInput.id = 'input_tag';
	nodeInput.className = 'pieTab';
	nodeInput.setAttribute('size','30');
	nodeInput.setAttribute('maxlength','40');
	nodeResult.appendChild(nodeInput);

	nodeResult.appendChild(document.createTextNode(' '));

	var nodeSelect = document.createElement('select');
	nodeSelect.id = 'list_tag';
	nodeSelect.className = 'pieTab';
	nodeSelect.multiple = 'multiple';
	nodeSelect.width = '20';
	nodeSelect.size = '4';
	nodeResult.appendChild(nodeSelect);
    } else {
	var nodeError = this.createTextNode('Error');
	nodeResult.appendChild(nodeError);
    }
	
    return nodeResult;
}


//
// call a XMLHttp() to set done attribute to the given XPath element in PIE document
//
document.setElementAttribute = function (strLocator,strXpath,strAttrName,strAttrValue) {

    if (strXpath == undefined) {
	alert('Please select element!');
	return undefined;
    }
    putsConsole(strAttrName + ' + reload ' + '"' + strLocator + ':' + strXpath + '"');

    var objPie = new Pie(strLocator,strXpath);

    this.submitXsl(objPie.setAttrXslString(strXpath,strAttrName,strAttrValue),strLocator);
  
    // var nodeElement = document.getElementById(mapXpathToLabel(strXpath));
    // if (nodeElement == undefined || nodeElement == null) {
    // 	this.reloadDocument();
    // } else {
    // 	putsConsole('change style of ' + '"' + nodeElement + '"');
    // 	nodeElement.className = 'done';
    // }
}


//
// call a XMLHttp() to set date attribute to the given XPath element in PIE document
//
document.dateElement = function (strLocator,strXpath,strDate) {

    if (strXpath == undefined) {
	alert('Please select element!');
	return undefined;
    }
    putsConsole('date + reload ' + '"' + strLocator + ':' + strXpath + '"');

    var objPie = new Pie(strLocator,strXpath);

    this.submitXsl(objPie.toStringXslDate(strDate),strLocator);
}


//
// call a XMLHttp() to set done attribute to the given XPath element in PIE document
//
document.doneElement = function (strLocator,strXpath,strDate) {

    if (strXpath == undefined) {
	alert('Please select element!');
	return undefined;
    }
    putsConsole('done + reload ' + '"' + strLocator + ':' + strXpath + '"');

    var objPie = new Pie(strLocator,strXpath);

    this.submitXsl(objPie.toStringXslDone(strDate),strLocator);
    
    var nodeElement = document.getElementById(mapXpathToLabel(strXpath));
    if (nodeElement == undefined || nodeElement == null) {
	this.reloadDocument();
    } else {
	putsConsole('change style of ' + '"' + nodeElement + '"');
	nodeElement.className = 'done';
    }
}


//
// call a XMLHttp() to remove the given XPath element in PIE document
//
document.removeElement = function (strLocator,strXpath) {

    if (strXpath == undefined) {
	alert('Please insert header in !');
	return undefined;
    }
    putsConsole('remove + reload ' + '"' + strLocator + ':' + strXpath + '"');

    var objPie = new Pie(strLocator,strXpath);

    this.submitXsl(objPie.toStringXslRemove(strXpath),strLocator);

    var nodeElement = document.getElementById(mapXpathToLabel(strXpath));
    if (nodeElement == undefined || nodeElement == null) {
	this.reloadDocument();
    } else {
	putsConsole('change style of ' + '"' + nodeElement + '"');
	nodeElement.className = 'invalid';
    }
}


//
// call a XMLHttp() to clone the given XPath element in PIE document
//
document.cloneElement = function (strLocator,strXpath) {

    if (strXpath == undefined) {
	alert('Please insert header in !');
	return undefined;
    }
    putsConsole('clone + reload ' + '"' + strLocator + ':' + strXpath + '"');

    var objPie = new Pie(strLocator,strXpath);

    this.submitXsl(objPie.toStringXslClone(strXpath),strLocator);

    // var nodeElement = document.getElementById(mapXpathToLabel(strXpath));
    // if (nodeElement == undefined || nodeElement == null) {
    // 	this.reloadDocument();
    // } else {
    // 	putsConsole('change style of ' + '"' + nodeElement + '"');
    // 	nodeElement.className = 'invalid';
    // }
}


//
//
//
document.submitXsl = function (strContent,strLocator) {

    //alert(strContent);
    var _this = this;

    if (strContent == undefined || strContent == null || strContent == '') {
	return;
    }

    // AJAX based way
    // http://www.openjs.com/articles/ajax_xmlhttp_using_post.php
    var xmlHttp = getXMLHttpRequest();

    var url = "/cxproc/exe";
    var params = 'cxp=ApplyXsl' + '&path=' + ((strLocator == undefined) ? this.strFile : strLocator) + '&strContent=' + encodeURIComponent(strContent);
 
    xmlHttp.open("POST", url, false);

    //Send the proper header information along with the request
    xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    //xmlHttp.setRequestHeader("Content-length", params.length);
    //xmlHttp.setRequestHeader("Connection", "close");

    xmlHttp.onreadystatechange = function() { //Call a function when the state changes.
	if (this.readyState == 4 /* complete */) {
	    if (this.status == 200 || this.status == 304) {
		//alert(this.responseText);
		_this.updateToc();
		_this.updateSelect('list_contact','GetContactsJson');
		_this.updateSelect('list_tag','GetTagsJson');
		//_this.reloadDocument();
	    }
	    else {
		alert('Error: ' + this.responseText);
	    }
	}
    }

    xmlHttp.send(params);
}


//
//
//
document.updateToc = function () {

    var _this = this;

    if (this.nodeStructure == undefined || this.nodeStructure == null) {
	//
//	alert('no <form/> found');
    } else {
	var xmlHttp = getXMLHttpRequest();

	// workaround because IE caching of XMLHttpRequest()
	xmlHttp.open("GET", '/cxproc/exe?cxp=GetToc' + '&id=' + Math.random() + '&path=' + this.strFile, true);
	xmlHttp.setRequestHeader("Pragma", "no-cache" );
	xmlHttp.setRequestHeader("Cache-Control", "no-cache, no-store, must-revalidate" );

	xmlHttp.onreadystatechange = function() { //Call a function when the state changes.
	    if (this.readyState == 4 /* complete */) {
		if (this.status == 200 || this.status == 304) {
		    var arrStruct;
		    var strJSON = this.responseText;
		    try {
			arrStruct = eval(strJSON);
		    } catch (e) {
			alert('XML problem!');
		    }

		    if (arrStruct == undefined || arrStruct.length < 1) {
			nodePre.appendChild(document.createTextNode('XML problem!'));
		    } else {
			putsConsole('update ToC');
			if (_this.nodeStructure.childNodes.length > 0) {
			    _this.nodeStructure.removeChild(_this.nodeStructure.childNodes[0]);
			}
			var nodePre = _this.createElement('pre');
			_this.nodeStructure.appendChild(nodePre);

			for (var i=0; i<arrStruct.length; i++) {

			    for (var j=0; j<arrStruct[i].intIndent; j++) {
				nodePre.appendChild(document.createTextNode('  '));
			    }

			    var nodeA = document.createElement('a');
			    var strXpath = arrStruct[i].xpath;

			    if (arrStruct[i].strHeader.length > 100) {
				nodeA.appendChild(document.createTextNode(arrStruct[i].strHeader.substring(0,100) + ' ...'));
			    } else {
				nodeA.appendChild(document.createTextNode(arrStruct[i].strHeader));
			    }

			    nodeA.setAttribute("title", strXpath);

			    nodeA.onclick = function () {
				var objSave = new Pie(_this.strFile,this.title);
				_this.submitXsl(objSave.toStringXslAdd());
			    }

			    nodeA.onmouseover = function () {
				this.className='highlight';
			    }

			    nodeA.onmouseout = function () {
				this.className='link';
			    }

			    nodePre.appendChild(nodeA);
			    nodePre.appendChild(document.createElement('br'));
			}
		    }
		} else {
		    alert('Error: ' + this.responseText);
		}
	    }
	}

	xmlHttp.send();
    }
}


//
//
//
document.updateSelect = function (strId, strCxp) {

    var _this = this;

    var xmlHttp = getXMLHttpRequest();

    var nodeSelect = this.getElementById(strId);
    if (nodeSelect == undefined || nodeSelect == null) {
	putsConsole('no <select/> for ' + strId + 'found');
	return null;
    } else {
	putsConsole("Found contact selection");
    }

    xmlHttp.open("GET", '/cxproc/exe?cxp=' + strCxp + '&path=' + this.strFile, true);
    xmlHttp.setRequestHeader("Cache-Control", "no-cache" );
    xmlHttp.setRequestHeader("Cache-Control", "no-store" );
    xmlHttp.setRequestHeader("Cache-Control", "must-revalidate" );

    xmlHttp.onreadystatechange = function() { //Call a function when the state changes.
	if (this.readyState == 4 /* complete */) {
	    if (this.status == 200 || this.status == 304) {
		var strJSON = this.responseText;
		//putsConsole(strJSON);

		var arrContact;

		try {
		    arrContact = eval(strJSON).sort();
		} catch (e) {
		    alert('XML problem!');
		}

		// remove old options
		if (arrContact == undefined || arrContact == null) {
		    //nodeSelect.appendChild(document.createTextNode('XML problem!'));
		} else if (arrContact.length > 0) {
		    putsConsole('update contacts');
		    for (var i=nodeSelect.childNodes.length-1; i>-1; i--) {
			//putsConsole('removeChild() ' + nodeSelect.childNodes[i]);
			nodeSelect.removeChild(nodeSelect.childNodes[i]);
		    }

		    // empty value by default
		    var nodeOption = document.createElement('option');
		    nodeOption.setAttribute('selected','selected');
		    nodeOption.appendChild(document.createTextNode(''));
		    nodeSelect.appendChild(nodeOption);

		    for (var i=0; i<arrContact.length; i++) {
			if (arrContact[i].length > 0) {
			    nodeOption = document.createElement('option');
			    nodeOption.appendChild(document.createTextNode(arrContact[i]));
			    nodeSelect.appendChild(nodeOption);
			    // skip all following redundant values
			    while (i < arrContact.length-1 && arrContact[i+1] == arrContact[i]) {
				i++;
			    }
			}
		    }
		}
	    } else {
		alert('Error: ' + this.responseText);
	    }
	}
    }

    xmlHttp.send();
}


