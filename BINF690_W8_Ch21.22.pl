#User: Samantha Sevilla
#Date: 10/23
#Course: BINF690
#Chapter 20/21
#!/usr/bin/perl
use strict;
use GD::Graph::mixed;

######################################################################################
								##NOTES##
######################################################################################
#1) Will calculate the trap. approximation, taking in the n term to be divided via the CML

#Search for ###UPDATE to update necessary inputs before running

######################################################################################
								##CODE##
######################################################################################
#Chose the problem
print "Which problem would you like to complete?\n";
print "1) Trapazoid Rule (21.2)\n";
print "2) Simpon's 1/3 Rule (21.4, 21.5)\n";
print "3) Simpson's 1/3 & 3/8 Rule Combo \n"; 
print "ANS: ";
my $ans = <STDIN>; chomp $ans;


if($ans==1){
	###UPDATE with input variables
	my $a = 0; my $b = 0.8;
	
	#Ask the level of sectioning to perform
	print "What is your n?\n";
	print "ANS: ";
		my $n = <STDIN>; chomp $n;

	#Call the subroutine to determine the approximation
	integrate_trap(\$ans, \$a, \$b, \$n);
} elsif($ans==2){
	###UPDATE with input variables
	my $a = 0; my $b = 0.8;
	
	#Ask the level of sectioning to perform
	print "What is your n?\n";
	print "ANS: ";
		my $n = <STDIN>; chomp $n;

	#Call the subroutine to determine the approximation
	simpsons_rule(\$ans, \$a, \$b, \$n);
} elsif($ans==3){
	###UPDATE with input variables
	my $a = 0; my $b = 0.8;
	
	#Ask the level of sectioning to perform
	print "What is your n?\n";
	print "ANS: ";
		my $n = <STDIN>; chomp $n;

	#Call the subroutine to determine the approximation
	simpsons_rule(\$ans, \$a, \$b, \$n);



}

######################################################################################
								##Subroutines##
######################################################################################
sub integrate_trap {
	#Initialize the variables
	my ($ans, $a, $b, $n)=@_;
	my $fx1; my $fx_old=0;
	my $i = $$n;
	
	###UPDATE the True Error
	my $ET = 1.64;
	
	#Solve for H
	my $h=($$b-$$a)/$$n;
	my $h_new = $h;

	#Determine the fx values for the limits
	my $fx_start = sprintf("%.4f", fx_solve($$ans, $$a));
	my $fx_end = sprintf("%.4f", fx_solve($$ans, $$b));

	#Determine the sum of all fx values for the estimations
	until ($i==1){
		$fx1 = sprintf("%.4f", fx_solve($$ans, $h));
		$fx1 = $fx_old + $fx1;
		
		#Save Old Values
		$fx_old=$fx1;
		$h = $h + $h_new;
		
		#Reset counters
		$i = $i-1;
	}

	#Determine the integral value
	my $i =  sprintf("%.4f",(($fx_start + 2*$fx1 + $fx_end )/(2*$$n))*($$b-$$a));

	#Determine the Error
	my $EA = error($$ans, $$a, $$b, $$n);
	$ET = (($ET-$i)/$ET)*100;
	
	#Print the final solutions to the command line
	print "The I value is $i\n";
	print "The EA for this problem is $EA\n";
	print "The ET for this problem is $ET\n";
}
sub simpsons_rule{
#Initialize the variables
	my ($ans, $a, $b, $n)=@_;
	my $fx1; my $fx2; 
	my $fx_old1=0; my $fx_old2=0;
	my $i = $$n;
	
	###UPDATE the True Error
	my $ET = 1.64;
	
	#Solve for H
	my $h=($$b-$$a)/$$n;
	my $h_new = $h;

	#Determine the fx values for the limits
	my $fx_start = sprintf("%.4f", fx_solve($$ans, $$a));
	my $fx_end = sprintf("%.4f", fx_solve($$ans, $$b));

	#Determine the sum of all fx values for the estimations
	until ($i==1){
		
		#If the number is even, add to the fx1 group
		if (0 == $i % 2) {
			$fx1 = sprintf("%.4f", fx_solve($$ans, $h));
			$fx1 = $fx_old1 + $fx1;
			$fx_old1=$fx1;
		} else {
			$fx2 = sprintf("%.4f", fx_solve($$ans, $h));
			$fx2 = $fx_old2 + $fx2;
			$fx_old2=$fx2;
		}
		
		#Save Old Values
		$h = $h + $h_new;
		
		#Reset counters
		$i = $i-1;
	}

	#Determine the integral value
	my $i =  sprintf("%.4f",(($fx_start + 4*$fx1 + 2*$fx2 + $fx_end )/(3*$$n))*($$b-$$a));
	
	#Determine the Error
	my $EA = error($$ans, $$a, $$b, $$n);
	$ET = (($ET-$i)/$ET)*100;
	
	#Print the final solutions to the command line
	print "The I value is $i\n";
	print "The EA for this problem is $EA\n";
	print "The ET for this problem is $ET\n";
}

sub error{
	#Initialize
	my ($ans, $a, $b, $n)=@_;
	my $app; my $EA;
	
	#Solve error
	my $f1x0= f1x_solve($ans, $a);
	my $f1xn= f1x_solve($ans, $b);
	
	if ($ans==1){
		$app = ($f1xn-$f1x0)/($b-$a);
		$EA = (-($b-$a)**3)/(12*($n**2))*$app;
	} elsif($ans==2){
		$app = ($f1xn+$f1x0)/(2);
		$EA = ((-($b-$a)**5)/(180*$n**4))*$app;
	}
	
	$EA = sprintf("%.4f", $EA);
	return $EA;
}

sub fx_solve{
	#Initialize values
	my ($ans, $x)=@_;
	my $fx;
	
	#Solve the equation, and return the solution
	if ($ans==1 | $ans==2){
		$fx= 0.2 + 25*$x - 200*$x**2 + 675*$x**3 -900*$x**4 + 400*$x**5;
	} 
	return $fx;
}

sub f1x_solve{
	#Initialize values
	my ($ans, $x)=@_;
	my $fx;
	
	#Solve the equation, and return the solution
	if ($ans==1){
		$fx=-400*$x + 2025*$x**2 - 3600*$x**3 + 2000*$x**4;
	} elsif ($ans=2){
		$fx=-21600 + 48000*$x;
	}
	return $fx;
}