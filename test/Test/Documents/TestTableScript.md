
```script
var s = '# Test of Table by Script\n\n';

s += '```csv\n';
for (i=1; i<1e2; i++) {
  for (j=1; j<1e2; j++) {
	s += 'script="(' + i.toString() + '+' + j.toString() + ')",';
  }
  s += '\n';
}
s += '```\n';
```
