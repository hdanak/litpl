use Filter::Literate::Test;

plan tests => 1 * blocks;
run_ok 'input';
__DATA__

=== Root anchors and scope modifiers work in section references
--- input glob valid_syntax
<< {,^^} first section {,:: second section {,:: third section} >>
=== Root anchors and scope modifiers work in section definitions
--- input glob valid_syntax
#{=,~} {,^^} first section {,:: second section {,:: third section}
