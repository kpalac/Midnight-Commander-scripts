Configuration for Midnight Commander to be used as a file manager in desktop environment (e.g. in a drop-down terminal)

Provides F2 quick menu, open, view and edit options for various types of files and a bunch of helper shell and perl scripts.

Features:

    Quick menu (F2):
        - desktop search with Recoll support
        - open-with menu support (by mimetype)
        - copy, paste, move using clipboard (with rudimentary integration with other file managers)
        - converting media
        - pdf manipulation
        - executing commands on multiple files (each/all)
        - sending file(s) as attachments/pushing files by Bluetooth
        - viewing multiple images
        - shredding files
        - shortcuts to password generator, calculator, htop process manager, BLESS hex editor etc.
        - batch renaming of files (e.g. adding timestamp to each image)
        - archiving
        - quick file backup creation
        - moving to and restoring from trash
        - grepping of multiple files of many types (e.g. pdf, docx) all at once
        - quick system info
        - generating checksums for many files
        - quick-downloading URL and YT media to current location
        - creating new files with preconfigured templates (by extension)
        - viewing detailed file information (exif included)
        - package search (apt + snap)
        - system services overview

    View, Open, Edit:
        - opening files in desktop using desktop applications for detected mimetype
        - converting PDF, EPUB, doc, docx, odt etc. to plaintext for quick view (using external tools and perl scripts)
        - quick-viewing mail files

    This package also includes a Midnight Commander skin with transparent background and non-assuming color pallette

    Scripts' configuration variables can be found and modified in /usr/local/lib/mcglobals file

I have been using Midnight Commander as my main destkop file manager for many years. I use it with Guake! drop-down terminal. 
This configuration came from a need for MC to be a full-blown part of desktop environment. It works well for me and saves me 
much time when working with large amounts of files of varied types, so I decide to share it. 
Perhaps it will be useful to someone.

Installation:

    - Unpack ZIP
    - run install.sh script from directory you unpacked into. Use no_deps command line argument to forgo installing dependencies.


