#! /usr/bin/env perl

use strict;
use warnings;

my $url = "https://kalendar.aktuality.sk/";
my $style = "MacOS";

my $custom = qq{};

# [0] title
# [1] string
sub notify{
    if ($style eq "MacOS") {
        system(qq{/usr/bin/osascript -e 'display notification "$_[1]" with title "nameday.pl" subtitle "$_[0]"'});
    } elsif ($style eq "dunst") {
        #WIP
    } elsif ($style eq "notify-send") {
        #WIP
    } elsif ($style eq "custom") {
        system($custom);
    }
}

# Downloads with curl
my $string = `curl -s $url`;

$string =~ s/\n/ /g;
$string =~ s/\t/ /g;
$string = (split /<ul class="head"/, $string) [1];
$string = (split /ul>/, $string) [0];
$string =~ s/<a/\n/g;

my @names = $string =~ m/href="\/meniny.*/g;

for (@names) {
    $_ = ($_ =~ m/>\w+</g)[0];
    $_ =~ s/[\<|\>]//g;
}

# Used for debug
# push(@names, "Andrea");
# print "$string";
# print "@names\n";
# print scalar @names, "\n";
# print "$#names\n";

my $notif_string = "";
my $notif_title = "";

if (scalar @names == 0) {
    $notif_string = "Dnes nemá meniny.";
    $notif_title = "";
} elsif (scalar @names == 1) {
    $notif_string = "Dnes má meniny $names[0]";
    $notif_title = "$names[0]";
} else {
    $notif_string = "Dnes majú meniny ";
    if (scalar @names > 2) {
        for(my $i = 0; $i < $#names - 1; $i++) {
            $notif_string = $notif_string.$names[$i];
            $notif_string = $notif_string.", ";

            $notif_title = $notif_title.$names[$i];
            $notif_title = $notif_title.", ";
        }
    }
    $notif_string = $notif_string."$names[-2] a $names[-1]";
    $notif_title = $notif_title."$names[-2] a $names[-1]";
}

# print "$notif_title";
# print "$notif_string";

notify($notif_title, $notif_string);
