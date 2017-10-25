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
print "2) Simpon's 1/3 & 3/8 Rule (21.4, 21.5)\n";
print "ANS: ";
my $ans = <STDIN>; chomp $ans;
my $partial;

if($ans==1){
	###UPDATE with input variables
	my $a = 0; my $b = 0.8;
	
	#Ask the level of sectioning to perform
	print "What is your n?\n";
	print "ANS: ";
		my $n = <STDIN>; chomp $n;
		$partial = $n;
	
	#Call the subroutine to determine the approximation, printing the I value
	my $i = integrate_trap(\$ans, \$a, \$b, \$n, \$partial);
		print "The I value is $i\n";
	
	#Call the subroutine to determine the error, printing the ET and EA values
	error(\$ans, \$a, \$b, \$n, \$partial, \$i);

} elsif($ans==2){
	###UPDATE with input variables
	my $a = 0; my $b = 0.8;
	
	#Ask the level of sectioning to perform
	print "What is your n?\n";
	print "ANS: ";
		my $n = <STDIN>; chomp $n;

	#If N is even, perform 1/3 rule
	if (0 == $n % 2) {
		$partial = $n;
		my $i = simpsons_rule_13(\$ans, \$a, \$b, \$n, \$partial);
		print "The I value is $i\n";
		error(\$ans, \$a, \$b, \$n, \$partial, \$i);

	#Else, if N is 3, perform 3/8 Rule
	} elsif($n==3){
		$partial = $n;
		my $i = simpsons_rule_38(\$ans, \$a, \$b, \$n, \$partial);
		error(\$ans, \$a, \$b, \$n, \$partial, \$i);
	
	#Else, if N is any other odd, perform a combination of 1/3 and 3/8 Rule
	} else{
		
		my $rule_38 = simpsons_rule_38(\$ans, \$a, \$b, \$n, \$partial);

		#Pass all N, minus the last three to the 1/3 Rule
		$partial = $n-3;
		my $rule_13 = simpsons_rule_13(\$ans, \$a, \$b, \$n, \$partial);
		
		my $i = $rule_38 + $rule_13; 
		print "The I value is $i\n";
		$ans=3;
		error(\$ans, \$a, \$b, \$n, \$partial, \$i);

	}
}

######################################################################################
								##Subroutines##
######################################################################################
sub integrate_trap {
	#Initialize the variables
	my ($ans, $a, $b, $n, $partial)=@_;
	my $fx1; my $fx_old=0;
	my $i = 1; my $cap=$$a;
	my @holder;
	
	#Solve for H, create array of segments
	my $h=($$b-$$a)/$$n;
	until ($cap >$$b){
		my $segs = $cap;
		push(@holder, $segs);
		$cap = $cap + $h;
	}
	
	#Determine the fx values for the limits
	my $fx_start = sprintf("%.4f", fx_solve($$ans, $holder[0]));
	my $fx_end = sprintf("%.4f", fx_solve($$ans, $holder[$$partial]));

	#Determine the sum of all fx values for the estimations
	until ($i==$$partial){
		$fx1 = sprintf("%.4f", fx_solve($$ans, $holder[$i]));
		$fx1 = $fx_old + $fx1;
		$fx_old=$fx1;
		
		$i++;
	}

	#Determine the integral value
	my $i =  sprintf("%.4f",(($fx_start + 2*$fx1 + $fx_end )/(2*$$n))*($$b-$$a));

	return $i;
}

sub simpsons_rule_13{
#Initialize the variables
	my ($ans, $a, $b, $n, $partial)=@_;
	my $fx1; my $fx2; 
	my $fx_old1=0; my $fx_old2=0;
	my $i = 1; my $cap=$$a;
	my @holder;

	#Solve for H, create array of segments
	my $h=($$b-$$a)/$$n;
	until ($cap >$$b){
		my $segs = $cap;
		push(@holder, $segs);
		$cap = $cap + $h;
	}
	
	#Determine the fx values for the limits
	my $fx_start = sprintf("%.4f", fx_solve($$ans, $holder[0]));
	my $fx_end = sprintf("%.4f", fx_solve($$ans, $holder[$$partial]));

	#Determine the sum of all fx values for the estimations
	until ($i==$$partial){
		
		#If the number is even, add to the fx1 group
		if (0 == $i % 2) {
			$fx2 = sprintf("%.4f", fx_solve($$ans, $holder[$i]));
			$fx2 = $fx_old2 + $fx2;
			$fx_old2=$fx2;
		} else {
			$fx1 = sprintf("%.4f", fx_solve($$ans, $holder[$i]));
			$fx1 = $fx_old1 + $fx1;
			$fx_old1= $fx1;
		}
		#Reset counters
		$i++;
	}

	#Determine the integral value
	my $i =  sprintf("%.4f",(($fx_start + 4*$fx1 + 2*$fx2 + $fx_end )/(3*$$partial))*($holder[$$partial]-$holder[0]));

	return $i;
}

sub simpsons_rule_38{
#Initialize the variables
	my ($ans, $a, $b, $n, $partial)=@_;
	my $i = 1; my $cap=$$a;
	my @holder;
	
	#Solve for H, create array of segments
	my $h=($$b-$$a)/$$n;
	until ($cap >$$b){
		my $segs = $cap;
		push(@holder, $segs);
		$cap = $cap + $h;
	}
	
	#Determine the fx values for the limits
	my $fx_start = sprintf("%.4f", fx_solve($$ans, $holder[$$n-3]));
	my $fx_1 = sprintf("%.4f", fx_solve($$ans, $holder[$$n-2]));
	my $fx_2 = sprintf("%.4f", fx_solve($$ans, $holder[$$n-1]));
	my $fx_end = sprintf("%.4f", fx_solve($$ans, $holder[$$n]));

	#Determine the integral value
	my $i =  sprintf("%.4f",(($fx_start + 3*($fx_1+$fx_2) + $fx_end )/(8))*($holder[$$n]-$holder[$$n-3]));

	#Set simpson 3/8 value for error
	my $simrule = 3;

	return $i;
}

sub error{
	#Initialize
	my ($ans, $a, $b, $n, $partial, $i)=@_;
	my $app; my $EA;
	
	###UPDATE
	my $ET = 1.6405333;

	#Solve error
	my $f1x0= f1x_solve($ans, $a);
	my $f1xn= f1x_solve($ans, $b);
	
	if ($ans==1){
		$app = ($f1xn-$f1x0)/($b-$a);
		$EA = (-($b-$a)**3)/(12*($n**2))*$app;
	} elsif($ans==2){
		$app = ($f1xn+$f1x0)/(2);
		$EA = ((-($b-$a)**5)/(180*$n**4))*$app;
		
	} elsif($ans==3){
		$app = ($f1xn+$f1x0)/(2);
		$EA = ((-$b-$a)**5)/(6480)*$app;
	}
	$EA = sprintf("%.4f", $EA);
	$ET =  sprintf("%.4f",(($ET-$$i)/$ET)*100);

	
	print "The ET for this problem is $ET%\n";
	if ($EA>0){
		print "The EA for this problem is $EA\n";
	}
}

sub fx_solve{
	#Initialize values
	my ($ans, $x)=@_;
	my $fx;
	
	#Solve the equation, and return the solution
	$fx= 0.2 + 25*$x - 200*$x**2 + 675*$x**3 -900*$x**4 + 400*$x**5;
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