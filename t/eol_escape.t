use Filter::Literate::Test;

plan tests => 1 * blocks;
run_ok 'input';
__DATA__

=== End-of-line escape works in #-directive strings
--- input glob valid_syntax
#{=,~}{,\t,\t\t, ,  }\\{,\r}\n
=== End-of-line escape works in <<...>>
--- input valid_syntax
<< breaking onto \\\n following line >>
