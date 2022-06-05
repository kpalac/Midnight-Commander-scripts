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
        elif prefix == 'WWW: ':
            pref = ''
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
    try:
        db = recoll.connect()
    except:
        print('Error connecting to recoll DB')
        return 1

    limit = params.get('limit',0)
    sdir = params.get('dir','') 

    q = db.query()

    if sdir != '':
        if os.path.isdir(sdir):
            q.execute(f'{phrase} AND dir:{sdir}')
            process_result_recoll(q, '', limit)

    else:
        mail_dir = os.getenv('MC_RECOLL_MAIL_DIR','')
        www_dir = os.getenv('MC_RECOLL_WWW_DIR','')
        www_db = os.getenv('MC_RECOLL_WWW_DB','')

        mail_dir = mail_dir.replace('"','\"')
        www_dir = www_dir.replace('"','\"')
        if www_db != '': www_db = os.path.expanduser(www_db)
        if not os.path.isdir(www_db): www_db = ''
        
        excl_dirs = ''
        if mail_dir != '': excl_dirs = f'{excl_dirs} AND -dir:"{mail_dir}"'
        if www_dir != '': excl_dirs = f'{excl_dirs} AND -dir:"{www_dir}"'
        

        q.execute(f'{phrase}{excl_dirs} AND -rclcat:www AND issub:0')
        process_result_recoll(q, '', limit)

        q.execute(f'{phrase}{excl_dirs} AND -rclcat:www AND -issub:0')
        process_result_recoll(q, '', limit)

        q.execute(f'{phrase} AND dir:"{mail_dir}"')
        process_result_recoll(q, 'Mail: ', limit)

        if www_db != '': 
            try:
                db = recoll.connect(confdir=www_db)
                q = db.query()
            except:
                print('Error connecting to WWW history database')

        if not os.path.isdir(www_dir):
            q.execute(f'{phrase} rclcat:www')
        else:
            q.execute(f'{phrase} dir:"{www_dir}"')
        process_result_recoll(q, 'WWW: ', limit)











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
