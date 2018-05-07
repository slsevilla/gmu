#User: Samantha Sevilla
#Date: 
#Course: BINF690
#Ch4 assignment
#!/usr/bin/perl

use strict;
use warnings;
use GD::Graph::Lines;

print "What equation do you want to run?\n";
print "1) Backwards, Forwards, Center\n";
print "2) Step Size comparision EX 4.8\n";
my $ans = <STDIN>; chomp $ans;

if($ans==1){
	#Inputs
	my $x=2; 
	my $h = 0.2;
	my $xf = $x + $h;
	my $xb = $x - $h;
	my $fx = 25*$x**3 - 6*$x**2 + 7*$x - 88;
	my $fx_P = 25*$xf**3 - 6*$xf**2 + 7*$xf - 88;
	my $fx_B = 25*$xb**3 - 6*$xb**2 + 7*$xb - 88;
	my $fx1 = 75*$x**2 - 12*$x + 7;
	
	#Perform Calculations
	my $fx_FOD = ($fx_P - $fx) / $h;
	my $fx_BACK = ($fx - $fx_B) / $h;
	my $fx_CEN = ($fx_P - $fx_B) / 2*$h;
	my $ET_B = ($fx1 - $fx_BACK) / $fx1;
	my $ET_F = ($fx1 - $fx_FOD) / $fx1;
	my $ET_C = ($fx1 - $fx_CEN) / $fx1;
	
	#Print to CML
	print "\nFX BACK is $fx_BACK, with an ET of $ET_B\n";
	print "FX FOD is $fx_FOD, with an ET of $ET_F\n";
	print "FX CEN is $fx_CEN, with an ET of $ET_C\n";
}


if ($ans==2){
	my $true_fin; my $n=0;
	my $fun_high; my $fun_low;
	my $h=1; my $x=.5;
	my $true = -0.9125;
	my $error; my @full_h, my @y;

	until ($n>10) {
		$a = $x+$h; $b=$x-$h;
		$fun_high=-0.1*($a**4)-.15*($a**3)-.5*($a**2)-(.25*$a)+1.2;
		$fun_low=-0.1*($b**4)-.15*($b**3)-.5*($b**2)-.25*$b+1.2;
		$true_fin=($fun_high-$fun_low)/(2*$h);
		$true_fin = sprintf "%16.14f", ($true_fin);
		$error=($true-$true_fin);
		push(@full_h,$h);
		push(@y,$error);
		
		print "H Value: $h  |  True Value: $true_fin | Error: $error\n";

		$h=$h/10;
		$n++;
	}

	log(@full_h);
	log(@y);
	my $M = abs(-2.4*$x-.9);
	my $prec = 10**-16;
	my $h_opt = ((3*($x*$prec))/$M)**(1/3);
	print "hOPT: $h_opt" ;

	my @axes = (\@full_h, \@y);
	my $barchart = GD::Graph::lines-> new;

	$barchart->set( 
		x_label=>'H Step', 
		y_label=>'Error', 
		title=>'Error Rate Related to Step',
		transparent=>0,
		) or die $barchart -> error;
			
	my $new_file = "Error.png";
	my $image = $barchart->plot(\@axes) or die $barchart->error;
		
	unless(open IMAGE,">". $new_file) {
		die "\nUnable to create $new_file\n";
	} 
	binmode IMAGE;
	print IMAGE $image->png;
	close IMAGE;
}
