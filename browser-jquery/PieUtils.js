
//
// http://www.tek-tips.com/viewthread.cfm?qid=1459948
//
function validateXML(xmlString) {
    try {
        if (document.implementation.createDocument) {
            var parser = new DOMParser();
            var myDocument = parser.parseFromString(xmlString, "text/xml");
            with (myDocument.documentElement) {
                if (tagName=="parseerror" ||
                    namespaceURI=="http://www.mozilla.org/newlayout/xml/parsererror.xml") {
                    alert("Failed the test of well-formedness.");
                    return false
                }
            }
        } else if (window.ActiveXObject) {
            var myDocument = new ActiveXObject("Microsoft.XMLDOM")
            myDocument.async = false
            var nret=myDocument.loadXML(xmlString);
            if (!nret) {
                alert("Failed the test of well-formedness.");
                return false
            }
        }
    } catch(e) {
        alert(e);
        return true    // maybe the user-agent does not support both, then it should be submitted and let server-side validation does the job
    }
    putsConsole("Passed the test of XML well-formedness.")
    return true
}


//
// returns a XML conformant string
//
function getXmlConformStr (strArg) {

    var strResult = strArg;

    //strResult = strResult.replace(/"/gi,'&quot;');
    strResult = strResult.replace(/\&/gi,'&amp;');
    strResult = strResult.replace(/</gi,'&lt;');
    strResult = strResult.replace(/>/gi,'&gt;');

    return strResult;
}


//
// returns a XMLHttpRequest
//
function getXMLHttpRequest() 
{
    var xmlHttp = null;

    if (window.XMLHttpRequest) {
        xmlHttp = new window.XMLHttpRequest;
    }
    else {
        try {
            xmlHttp = new ActiveXObject("MSXML2.XMLHTTP.3.0");
        }
        catch(ex) {
	    //
        }
    }

    return xmlHttp;
}


//
// portable console log
//
function putsConsole (strMessage)
{
    if (window.console) {
	window.console.log(strMessage);
    }
    else {
	// ignore strMessage
    }
}


//
// http://unixpapa.com/js/querystring.html
//
function RFC1738Decode(s)
{
    s= s.replace(/%([EF][0-9A-F])%([89AB][0-9A-F])%([89AB][0-9A-F])/gi,
        function(code,hex1,hex2,hex3)
        {
            var n1= parseInt(hex1,16)-0xE0;
            var n2= parseInt(hex2,16)-0x80;
            if (n1 == 0 && n2 < 32) return code;
            var n3= parseInt(hex3,16)-0x80;
            var n= (n1<<12) + (n2<<6) + n3;
            if (n > 0xFFFF) return code;
            return String.fromCharCode(n);
        });
    s= s.replace(/%([CD][0-9A-F])%([89AB][0-9A-F])/gi,
        function(code,hex1,hex2)
        {
            var n1= parseInt(hex1,16)-0xC0;
            if (n1 < 2) return code;
            var n2= parseInt(hex2,16)-0x80;
            return String.fromCharCode((n1<<6)+n2);
        });
    s= s.replace(/%([0-7][0-9A-F])/gi,
        function(code,hex)
        {
            return String.fromCharCode(parseInt(hex,16));
        });
    return s;
}

