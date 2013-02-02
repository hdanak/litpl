package Filter::Literate::Test;
use Test::Base -Base;
 
use Filter::Literate;

push our @EXPORT, 'run_ok';
sub run_ok {
    run { ok shift->$_ } for @_;
}
 
package Filter::Literate::Test::Filter;
use Test::Base::Filter -base;
 
sub glob {
    CORE::glob($_)
}
sub valid_syntax {
    ...
}
