

use POSIX;


$range = 20;


my $rnum = rand($range);
$rnum = floor($rnum);



print "Enter a number between 0 and $range: ";
my $user_num = <STDIN>;



if ($user_num == $rnum) {
	print "You guessed correctly!\n";
} else {
	print "Sorry, the number was $rnum.\n";
}




print "Bye!\n";

