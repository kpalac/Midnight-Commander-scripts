#!/bin/bash

#Wrapper for viewing sqlite databases

DB="$1"

TABLES="$(/usr/bin/sqlite3 "$DB" '.tables')"
INDICES="$(/usr/bin/sqlite3 "$DB" '.indices')"

printf "\n\n\nTABLES:"
printf '\n\n'%s'\n\n\n\n' "$TABLES"


TABLES_TMP="${TABLES// /$'\n'}"
mapfile -t TABLES_A < <(printf %s "$TABLES_TMP" | /bin/sed '/^$/d')

for TMP in "${TABLES_A[@]}"; do
    printf '\n\n\n'%s'\n' "	------------------	$TMP	------------------"
    /usr/bin/sqlite3 "$DB" "select * from $TMP"
done

printf "\n\nINDICES:\n\n"
printf %s'\n\n\n\n' "$INDICES"
