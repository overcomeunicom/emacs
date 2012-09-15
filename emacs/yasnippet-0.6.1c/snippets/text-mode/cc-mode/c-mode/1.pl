#!/usr/bin/env perl
while (<STDIN>) {
    if (/.*\s+(\w+)\((.*)\)/) {
	$name=$1;
	$_=$2;
	s/"$/}/g;
	s/"\s+/},/g;
	s/"/\${/g;
	$para=$_;
	open tmp,">",$name or die "oops";
	print tmp $name," (",$para,");\n\$0";
	close tmp;
    }
}
