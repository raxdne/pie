//
// myGanttChart (p) 2021,2022 A. Tenbusch
//

// s. https://developer.mozilla.org/en-US/docs/Web/SVG

function objGanttChart (strId, argW, argH, grid) {

    this.box = new Array();

    this.items = new Array();
    
    this.grid = grid;

    this.h = argH * this.grid;
    this.w = argW * this.grid;
    
    this.y_n = - this.grid / 2;

    this.flagCompress = false;
	
    this.barbackground = '#aaffaa';

    this.id = strId;
    this.svg = document.getElementById(this.id);

    this.clean();
    
    var dT = new DataTransfer();

    //https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent/ClipboardEvent
    var evt = new ClipboardEvent('paste', {clipboardData: dT});
    
    //window.console.log('clipboardData available: ', evt.clipboardData);

    var self = this;

    document.onpaste = function(e) {

	var s = e.clipboardData.getData('text/plain');

	if (s == undefined || s == '') {
	    window.console.log('onpaste: ', 'undefined');
	} else {
	    window.console.log('onpaste: ', s);
	    self.append(self.parseInput(s));
	    // TODO: check self.isHistogram()
	    //self.appendHistogram();
	    self.clean();
	    self.reDraw();
	}
    };
    
    document.dispatchEvent(evt);
    
    return this;
}


objGanttChart.prototype.clean = function () {

    this.svg = document.getElementById(this.id);
    if (this.svg == undefined) {
	window.console.warn('No SVG element found!');
    } else {
	window.console.log('SVG id is ' + this.id);
	
	this.y_n = - this.grid / 2;

	if (this.svg.children == undefined || this.svg.children.length < 1) {
	    window.console.log('No SVG child to remove!');
	} else {
	    while (this.svg.firstChild) {
		// Remove elements from DOM
		this.svg.removeChild(this.svg.firstChild);
	    }
	}

	var g = document.createElementNS('http://www.w3.org/2000/svg','g');
	//g.setAttribute('transform','scale(0.5)');
	this.svg.appendChild(g);

	var s = document.createElementNS('http://www.w3.org/2000/svg','style');
	s.setAttribute('type',"text/css");
	s.appendChild(document.createTextNode('svg { font-family: Arial; font-size: ' + this.grid / 2 + 'pt; }'));
	this.svg.appendChild(s);

	window.console.log(this.svg);
    }

    return this;
}


objGanttChart.prototype.switchCompress = function (fArg) {

    if (fArg == undefined) {
	this.flagCompress = ! this.flagCompress;
    } else {
	this.flagCompress = fArg;
    }
    console.log('flagCompress: ', this.flagCompress);
    
    return this.flagCompress;
}


objGanttChart.prototype.addLabel = function (argT,argStr) {

    var g = document.createElementNS('http://www.w3.org/2000/svg','g');
    g.setAttribute('transform','rotate(-90,' + ((argT) * this.grid - 4) + ',' + (this.grid / 2) + ')');
    //g.setAttribute('transform','rotate(-90)');

    tx = document.createElementNS('http://www.w3.org/2000/svg','text');
    tx.setAttribute('x', (argT - 4) * this.grid + 1);
    tx.setAttribute('y', this.grid / 2);

    //tx.setAttribute('x', 0);
    //tx.setAttribute('y', 0);
    
    tx.appendChild(document.createTextNode(argStr));
    g.appendChild(tx);

    this.svg.children[0].prepend(g);
    
    return this;
}


objGanttChart.prototype.appendVBar = function (argT,argL,argTitle,argColor) {

    window.console.log('vbar ' + argT);
    
    f = document.createElementNS('http://www.w3.org/2000/svg','rect');
    f.setAttribute('x',(argT - 1) * this.grid);
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

    if (argY === undefined) {
	this.svg.children[0].setAttribute('transform','translate(' + (argX * this.grid) + ',' + (0) + ')');
    } else {
	this.svg.children[0].setAttribute('transform','translate(' + (argX * this.grid) + ',' + (argY * this.grid) + ')');
    }
    
    return this;
}


objGanttChart.prototype.append = function () {

    for (var i = 0; i < arguments.length; i++) {
	if (typeof arguments[i] === 'object') {
	    this.items.push(arguments[i]);
	}
    }	

    //window.console.log(arguments);
    return this;
}


objGanttChart.prototype.reDraw = function() {

    if (arguments.length < 1) {
	this.clean();
	this.reDraw(this.items);
	//this.appendHLines();
	this.appendVLines();

	return this;
    }
    
    for (var i = 0; i < arguments.length; i++) {

	var li = arguments[i];
    
	// TODO: image??
	
	if (this.flagCompress && li.hasOwnProperty("done") && li.done) {
	    continue;	    
	} else if (typeof li === 'object' && li instanceof Array) {
	    window.console.log('Array');
	    for (var j = 0; j < li.length; j++) {
		this.reDraw(li[j]);
	    }
	} else if (typeof li === 'object' && (li.hasOwnProperty("start") || li.hasOwnProperty("end")) && li.hasOwnProperty("title")) {

	    var g = document.createElementNS('http://www.w3.org/2000/svg','g');

	    if (li.hasOwnProperty("url")) {
		a = document.createElementNS('http://www.w3.org/2000/svg','a');
		a.setAttribute('href', li.url);
		a.setAttribute('target', 'blank');
		g.appendChild(a);
		g = a;
	    }

	    var t = (li.start - 1) * this.grid;
	    
	    if (li.hasOwnProperty("end") || li.hasOwnProperty("length")) {
		
		window.console.log('bar');

		var l;
		if (li.hasOwnProperty("length")) {
		    if (li.hasOwnProperty("start")) {
			li.end = li.start + li.length;
		    } else {
			li.start = li.end - li.length + 1;
		    }
		    l = li.length * this.grid;
		} else {
		    l = (li.end - li.start + 1) * this.grid;
		}
		t = (li.start - 1) * this.grid;
		
		for (var k = li.start; k <= li.end; k++) {
		    if (this.box[k] === undefined) {
			this.box[k] = 1;
		    } else {
			this.box[k]++;
		    }
		}

		// BUG: use current week
		if ( li.start <= 60 && li.end >= 60) {
		} else if (this.flagCompress) {
		    continue;
		}
		
		var h = this.grid;
		if (li.hasOwnProperty("height") && li.height > 1) {
		    h = li.height  * this.grid;
		} else {
		    h = this.grid;
		}

		if (li.hasOwnProperty("newline") && li.newline == false && this.flagCompress == false) {
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
		
		if (li.hasOwnProperty("opacity")) {
		    f.setAttribute('opacity',li.opacity);
		} else {
		    f.setAttribute('opacity',0.6);
		}
		
		var tip = li.title + ' (' + (t / this.grid) + ',' + (l / this.grid) +')';
		if (li.hasOwnProperty("tip")) {
		    tip += ', ' + li.tip;
		}

		tt = document.createElementNS('http://www.w3.org/2000/svg','title');
		tt.appendChild(document.createTextNode(tip));
		f.appendChild(tt);
		
		g.appendChild(f);

		//this.appendFlag(t+l-10,this.y_n + this.grid - 5);

		tx = document.createElementNS('http://www.w3.org/2000/svg','text');
		tx.setAttribute('x', t + 4);
		tx.setAttribute('y',this.y_n + this.grid - 5);
		tx.appendChild(document.createTextNode(li.title));
		
		g.appendChild(tx);

		if (h > this.grid) {
		    this.y_n += h - this.grid;
		}

	    } else {

		window.console.log('milestone');

		t += this.grid / 2;
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
		//tx.appendChild(document.createTextNode(li.title + ' (' + li.start + ')'));
		tx.appendChild(document.createTextNode(li.title));
		
		g.appendChild(tx);
	    }
	    
	    if (li.hasOwnProperty("color")) {
		f.setAttribute('fill',li.color);
	    }

	    f.setAttribute('stroke-width','.5');
	    
	    if (li.hasOwnProperty("url")) {
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

	} else if (typeof li === 'object' && li.hasOwnProperty("color")) {

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
     
	    this.barbackground = li.color;

	} else if (typeof li === 'object' && li.hasOwnProperty("posx") && li.hasOwnProperty("url")) {
	    
	    window.console.log('link');
	    
	    var g = document.createElementNS('http://www.w3.org/2000/svg','g');

	    a = document.createElementNS('http://www.w3.org/2000/svg','a');
	    a.setAttribute('href', li.url);
	    a.setAttribute('target', 'blank');
	    a.setAttribute('fill','#0000ff');
	    
	    g.appendChild(a);
	    g = a;
	    
	    var x = li.posx * this.grid + this.grid / 3;
	    
	    var y;
	    if (li.hasOwnProperty("posy")) {
		y = li.posy * this.grid;
	    } else {
		y = this.y_n + 1.5 * this.grid;
	    }

	    tx = document.createElementNS('http://www.w3.org/2000/svg','text');
	    tx.setAttribute('x', x);
	    tx.setAttribute('y', y);
	    tx.setAttribute('text-decoration', 'underline');
	    tx.appendChild(document.createTextNode(li.title));
	    
	    g.appendChild(tx);
	    this.svg.children[0].appendChild(g);

	} else {
	}
	
	if (li.hasOwnProperty("done") && li.done) {
	    g.appendChild(this.getDone(t+l-5,this.y_n + 0.2 * this.grid));
	} else if (li.hasOwnProperty("flag") && li.flag) {
	    g.appendChild(this.getFlag(t+l-5,this.y_n + 0.2 * this.grid));
	}
		
	this.h = this.y_n + 2 * this.grid;
    }
    
    window.console.log('items: ' + this.items.toString());

    return this;
}


objGanttChart.prototype.toString = function() {
    
    //window.console.log(this.items);

    return this.items;
}


objGanttChart.prototype.getDone = function(x,y) {

    var g = document.createElementNS('http://www.w3.org/2000/svg','g');
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


objGanttChart.prototype.getFlag = function(x,y) {

    var g = document.createElementNS('http://www.w3.org/2000/svg','g');
    g.setAttribute('transform','rotate(15,' + x + ',' + y + ')');

    //return g;
    
    f = document.createElementNS('http://www.w3.org/2000/svg','rect');
    f.setAttribute('x',x);
    f.setAttribute('y',y-20);
    f.setAttribute('height',10);
    f.setAttribute('width',15);
    f.setAttribute('rx',1);
    f.setAttribute('fill','red');
    //f.setAttribute('stroke','blue');
    g.appendChild(f);

    f = document.createElementNS('http://www.w3.org/2000/svg','line');
    f.setAttribute('x1',x);
    f.setAttribute('y1',y);
    f.setAttribute('x2',x);
    f.setAttribute('y2',y-22);
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


objGanttChart.prototype.appendHistogram = function () {

    var g = document.createElementNS('http://www.w3.org/2000/svg','g');

    var threshold = 19;
    var scale = 3;
    
    for (var k = 0; k < this.box.length; k++) {
	if (this.box[k] === undefined) {
	    // ignore
	} else {
	    //c.addLabel(k,this.box[k]);

	    var f = document.createElementNS('http://www.w3.org/2000/svg','rect');
	    f.setAttribute('x', (k - 1) * this.grid + 1);
	    f.setAttribute('y', 0);
	    f.setAttribute('height',this.box[k] * scale);
	    f.setAttribute('width',this.grid - 2);
	    //f.setAttribute('stroke','#000000');
	    //f.setAttribute('stroke-width','.5');
	    f.setAttribute('opacity','.5');

	    f.setAttribute('fill', (this.box[k] > threshold) ? '#ff8888' : '#8888cc');

	    var t = document.createElementNS('http://www.w3.org/2000/svg','title');
	    t.appendChild(document.createTextNode(this.box[k]));
	    f.appendChild(t);
	    
	    g.append(f);
	}
    }	

    l = document.createElementNS('http://www.w3.org/2000/svg','line');
    l.setAttribute('x1', 0);
    l.setAttribute('y1', threshold * scale);
    l.setAttribute('x2', this.w);
    l.setAttribute('y2', threshold * scale);

    l.setAttribute('stroke','#8888cc');
    l.setAttribute('stroke-width','1');
    
    g.append(l);
    
    this.svg.children[0].prepend(g);
}


objGanttChart.prototype.appendVLines = function () {

    for (i = Math.floor(this.w / this.grid); i > -1; i--) {
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

    for (i = Math.floor(this.h / this.grid); i > -1; i--) {
	l = document.createElementNS('http://www.w3.org/2000/svg','line');
	l.setAttribute('x1','0');
	l.setAttribute('y1',i * this.grid);
	l.setAttribute('x2',this.w);
	l.setAttribute('y2',i * this.grid);
	if (i % 4 == 0) {
	    l.setAttribute('stroke','rgb(128,128,128)');
	    //l.setAttribute('stroke-width','.5');
	} else {
	    l.setAttribute('stroke','rgb(128,128,128)');
	    l.setAttribute('stroke-width','.5');
	}

	//tt = document.createElementNS('http://www.w3.org/2000/svg','title');
	//tt.appendChild(document.createTextNode(i));
	//l.appendChild(tt);

	this.svg.children[0].prepend(l);
    }    
}


objGanttChart.prototype.parseInput = function (strInput) {

    var s = new String(strInput);
    var listResult = new Array();
    
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

    request.open("GET", strUrl, false);
    
    request.addEventListener('load', function(event) {
	if (request.status >= 200 && request.status < 300) {
	    if (request.responseText == undefined || request.responseText.length < 1) {
		window.console.error('empty ' + request.responseText);
	    } else {
		var list;

		try {
		    list = JSON.parse(request.responseText); // try to parse as JSON first

		    if (list == undefined) {
			window.console.error('JSON ' + request.responseText + '');
		    } else if (list.length < 1) {
			window.console.error('empty JSON ' + request.responseText + '');
		    } else {
			self.append(list);
		    }
		} catch (e) {
		    window.console.error('JSON.parse(' + e + ')');

		    list = self.parseInput(request.responseText); // try to parse as CSV
			
		    if (list == undefined) {
			window.console.error('CSV format');
		    } else if (list.length < 1) {
			window.console.error('empty CSV ' + request.responseText + '');
		    } else {
			self.append(list);
			self.clean();
			self.reDraw();
		    }
		}
	    }
	} else {
	    window.console.warn(request.statusText, request.responseText);
	}
    });
    
    request.send();    
}


