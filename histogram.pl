#!/usr/bin/perl

my %numbers;
my ($max, $min) = (0,0);

while(<>) {
	if (/(\d+)/) {
		$numbers{$1} = defined $numbers{$1} ? $numbers{$1} + 1
						    : 1;
		if ($1 > $max) {
			$max = $1;
		}
		if ($1 < $min) {
			$min = $1;
		}


	}
	else {
		die "Can't find number in input '$_' ";
	}
}

print "Min: $min\n", "Max: $max\n";
for ($min .. $max) {
	my $count = $numbers{$_}//0;
	print "$_: ", '#' x $count, " [$count]\n";
}


