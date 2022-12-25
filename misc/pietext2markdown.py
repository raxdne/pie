#
# https://docs.python.org/3/library/glob.html
#

"""
 (setq python-shell-interpreter "/usr/bin/python3")
 (local-set-key [f3] (lambda () "" (interactive)(save-buffer)(python-shell-send-buffer)))
"""

import os
from pathlib import Path
import argparse
import glob
import re


def parse_args(args=None):

    # https://docs.python.org/3/howto/argparse.html
    parser = argparse.ArgumentParser(
        description='Dump .CSV training files to various formats',
        epilog='python-fitparse version ',
    )
    parser.add_argument('-v', '--verbose', action='count', default=0)
    parser.add_argument(
        '-o', '--output', type=argparse.FileType(mode='w'), default="-",
        help='File to output data into (defaults to stdout)',
    )
    parser.add_argument(
        'infile', nargs="+", type=str,
        help='Input .txt file (Use - for stdin)',
    )

    options = parser.parse_args(args)
    options.verbose = options.verbose >= 1
    #options.with_defs = (options.type == "readable" and options.verbose)
    #options.as_dict = (options.type != "readable" and options.verbose)

    return options


def update(a,b):

    d = {'^\*{5}\s' : '\n##### ', '^\*{4}\s' : '\n#### ', '^\*{3}\s' : '\n### ', '^\*{2}\s' : '\n## ', '^\*\s' : '\n# ',
         '^\-{5}\s' : '        - ', '^\-{4}\s' : '      - ', '^\-{3}\s' : '    - ', '^\-{2}\s' : '  - ', '^\-\s' : '- ',
         '^\+{5}\s' : '           1) ', '^\+{4}\s' : '         1) ', '^\+{3}\s' : '      1) ','^\+\s{2}' : '   1) ','^\+\s' : '1) '}
    # BUG: indent depth
    
    if a == b:
        print(a + ': equal file names')
    else:
        with open(a,'r') as f:
            content = f.read().splitlines(keepends=True)
            #content = f.read().split('\n\n')
        f.close()
        
        fOut = True
        fPre = False
        for l in content:
            s = l.rstrip()
            s = re.sub(r'^[\t\n\r]+','',s)
            s = re.sub(r'[\t\n\r]+',' ',s)
            if len(s) > 0:
                if re.match(r'^#begin_of_skip',s):
                    fOut = False
                    break
                elif re.match(r'^#end_of_skip',s):
                    fOut = True
                elif not fOut:
                    break
                elif re.match(r'^TAGS:',s):
                    print('\n' + s, end='\n\n')
                elif re.match(r'^#begin_of_pre',s):
                    fPre = True
                    print('\n~~~', end='\n')
                elif re.match(r'^#end_of_pre',s):
                    fPre = False
                    print('~~~\n', end='\n')
                else:
                    fPar = True

                    # TODO: #begin_of_csv
                    
                    # TODO: #begin_of_script
                    
                    # legacy links
                    s = re.sub(r"\|([^\|]+)\|([^\|]+)*\|",'[\g<2>](\g<1>)', s)

                    # specific tags
                    #s = re.sub(r'@(amazon|ebay)','#\g<1>',s)

                    for r in d.keys():
                        if re.match(r,s):
                            s = re.sub(r,d[r],s)
                            fPar = False
                            break
                    
                    if fPar and not fPre:
                        print(end='\n')

                    print(s, end='\n')
                
    
def main(args=None):

    options = parse_args(args)
    #prefix = '/tmp/Test'
    
    for f in options.infile:
        #g = prefix + f
        #print(g)
        #Path(os.path.dirname(g)).mkdir(parents=True, exist_ok=True)
        update(f,'')

        
if __name__ == '__main__':
    try:
        main()
    except BrokenPipeError:
        pass
        

