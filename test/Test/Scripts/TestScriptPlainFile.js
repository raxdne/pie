//
//
//
var objNow = Date();
var strResult = '';

function abc (iArg) {
  strResult += 'PREFIX ' + iArg + ' SUFFIX' + '\n';
}


for (i=0; i < 10; i++) {
  abc(i);
}

strResult + objNow;
