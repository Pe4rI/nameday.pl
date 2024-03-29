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
        system(qq{notify-send 'nameday.pl' '$_[1]'}); # if not working, insert notify-send's location
    } elsif ($style eq "custom") {
        system($custom);
    }
}

# Downloads with curl
my $string = `curl -s $url`;

$string =~ s/[\n|\t|\r]/ /g;
# print "$string";
$string = (split /<ul class="head"/, $string) [1];
# print "$string";
$string = (split /ul>/, $string) [0];
# print "$string";
$string =~ s/<a/\n/g;
#  print "----------------------------------\n";
#  print "$string";
#  print "\n----------------------------------\n";

my @names = $string =~ m/href="\/meniny.*/g;

# print "@names\n";
# print "----------------------------------\n";

foreach my $temp (@names) {
    $temp = (split /\>/, $temp)[1];
    $temp = (split /\</, $temp)[0];
    #print($temp);
}

# Used for debug
# push(@names, "Test_name_1");
# push(@names, "Test_name_2");
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
            $notif_title = $notif_title.$names[$i];
            $notif_title = $notif_title.", ";
        }
    }
    $notif_title = $notif_title."$names[-2] a $names[-1]";
    $notif_string = $notif_string.$notif_title;
}

# print "$notif_title";
# print "$notif_string";

notify($notif_title, $notif_string);

