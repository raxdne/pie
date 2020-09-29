////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// new Methods for Date
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//
//
//
Date.prototype.getInput = function () {

    var strMonth = ((this.getMonth() < 9) ? '0' : '') + (this.getMonth() + 1).toString();

    var strDayOfMonth = ((this.getDate() < 10) ? '0' : '') + this.getDate().toString();

    return this.getFullYear().toString() + strMonth + strDayOfMonth;
};


//
//
//
Date.prototype.isOK = function (strDate) {

    // TODO: implement test code

    return true;
};


//
// scan date values from URL string
//
Date.prototype.scanURL = function (strUrl) {
    
    if (strUrl == undefined) {
	// ignore
    } else {
	// analyze current URL
	var strQuery = strUrl.replace(/\#.*$/,'').split('?')[1];
	if (strQuery == undefined || strQuery == null) {
	    strQuery = strUrl;
	}
	var arrPair = strQuery.split('&');
	for (var i=0; i < arrPair.length; i++) {
	    var j = arrPair[i].split('=')[1];
	    if (arrPair[i].match(/^(day|date)=/)) {
		if (j > 0 && j < 32) {
		    this.setDate(j);
		} else {
		    return;
		}
	    } else if (arrPair[i].match(/^month=/)) {
		if (j > -1 && j < 12) {
		    this.setMonth(j-1);
		} else {
		    return;
		}
	    } else if (arrPair[i].match(/^year/)) {
		if (j > 1969 && j < 2100) {
		    this.setFullYear(j);
		} else {
		    return;
		}
	    }
	}
    }
};

//
// returns date values as URL string
//
Date.prototype.toURL = function () {
    
    return '&year=' + this.getFullYear() + '&month=' + (this.getMonth() + 1) + '&day=' + this.getDate();
};
