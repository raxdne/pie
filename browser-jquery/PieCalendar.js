//
//
//

function objContextDate (strUrl) {

    this.date = new Date();
    
    if (strUrl == null || strUrl == undefined) {
	this.URL = window.document.URL;
    } else {
	this.URL = strUrl;
    }
    this.date.scanURL(this.URL);
    this.scanContext();
    
    console.log(this + ": " + this.toURL());
}


//
// remove all Date and context parameters from URL
//
objContextDate.prototype.cleanURL = function () {

    return this.URL.replace(/\#.*/,'').replace(/&*(context|year|month|week|day)=[^&]*/ig,'');
}


//
//
//
objContextDate.prototype.setMonth = function (value) {

    if (value == null || value == undefined) return;

    this.date.setMonth(value);
}


//
// increments Date according to current context
//
objContextDate.prototype.setNext = function () {

    if (this.context == 'year') {
	this.date.setFullYear(this.date.getFullYear() + 1);
    } else if (this.context == 'month') {
	if (this.date.getMonth() < 11) {
	    this.date.setMonth(this.date.getMonth() + 1);
	} else {
	    this.date.setMonth(0);
	    this.date.setFullYear(this.date.getFullYear() + 1);
	}
    } else if (this.context == 'week') {
	//this.date.setWeek(this.date.getWeek() + 1);
    } else {
	this.date.setDate(this.date.getDate() + 1);
    }
}


//
// decrements Date according to current context
//
objContextDate.prototype.setPrev = function () {

    if (this.context == 'year') {
	this.date.setFullYear(this.date.getFullYear() - 1);
    } else if (this.context == 'month') {
	if (this.date.getMonth() > 0) {
	    this.date.setMonth(this.date.getMonth() - 1);
	} else {
	    this.date.setMonth(11);
	    this.date.setFullYear(this.date.getFullYear() - 1);
	}
    } else if (this.context == 'week') {
	//this.date.setWeek(this.date.getWeek() - 1);
    } else {
	this.date.setDay(this.date.getDay() - 1);
    }
}


//
//
//
objContextDate.prototype.toURL = function () {

    var strPrefix = this.cleanURL();

    console.log(this + ": " + strPrefix);
    if (strPrefix.match(/\?/)) {
	if (strPrefix.match(/\&$/)) {
	} else {
	    strPrefix = strPrefix.concat('&');
	}
    } else {
	if (strPrefix.match(/\&$/)) {
	} else {
	    strPrefix = strPrefix.concat('?');
	}
    }
    return  strPrefix + 'context=' + this.context + this.date.toURL();
}


//
//
//
objContextDate.prototype.scanContext = function (strUrl) {

    var strQuery;
    if (strUrl == undefined) {
	// analyze current URL
	strQuery = this.URL.replace(/\#.*$/,'').split('?')[1];
    } else {
	strQuery = strUrl.replace(/\#.*$/,'').split('?')[1];
    }
    
    this.context = 'year';
    if (strQuery == undefined || strQuery == null || strQuery == '') {
	console.log('Empty call, set default!');
    } else {
	var arrPair = strQuery.split('&');
	for (var i=0; i < arrPair.length; i++) {
	    if (arrPair[i].match(/^context=/)) {
		this.context = arrPair[i].split('=')[1].toLowerCase();
		break;
	    }
	}
    }
}


//
//
//
objContextDate.prototype.switchContext = function (strContext) {

    if (strContext == null || strContext == undefined) {
      if (this.context == 'year') {
        this.context = 'month';    
      } else if (this.context == 'month') {
      //  this.context = 'week';    
      //} else if (this.context == 'week') {
        this.context = 'day';    
      } else {
        this.context = 'year';
      }
    } else if (strContext.match(/(year|month|week|day)/i)) {
      this.context = strContext.toLowerCase();    
    } else {
        this.context = 'year';    
    }
    console.log( this + ".toURL(): " + this.toURL());
}


//
//
//
function setMonth(value) {
    
    if (value == null) return;

    var objTest = new objContextDate();
    objTest.switchContext('month');
    objTest.setMonth(value);
    console.log( objTest + ".toURL(): " + objTest.toURL());
    window.location.assign(objTest.toURL());
}


//
//
//
function goNext() {

    var objTest = new objContextDate();
    objTest.setNext();
    console.log( objTest + ".toURL(): " + objTest.toURL());
    window.location.assign(objTest.toURL());
}


//
//
//
function goPrev() {

    var objTest = new objContextDate();
    objTest.setPrev();
    console.log( objTest + ".toURL(): " + objTest.toURL());
    window.location.assign(objTest.toURL());
}


//
//
//
function switchContext (strContext) {

    var objTest = new objContextDate();
    objTest.switchContext(strContext);
    console.log( objTest + ".toURL(): " + objTest.toURL());
    window.location.assign(objTest.toURL());
}
