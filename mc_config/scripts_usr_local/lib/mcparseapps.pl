#!/usr/bin/perl






#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#  Author: Karol Pałac (lolko), palac.karol@gmail.com



# Create desktop application manifest



use utf8;
use File::Basename;
use File::Spec;

local $/;

my $locale = $ARGV[0];
my $target = $ARGV[1];


my $app_dir="/usr/share/applications";
my $temp;
my($vol,$tdir,$tfile) = File::Spec->splitpath($target);


foreach my $desktop_file (glob("$app_dir/*.desktop")) {

    open $descriptor, "<", $desktop_file or die "Cannot open $desktop_file for reading!";

    while (<$descriptor>) {
	my $contents_main = $_;
	$icon = '';
	$name = '';
	$comment = '';
	$mimes = '';
	$categories = '';
	$display = '';
	$terminal = '';
	$exec = '';


	$contents = $contents_main;
	if ( $contents =~ m/Icon=(.*+)\n/ ) {
	    $icon = $1;
	}
	    if ( $icon eq '' ) {
		$icon = "application"; 
	    } else {
		$icon = basename($icon);
		$icon =~ s/\.[pP][Nn][gG]$//;
		$icon =~ s/\.[xX][pP][mMsS]$//;
	    }

	    if ( $icon =~ /.*_rundll32$/sg ) {
		$icon = "wine";
	    } elsif ( $icon =~ /.*_notepad$/sg ) {
		$icon = "wine-notepad";
	    } elsif ( $icon =~ /.*_hh$/sg ) {
		$icon = "wine";
	    } elsif ( $icon =~ /.*_winhlp32$/sg ) {
		$icon = "wine";
	    } elsif ( $icon =~ /.*_winebrowser$/sg ) {
		$icon = "wine";
	    } elsif ( $icon =~ /.*_iexplore$/sg ) {
		$icon = "wine-internet-explorer";
	    } elsif ( $icon =~ /.*_wordpad$/sg ) {
		$icon = "wine-notepad";
	    }

	$contents = $contents_main;
	if ( $contents =~ /Name\[$locale\]=(.*?)\n/sg ) {
	    $name = $1;
	}
	    if ( $name eq '' ) {
		$contents = $contents_main;
		if ( $contents =~ m/Name=(.*+)\n/ ) {
		    $name = $1;
		}
	    }

	$contents = $contents_main;
	if ( $contents =~ m/Comment\[$locale\]=(.*+)\n/ ) {
	    $comment = $1;
	}
	    if ( $comment eq '' ) {
		$contents = $contents_main;
		if ( $contents =~ m/Comment=(.*+)\n/ ) {
		    $comment = $1;
		}
	    }

	$contents = $contents_main;
	if ( $contents =~ m/MimeType=(.*+)\n/ ) {
	    $mimes = $1;
	}

	$contents = $contents_main;
	if ( $contents =~ m/Categories=(.*+)\n/ ) {
	    $categories = $1;
	}

	$contents = $contents_main;
	if ( $contents =~ m/Terminal=(.*+)\n/ ) {
	    $terminal = $1;
	}

	$contents = $contents_main;
	if ( $contents =~ m/Exec=(.*+)\n/ ) {
	    $exec = $1;
	}


	$contents = $contents_main;
	if ( $contents =~ m/NoDisplay=(.*+)\n/ ) {
	    $display = $1;
	}
	    if ( $display =~ /true/sg ) { 
		$display = "_NoDisplay_"; 
	    } else {
		$display = "_Display_"; 
	    }

    }

    $name =~ s/\|/ /g;
    $comment =~ s/\|/ /g;
    $comment =~ s/;/ /g;
    $mimes =~ s/\|/ /g;
    $categories =~ s/\|/ /g;

    $exec =~ s/\|/\/\/\/\//g;

    $name = ucfirst $name;
    $comment = ucfirst $comment;

    print $name."|".$comment."|".$desktop_file."|".$mimes."|".$display."|".$categories."\n"

}













