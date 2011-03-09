#!/usr/bin/perl
#
# A script to 'tangle' a literate program, to extract the compilable source.
#

use Data::Dumper;
use feature 'switch';
no warnings 'deprecated';

# Get filename

my %config = %{process_args()};

# Open file

open (my $fh, '<', $config{filename})
	or die "Unable to open file '$config{filename}'.\n";

# List of all comment blocks with their code sections:
my @sections = ();

my %cur_seg;
my $STATE = 0;
while (my $line = <$fh>) {
	# Start section
#	print "State$STATE: Line => $_\n";
	if ($line =~ /^\s*#=+(.*)$/) {
		given ($STATE) {
			when (0) {
				# Extract title from capture
				$cur_seg{title} = cleanup_title($1);
				$STATE = 1;
			}
			when (1) {
				warn "WARNING: Comment block ended implicitely at ";

				# Check-in %cur_seg into %section
				push @sections, [$cur_seg{title},
						 $cur_seg{code_title},
						 $cur_seg{comments},
						 $cur_seg{code}
					 	];
				%cur_seg = ();

				# Extract title from capture
				$cur_seg{title} = cleanup_title($1);
				$STATE = 1;
			}
			when (2) {
				warn "WARNING: Section ended implicitely at ";

				# Check-in %cur_seg into %section
				push @sections, [$cur_seg{title},
						 $cur_seg{code_title},
						 $cur_seg{comments},
						 $cur_seg{code}
					 	];
				%cur_seg = ();

				# Extract title from capture
				$cur_seg{title} = cleanup_title($1);
				$STATE = 1;
			}
		}
	}
	# Code segment toggle
	elsif ($line =~ /^\s*#~(.*)$/) {
		$cur_seg{code_title} = parse_code_title($1);
		given ($STATE) {
			when (0) {
				warn "Warning: You're trying to put a code segment outside any open section at "
					unless $cur_seg{code_title};
			}
			when (1) {
				$STATE = 2;
			}
			when (2) {
				$STATE = 1;
			}
		}
	}
	# End section
	elsif ($line =~ /^\s*#-/) {
		given ($STATE) {
			when (0) {
				warn "WARNING: You're trying to close a section without first opening one at ";
			}
			when (1) {
				# Check-in %cur_seg into %section
				push @sections, [$cur_seg{title},
						 $cur_seg{code_title},
						 $cur_seg{comments},
						 $cur_seg{code}
					 	];
				%cur_seg = ();

				$STATE = 0;
			}
			when (2) {
				# Check-in %cur_seg into %section
				push @sections, [$cur_seg{title},
						 $cur_seg{code_title},
						 $cur_seg{comments},
						 $cur_seg{code}
					 	];
				%cur_seg = ();

				$STATE = 0;
			}
		}
	}
	# Aggregate code or comments
	else {
		given ($STATE) {
			when (0) {
				warn "WARNING: You have stuff outside any open section at "
					unless $line =~ /^\s*$/;
			}
			when (1) {
				push @{$cur_seg{comments}}, $line;
			}
			when (2) {
				push @{$cur_seg{code}}, $line;
			}
		}
	}
}
close ($fh);

if ($STATE != 0) {
	push @sections, [$cur_seg{title},
			 $cur_seg{code_title},
			 $cur_seg{comments},
			 $cur_seg{code}
		 	];
}


# Now output weave_file and/or tangle_file
#if (defined $config{weave_file}) {
#	open (my $wfh, '>', $config{weave_file});
#	foreach my $section (@sections) {
#		print $wfh "Section: $section->[0]\n";
#		print $wfh join('', $section->[2]);
#	}
#	close ($wfh);
#}
if (defined $config{tangle_file}) {
	open (my $tfh, '>', $config{tangle_file});
	# Get the TOP code-block
	my $tangled_code = resolve_code('TOP');
	print $tfh $tangled_code;
	close ($tfh);
}

sub resolve_code {
	my ($name) = @_;

	# Find all instances of $name

	my @parts = get_sections_by_name($name);
	my $primary = (shift @parts)->[3];
	foreach my $part (@parts) {
		push @$primary, @{$part->[3]};
	}

	my $code = join '', @$primary;

	# Find and replace all placeholders (<< ... >>) in code
	$code =~ s/<<\s*(.*?)\s*>>/resolve_code($1)/eg;
	return $code;
}

sub get_placeholders {
	my ($code_lines) = @_;
	my $code = join '', @$code_lines;
	my @placeholders = ($code =~ /<<(.*?)>>/g);
	return @placeholders;
}

sub get_sections_by_name {
	my ($name) = @_;
	my @results = grep {lc $_->[0] eq lc $name || lc $_->[1] eq lc $name} @sections;
	die "Couldn't find code block for '$name'.\n" unless @results;
	return @results;
}



sub cleanup_title {
	my ($capture) = @_;

	# Trim right- and left- side spaces
	chomp $capture;
	$capture =~ s/^\s*//g;
	$capture =~ s/\s*$//g;

	return $capture;
}

sub parse_code_title {
	my ($capture) = @_;

	# Trim right- and left- side spaces
	chomp $capture;
	$capture =~ s/^\s*//g;
	$capture =~ s/\s*$//g;

	if ($capture =~ /<<(.*?)>>=/) {
		return $1;
	}
	else {
		return '';
	}
}


sub print_usage {
	print "Usage: literate.pl filename [--tangle tangle_file] [--weave weave_out]\n";
}

sub process_args {

	print_usage() and exit if @ARGV < 2;

	my $filename = shift @ARGV;

	use Getopt::Long;
	my ($tangle_file, $weave_file);
	GetOptions( "weave=s" => \$weave_file, "tangle=s" => \$tangle_file)
		or exit;
	unless ($weave_file || $tangle_file) {
		print_usage() and exit;
	}

	unless (-e $filename) {
		die "File '$filename' not found\n";
	}
#	if ($tangle_file && !(-e $tangle_file)) {
#		die "Tangle file '$tangle_file' not found\n";
#	}
#	if ($weave_file && !(-e $weave_file)) {
#		die "Weave file '$weave_file' not found\n";
#	}
	return { weave_file	=> $weave_file,
		 tangle_file	=> $tangle_file,
		 filename	=> $filename };
}
