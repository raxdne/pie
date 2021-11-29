//
//
//

function objGanttChart (strId, argW, argH) {

    this.h = argH;
    this.w = argW * 20;
    
    this.dy = 20;
    this.y_n = - this.dy / 2;

    this.barbackground = '#aaffaa';
    
    this.svg = document.getElementById(strId);
    if (this.svg == undefined) {
	window.console.log('ERROR: No SVG element found!');
    } else {
	this.svg.setAttribute('height',this.h);
	this.svg.setAttribute('width',this.w);
	var g = document.createElementNS('http://www.w3.org/2000/svg','g');
	g.setAttribute('transform','scale(1)');
	this.svg.appendChild(g);

	var s = document.createElementNS('http://www.w3.org/2000/svg','style');
	s.setAttribute('type',"text/css");
	s.appendChild(document.createTextNode('svg { font-family: Arial; font-size: 10pt; }'));
	this.svg.appendChild(s);

	window.console.log(this.svg);
    }
    
    return this;
}


objGanttChart.prototype.fixDate = function (argT,argDate) {

    f = document.createElementNS('http://www.w3.org/2000/svg','rect');
    f.setAttribute('x',argT * 10);
    f.setAttribute('y',0);
    f.setAttribute('height',this.h);
    f.setAttribute('width',10);
    f.setAttribute('stroke','#000000');
    f.setAttribute('stroke-width','.25');		
    f.setAttribute('fill','#ffaaaa');

    t = document.createElementNS('http://www.w3.org/2000/svg','title');
    t.appendChild(document.createTextNode(argDate));
    f.appendChild(t);
    
    this.svg.children[0].appendChild(f);
    
    return this;
}


objGanttChart.prototype.addLabel = function (argT,argStr) {

    tx = document.createElementNS('http://www.w3.org/2000/svg','text');
    tx.setAttribute('x', argT * 10 + 1);
    tx.setAttribute('y', this.dy / 2 + 1);
    tx.appendChild(document.createTextNode(argStr));
    
    this.svg.children[0].appendChild(tx);
    
    return this;
}


objGanttChart.prototype.excludeDate = function (argT,argL,argDate) {

    f = document.createElementNS('http://www.w3.org/2000/svg','rect');
    f.setAttribute('x',argT * 10);
    f.setAttribute('y',0);
    f.setAttribute('height',this.h);
    f.setAttribute('width',argL * 10);
    f.setAttribute('stroke','#000000');
    f.setAttribute('stroke-width','.25');		
    f.setAttribute('fill','#aaaaaa');

    t = document.createElementNS('http://www.w3.org/2000/svg','title');
    t.appendChild(document.createTextNode(argDate));
    f.appendChild(t);
    
    this.svg.children[0].appendChild(f);
    
    return this;
}


objGanttChart.prototype.shift = function (argT) {

    this.svg.children[0].setAttribute('transform','translate(' + (argT * 10) + ',0)');
    
    return this;
}


objGanttChart.prototype.append = function () {

    //window.console.log(objArg);

    for (var i = 0; i < arguments.length; i++) {

	if (typeof arguments[i] === 'object' && arguments[i].hasOwnProperty("start") && arguments[i].hasOwnProperty("title")) {

	    var g = document.createElementNS('http://www.w3.org/2000/svg','g');

	    var t = arguments[i].start;
	    
	    if (arguments[i].hasOwnProperty("end") || arguments[i].hasOwnProperty("length")) {
		window.console.log('bar');

		if ( ! arguments[i].hasOwnProperty("length")) {
		    arguments[i].length = arguments[i].end - arguments[i].start
		}
		
		var h = this.dy;
	    
		if (arguments[i].hasOwnProperty("height") && arguments[i].height * 10 > h) {
		    h = arguments[i].height * 10;
		}

		if (arguments[i].hasOwnProperty("newline") && arguments[i].newline == false) {
		} else {
		    this.y_n += 1.25 * this.dy;
		    this.svg.setAttribute('height',this.y_n + 2 * h);
		}
		
		f = document.createElementNS('http://www.w3.org/2000/svg','rect');
		f.setAttribute('x', t * 10);
		f.setAttribute('y',this.y_n);
		f.setAttribute('height',h);
		f.setAttribute('width',arguments[i].length * 10);
		f.setAttribute('rx',5);
		f.setAttribute('stroke','#000000');
		f.setAttribute('stroke-width','.25');
		
		if (arguments[i].hasOwnProperty("color")) {
		    f.setAttribute('fill',arguments[i].color);
		} else {
		    f.setAttribute('fill',this.barbackground);
		}

		tt = document.createElementNS('http://www.w3.org/2000/svg','title');
		tt.appendChild(document.createTextNode(arguments[i].title + ' (' + t + ',' + arguments[i].length +')'));
		f.appendChild(tt);
		
		g.appendChild(f);

		tx = document.createElementNS('http://www.w3.org/2000/svg','text');
		tx.setAttribute('x', t * 10 + 4);
		tx.setAttribute('y',this.y_n + this.dy - 5);
		tx.appendChild(document.createTextNode(arguments[i].title + ' (' + t + ',' + arguments[i].length +')'));
		
		g.appendChild(tx);

		if (h > this.dy) {
		    this.y_n += h * 0.75;
		}
		
	    } else {
		window.console.log('milestone');

		f = document.createElementNS('http://www.w3.org/2000/svg','polygon');
		f.setAttribute('points',
		               (t * 10)               + ',' + (this.y_n)
			       + ' ' + (t * 10 + this.dy / 2) + ',' + (this.y_n + this.dy / 2)
			       + ' ' + (t * 10)               + ',' + (this.y_n + this.dy)
			       + ' ' + (t * 10 - this.dy / 2) + ',' + (this.y_n + this.dy / 2)
			       + ' ' + (t * 10)               + ',' + (this.y_n));
		f.setAttribute('stroke','#000000');
		f.setAttribute('stroke-width','.25');		
		f.setAttribute('fill','#aaaaff');

		g.appendChild(f);

		f = document.createElementNS('http://www.w3.org/2000/svg','text');
		f.setAttribute('x', t * 10 + this.dy / 2 + 2);
		f.setAttribute('y',this.y_n + this.dy - 5);
		f.appendChild(document.createTextNode(arguments[i].title + ' (' + t + ')'));
		
		g.appendChild(f);
		
	    }
	    
	    if (arguments[i].hasOwnProperty("url")) {
		a = document.createElementNS('http://www.w3.org/2000/svg','a');
		a.setAttribute('href', arguments[i].url);
		a.appendChild(tx);
		
		g.appendChild(a);
	    } 
	    
	    this.svg.children[0].appendChild(g);
	    
	} else if (typeof arguments[i] === 'object' && arguments[i].hasOwnProperty("color")) {
	    this.y_n += 1.75 * this.dy;

	    this.svg.setAttribute('height',this.y_n + 2 * this.dy);

	    // x axis
	    l = document.createElementNS('http://www.w3.org/2000/svg','line');
	    l.setAttribute('x1',0);
	    l.setAttribute('y1',this.y_n );
	    l.setAttribute('x2',this.w);
	    l.setAttribute('y2',this.y_n);
	    l.setAttribute('stroke','#000000');
	    //l.setAttribute('stroke-width','.5');		

	    this.svg.children[0].appendChild(l);
     
	    this.barbackground = arguments[i].color;
	} else {
	} 
    }
    return this;
}


objGanttChart.prototype.appendChart = function () {

    f = document.createElementNS('http://www.w3.org/2000/svg','rect');
    f.setAttribute('x','0');
    f.setAttribute('y','0');
    f.setAttribute('height',this.h);
    f.setAttribute('width',this.w);
    f.setAttribute('stroke','#000000');
    f.setAttribute('fill','#ffffff');
    
    this.svg.children[0].appendChild(f);

    // // x axis
    // l = document.createElementNS('http://www.w3.org/2000/svg','line');
    // l.setAttribute('x1',0);
    // l.setAttribute('y1',5);
    // l.setAttribute('x2',this.w);
    // l.setAttribute('y2',5);
    // l.setAttribute('stroke','#000000');
    //l.setAttribute('stroke-width','.5');		

    //this.svg.children[0].appendChild(l);

    for (i=0; i < this.w; i++) {
	if (i % 10 == 0) {
	    l = document.createElementNS('http://www.w3.org/2000/svg','line');
	    l.setAttribute('x1',i);
	    l.setAttribute('y1','0');
	    l.setAttribute('x2',i);
	    l.setAttribute('y2',this.h);
	    if (i % 50 == 0) {
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
}

