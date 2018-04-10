#!/usr/bin/env perl6
# Estimate Pi by summing terms from an infnite series discovered by Ramanujan.
# See, e.g.
# https://crypto.stanford.edu/pbc/notes/pi/ramanujan.html
# https://en.wikipedia.org/wiki/Approximations_of_%CF%80#Efficient_methods

sub print_comparison(Str $s) {
        # Print string representation of pi
        # Colour green while we agree with the reference value
        # Colour digits red after the first error
        my $ref_val := "3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989";
        my $red := "\e[0;31m";
        my $off := "\e[0m";
        my $green := "\e[0;36m";
        print $green;
        for 0..($s.chars - 1) -> $i {
                last if ($i == $ref_val.chars);
                if (substr($s, $i, 1) ne substr($ref_val, $i, 1)) {
                        print $red;
                }
                print substr($s, $i, 1);
        }
        print "\n$off";
}

sub fact($x) {[*] 1..$x}  #factorial

sub root2($n) {
        # Rational approximation of sqrt(2)
        # Numerator: OEIS A001601
        # Denominator: OEIS A0510009
        my $num = 3;
        my $denom = 2;
        for 2..$n {
                $denom = 2 * $denom * $num;
                $num = 2 * ($num ** 2) - 1;
        }
        return FatRat.new($num, $denom);
}

# Evaluate terms in series:
my $num;
my $denom;
my $scale := FatRat.new(2, 9801) * root2(11);
my $recip = 0;
my $i;
my $pi;
for 0..125 -> $k {
        $num = fact(4 * $k) * (1103 + 26390 * $k);
        $denom =  (fact($k) ** 4) * (396 ** (4 * $k));
        $recip += FatRat.new($num, $denom) * $scale;
        $pi = 1 / $recip;
        $i = $k + 1;
        print "Terms: $i; Estimate: ";
        print_comparison("$pi");
}
