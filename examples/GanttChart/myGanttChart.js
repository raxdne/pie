//
// myGanttChart (p) 2021 A. Tenbusch
//

// s. https://developer.mozilla.org/en-US/docs/Web/SVG

function objGanttChart (strId, argW, argH, grid) {

    this.grid = grid;

    this.h = argH * this.grid;
    this.w = argW * this.grid;
    
    this.y_n = - this.grid / 2;

    this.barbackground = '#aaffaa';
    
    this.svg = document.getElementById(strId);
    if (this.svg == undefined) {
	window.console.log('ERROR: No SVG element found!');
    } else {
	this.svg.setAttribute('height',this.h);
	this.svg.setAttribute('width',this.w);
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


objGanttChart.prototype.addLabel = function (argT,argStr) {

    tx = document.createElementNS('http://www.w3.org/2000/svg','text');
    tx.setAttribute('x', argT * this.grid + 1);
    tx.setAttribute('y', this.grid / 2 + 1);
    tx.appendChild(document.createTextNode(argStr));
    
    this.svg.children[0].prepend(tx);
    
    return this;
}


objGanttChart.prototype.appendVBar = function (argT,argL,argDate) {

    f = document.createElementNS('http://www.w3.org/2000/svg','rect');
    f.setAttribute('x',argT * this.grid);
    f.setAttribute('y',0);
    f.setAttribute('height',this.h);
    f.setAttribute('width',argL * this.grid);
    f.setAttribute('stroke','#000000');
    f.setAttribute('stroke-width','.25');		
    f.setAttribute('fill','#cccccc');
    f.setAttribute('opacity',0.6);

    t = document.createElementNS('http://www.w3.org/2000/svg','title');
    t.appendChild(document.createTextNode(argDate));
    f.appendChild(t);
    
    this.svg.children[0].prepend(f);
    
    return this;
}


objGanttChart.prototype.shift = function (argT) {

    this.svg.children[0].setAttribute('transform','translate(' + (argT * this.grid) + ',0)');
    
    return this;
}


objGanttChart.prototype.append = function () {

    // TODO: image??
    
    for (var i = 0; i < arguments.length; i++) {

	if (typeof arguments[i] === 'object' && arguments[i].hasOwnProperty("start") && arguments[i].hasOwnProperty("title")) {

	    var g = document.createElementNS('http://www.w3.org/2000/svg','g');

	    if (arguments[i].hasOwnProperty("url")) {
		a = document.createElementNS('http://www.w3.org/2000/svg','a');
		a.setAttribute('href', arguments[i].url);
		a.setAttribute('target', 'blank');
		g.appendChild(a);
		g = a;
	    }

	    var t = arguments[i].start * this.grid;
	    
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
		tt.appendChild(document.createTextNode(arguments[i].title + ' (' + t + ',' + arguments[i].length +')'));
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
    return this;
}


objGanttChart.prototype.appendVLines = function () {

    for (i=0; i < this.w; i+=this.grid) {
	l = document.createElementNS('http://www.w3.org/2000/svg','line');
	l.setAttribute('x1',i);
	l.setAttribute('y1','0');
	l.setAttribute('x2',i);
	l.setAttribute('y2',this.h);
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
	this.svg.children[0].appendChild(l);
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
	this.svg.children[0].appendChild(l);
    }    
}

