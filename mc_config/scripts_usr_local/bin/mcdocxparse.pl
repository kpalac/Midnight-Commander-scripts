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

    $member = $zip->memberNamed( 'word/document.xml' );
    $member->desiredCompressionMethod( COMPRESSION_STORED );
    ($contents, $status) = $member->contents();

    utf8::decode($contents);

} else {

    $contents = <STDIN>;

}







#    $contents =~ s/<w:drawing(.*?)>/ \n\t\t\t[pic]\n/g;
#    $contents =~ s/<\/w:drawing(.*?)>//g;
#    $contents =~ s/<a:graphic(.*?)>/ \n\t\t\t[pic]\n/g;
#    $contents =~ s/<\/a:graphic(.*?)>//g;



while ($contents =~ /<w:p(.*?)>(.*?)<\/w:p>/sg) {

    my $pars = $2;

    $pars =~ s/<w:drawing(.*?)<\/w:drawing(.*?)>/ \t\t\t[pic]/g;
#    $pars =~ s/<\/w:drawing(.*?)>//g;
#    $pars =~ s/<a:graphic(.*?)>/ \t\t\t[pic]/g;
#    $pars =~ s/<\/a:graphic(.*?)>//g;

    $pars =~ s/<(.*?)>//g;
    $pars =~ s/<\/(.*?)>//g;

    $pars =~ s/&apos;/\'/g;
    $pars =~ s/&gt;/>/g;
    $pars =~ s/&lt;/>/g;

    print "$pars\n";

}



