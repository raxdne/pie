//
// myGanttChart (p) 2021,2022,2024 A. Tenbusch
//

// TODO: #review `moment.js` https://day.js.org/en/

// https://github.com/csnover/js-iso8601
// https://www.twilio.com/en-us/blog/parse-iso8601-duration-javascript
// https://github.com/EvanHahn/HumanizeDuration.js
// https://www.epoch-calendar.com/javascript_calendar/index.html

var locale = 'de-DE';
const optionsWithWeekday = { weekday: "long", year: "numeric", month: "long", day: "numeric" };

// default format for Dates
Date.prototype.getDateString = function () {

    //return this.toLocaleDateString('de-DE', { year: 'numeric', month: 'numeric', day: 'numeric'});
    //return this.toLocaleDateString(locale,optionsWithWeekday))
    return this.toISOString().substring(0,10);
}


/**
 * Returns the week number for this date.  dowOffset is the day of week the week
 * "starts" on for your locale - it can be from 0 to 6. If dowOffset is 1 (Monday),
 * the week returned is the ISO 8601 week number.
 * @param int dowOffset
 * @return int
 */
Date.prototype.getWeek = function (dowOffset) {
    /*getWeek() was developed by Nick Baicoianu at MeanFreePath: http://www.epoch-calendar.com */

    var strResult = this.getFullYear();
    
    dowOffset = (typeof dowOffset === 'number') ? dowOffset : 0; //default dowOffset to zero
    var newYear = new Date(this.getFullYear(),0,1);
    var day = newYear.getDay() - dowOffset; //the day of week the year begins on
    day = (day >= 0 ? day : day + 7);
    var daynum = Math.floor((this.getTime() - newYear.getTime() - 
			     (this.getTimezoneOffset()-newYear.getTimezoneOffset())*60000)/86400000) + 1;
    var weeknum;
    //if the year starts before the middle of a week
    if(day < 4) {
	weeknum = Math.floor((daynum+day-1)/7) + 1;
	if (weeknum > 52) {
	    nYear = new Date(this.getFullYear() + 1,0,1);
	    nday = nYear.getDay() - dowOffset;
	    nday = nday >= 0 ? nday : nday + 7;
	    /*if the next year starts before the middle of
 	      the week, it is week #1 of that year*/
	    weeknum = nday < 4 ? 1 : 53;
	    if (nday < 4) {
		strResult = nYear.getFullYear().toString() + '-W01';
	    }
	    else {
		strResult += '-W' + weeknum.toString();
	    }
	}
	else if (weeknum < 10) {
	    strResult += '-W0' + weeknum.toString();
	}
	else {
	    strResult += '-W' + weeknum.toString();
	}
    }
    else {
	weeknum = Math.floor((daynum+day-1)/7);
	if (weeknum < 10) {
	    strResult += '-W0' + weeknum.toString();
	}
	else {
	    strResult += '-W' + weeknum.toString();
	}
    }
    return strResult;
};


// https://stackoverflow.com/questions/16590500/calculate-date-from-week-number-in-javascript
/**
 * Get the date from an ISO 8601 week and year
 *
 * https://en.wikipedia.org/wiki/ISO_week_date
 *
 * @param {number} week ISO 8601 week number
 * @param {number} year ISO year
 *
 * Examples:
 *  getDateOfIsoWeek(53, 1976) -> Mon Dec 27 1976
 *  getDateOfIsoWeek( 1, 1978) -> Mon Jan 02 1978
 *  getDateOfIsoWeek( 1, 1980) -> Mon Dec 31 1979
 *  getDateOfIsoWeek(53, 2020) -> Mon Dec 28 2020
 *  getDateOfIsoWeek( 1, 2021) -> Mon Jan 04 2021
 *  getDateOfIsoWeek( 0, 2023) -> Invalid (no week 0)
 *  getDateOfIsoWeek(53, 2023) -> Invalid (no week 53 in 2023)
 */
function getDateOfIsoWeek(week, year) {
    week = parseFloat(week);
    year = parseFloat(year);
  
    if (week < 1 || week > 53) {
      throw new RangeError("ISO 8601 weeks are numbered from 1 to 53");
    } else if (!Number.isInteger(week)) {
      throw new TypeError("Week must be an integer");
    } else if (!Number.isInteger(year)) {
      throw new TypeError("Year must be an integer");
    }
  
    const simple = new Date(year, 0, 1 + (week - 1) * 7);
    const dayOfWeek = simple.getDay();
    const isoWeekStart = simple;

    // Get the Monday past, and add a week if the day was
    // Friday, Saturday or Sunday.
  
    isoWeekStart.setDate(simple.getDate() - dayOfWeek + 1);
    if (dayOfWeek > 4) {
        isoWeekStart.setDate(isoWeekStart.getDate() + 7);
    }

    // The latest possible ISO week starts on December 28 of the current year.
    if (isoWeekStart.getFullYear() > year ||
        (isoWeekStart.getFullYear() == year &&
         isoWeekStart.getMonth() == 11 &&
         isoWeekStart.getDate() > 28)) {
        throw new RangeError(`${year} has no ISO week ${week}`);
    }
  
    return isoWeekStart;
}


//
// returns timestamp of 'dt'
//
function ISO8601_parse(dt) {

    var t_result = 0;
    
    if (typeof dt === 'string') {
	if (dt.match(/[0-9]{4}-*[0-9]{2}-*[0-9]{2}T[0-9:]+[A-Z]*/)) {
	    t_result = ISO8601_parse(dt.split("T")[0]);
	} else if (dt.match(/[0-9]{4}[0-9]{2}[0-9]{2}/)) {
            t_result = ISO8601_parse(dt.slice(0,4) + '-' + dt.slice(4,6) + '-' + dt.slice(6,8)); // UTC time
	} else if (dt.match(/[0-9]{4}-[0-9]{2}-[0-9]{2}/)) {
            t_result = Date.parse(dt); // UTC time
	} else if (dt.match(/[0-9]{4}-W[0-9]{2}-[0-9]/)) {
	    // ISO week + day of week
	    var d = dt.split(/-/);
	    d[1] = d[1].replace(/W/,'');
	    t_result = ISO8601_parse(getDateOfIsoWeek(d[1],d[0])) + d[2] * 3600 * 24 * 1000;
	} else if (dt.match(/[0-9]{4}-W[0-9]{2}/)) {
	    // ISO week
	    var d = dt.split(/-W/);
	    //ISO8601_parse(dt + '-1'); // Monday by default
	    t_result = ISO8601_parse(getDateOfIsoWeek(d[1],d[0]));
	} else {
	    // ???
	}
    } else if (dt instanceof Date) {
	t_result = dt.getTime();
    } else if (typeof dt === 'number' && dt > 0) {
	t_result = dt;
    }
    return t_result;
}

// s. https://developer.mozilla.org/en-US/docs/Web/SVG

function objGanttChart (strId) {

    if (strId === undefined || strId === null || strId.length < 3) {
	window.alert('No usable id: ' + strId);
	return null;
    }

    this.id = strId;

    if (this.clean() === null) {
	return null;
    }
    
    var dT = new DataTransfer();

    //https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent/ClipboardEvent
    var evt = new ClipboardEvent('paste', {clipboardData: dT});
    
    //window.console.log('clipboardData available: ', evt.clipboardData);

    var self = this;

    document.onpaste = function(e) {

	var s = e.clipboardData.getData('text/plain');

	if (s === undefined || s === null || s == '') {
	    window.console.log('onpaste: ', 'undefined');
	} else {
	    //window.console.log('onpaste: ', s);
	    if (self.clean() === null) {
	    } else {

		list = self.parseIcsInput(s); // try to parse as ICS

		if (list === undefined || list.length < 1) {
		    window.console.error('empty ICS ' + s + '');

		    list = self.parseCsvInput(s); // try to parse as CSV
		    if (list === undefined || list.length < 1) {
			window.console.error('empty CSV ' + s + '');
		    } else {
			//self.clean();
			self.append(list);
		    }
		} else {
		    //self.clean();
		    self.append(list);
		}
		// TODO: check self.isHistogram()
		//self.appendHistogram();
		self.draw();
	    }
	}
    };
    
    document.dispatchEvent(evt);
    
    return this;
}


objGanttChart.prototype.switchCompact = function (v) {

    if (v === undefined) {
	this.compact = ! this.compact;
    } else if (typeof v === 'string') {
	this.switchCompact(Number(v));
    } else if (typeof v === 'boolean') {
	this.compact = v;
    } else if (Math.abs(v) > 0.1) {
	this.compact = true;
	this.t_epsilon = v * this.unit;
	window.console.log('t_epsilon = ', this.t_epsilon);
    } else {
	this.compact = false;
    }
    
    return this.compact;
}


objGanttChart.prototype.switchLength = function (v) {

    if (v === undefined) {
    } else if (typeof v === 'string') {
	this.switchLength(Number(v));
    } else if (typeof v === 'number') {
	if (Math.abs(v) < 0.1 || Math.abs(v) > 52) {
	    this.t_length = -1;
	} else {
	    this.t_length = v * this.unit;
	}
	window.console.log('t_length = ', this.t_length);
    } else {
      this.t_length = -1;
    }
}


objGanttChart.prototype.scale = function (v) {

    if (v === undefined) {
	return this.scaleFactor;
    }

    return Math.round(v * this.scaleFactor);
}


objGanttChart.prototype.setHeight = function (v) {

    if (v === undefined) {
    } else {
	this.height = Math.round(v);
    }
    window.console.log('SVG height: ' + this.height);
    
    return this.height;
}


objGanttChart.prototype.setScaleFactor = function (v) {

    if (v === undefined || v === null || ! typeof v === 'number' || v < 3.0 || v > 50.0) {
	this.scaleFactor = 20;
    } else {
	this.scaleFactor = Math.round(v);
    }
    window.console.log('SVG scaleFactor: ' + this.scaleFactor);
    
    return this.scaleFactor;
}


//
// init procedure
//
objGanttChart.prototype.clean = function () {

    var urlParams = new URLSearchParams(document.location.search);

    this.svg = document.getElementById(this.id);
    if (this.svg === null) {
	window.console.warn('No existing SVG element found!');
        this.svg = document.getElementsByTagName('body')[0].appendChild(document.createElementNS('http://www.w3.org/2000/svg','svg'));
	if (this.svg === null) {
	    window.alert('Not able to create new SVG element!');
	    return null;
	} else {
            this.svg.setAttribute('id',this.id);
	}
    } else {
	window.console.log('SVG id is ' + this.id);
	while (this.svg.firstChild) {
	    // Remove elements from DOM
	    this.svg.removeChild(this.svg.firstChild);
	}
    }
    
    this.t_now = new Date().getTime();
    this.t_0 = undefined;
    this.t_1 = undefined;

    this.box = new Array();
    this.items = new Array();
    
    this.setScaleFactor(urlParams.get("f"));
    this.y_n = this.scale(4);

    this.format_date = { year: 'numeric', month: 'numeric', day: 'numeric'};

    // TODO: configure unit as hours, days, weeks, months, years
    if (urlParams.has("s")) {
 	this.unit = (1000 * 60 * 60 * 24 * Math.abs(Number(urlParams.get("s"))));
   } else {
	this.unit = (1000 * 60 * 60 * 24 * 7 * 1);
    }

    this.switchCompact(urlParams.get("c"));
    this.switchLength(urlParams.get("l"));
    this.barbackground = '#aaffaa';
    this.height = 100;
    this.offset_draw = this.scale(4); // delta

    //var g = document.createElementNS('http://www.w3.org/2000/svg','g');
    //g.setAttribute('transform','scale(0.5)');
    //this.svg.appendChild(g);

    var s = document.createElementNS('http://www.w3.org/2000/svg','style');
    s.setAttribute('type',"text/css");
    s.appendChild(document.createTextNode('svg { font-family: Arial; font-size: ' + this.scale(0.5) + 'pt; border: 1px solid #cccccc}'));
    this.svg.prepend(s);

    return this;
}


objGanttChart.prototype.setBegin = function (t) {

    this.t_0 = ISO8601_parse(t);
    
    // adjust to first day of a week
    dow = new Date(this.t_0).getDay();
    //window.console.log('dow: ', dow + ' ' + new Date(this.t_0).toString());

    // BUG: to be aligned with this.unit
    if (dow == 0) {
	this.t_0 += (1000 * 60 * 60 * 24 * 1);
    } else {
	// REQ: change to Date.UTC() ?
	this.t_0 -= (1000 * 60 * 60 * 24 * (dow - 1.25)); // to avoid impact of timezone
    }

    console.log('Set Begin: ', new Date(this.t_0).toString());
    
    return this.t_0;
}


objGanttChart.prototype.getBegin = function() {

    if (this.t_0 === undefined) {
	return 0;
    } else {
	return this.t_0;
    }
}

objGanttChart.prototype.setEnd = function (t) {

    this.t_1 = ISO8601_parse(t);
    
    // adjust to last day of a week
    dow = new Date(this.t_1).getDay();
    //window.console.log('dow: ', dow + ' ' + new Date(this.t_1).toString());

    // BUG: to be aligned with this.unit
    if (dow == 0) {
    } else {
	this.t_1 += (1000 * 60 * 60 * 24 * (7 - dow));
    }
    console.log('Set End: ', new Date(this.t_1).getDateString());
    
    return this.t_1;
}


objGanttChart.prototype.getEnd = function() {

    if (this.t_1 === undefined) {
	return 0;
    } else {
	return this.t_1;
    }
}


objGanttChart.prototype.getNumberOfHorizontalItems = function() {

    var i = 0;
    
    if (this.items === undefined || ! typeof this.items === 'list') {
	// ignoring
    } else {
	for (const value of this.items) {
	    if (value.hasOwnProperty("vertical")) {
		// ignoring
	    } else {
		i += 1;
	    }
	}
    }
    return i;
}


//
// returns true if 'o' is currently running (inside t_epsilon)
//
objGanttChart.prototype.isRunning = function (o) {

    if (o === undefined) {
	//
    } else if (this.compact && o.hasOwnProperty("done") && o.done == true) {
	// default
    } else if (o.hasOwnProperty("t_0")) {
	if (o.hasOwnProperty("t_1")) {
	    if ((o.t_0 < (this.t_now + this.t_epsilon)) && (o.t_1 > (this.t_now - this.t_epsilon))) {
		return true;
	    }
	} else if (Math.abs(this.t_now - o.t_0) < this.t_epsilon) {
	    return true;
	}
    }
    return false;
}


//
// TODO: returns true if 'o' is longer than self.t_length
//
objGanttChart.prototype.isLong = function (o) {

    if (o === undefined) {
	return false;
    } else if (this.t_length === undefined || this.t_length < 1) {
	//
    } else if (o.hasOwnProperty("vertical")) {
	//
    } else if (o.hasOwnProperty("t_0")) {
	if (o.hasOwnProperty("t_1")) {
	    if ((o.t_1 - o.t_0) < this.t_length) {
		return false;
	    }
	} else {
	    // t_0 only
	}
    } else if (o.hasOwnProperty("t_1")) {
	// t_1 only
    }
    return true;
}


//
// returns true if 'o' is not visible in current time window
//
objGanttChart.prototype.isOutOfScope = function (o) {

    if (o === undefined) {
	//
    } else if (o.hasOwnProperty("t_0")) {
	if (o.hasOwnProperty("t_1")) {
	    return (o.t_1 < this.t_0 || o.t_0 > this.t_1);
	} else {
	    return (o.t_0 < this.t_0 || o.t_0 > this.t_1);
	}
    }
    return true;
}


objGanttChart.prototype.delta2grid = function (t) {

    if (typeof t === 'number') {
	if (t < 1000) {
	    return 0;
	} else {
	    //return Math.round(t / this.unit);
	    return (t / this.unit);
	}
    }
    return 1.0;
}


objGanttChart.prototype.date2grid = function (t) {

    if (typeof t === 'string' && t.match(/[0-9]{4}-[0-9]{2}-[0-9]{2}/)) {
        return this.date2grid(Date.parse(t));
    } else if (t instanceof Date) {
        return this.date2grid(t.getTime());
    } else if (typeof t === 'number' && t > 0) {
        return this.delta2grid(t - this.t_0);
    }
    return 0;
}


objGanttChart.prototype.grid2date = function (g) {

    var d;
    
    if (g > 0) {
	d = new Date(this.t_0.valueOf() + Math.round(g * this.unit));
    } else {
	d = new Date(this.t_0.valueOf());
    }
    return d;
}


objGanttChart.prototype.grid2delta = function (g) {

    return (this.unit * g);
}


objGanttChart.prototype.toString = function() {
    
    // TODO: return a formatted JS string of this.items
    
    // TODO: list input as JSON string
    
    strResult = typeof this + ' ' + this.id + '\n\n';
    
    if (this.svg != null) {
        strResult += this.svg.toString() + '\n\n';
    }

    if (this.box != null && this.box.length > 0) {
        strResult += this.box.toString() + '\n\n';
    }
    
    strResult += new Date(this.t_0).getDateString() + ' .. ' + new Date(this.t_1).getDateString() + '\n\n';
    
    for (var i = 0; i < this.items.length; i++) {
	strResult += i + ' ' + this.items[i].toString() + '\n\n';
    }
    
    return strResult;
}


objGanttChart.prototype.addLabel = function (argT,argStr) {

    var g = document.createElementNS('http://www.w3.org/2000/svg','g');
    //g.setAttribute('transform','rotate(-90,' + (this.scale(argT) - 4) + ',' + this.scale(1/3) + ')');
    //g.setAttribute('transform','rotate(-90)');

    tx = document.createElementNS('http://www.w3.org/2000/svg','text');
    tx.setAttribute('x', this.scale(argT) + 1);
    tx.setAttribute('y', this.scale(1/2));

    //tx.setAttribute('x', 0);
    //tx.setAttribute('y', 0);
    
    // TODO: tooltip
    //title = document.createElementNS('http://www.w3.org/2000/svg','desc');
    //title.appendChild(document.createTextNode(argStr));
    //g.appendChild(title);
    
    tx.appendChild(document.createTextNode(argStr));
    g.appendChild(tx);

    this.svg.children[0].prepend(g);
    
    return this;
}


objGanttChart.prototype.shift = function (argX, argY) {

    if (argY === undefined) {
	this.svg.children[0].setAttribute('transform','translate(' + this.scale(argX) + ',' + (0) + ')');
    } else {
	this.svg.children[0].setAttribute('transform','translate(' + this.scale(argX) + ',' + this.scale(argY) + ')');
    }
    
    return this;
}


objGanttChart.prototype.append = function (args) {

    //window.console.log(args);

    if (typeof args === 'object' && args.length === undefined) {
	this.append([args]);
    } else {
	for (var i = 0; i < args.length; i++) {
	    if (typeof args[i] === 'object') {
		if (args[i].hasOwnProperty("title") && typeof args[i].title === 'string' && args[i].title.length > 0) {		
		    if (args[i].hasOwnProperty("dt_0")) {

			args[i].t_0 = ISO8601_parse(args[i].dt_0);
			if (args[i].t_0 > 0) {
			    // valid value
			    if (this.t_0 === undefined || args[i].t_0 < this.t_0) {
				this.setBegin(args[i].dt_0);
			    }
			} else {
			    delete args[i].t_0; // invalid value, not required
			}

			if (args[i].hasOwnProperty("dt_1")) {
			    args[i].t_1 = ISO8601_parse(args[i].dt_1);
			    if (args[i].t_1 > 0) {
				// valid value
				args[i].t_length = args[i].t_1 - args[i].t_0;
				if (this.t_1 === undefined || this.t_1 < args[i].t_1) {
				    this.setEnd(args[i].dt_1);
				}
			    } else {
				delete args[i].t_1; // invalid value, not required
			    }
			} else if (args[i].hasOwnProperty("dt_length")) {
			    args[i].t_1 = args[i].t_0 + args[i].dt_length * this.unit;
			} else {
			    // milestone
			}

		    } else if (args[i].hasOwnProperty("dt_1") && args[i].hasOwnProperty("dt_length")) {
			args[i].t_0 = args[i].t_1 - args[i].dt_length * this.unit;
		    } else {
			// REQ: this.getSvgHruler(this.y_n);
			window.console.error(args[i]);
			continue;
		    }
		    delete args[i].dt_0; // no longer required
		    delete args[i].dt_1; // no longer required
		    delete args[i].dt_length; // no longer required
		    
		    //window.console.log(args[i]);
		    this.items.push(args[i]);
		} else if (args[i].hasOwnProperty("dt_0") && args[i].hasOwnProperty("dt_1")) {
		    // no title -> begin and end only
		    window.console.log('set interval: ' + args[i].dt_0 + ' ... ' + args[i].dt_1);
		    this.setBegin(args[i].dt_0);
		    this.setEnd(args[i].dt_1);
		} else if (args[i].hasOwnProperty("SUMMARY") && typeof args[i].SUMMARY === 'string' && args[i].SUMMARY.length > 0) {		
		    if (args[i].hasOwnProperty("DTSTART") && args[i].hasOwnProperty("DTEND")) {

			args[i].title = args[i].SUMMARY;
			delete args[i].SUMMARY; // no longer required

			args[i].t_0 = ISO8601_parse(args[i].DTSTART);
			if (args[i].t_0 > 0) {
			    // valid value
			    if (this.t_0 === undefined || args[i].t_0 < this.t_0) {
				this.setBegin(args[i].DTSTART);
			    }
			} else {
			    delete args[i].t_0; // invalid value, not required
			}
			delete args[i].DTSTART; // no longer required

			args[i].t_1 = ISO8601_parse(args[i].DTEND);
			if (args[i].t_1 > 0) {
			    // valid value
			    args[i].t_length = args[i].t_1 - args[i].t_0;
			    if (this.t_1 === undefined || this.t_1 < args[i].t_1) {
				this.setEnd(args[i].DTEND);
			    }
			} else {
			    delete args[i].t_1; // invalid value, not required
			}
			delete args[i].DTEND; // no longer required

			if (args[i].t_1 - args[i].t_0 > (24 * 60 * 60 * 1000)) {
			    this.items.push(args[i]);
			} else {
			    window.console.log('ICS ignoring: ' + args[i]);
			}
		    } else {
			// REQ: this.getSvgHruler(this.y_n);
			window.console.error(args[i]);
			continue;
		    }
		    
		    //window.console.log(args[i]);
		} else if (args[i].hasOwnProperty("DTSTART") && args[i].hasOwnProperty("DTEND")) {
		    // no title -> begin and end only
		    window.console.log('set interval: ' + args[i].DTSTART + ' ... ' + args[i].DTEND);
		    this.setBegin(args[i].DTSTART);
		    this.setEnd(args[i].DTEND);
		}
	    }
	}
	// REQ: add some space before this.t_0  and after this.t_1
	//this.setBegin(this.getBegin() - this.scale(4));

	// TODO: append hruler
	this.items.push({});
    }
    return this;
}


function compareByStart(a,b) {
    
    if (a.hasOwnProperty('t_0')) {
	if (b.hasOwnProperty('t_0')) {
	    window.console.log('compare: ' + (a.t_0 - b.t_0));
	    if (a.t_0 < b.t_0) {
		return -1;
	    } else if (a.t_0 > b.t_0) {
		return 1;
	    } else {
		return 0;
	    }
	} else if (b.hasOwnProperty('t_1')) {
	    if (a.t_0 < b.t_1) {
		return -1;
	    } else if (a.t_1 > b.t_0) {
		return 1;
	    } else {
		return 0;
	    }
	} else {
	    return 1;
	}
    } else if (a.hasOwnProperty('t_1')) {
	if (b.hasOwnProperty('t_0')) {
	    if (a.t_1 < b.t_0) {
		return -1;
	    } else if (a.t_1 > b.t_0) {
		return 1;
	    } else {
		return 0;
	    }
	} else if (b.hasOwnProperty('t_1')) {
	    if (a.t_1 < b.t_1) {
		return -1;
	    } else if (a.t_1 > b.t_1) {
		return 1;
	    } else {
		return 0;
	    }
	} else {
	    return -1;
	}
    } else if (b.hasOwnProperty('t_0')) {
	//return -1;
    }
    return NaN;
}


objGanttChart.prototype.sort = function() {

    //window.console.log('before sort: ' + this.items);
    this.items.sort(compareByStart);

    return this;
}


objGanttChart.prototype.preDraw = function() {

    this.setHeight(this.scale(this.getNumberOfHorizontalItems() * 1.5));

    //window.console.log(arguments);
    now = new Date(this.t_now);
    var mon = now.getMonth();
    var dom = now.getDate();
    
    for (var y = now.getFullYear(), j=-1; j < 5; j++) {
	var dt_y = new Date(y+j,mon,dom);

	dt_y.setDate(dt_y.getDate() - (dt_y.getDay() === 0 ? 7 : dt_y.getDay()) + 1); // fix to previous Monday
	this.append({dt_0: dt_y, dt_length: 1, title: 'Current Week in ' + (y+j), class: 'cw', vertical: true});
    }

    var i = this.date2grid(this.t_now);
    var x_i = this.scale(i);
	
    var l = document.createElementNS('http://www.w3.org/2000/svg','line');
    l.setAttribute('x1',x_i);
    l.setAttribute('y1',0);
    l.setAttribute('x2',x_i);
    l.setAttribute('y2',this.height);
    l.setAttribute('stroke','rgb(255,0,0)');
    l.setAttribute('stroke-width','.75');
    this.svg.appendChild(l);
    
    return this;

	  window.console.log('Pre ' + d_0 + ' ... ' + d_1);

	      for (var d_w = d_0; d_w < d_1; d_w += this.unit) {
		  this.addLabel(this.date2grid(d_w),'CW' + ISO8601_week_no(d_w) + '/' );
	      }
	  return this;
	  
	  for (var y = 2021; y < 2025; y++) {
	      //this.append({dt_0: Date(y,now.getMonth()+1,now.getDate()), dt_length: 1, title: 'Current Week ' + y, color: '#ffcccc', vertical: true});
	  }
    //this.y_n += this.scale(5);
    
    // create grid labels
    for (var g_i = 0; g_i < 10; g_i += 4) {
	//this.append({dt_0: Date(y,now.getMonth()+1,now.getDate()), dt_length: 1, title: 'Current Week ' + y, color: '#ffcccc', vertical: true});
	// for (var w = 2; w < 53; w += 4) {
	// }

	var d_i = new Date(this.grid2date(g_i));
	this.addLabel(g_i,d_i.getweek());
	//this.addLabel(g_i,g_i);
    }
    //this.y_n += this.scale(5);
    
    return this;
}


//
// change fill color by clicking on shapes
//
function clickOnShape (event) {

    const strClass = 'sel';

    if ( ! event.ctrlKey) {
	// ignoring
    } else if (this.getAttribute('class') == strClass) {
	if (this.getAttribute('classb') != undefined) {
	    this.setAttribute('class', this.getAttribute('classb'));
	    this.removeAttribute('classb');
	} else {
	    this.removeAttribute('class');
	}
    } else if (this.getAttribute('class') != undefined) {
	this.setAttribute('classb', this.getAttribute('class'));
	this.setAttribute('class', strClass);
    } else {
	this.setAttribute('class', strClass);
    }
}


objGanttChart.prototype.addEventListener = function(strTagName) {

    const list = document.getElementsByTagName(strTagName);
    
    for (i=0; i<list.length; i++) {
	list[i].addEventListener('click', clickOnShape);
    }
    return this;
}


objGanttChart.prototype.postDraw = function() {

    window.console.log('Post ');

    // REQ: select by element class?
    this.addEventListener('rect');
    this.addEventListener('polygon');
    
    return this;
}


objGanttChart.prototype.getSvg = function(li) {

    //window.console.log(arguments);
    
    var g = document.createElementNS('http://www.w3.org/2000/svg','g');
    var result = g;
    
    if (typeof li === 'object'
	&& (li.hasOwnProperty("t_0") || li.hasOwnProperty("t_1"))
	&& li.hasOwnProperty("title")
	&& this.isLong(li)
	&& (! this.compact || this.isRunning(li) || li.hasOwnProperty("vertical"))
       ) {
	
	var f;

	var tip = li.title;

	var g_x = 0;
	
	if (li.hasOwnProperty("t_1") || li.hasOwnProperty("vertical")) {

	    // REQ: t_0 + t_1 - title => Begin + End
	    
	    // REQ: no t_0, t_1, title => Hruler
	    
	    if (this.isOutOfScope(li)) {
		window.console.log('skipping ' + li);
		return null;
	    }
	    
	    var l_x = 0;
	    
	    window.console.log('horizontal bar ' + this.date2grid(li.t_0) + ' -- ' + this.date2grid(li.t_1));

	    if (li.t_0 < this.t_0) {
		// period starts before time frame of diagram
		g_x = 0;
		l_x = this.scale(this.delta2grid(li.t_1 - this.t_0));
	    } else {
		g_x = this.scale(this.date2grid(li.t_0));
		l_x = this.scale(this.delta2grid(li.t_1 - li.t_0));
	    }
	    
	    var h = this.scale();

	    if (li.hasOwnProperty("newline") && li.newline == false) {
		// keep same line
	    } else {
		//this.y_n += 1.35 * this.scale;
		//this.svg.setAttribute('height',this.y_n + 2 * h);
	    }
	    
	    f = document.createElementNS('http://www.w3.org/2000/svg','rect');
	    f.setAttribute('class','bar');
	    f.setAttribute('x',g_x);
	    g.appendChild(f);
	    
	    if (li.hasOwnProperty("vertical") && li.vertical) {
		//window.console.log('vbar ');
		f.setAttribute('y',0);
		f.setAttribute('height',this.height);
	    } else {
		//window.console.log('hbar ');
		f.setAttribute('y',this.y_n);
		f.setAttribute('height',h);
		f.setAttribute('rx',this.scale(0.1));
	    }
	    
	    f.setAttribute('width',l_x);

	    if (li.hasOwnProperty("flag") && li.flag) {
		g.appendChild(this.getSvgFlag(g_x + l_x - 5, this.y_n + this.scale(0.2)));
	    }

	    if (li.hasOwnProperty("opacity")) {
		f.setAttribute('opacity',li.opacity);
	    } else {
		f.setAttribute('opacity',0.6);
	    }
	    
	    //this.appendFlag(g_x+l_x-10,this.y_n + this.scale - 5);

	    if (li.hasOwnProperty("vertical") && li.vertical) {
		if (li.hasOwnProperty("class") == false) {
		    f.setAttribute('class','vbar');
		}
	    } else {

		var a = document.createElementNS('http://www.w3.org/2000/svg','a');
		if (li.hasOwnProperty("url")) {
		    a.setAttribute('href', li.url);
		    a.setAttribute('target', 'blank');
		}

		var tx = document.createElementNS('http://www.w3.org/2000/svg','text');
		tx.setAttribute('x', g_x + 4);
		tx.setAttribute('y',this.y_n + this.scale(0.73));
		tx.appendChild(document.createTextNode(li.title));
		
		a.appendChild(tx);
		g.appendChild(a);
	    }
	    
	    if (li.hasOwnProperty("vertical") && li.vertical) {
		// no line feed
	    } else {
		this.y_n += this.scale(1.35);
	    }
	    
	    tip += '\n(' + new Date(li.t_0).getDateString() + ' .. ' + new Date(li.t_1).getDateString() + ' = ' + Math.round((li.t_1 - li.t_0) / this.unit) + ')';	    
	// if (li.hasOwnProperty("tip")) {
	//     tip += ', ' + li.tip;
	// }
	// tt = document.createElementNS('http://www.w3.org/2000/svg','title');
	// tt.appendChild(document.createTextNode(tip));
	// g.appendChild(tt);
	
	} else {

	    if (this.isOutOfScope(li) || (this.compact && this.isRunning(li) == false)) {
		window.console.log('skipping milestone ' + li);
		return null;
	    } else {
		window.console.log('milestone ' + this.date2grid(li.t_0));
		
		//this.y_n -= this.scale(1.35);
		g_x = this.scale(this.date2grid(li.t_0));

		f = this.getSvgPolygon(g_x,this.y_n + this.scale(1/2));
		
		tx = document.createElementNS('http://www.w3.org/2000/svg','text');
		tx.setAttribute('x', g_x - this.scale(1/2) - 5);
		tx.setAttribute('y',this.y_n + this.scale(0.73));
		tx.setAttribute('text-anchor', "end");
		tx.appendChild(document.createTextNode(li.title + ' (' + new Date(li.t_0).getDateString() + ')'));
		g.appendChild(tx);

		g.appendChild(f);
		this.y_n += this.scale(1.35);
		tip += '\n(' + new Date(li.t_0).getDateString() + ')';	    
	    }
	}

	if (li.hasOwnProperty("done") && li.done && ! li.title.includes('✔')) {
	    //window.console.log('done ');
	    g.appendChild(this.getSvgDone(g_x + this.scale(1),this.y_n - this.scale(1)));
	}

	if (f != undefined) {
	    
	    if (li.hasOwnProperty("class")) {1
		f.setAttribute('class', li.class);
	    } else if (li.hasOwnProperty("border")) {
		f.setAttribute('stroke',li.border);
		f.setAttribute('stroke-width',1.0);
	    } else if (li.hasOwnProperty("fill")) {
		f.setAttribute('fill',li.fill);
	    } else if (li.hasOwnProperty("color")) { // TODO: 'fill' or 'color'
		f.setAttribute('fill',li.color);
	    } else {
		f.setAttribute('fill',this.barbackground);
	    }

	    if (li.hasOwnProperty("url")) {
		f.setAttribute('stroke','#0000ff');
	    }

	    if (li.hasOwnProperty("tip")) {
		tip += ', ' + li.tip;
	    }
	    tt = document.createElementNS('http://www.w3.org/2000/svg','title');
	    tt.appendChild(document.createTextNode(tip));
	    g.appendChild(tt);
	    
	    if (false) {		

	    var tip = li.title + '\n(' + new Date(li.t_0).getDateString() + ' .. ' + new Date(li.t_1).getDateString() + ' = ' + Math.round((li.t_1 - li.t_0) / this.unit) + ')';	    
	    //g.appendChild(f);


		if (li.hasOwnProperty("vertical") && li.vertical) {
		    this.svg.children[0].prepend(g);
		} else {
		    this.svg.children[0].appendChild(g);
		}

		var w = g_x + l_x + li.title.length * this.scale(1/2);
		// TODO: calculate length of title
		if (this.svg.getAttribute('width') < w) { // extend SVG width if neccesary
		    this.w = w + this.scale;
	    	    this.svg.setAttribute('width',this.w);
		}
	    }
	    
	}
	
    } else if (typeof li === 'object' && li.hasOwnProperty("color")) {

	//window.console.log('');
	
	//this.y_n += 1.5 * this.scale;

	//this.svg.setAttribute('height',this.y_n + 2 * this.scale);

	// x axis
	l = document.createElementNS('http://www.w3.org/2000/svg','line');
	l.setAttribute('x1',0);
	l.setAttribute('y1',this.y_n );
	l.setAttribute('x2',this.w);
	l.setAttribute('y2',this.y_n);
	l.setAttribute('stroke','#000000');
	//l.setAttribute('stroke-width','.5');		

	this.svg.children[0].appendChild(l);

	//this.y_n -= 0.5 * this.scale; // 
	
	this.barbackground = li.color;

    } else if (typeof li === 'object' && li.hasOwnProperty("posx") && li.hasOwnProperty("url")) {
	
	//window.console.log('link');
	
	a = document.createElementNS('http://www.w3.org/2000/svg','a');
	a.setAttribute('href', li.url);
	a.setAttribute('target', 'blank');
	//a.setAttribute('fill','#0000ff');
	
	g.appendChild(a);
	g = a;
	
	var x = this.scale(li.posx) + this.scale(1/3);
	
	var y;
	if (li.hasOwnProperty("posy")) {
	    y = this.scale(li.posy);
	} else {
	    y = this.y_n + this.scale(1.5);
	}

	tx = document.createElementNS('http://www.w3.org/2000/svg','text');
	tx.setAttribute('x', x);
	tx.setAttribute('y', y);
	tx.setAttribute('text-decoration', 'underline');
	tx.appendChild(document.createTextNode(li.title));
	
	g.appendChild(tx);
	this.svg.children[0].appendChild(g);
	
    } else if (typeof li === 'object' && Object.keys(li).length === 0) {
	// empty object as a hruler
	g.appendChild(this.getSvgHruler(this.y_n - this.scale(1/5)));
    }
    
    return result;
} // end of .getSvg()


objGanttChart.prototype.draw = function() {

    if (this.svg === undefined || this.svg === null) {
	window.alert('No SVG element prepared!');
	return null;
    }
	
    if (arguments.length < 1) {
	// init recursion
	this.preDraw();
	this.draw(this.items);
	this.appendVLines();
	//this.appendHLines();
	this.postDraw();
	
	const w = this.scale(Math.ceil(this.date2grid(this.getEnd()) + 10));
	const h = this.height + this.scale(4);
	
	window.console.log('svg width: ' + w);
	this.svg.setAttribute('width', w);
	window.console.log('svg height: ' + h);
	this.svg.setAttribute('height', h);
    } else {

	var g = this.svg.querySelectorAll('*[name*="draw"]')[0];
	
	if (g === undefined || g === null) {
	    g = document.createElementNS('http://www.w3.org/2000/svg','g');
	    g.setAttribute('name', 'draw');
	    //g.setAttribute('transform','translate(' + this.scale(0) + ',' + this.offset_draw + ')');
	    this.svg.appendChild(g);
	}

	for (var i = 0; i < arguments.length; i++) {

	    var li = arguments[i]; // shortcut

	    // REQ: display images

	    if (typeof arguments[i] === 'object' && arguments[i] instanceof Array) {
		window.console.log('Array');
		for (var j = 0; j < arguments[i].length; j++) {
		    this.draw(arguments[i][j]);
		}
	    } else if (arguments[i].hasOwnProperty("vertical") && arguments[i].vertical) {
		g.prepend(this.getSvg(arguments[i]));
	    } else {
		g.append(this.getSvg(arguments[i]));
		this.h = this.y_n + this.scale(2);
	    }
            // TODO: g.appendChild(this.getSvgHruler(this.y_n));
	    this.h += this.y_n + this.scale(2);
	}
    }    
    return this;
}


objGanttChart.prototype.getSvgDone = function(x,y) {

    var g = document.createElementNS('http://www.w3.org/2000/svg','g');
    g.setAttribute('class','done');
    //g.setAttribute('transform','rotate(15,' + x + ',' + y + ')');

    f = document.createElementNS('http://www.w3.org/2000/svg','polyline');
    f.setAttribute('points',
		   (x - 5) + ',' + (y - 5) + ' '
		   + (x + 0) + ',' + (y - 0) + ' '
		   + (x + 10)  + ',' + (y - 10)
		  );
    f.setAttribute('stroke','green');
    f.setAttribute('stroke-width','3');
    //f.setAttribute('stroke-linejoin','round');
    f.setAttribute('fill','none');
    
    g.appendChild(f);

    return g;
}


objGanttChart.prototype.getSvgHruler = function(y) {

    window.console.log('hrule ' + y);
   
    var g = document.createElementNS('http://www.w3.org/2000/svg','g');
    g.setAttribute('class','hruler');

    var l = document.createElementNS('http://www.w3.org/2000/svg','line');
    l.setAttribute('x1','0');
    l.setAttribute('y1',y);
    l.setAttribute('x2',this.scale(this.date2grid(this.getEnd())));
    l.setAttribute('y2',y);
    l.setAttribute('stroke','rgb(128,128,128)');
    l.setAttribute('stroke-width','.5');
    
    g.appendChild(l);
    return g;
}


objGanttChart.prototype.getSvgPolygon = function(x,y) {

    var g = document.createElementNS('http://www.w3.org/2000/svg','g');
    //g.setAttribute('class','polygon');

    f = document.createElementNS('http://www.w3.org/2000/svg','polygon');
    var half = this.scale(1/2);
    f.setAttribute('points',
		   (x - half) + ',' + (y)
		   + ' ' + (x) + ',' + (y - half)
		   + ' ' + (x + half)               + ',' + (y)
		   + ' ' + (x) + ',' + (y + half)
		   + ' ' + (x - half)               + ',' + (y));
    //f.setAttribute('fill','#aaaaff');
    
    g.appendChild(f);
    return g;
}


objGanttChart.prototype.getSvgFlag = function(x,y) {

    var g = document.createElementNS('http://www.w3.org/2000/svg','g');
    g.setAttribute('class','flag');
    g.setAttribute('transform','rotate(15,' + x + ',' + y + ')');
    
    f = document.createElementNS('http://www.w3.org/2000/svg','rect');
    f.setAttribute('x',x);
    f.setAttribute('y',y - this.scale(1));
    f.setAttribute('height',this.scale(0.5));
    f.setAttribute('width',this.scale(1));
    f.setAttribute('rx',this.scale(0.1));
    f.setAttribute('fill','yellow');
    f.setAttribute('stroke','blue');
    g.appendChild(f);

    f = document.createElementNS('http://www.w3.org/2000/svg','line');
    f.setAttribute('x1',x);
    f.setAttribute('y1',y);
    f.setAttribute('x2',x);
    f.setAttribute('y2',y - this.scale(1));
    //f.setAttribute('fill','red');
    f.setAttribute('stroke','black');
    f.setAttribute('stroke-width','2');
    g.appendChild(f);

    return g;

    f = document.createElementNS('http://www.w3.org/2000/svg','polyline');
    f.setAttribute('points',
		   x          + ',' + y + ' '
		   +  x +       ',' + (y - 20) + ' '
		   + (x + 15) + ',' + (y - 20) + ' '
		   + (x + 15) + ',' + (y - 10) + ' '
		   + (x + 2)  + ',' + (y - 10) + ' '
		   + (x + 2) + ',' + y
		  );
    f.setAttribute('stroke','red');
    f.setAttribute('fill','red');
    
    g.appendChild(f);

    //this.svg.children[0].append(g);
    return g;
}


objGanttChart.prototype.appendVLines = function () {

    var g = document.createElementNS('http://www.w3.org/2000/svg','g');
    g.setAttribute('name', 'vlines');
    var d_0 = new Date(this.getBegin());
    // TODO: align to begin of same week
    //g.setAttribute('transform','translate(' + -this.scale(1/4) + ',' + (0) + ')');
    var j = 0;
    //var y_d = this.y_n + this.scale(6);
    
    // TODO: visible grid in hours, days, weeks, months, years

    for (var t_i = this.getBegin(); t_i < this.getEnd(); t_i += this.unit, j++) {
	//window.console.log('t_i = ' + this.date2grid(t_i) + ' -> ' + this.scale(this.date2grid(t_i)));

	var i = this.date2grid(t_i);
	var x_i = this.scale(i);
	
	var l = document.createElementNS('http://www.w3.org/2000/svg','line');
	l.setAttribute('x1',x_i);
	l.setAttribute('y1',0);
	l.setAttribute('x2',x_i);
	l.setAttribute('y2',this.height);
	l.setAttribute('stroke','rgb(128,128,128)');
	if (j % 4 == 0) {
	    l.setAttribute('stroke-width','.75');
	} else {
	    l.setAttribute('stroke-width','.5');
	}

	var d = new Date(t_i);

	if (this.unit > (1000 * 60 * 60 * 24)) {
	    if (j % 4 == 0) {
		var g_text = document.createElementNS('http://www.w3.org/2000/svg','g');
		g_text.setAttribute('transform','translate(' + (this.scale(i + 0.75)) + ' ' + this.scale(3.5) + ')');
		tx = document.createElementNS('http://www.w3.org/2000/svg','text');
		tx.setAttribute('transform','rotate(-90)');
		tx.appendChild(document.createTextNode(d.getWeek(1)));
		g_text.appendChild(tx);
		g.appendChild(g_text);
	    }
	} else {
	    tx.appendChild(document.createTextNode(d.getDateString()));
	}
	

	//tt = document.createElementNS('http://www.w3.org/2000/svg','title');
	//tt.appendChild(document.createTextNode(i));
	//l.appendChild(tt);
	g.append(l);
    }    
    this.svg.prepend(g);
    this.y_n += this.scale(4);
}


objGanttChart.prototype.appendHLines = function () {

    var g = document.createElementNS('http://www.w3.org/2000/svg','g');
    g.setAttribute('name', 'hlines');
    g.setAttribute('transform','translate(' + 0 + ',' + this.scale(1/4) + ')');
    
    var j = Math.floor(this.height / this.scale()) + 1
    window.console.log('hlines: ' + j);
    
    for (i = 0; i < j; i++) {
	var l = document.createElementNS('http://www.w3.org/2000/svg','line');
	l.setAttribute('x1','0');
	l.setAttribute('y1',this.scale(i));
	l.setAttribute('x2',this.scale(this.date2grid(this.getEnd())));
	l.setAttribute('y2',this.scale(i));
	l.setAttribute('stroke','rgb(128,128,128)');
	l.setAttribute('stroke-width','.5');
	g.append(l);
    }    
    this.svg.prepend(g);
}



//
// 
//
objGanttChart.prototype.parseIcsInput = function(strInput) {

    const lines = strInput.split('\n');
    const events = [];
    let event;
    
    for (let i = 0; i < lines.length; i++) {
	const line = lines[i].trim();
	if (line === 'BEGIN:VEVENT') {
	    event = {};
	} else if (line === 'END:VEVENT') {
	    if (event.hasOwnProperty('SUMMARY') && event.hasOwnProperty('DTSTART') && event.hasOwnProperty('DTEND')) {
		events.push(event);
	    }
	} else if (event) {
	    const match = /^([A-Z]+)(;[A-Z]+=[A-Z]+)*:(.*)$/.exec(line);
	    if (match) {
		if (match[1] == 'DTSTART' || match[1] == 'DTEND' || match[1] == 'SUMMARY') {
		    event[match[1]] = match[3];
		}
	    }
	}
    }
    window.console.log('ICS events: ', events);
    
    return events;
}


objGanttChart.prototype.appendForm = function (strInput) {

    // TODO: textarea for input of CSV
}


objGanttChart.prototype.getCsvForm = function (strInput) {

    // TODO: get input of CSV textarea
}


objGanttChart.prototype.getCsvOutput = function (strInput) {

    // TODO: format this.item as CSV
}


objGanttChart.prototype.parseCsvInput = function (strInput) {

    var s = new String(strInput);
    var listResult = new Array();
    
    var a = s.split(/\r*\n/);
    
    window.console.log('Lines ' + a.length);

    for (var i=0; i < a.length; i++) {
	var l = new String(a[i]);
	
	var c = l.split(/[;,\t]/);
	
	//window.console.log('Cells ' + c.length);

	if (c.length == 3 && c[0].length > 0 && c[1].length > 0) {
	    listResult.push({dt_0: c[0], dt_1: c[1], title: c[2]});
	} else if (c.length == 3 && c[0].length > 0) {
	    listResult.push({dt_0: c[0], title: c[2]});
	}
    }
    window.console.log('Result ' + listResult.toString());

    return listResult;
}


objGanttChart.prototype.getInput = function (strUrl) {

    // https://wiki.selfhtml.org/wiki/JavaScript/XMLHttpRequest
    
    var self = this;
    
    var request = new XMLHttpRequest();

    request.open("GET", strUrl, false);
    
    request.addEventListener('load', function(event) {
	
	if (request.status >= 200 && request.status < 300) {
	    if (request.responseText === undefined || request.responseText.length < 1) {
		window.console.warn('empty content:' + strUrl);
	    } else {
		var list;

		//console.log(request.responseText);
		try {
		    list = JSON.parse(request.responseText); // try to parse as JSON first

		    if (list === undefined) {
			window.console.error('JSON ' + request.responseText + '');
		    } else if (list.length < 1) {
			window.console.error('empty JSON ' + request.responseText + '');
		    } else {
			//self.clean();
			self.append(list);
			//self.draw();
		    }
		} catch (e) {
		    window.console.error('JSON.parse(' + e + ')');

		    list = self.parseIcsInput(request.responseText); // try to parse as ICS

		    if (list === undefined || list.length < 1) {
			window.console.error('empty ICS ' + request.responseText + '');

			list = self.parseCsvInput(request.responseText); // try to parse as CSV
			if (list === undefined || list.length < 1) {
			    window.console.error('empty CSV ' + request.responseText + '');
			} else {
			    //self.clean();
			    self.append(list);
			    //self.draw();
			}
		    } else {
			//self.clean();
			self.append(list);
			//self.draw();
		    }
		}
	    }
	} else {
	    window.console.warn(request.statusText, request.responseText);
	}
    });
    
    request.send();    
}

