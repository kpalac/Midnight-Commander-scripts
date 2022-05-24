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



# Create desktop calendars manifest

use utf8;
use File::Basename;
use File::Spec;

local $/;

my $temp;
my @glob1 = glob("~/.local/share/evolution/calendar/system/*.ics");


foreach my $cal_file (@glob1) {

    if (not -f $cal_file) { next }

    open $descriptor, "<", $cal_file or die "Cannot open ".$cal_file." for reading!";

    while (<$descriptor>) {
	my $contents_main = $_;
        $contents_main = $contents_main."\n";

        

	$dtstart = '';
	$dtend = '';
	$summary = '';

        $rrule = '';
        $freq = ''
        $by_ent = '';
        
        
        

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
	if ( $contents =~ m/Keywords=(.*+)\n/ ) {
	    $keywords = $1;
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

    print $name."|".$comment."|".$desktop_file."|".$mimes."|".$display."|".$categories."|".$keywords."\n"

}













