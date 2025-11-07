
# Test script="Date();"

This is a Test: script="5*5;" : postfix

This is a Test: script="5*5;" sep script="5*5*5;" : postfix

This is a Test: SCRIPT="5*5;" : postfix

This is an script error: script="ABC;" : postfix

## Embedded

```script
Year = new Date().getFullYear() + 1;
Month = ['Januar','Februar','März','April','Mai','Juni','Juli','August','September','Oktober','November','Dezember'];
r = '; Journal' + Year + '.md\n\n' +  '# ' + Year;
for (m = 0; m < Month.length; m++) {r += '\n\n## ' + Month[m] + ' ' + Year};
```

## Test Script Accumulator

A = script="var a = 1;a"

B = script="a++;a"

C = script="c=++a;c"

D = script="++c"
