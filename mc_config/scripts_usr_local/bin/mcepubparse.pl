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



# Convert EPUB document to plaintext. Script for TCM and MC quick viewer



use open ':std', ':encoding(UTF-8)';
use Archive::Zip;
use utf8;
use HTML::FormatText;

local $/;

my $mode = $ARGV[0];
my $filename = $ARGV[1];
my $thumbnail_file = '';
if ( $mode eq 'thumbnail' ) {
    $thumbnail_file = $ARGV[2];
}

my $contents = '';
my $rootfile = '';
my $rootdir = '';
my ( $member, $status, $contents );

my $zip = Archive::Zip->new;
$zip->read ($filename);
$member = $zip->memberNamed('META-INF/container.xml');
$member->desiredCompressionMethod( COMPRESSION_STORED );
($contents, $status) = $member->contents();

utf8::decode($contents);

while ($contents =~ /<rootfiles>.*<rootfile.* full-path=\"(.*?)\".*\/>.*<\/rootfiles>/sg) {
    $rootfile = $1;
}

while ( $rootfile =~ /(.*?)\/.*/sg ) { $rootdir = $1; }


$member = $zip->memberNamed($rootfile);
$member->desiredCompressionMethod( COMPRESSION_STORED );
($contents, $status) = $member->contents();
utf8::decode($contents);


my $manifest_str = '';
my $spine_str = '';
my %manifest;


while ( $contents =~ /<manifest(.*?)>(.*?)<\/manifest>/sg ) {
    $manifest_str = $2;
}


while ( $manifest_str =~ /<item(.*?)\/>/sg ) {

    my $href = '';
    my $id = '';

    $item_str = $1;
    while ( $item_str =~ /href=\"(.*?)\"/sg ) {
	$href = $1;
    }
    while ( $item_str =~ /id=\"(.*?)\"/sg ) {
	$id = $1;
    }

    $manifest{$id} = $href;
}




if ( $mode eq 'thumbnail' ) {

    my $guide_str = '';
    my $href = '';
    my $title_str = '';
    my $image = '';

    while ( $contents =~ /<guide(.*?)>(.*?)<\/guide>/sg ) {
	$guide_str = $2;
    }

    while ( $guide_str =~ /<(.*?)\/>/sg ) {
	my $tmp = $1;
	if ( $1 =~ / type=\"cover\"/sg or $1 =~ / type=\"thumbimage\"/sg or $1 =~ / type=\"thumbnail\"/sg )  {
	    while ( $tmp =~ / href=\"(.*?)\"/sg )  {
		$href = $1;
	    }
	}
    }

    my $member = $zip->memberNamed($href);
    if ( $member eq '' ) {
	$href =~ s/^\///g;
     	$member = $zip->memberNamed("OEBPS/".$href);
	if ( $member eq '' ) {
    	    $member = $zip->memberNamed("OPS/".$href);
	    if ( $member eq '' ) { $member = $zip->memberNamed($rootdir."/".$href); }
	}
    }

    
    if ( lc($href) =~ /.*\.(jpg|png|jpeg|svg|pcx|gif|bmp)/sg ) {
	$image = $href;
    } else {

	$member->desiredCompressionMethod( COMPRESSION_STORED );
	($title_str, $status) = $member->contents();
	utf8::decode($title_str);
	
	while ( $title_str =~ /<body.*<image.*href=\"(.*?)\".*>.*\/body>/sg ) {
	    $image = $1;
	}
	if ( $image eq '' ) {
	    while ( $title_str =~ /<body.*<img.*src=\"(.*?)\".*>.*\/body>/sg ) {
		$image = $1;
	    }
	}
    }

    $image =~ s/^\.\.//g;

    if ( lc($image) =~ /.*\.(jpg|png|jpeg|svg|pcx|gif|bmp)/sg ) {

	my $member = $zip->memberNamed($image);
	if ( $member eq '' ) {
	$image =~ s/^\///g;
     	$member = $zip->memberNamed("OEBPS/".$image);
	    if ( $member eq '' ) {
    		$member = $zip->memberNamed("OPS/".$image);
		if ( $member eq '' ) { $member = $zip->memberNamed($rootdir."/".$image); }
	    }
	}
	$member->desiredCompressionMethod( COMPRESSION_STORED );
	($img, $status) = $member->extractToFileNamed($thumbnail_file);
    }

    print "\n\n\nImage:".$image."\n\nGuide:".$guide_str."\n\nTitle:".$title_str."\n\n";

}




if ( $mode ne 'thumbnail' ) {

    if ( $mode eq 'html' ) {
	print "<html>\n<head>";
	while ( $contents =~ /<metadata(.*?)>(.*?)<\/metadata>/sg ) {
	    my $meta_str = $2;
	    while ( $meta_str =~ /<dc:(.*?)>(.*?)<\/dc:(.*?)>/sg ) {
		my $meta_name = lc($1);
		my $meta_value = $2;

		if ( $meta_name =~ /language/sg ) { $meta_name = 'lang'; }
		if ( $meta_name =~ /description/sg ) { $meta_name = 'abstract'; }
		if ( $meta_name =~ /creator/sg ) { $meta_name = 'author'; }
		print "\nmeta ".$meta_name."=\"".$meta_value."\"";
	    }
	}
	print "\n</head>\n<body></body>\n</html>\n\n";
    }


    while ( $contents =~ /<spine(.*?)>(.*?)<\/spine>/sg ) {
	$spine_str = $2;
    }


    while ( $spine_str =~ /<itemref(.*?)idref=\"(.*?)\"(.*?)\/>/sg ) {

	my $string = '';
	$to_extract = $manifest{$2};

	if ( $to_extract =~ /.*\..*htm.*/sg ) {
	    $member = $zip->memberNamed($to_extract);
	    if ( $member eq '' ) {
		$to_extract =~ s/^\///g;
     		$member = $zip->memberNamed("OEBPS/".$to_extract);
		if ( $member eq '' ) {
     		    $member = $zip->memberNamed("OPS/".$to_extract);
		    if ( $member eq '' ) { $member = $zip->memberNamed($rootdir."/".$to_extract); }
		}
	    }

	    if ( $member ne '' ) {
		$member->desiredCompressionMethod( COMPRESSION_STORED );
		($contents, $status) = $member->contents();
		utf8::decode($contents);
	    }

	    if ( $mode eq 'text' ) {
		$string = HTML::FormatText->format_string(
    		$contents,
    		leftmargin => 0, rightmargin => 0
    		);
	    } elsif ( $mode eq 'html' ) {
		$string = $contents;
	    }


	    print $string;


	}
    }

}



