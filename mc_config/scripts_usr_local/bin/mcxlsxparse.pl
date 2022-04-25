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



# Convert XLSX spreadsheet to plaintext. Script for MC quick viewer



use open ':std', ':encoding(UTF-8)';
use Archive::Zip;
use utf8;

local $/;

my $contents = '';
my ( $member, $status, $contents );
my ( $member2, $status2, $contents2 );
my $filename = $ARGV[0];

if ( $filename ne '' ) {

    my $zip = Archive::Zip->new;
    $zip->read ($filename);

    $member = $zip->memberNamed( 'xl/sharedStrings.xml' );
    $member->desiredCompressionMethod( COMPRESSION_STORED );
    ($contents, $status) = $member->contents();

    utf8::decode($contents);

    my $mem = '';
    my @members = $zip->membersMatching( '.*xl\/worksheets\/.*\.xml' );

    foreach $mem (@members) {
	#$member2 = $zip->members( $mem );
	#$member2->desiredCompressionMethod( COMPRESSION_STORED );
	($contents2, $status2) = $mem->contents();

	utf8::decode($contents2);

	$contents = $contents.$contents2;
    }

} else {
    $contents = <STDIN>;
}








sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}




#Shared strings
while ($contents =~ /<sst.*?>(.*?)<\/sst>/sg) {

    $strings = $1;

    $i='0';
    while ($strings =~ /<t.*?>(.*?)<\/t>/sg) {

	@string[$i] = $1;
	$i=$i+1;
    }

}
@string = uniq(@string);



#Worksheets
while ($contents =~ /<worksheet.*?>(.*?)<\/worksheet>/sg) {

    $worksheet = $1;

    print "\n\n";

    while ($worksheet =~ /<row.*?>(.*?)<\/row>/sg) {

	$row = $1;

	while ($row =~ /<c(.*?)<\/c>/sg) {
	    
	    $col = $1;
	    #strings
	    while ($col =~ /.*t=\"s\".*<v>(.*?)<\/v>/sg) {
		$str = $1;
		$str = @string[$str];
		print "$str, ";
	    }

	    #others
	    while ($col =~ /.*t=\"[^s]\".*<v>(.*?)<\/v>/sg) {
		$val = $1;
		print "$val, ";
	    }

	}

	print "\n"
    }

}



