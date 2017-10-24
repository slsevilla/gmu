#User: Samantha Sevilla
#Date: 10/23
#Course: BINF690
#Chapter 21.5 homework
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
print "Which method would you like to us?\n";
print "1) Trapazoid Rule (21.5)\n";
print "2) Simpon's 1/3 Rule (21.5)\n";
print "ANS: ";
my $ans = <STDIN>; chomp $ans;


if($ans==1){
	###UPDATE with input variables
	my $a = -3; my $b = 5;
	
	#Ask the level of sectioning to perform
	print "What is your n?\n";
	print "ANS: ";
		my $n = <STDIN>; chomp $n;

	#Call the subroutine to determine the approximation
	integrate_trap(\$ans, \$a, \$b, \$n);
} elsif($ans==2){
	###UPDATE with input variables
	my $a = -3; my $b = 5;
	
	#Ask the level of sectioning to perform
	print "What is your n?\n";
	print "ANS: ";
		my $n = <STDIN>; chomp $n;

	#Call the subroutine to determine the approximation
	simpsons_rule(\$ans, \$a, \$b, \$n);
} elsif($ans==3){




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
	my $ET = 2056;
	
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
	$ET = (($ET-$i)/$ET)*100;
	
	#Print the final solutions to the command line
	print "The I value is $i\n";
	print "The ET for this problem is $ET\n";
}
sub simpsons_rule{
#Initialize the variables
	my ($ans, $a, $b, $n)=@_;
	my $fx1; my $fx2; 
	my $fx_old1=0; my $fx_old2=0;
	my $i = $$n;
	
	###UPDATE the True Error
	my $ET = 2056;
	
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
	$ET = (($ET-$i)/$ET)*100;
	
	#Print the final solutions to the command line
	print "The I value is $i\n";
	print "The ET for this problem is $ET\n";
}

sub fx_solve{
	#Initialize values
	my ($ans, $x)=@_;
	my $fx;
	
	###UPDATE Solve the equation, and return the solution
	if ($ans==1 | $ans==2){
		$fx= (1/16)*(4*$x-3)**4;
	}
	return $fx;
}