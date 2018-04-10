#!/usr/bin/env perl6
my $a = 1;
my $b = 1;
my $tmp;
for 1..1000 {
        say $a;
        $tmp = $b;
        $b += $a;
        $a = $tmp;
}
