#!/usr/bin/perl



use open ':std', ':encoding(UTF-8)';
use Email::MIME;
use utf8;
use HTML::FormatText;




my $message = '';

my $message_file = $ARGV[0];

local $/;



if ( -f $message_file ) {

    open(my $fh, '<', $message_file) or die "cannot open file $message_file";
    {
        local $/;
        $message = <$fh>;
    }
    close($fh);


} else {

    local $/;
    $message = <STDIN>;
}



my $email = Email::MIME->new($message);

my $header_from = $email->header("From");
my $header_rec = $email->header("Received");
my $header_to = $email->header("To");
my $header_subj = $email->header("Subject");
my $header_cc = $email->header("cc");
my $header_bc = $email->header("bc");

my $from_str = $ENV{'T_From'};
my $received_str = $ENV{'T_Received'};
my $to_str = $ENV{'T_To'};
my $subj_str = $ENV{'T_Subject'};
my $att_str = $ENV{'T_Attachment'};
if ( $from_str eq '' ) { $from_str = 'From:'; }
if ( $rec_str eq '' ) { $rec_str = 'Received:'; }
if ( $to_str eq '' ) { $to_str = 'To:'; }
if ( $subj_str eq '' ) { $subj_str = 'Subject:'; }
if ( $att_str eq '' ) { $att_str = 'Attachement:'; }


my @parts = $email->parts;

print $from_str." ".$header_from."\n";
print $rec_str." ".$header_rec."\n";
print $to_str." ".$header_to."\n"; 
print $subj_str." ".$header_subj."\n"; 
print "CC: ".$header_cc."\n";
print "BC: ".$header_bc."\n\n\n";







sub process_part {

    my ($part_sub) = @_;

    my $content_type = $part_sub->content_type;

    if ( $content_type =~ /^text\/plain;.*/sg or $content_type =~ /^TEXT\/PLAIN;.*/sg ) {
	my $body_part = $part_sub->body_str;
	print $body_part."\n\n";
	$text_printed = 'true';
    }
    elsif ( $content_type =~ /^text\/html;.*/sg or $content_type =~ /^TEXT\/HTML;.*/sg ) {

	if ( $text_printed ne 'true' ) {
	    my $body_part = $part_sub->body_str;

	    my $string = HTML::FormatText->format_string(
    	    $body_part,
    	    leftmargin => 0, rightmargin => 0
    	    );
	    #fallback
	    if ( $string eq '' ) {

	    }

	    print $string."\n\n";
	    $text_printed = 'true';
	}

    } elsif ( $content_type =~ /^multipart\/.*;.*/sg or $content_type =~ /^MULTIPART\/.*;.*/sg ) {

	my @parts_sub = $part_sub->parts;
	foreach $part_node (@parts_sub) {
	    process_part($part_node);
	}
    } else {
	print $att_str."	[".$content_type."]\n\n";
    }
}





my $text_printed = 'false';

foreach $part (@parts) {
    process_part($part);
}



