#!/bin/bash


#  Wrapper for viewing PS documents (convert ot pdf and use default PDF viewer)
. /usr/local/lib/mcglobals

SFILE="$@"

TMP_FILE="/tmp/mc-$USER/mc_view_tmp_$RANDOM""$RANDOM"".pdf"

/usr/bin/ps2pdfwr "$SFILE" "$TMP_FILE"
/usr/local/lib/mcpdfview "$TMP_FILE"

