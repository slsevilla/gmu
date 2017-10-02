#User: Samantha Sevilla
#Date: 
#Course: BINF690
#Chapter 2 Examples
#!/usr/bin/perl

use strict;
use warnings;
use GD::Graph::linespoints;

my $a, my $b, my $c;
my $m, my $cd, my $dt;
my $ans; my $tf;

print "\n Do you want 1) 2.1 or 2) Euler? ";
	$ans = <STDIN>; chomp $ans;
	if($ans == "1") {
		
	##Example 2.1
	input(\$a,\$b,\$c);
	} else{
		
	##Euler Example
	euler(\$m,\$cd,\$dt,\$tf);
	}

sub input{
	
	my ($a, $b, $c)=@_;
		
	#Take in Variables A, B and C
	print "\n Variable A:";
		$$a = <STDIN>; chomp $$a;
		if($$a == "0") {print "\n**Cannot be a zero value**\n";
			exit;}
	print "\n Variable B:";
		$$b = <STDIN>; chomp $$b;
		if($$b == "0") {print "\n**Cannot be a zero value**\n";
			exit;}
	print "\n Variable C:";
		$$c = <STDIN>; chomp $$c;
		if($$c == "0") {print "\n**Cannot be a zero value**\n";
			exit;}
			
	quad($a,$b,$c);
}

sub quad{
	
	my ($a, $b, $c)=@_;
	my $ans;
	my $x1=0; my $x2=0;
	my $num; my $denom;

	$num = (($$b**2)-4*$$a*$$c)**(1/2);
	$denom = 2*$$a;
	
	$x1=(-$$b+$num)/$denom;
	$x2=(-$$b-$num)/$denom;

	print "\nX1 is: $x1 and X2 value is $x2";
	
	print "\n\nWould you like continue (Y or N)?";
	$ans = <STDIN>; chomp $ans;
	if($ans=~"Y"){
		input(\$a,\$b,\$c);
	} else{exit;} 
}

sub euler{
	my ($m,$cd,$dt,$tf)=@_;
	my $g=9.81; my $t=0;
	my $v=0; my $dvdt;
	my $n; my $ti=2;
	
	#Take in Variables M= Mass, CD, DT = step size, TF = total time
	print "\n Variable M:";
		$$m = <STDIN>; chomp $$m;
		if($$m == "0") {print "\n**Cannot be a zero value**\n";
			exit;}
	print "\n Variable CD:";
		$$cd = <STDIN>; chomp $$cd;
		if($$cd == "0") {print "\n**Cannot be a zero value**\n";
			exit;}
	print "\n Variable DT:";
		$$dt = <STDIN>; chomp $$dt;
		if($$dt == "0") {print "\n**Cannot be a zero value**\n";
			exit;}
	
	print "\n Variable TF:";
		$$tf = <STDIN>; chomp $$tf;
		if($$tf == "0") {print "\n**Cannot be a zero value**\n";
			exit;}

	until ($ti>$$tf){
		$v=$v + ($g-($$cd/$$m)*$v)*$$dt;
	
		print "at time $ti, volume is: $v\n";
		$ti= $ti + $$dt;
	}
}