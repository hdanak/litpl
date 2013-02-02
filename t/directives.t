use Filter::Literate::Test;

plan tests => 1 * blocks;
run_ok 'input';
__DATA__

=== Basic directives are valid
--- input glob valid_syntax
#{=,~} Section Name
