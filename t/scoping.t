use Filter::Literate::Test;

plan tests => 1 * blocks;
run_ok 'input';
__DATA__

=== Balanced nested scopes are valid
--- input valid_syntax
#= section 1
    #= section 1.1
    #.
#.
