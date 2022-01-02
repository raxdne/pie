//
// myGanttChart (p) 2021 A. Tenbusch
//

// s. https://developer.mozilla.org/en-US/docs/Web/SVG

function objGanttChart (strId, argW, argH, grid) {

    var self = this;
    
    self.grid = grid;

    self.h = argH * self.grid;
    self.w = argW * self.grid;
    
    self.y_n = - self.grid / 2;

    self.barbackground = '#aaffaa';
    
    self.svg = document.getElementById(strId);
    if (self.svg == undefined) {
	window.console.log('ERROR: No SVG element found!');
    } else {
	self.svg.setAttribute('height',self.h);
	self.svg.setAttribute('width',self.w);
	var g = document.createElementNS('http://www.w3.org/2000/svg','g');
	//g.setAttribute('transform','scale(0.5)');
	self.svg.appendChild(g);

	var s = document.createElementNS('http://www.w3.org/2000/svg','style');
	s.setAttribute('type',"text/css");
	s.appendChild(document.createTextNode('svg { font-family: Arial; font-size: ' + self.grid / 2 + 'pt; }'));
	self.svg.appendChild(s);

	window.console.log(self.svg);
    }

    var dT = new DataTransfer();

    //https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent/ClipboardEvent
    var evt = new ClipboardEvent('paste', {clipboardData: dT});
    
    //console.log('clipboardData available: ', evt.clipboardData);

    document.onpaste = function(e) {

	var s = e.clipboardData.getData('text/plain');

	if (s == undefined || s == '') {
	    console.log('onpaste: ', 'undefined');
	} else {
	    console.log('onpaste: ', s);
	    self.append(self.parseInput(s));
	}
    };
    
    document.dispatchEvent(evt);
    
    return self;
}


objGanttChart.prototype.addLabel = function (argT,argStr) {

    tx = document.createElementNS('http://www.w3.org/2000/svg','text');
    tx.setAttribute('x', argT * this.grid + 1);
    tx.setAttribute('y', this.grid / 2 + 1);
    tx.appendChild(document.createTextNode(argStr));
    
    this.svg.children[0].prepend(tx);
    
    return this;
}


objGanttChart.prototype.appendVBar = function (argT,argL,argTitle,argColor) {

    window.console.log('vbar ' + argT);
    
    f = document.createElementNS('http://www.w3.org/2000/svg','rect');
    f.setAttribute('x',argT * this.grid);
    f.setAttribute('y',0);
    f.setAttribute('height',this.h);
    f.setAttribute('width',argL * this.grid);
    f.setAttribute('stroke','#000000');
    f.setAttribute('stroke-width','.25');
    if (argColor === undefined || argColor == "") {
	f.setAttribute('fill','#cccccc');
    } else {
	f.setAttribute('fill',argColor);
    }
    f.setAttribute('opacity',0.6);

    if (argTitle === undefined || argTitle == "") {
    } else {
	t = document.createElementNS('http://www.w3.org/2000/svg','title');
	t.appendChild(document.createTextNode(argTitle));
	f.appendChild(t);
    }
    
    this.svg.children[0].prepend(f);
    
    return this;
}


objGanttChart.prototype.shift = function (argX, argY) {

    this.svg.children[0].setAttribute('transform','translate(' + (argX * this.grid) + ',' + (argY * this.grid) + ')');
    
    return this;
}


objGanttChart.prototype.append = function () {

    // TODO: image??
    
    for (var i = 0; i < arguments.length; i++) {
	
	if (typeof arguments[i] === 'object' && arguments[i] instanceof Array) {
	    window.console.log('Array');
	    for (var j = 0; j < arguments[i].length; j++) {
		this.append(arguments[i][j]);
	    }
	} else if (typeof arguments[i] === 'object' && arguments[i].hasOwnProperty("start") && arguments[i].hasOwnProperty("title")) {

	    var g = document.createElementNS('http://www.w3.org/2000/svg','g');

	    if (arguments[i].hasOwnProperty("url")) {
		a = document.createElementNS('http://www.w3.org/2000/svg','a');
		a.setAttribute('href', arguments[i].url);
		a.setAttribute('target', 'blank');
		g.appendChild(a);
		g = a;
	    }

	    var t = (arguments[i].start - 1) * this.grid;
	    
	    if (arguments[i].hasOwnProperty("end") || arguments[i].hasOwnProperty("length")) {
		
		window.console.log('bar');

		var l;
		if (arguments[i].hasOwnProperty("length")) {
		    l = arguments[i].length * this.grid;
		} else {
		    l = (arguments[i].end - arguments[i].start + 1) * this.grid;
		}
	    
		var h = this.grid;
		if (arguments[i].hasOwnProperty("height") && arguments[i].height > 1) {
		    h = arguments[i].height  * this.grid;
		} else {
		    h = this.grid;
		}

		if (arguments[i].hasOwnProperty("newline") && arguments[i].newline == false) {
		} else {
		    this.y_n += 1.35 * this.grid;
		    this.svg.setAttribute('height',this.y_n + 2 * h);
		}
		
		f = document.createElementNS('http://www.w3.org/2000/svg','rect');
		f.setAttribute('x',t);
		f.setAttribute('y',this.y_n);
		f.setAttribute('height',h);
		f.setAttribute('width',l);
		f.setAttribute('rx',5);
		f.setAttribute('fill',this.barbackground);
		
		if (arguments[i].hasOwnProperty("opacity")) {
		    f.setAttribute('opacity',arguments[i].opacity);
		} else {
		    f.setAttribute('opacity',0.6);
		}
		
		tt = document.createElementNS('http://www.w3.org/2000/svg','title');
		tt.appendChild(document.createTextNode(arguments[i].title + ' (' + (t / this.grid) + ',' + (l / this.grid) +')'));
		f.appendChild(tt);
		
		g.appendChild(f);

		tx = document.createElementNS('http://www.w3.org/2000/svg','text');
		tx.setAttribute('x', t + 4);
		tx.setAttribute('y',this.y_n + this.grid - 5);
		tx.appendChild(document.createTextNode(arguments[i].title));
		
		g.appendChild(tx);

		if (h > this.grid) {
		    this.y_n += h - this.grid;
		}
		
	    } else {

		window.console.log('milestone');

		t -= this.grid / 2;
		f = document.createElementNS('http://www.w3.org/2000/svg','polygon');
		f.setAttribute('points',
		               (t)               + ',' + (this.y_n)
			       + ' ' + (t + this.grid / 2) + ',' + (this.y_n + this.grid / 2)
			       + ' ' + (t)               + ',' + (this.y_n + this.grid)
			       + ' ' + (t - this.grid / 2) + ',' + (this.y_n + this.grid / 2)
			       + ' ' + (t)               + ',' + (this.y_n));
		f.setAttribute('fill','#aaaaff');

		g.appendChild(f);

		tx = document.createElementNS('http://www.w3.org/2000/svg','text');
		tx.setAttribute('x', t + this.grid / 2 + 2);
		tx.setAttribute('y',this.y_n + this.grid - 5);
		tx.appendChild(document.createTextNode(arguments[i].title + ' (' + arguments[i].start + ')'));
		
		g.appendChild(tx);		
	    }
	    
	    if (arguments[i].hasOwnProperty("color")) {
		f.setAttribute('fill',arguments[i].color);
	    }

	    f.setAttribute('stroke-width','.5');
	    
	    if (arguments[i].hasOwnProperty("url")) {
		f.setAttribute('stroke','#0000ff');
	    } else {
		f.setAttribute('stroke','#000000');
	    }
	    
	    this.svg.children[0].appendChild(g);

	    var w = t + l;
	    if (this.svg.getAttribute('width') < w) { // extend SVG width if neccesary
		this.w = w + this.grid;
	    	this.svg.setAttribute('width',this.w);
	    }

	} else if (typeof arguments[i] === 'object' && arguments[i].hasOwnProperty("color")) {

	    this.y_n += 1.5 * this.grid;

	    this.svg.setAttribute('height',this.y_n + 2 * this.grid);

	    // x axis
	    l = document.createElementNS('http://www.w3.org/2000/svg','line');
	    l.setAttribute('x1',0);
	    l.setAttribute('y1',this.y_n );
	    l.setAttribute('x2',this.w);
	    l.setAttribute('y2',this.y_n);
	    l.setAttribute('stroke','#000000');
	    //l.setAttribute('stroke-width','.5');		

	    this.svg.children[0].appendChild(l);

	    this.y_n -= 0.5 * this.grid; // 
     
	    this.barbackground = arguments[i].color;

	} else if (typeof arguments[i] === 'object' && arguments[i].hasOwnProperty("posx") && arguments[i].hasOwnProperty("url")) {
	    
	    window.console.log('link');
	    
	    var g = document.createElementNS('http://www.w3.org/2000/svg','g');

	    a = document.createElementNS('http://www.w3.org/2000/svg','a');
	    a.setAttribute('href', arguments[i].url);
	    a.setAttribute('target', 'blank');
	    a.setAttribute('fill','#0000ff');
	    
	    g.appendChild(a);
	    g = a;
	    
	    var x = arguments[i].posx * this.grid + this.grid / 3;
	    
	    var y;
	    if (arguments[i].hasOwnProperty("posy")) {
		y = arguments[i].posy * this.grid;
	    } else {
		y = this.y_n + this.grid - 5;
	    }

	    tx = document.createElementNS('http://www.w3.org/2000/svg','text');
	    tx.setAttribute('x', x);
	    tx.setAttribute('y', y);
	    tx.setAttribute('text-decoration', 'underline');
	    tx.appendChild(document.createTextNode(arguments[i].title));
	    
	    g.appendChild(tx);
	    this.svg.children[0].appendChild(g);

	} else {
	}
	
	this.h = this.y_n + 2 * this.grid;
    }
    
    window.console.log(arguments);
    return this;
}


objGanttChart.prototype.appendVLines = function () {

    for (i=0; i < this.w; i++) {
	l = document.createElementNS('http://www.w3.org/2000/svg','line');
	l.setAttribute('x1',i * this.grid);
	l.setAttribute('y1','0');
	l.setAttribute('x2',i * this.grid);
	l.setAttribute('y2',this.h);
	if (i % 4 == 0) {
	    l.setAttribute('stroke','rgb(128,128,128)');
	    //l.setAttribute('stroke-width','.5');
	} else {
	    l.setAttribute('stroke','rgb(128,128,128)');
	    l.setAttribute('stroke-width','.5');
	}

	tt = document.createElementNS('http://www.w3.org/2000/svg','title');
	tt.appendChild(document.createTextNode(i));
	l.appendChild(tt);

	this.svg.children[0].prepend(l);
    }    
}

objGanttChart.prototype.appendHLines = function () {

    for (i=0; i < this.h; i+=this.grid) {
	l = document.createElementNS('http://www.w3.org/2000/svg','line');
	l.setAttribute('x1',0);
	l.setAttribute('y1',i);
	l.setAttribute('x2',this.w);
	l.setAttribute('y2',i);
	if (i % 80 == 0) {
	    l.setAttribute('stroke','rgb(0,0,0)');
	    l.setAttribute('stroke-width','.5');

	    t = document.createElementNS('http://www.w3.org/2000/svg','title');
	    t.appendChild(document.createTextNode(i/10));
	    l.appendChild(t);
	} else {
	    l.setAttribute('stroke','rgb(128,128,128)');
	    l.setAttribute('stroke-width','.25');
	}
	this.svg.children[0].prepend(l);
    }    
}


objGanttChart.prototype.parseInput = function (strInput) {

    var s = new String(strInput);
    var listResult = [];
    
    var a = s.split(/\r*\n/);
    
    window.console.log('Lines ' + a.length);

    for (var i=0; i < a.length; i++) {
	var l = new String(a[i]);
	
	var c = l.split(/[;,\t]/);
	
	window.console.log('Cells ' + c.length);

	if (c.length == 3) {
	    listResult.push({start: c[0], end: c[1], title: c[2]});
	    //this.append({start: c[0], end: c[1], title: c[2]});
	}
    }
    //window.console.log('Result ' + listResult.toString());

    return listResult;
}


objGanttChart.prototype.getInput = function (strUrl) {

    // https://wiki.selfhtml.org/wiki/JavaScript/XMLHttpRequest
    
    var self = this;
    
    var request = new XMLHttpRequest();

    request.open("GET", strUrl);
    //request.setRequestHeader("X-Test","test1");
    //request.setRequestHeader("X-Test","test2");
    
    request.addEventListener('load', function(event) {
	if (request.status >= 200 && request.status < 300) {
	    console.log(request.responseType + ':' + request.responseText);
	    // TODO: check request.responseType
	    if (request.responseType == "text") {
		self.append(self.parseInput(request.responseText));
	    } else if (request.responseType == "json") {
		self.append(JSON.parse(request.responseText));
	    } else {
		self.append(self.parseInput(request.responseText));
	    }
	} else {
	    console.warn(request.statusText, request.responseText);
	}
    });
    
    request.send();    
}


