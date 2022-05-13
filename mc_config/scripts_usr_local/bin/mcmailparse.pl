#!/usr/bin/perl



use open ':std', ':encoding(UTF-8)';
use Email::MIME;
use utf8;
use HTML::FormatText;



my $mode = $ARGV[0];

my $message = '';
my $message_file = $ARGV[1];

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
my $header_date = $email->header("Date");

my @parts = $email->parts;




if ( $mode eq 'reply_claws' ) {

    print "To: ".$header_from."\n";
    print "Subject: Re:".$header_subj."\n";

}
elsif ( $mode == 'view') {

    print "From: ".$header_from."\n";
    print "Received ".$header_rec."\n";
    print "To: ".$header_to."\n"; 
    print "Date: ".$header_date."\n";
    print "Subject: ".$header_subj."\n"; 

}

print "CC: ".$header_cc."\n";
print "BC: ".$header_bc."\n\n\n";



sub process_part {

    my ($part_sub) = @_;

    my $content_type = $part_sub->content_type;

    if ( $content_type =~ /^text\/plain;.*/sg or $content_type =~ /^TEXT\/PLAIN;.*/sg ) {
	my $body_part = $part_sub->body_str;
        
        if ( $mode eq 'reply_claws' ) {
            print "On ".$header_date."\n".$header_from."wrote:\n";
            $body_part =~ s/\r//ig;
            $body_part =~ s/^\n//ig;
            $body_part =~ s/\n/\n>/ig;
	    print "     >".$body_part."\n\n";
        } 
        elsif ( $mode eq 'view' ) {
	    print $body_part."\n\n";        
        }
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

            if ( $mode eq 'reply_claws' ) {
                print "On ".$header_date."\n".$header_from."wrote:\n";
                $string =~ s/\r//ig;
                $string =~ s/^\n//ig;
                $string =~ s/\n/\n>/ig;
	        print "     >".$string."\n\n";
            } elsif ( $mode eq 'view' ) {
	        print $string."\n\n";
            }
	    $text_printed = 'true';
	}

    } elsif ( $content_type =~ /^multipart\/.*;.*/sg or $content_type =~ /^MULTIPART\/.*;.*/sg ) {

	    my @parts_sub = $part_sub->parts;
	    foreach $part_node (@parts_sub) {
	        process_part($part_node);
	    }

    } else {
        if ( $mode eq 'view' ) { print $att_str."	[".$content_type."]\n\n"; }
    }
}





my $text_printed = 'false';

foreach $part (@parts) {
    process_part($part);
}



