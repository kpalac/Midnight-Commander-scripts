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



# Convert ODT document to plaintext. Script for TCM and MC quick viewer



use open ':std', ':encoding(UTF-8)';
use Archive::Zip;
use utf8;

local $/;

my $contents = '';
my ( $member, $status, $contents );
my $filename = $ARGV[0];

if ( $filename ne '' ) {

    my $zip = Archive::Zip->new;
    $zip->read ($filename);

    $member = $zip->memberNamed( 'content.xml' );
    $member->desiredCompressionMethod( COMPRESSION_STORED );
    ($contents, $status) = $member->contents();

    utf8::decode($contents);

} else {

    $contents = <STDIN>;

}





while ($contents =~ /<text:p(.*?)>(.*?)<\/text:p>/sg) {

    my $pars = $2;
    $pars =~ s/<\/text:span>//g;
    $pars =~ s/<text:span(.*?)>//g;
    $pars =~ s/<text:span(.*?)>//g;
    $pars =~ s/<text:section(.*?)>/\n/g;
    $pars =~ s/<text:(.*?)>//g;
    $pars =~ s/<\/text:(.*?)>//g;
    $pars =~ s/<draw:image(.*?)>/ \n\n\n\t\t\t[pic]\n/g;
    $pars =~ s/<draw:(.*?)>//g;
    $pars =~ s/<\/draw:(.*?)>//g;

    $pars =~ s/<table:table-row(.*?)>//g;
    $pars =~ s/<\/table:table-row>/\n/g;
    $pars =~ s/<table:(.*?)>//g;
    $pars =~ s/<\/table:(.*?)>//g;

    $pars =~ s/&apos;/\'/g;
    $pars =~ s/&gt;/>/g;
    $pars =~ s/&lt;/>/g;

    print "\n\n$pars\n";

}



