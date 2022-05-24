#!/usr/bin/python3
# Copyright (C) 2017-2019 J.F.Dockes
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU Lesser General Public License as published by
#   the Free Software Foundation; either version 2.1 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Lesser General Public License for more details.
#
#   You should have received a copy of the GNU Lesser General Public License
#   along with this program; if not, write to the
#   Free Software Foundation, Inc.,
#   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.



import sys
import os

from recoll import recoll










def process_result_recoll(q, prefix, limit):

    if q.rowcount == 0: return 0

    for i,doc in enumerate(q):

        if i >= limit and limit != 0: break

        name = doc.title if doc.title else doc.filename
        if not name: name = "<???>"

        if prefix == 'Mail: ': 
            pref = 'mail://'
            name = f'{doc.author}: {name}'
        else:
            pref = 'file://'

        path = str(doc.url)
        if path.startswith('file://'): path = path.replace('file://','')
        if doc.ipath: path = f"""{path}////{doc.ipath}"""

        abstract = q.makedocabstract(doc)
        if abstract is None: abstract = ''

        print(f"""{prefix}{name.replace('|',' ')}|{abstract.replace('|',' ')}|{pref}{path}""")





def search_recoll(phrase:str, params:dict):
    
    results = []
    db = None
    try:
        db = recoll.connect()
    except:
        print('Error connecting to recoll DB')
        return 1

    if not db: recoll.connect() 

    limit = params.get('limit',0)
    sdir = params.get('dir','') 

    q = db.query()

    if sdir != '':
        if os.path.isdir(sdir):
            q.execute(f'{phrase} AND dir:{sdir}')
            process_result_recoll(q, '', limit)

    else:
        q.execute(f'{phrase} -dir:~/Mail AND issub:0')
        process_result_recoll(q, '', limit)

        q.execute(f'{phrase} -dir:~/Mail AND -issub:0')
        process_result_recoll(q, '', limit)

        q.execute(f'{phrase} dir:~/Mail')
        process_result_recoll(q, 'Mail: ', limit)











def main():

    params = {}
    params_end = False
    phrase = ''

    if len(sys.argv) > 1: 
    
        for i, arg in enumerate(sys.argv):

            if i == 0: continue

            if arg == '-limit': params['limit'] = int(sys.argv[i+1])

            elif arg == '-dir': params['dir'] = str(sys.argv[i+1])

            elif arg == '-query': phrase = str(sys.argv[i+1])

            elif arg == '-help':
                print("""
mcsearcher.py [OPTION] [VALUE] ... -query [PHRASE]

Search tool for Midnight Commander mcsearch. Extracts Recoll search results

Options:

    -limit [N]          Set limit on number of results (0 - no limit)
    -dir [DIR]          Search in a provided directory recursively
    -query [PHRASE]     Provide a search phrase

    -help               Show this message


""")
                sys.exit(0)

    
    if phrase == '': sys.exit(1)

    search_recoll(phrase, params)







if __name__ == '__main__':
    main()
