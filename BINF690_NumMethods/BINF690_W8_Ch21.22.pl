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
#2) Will calculate Simpson's 1/3 rule for even numbers, 3/8 rule for N=3 and a combo of 1/3 and 3/8 for odd numbers
#3) Will calculate the trap approximation, using two n values

#Search for ###UPDATE to update necessary inputs before running

######################################################################################
								##CODE##
######################################################################################
#Chose the problem
print "Which problem would you like to complete?\n";
print "1) Trapazoid Rule (21.2)\n";
print "2) Simpon's 1/3 & 3/8 Rule (21.4, 21.5)\n";
print "3) Romberg Integration\n";
print "ANS: ";
my $ans = <STDIN>; chomp $ans;


if($ans==1){
	###UPDATE with input variables
	my $a = 0; my $b = 0.8;
	my $ET=1.64;
	
	#Ask the level of sectioning to perform
	print "What is your n?\n";
	print "ANS: ";
		my $n = <STDIN>; chomp $n;
	
	#Call the subroutine to determine the approximation, printing the I value
	my $i = integrate_trap(\$ans, \$a, \$b, \$n);
		print "The I value is $i\n";
	
	#Call the subroutine to determine the error, printing the ET and EA values
	error(\$ans, \$ET, \$a, \$b, \$n, \$i);

} elsif($ans==2){
	
	###UPDATE with input variables
	my $a = 0; my $b = 0.8;
	my $ET = 1.64;
	
	#Ask the level of sectioning to perform
	print "What is your n?\n";
	print "ANS: ";
		my $n = <STDIN>; chomp $n;

	#If N is even, perform 1/3 rule with error analysis
	if (0 == $n % 2) {
		my $i = simpsons_rule_13(\$ans, \$a, \$b, \$n);
		print "The I value is $i\n";
		error(\$ans, \$ET, \$a, \$b, \$n, \$i);

	#Else, if N is 3, perform 3/8 Rule with error analysis
	} elsif($n==3){
		my $i = simpsons_rule_38(\$ans, \$a, \$b, \$n);
		print "The I value is $i\n";
		
		#Use the 3rd error equation
		$ans =3;
		error(\$ans, \$ET, \$a, \$b, \$n, \$i);
	
	#Else, if N is any other odd, perform a combination of 1/3 and 3/8 Rule
	} else{
		#Pass all N, minus the last three to the 1/3 Rule
		my $rule_13 = simpsons_rule_13(\$ans, \$a, \$b, \$n);
		print "$rule_13\n";
		
		#Pass the last 3 N's to the 3/8 Rule
		my $rule_38 = simpsons_rule_38(\$ans, \$a, \$b, \$n);
		print "$rule_38\n";
		
		#Calculate the total I Value
		my $i = $rule_38 + $rule_13; 
		print "The I value is $i\n";

		#Determine the error for the problem
		$ans=3;
		error(\$ans, \$ET, \$a, \$b, \$n, \$i);

	}
} elsif($ans==3){
	###UPDATE with input variables
	my $a = 1; my $b = 2;
	my $n1=1; my $n2=2;
	my $EA = .5; my $ET=4.8333;
	
	rombergInt(\$ans, \$a, \$b, \$n1, \$n2, \$EA, \$ET);
} 

######################################################################################
								##Subroutines##
######################################################################################
sub integrate_trap {
	#Initialize the variables
	my ($ans, $a, $b, $n)=@_;
	my $fx1; my $fx_old=0;
	my $counter = 1; my $cap=$$a;
	my @holder;
	
	#Solve for H
	my $h=($$b-$$a)/$$n;
	
	#Create array of values
	until ($cap >$$b){
		my $segs = $cap;
		push(@holder, $segs);
		$cap = $cap + $h;
	}
	
	#Determine the fx values for the limits
	my $fx_start = sprintf("%.4f", fx_solve($$ans, $holder[0]));
	my $fx_end = sprintf("%.4f", fx_solve($$ans, $holder[$$n]));

	#Determine the sum of all fx values for the estimations
	until ($counter==$$n){
		$fx1 = sprintf("%.4f", fx_solve($$ans, $holder[$counter]));
		$fx1 = $fx_old + $fx1;
		$fx_old=$fx1;
		$counter++;
	}

	#Determine the integral value
	my $i =  sprintf("%.4f",(($fx_start + 2*$fx1 + $fx_end )/(2*$$n))*($$b-$$a));
	return $i;
}

sub rombergInt{
#Initialize the variables
	my ($ans, $a, $b, $n1, $n2, $EA_set, $ET)=@_;
	my $EA=5; my $value;
	my @lev1; my @lev2; my @lev3; my @lev4;
	my $iter=0; my $iter_L2=0; 	my $iter_L3=0; my $iter_L4=0;
	my $EA2=5; my $EA3=5; my $EA4=5; 

	#Calculate the first value
	my $temp1 = integrate_trap($ans, $a, $b, $n1);
	push(@lev1, $temp1);
	$$n1=$$n1+1;
	
	until ($$EA_set>$EA | $iter>10){
		#Calculate and save to an array the level 1 values
		my $temp1 = integrate_trap($ans, $a, $b, $n1);
		push(@lev1, $temp1);
				
		#Calculate and save to an array, the level 2 values 
		if ($iter>0){
			my $final = ((4*$lev1[$iter_L2+1])-($lev1[$iter_L2]))/3;
			push(@lev2,$final);
			$EA2 =  abs(sprintf("%.4f",(($lev2[0]-$lev1[1])/$lev1[0])*100));
			$iter_L2 = $iter_L2+1;
		}
		if($iter >2){			
			my $final = ((16*$lev2[$iter_L3+1])-($lev2[$iter_L3]))/15;
			push(@lev3,$final);
			$EA3 =  abs(sprintf("%.4f",(($lev3[0]-$lev2[1])/$lev3[0])*100));
			$iter_L3 = $iter_L3+1;
		}
		if($iter >3){			
			my $final = ((64*$lev3[$iter_L4+1])-($lev3[$iter_L4]))/63;
			push(@lev4,$final);
			$EA4 =  abs(sprintf("%.4f",(($lev4[0]-$lev3[1])/$lev3[0])*100));
			$iter_L4 = $iter_L4+1;
		}
		
		#Check the EA values to determine whether to continue

		if($EA2<$EA){
			$EA = $EA2; 
			$value = $lev2[$0];
		} elsif($EA3<$EA){
			$EA = $EA3;
			$value = $lev3[0];
		} elsif($EA4<$EA){
			$value=$lev4[0];
			$EA=$EA4;
		}
	
		#Move counters and N value forward
		$$n1=$$n1*2;
		$iter=$iter+1;
	}
	my $ET_sol =  abs(sprintf("%.4f",(($$ET-$value)/$$ET)*100));

	print "With an ET of $ET_sol, an ES of $EA, the value is $value\n";
}

sub simpsons_rule_13{
#Initialize the variables
	my ($ans, $a, $b, $n)=@_;
	my $fx1; my $fx2;  my $h;
	my $fx_old1=0; my $fx_old2=0;
	my $counter = 1; my $cap=$$a;
	my $length; my @holder;
	
	
	#Solve for H
	$h=($$b-$$a)/$$n;
	
	#Create array of values
	until ($cap >$$b){
			my $segs = $cap;
			push(@holder, $segs);
			$cap = $cap + $h;
	}
	
	#If 3/8 is being used, limit N to N-3
	if (0 == $$n % 2) {
		$length = $$n;
	} else{ 
		$length = $$n-3;
	}
		
	#Determine the fx values for the limits
	my $fx_start = sprintf("%.4f", fx_solve($$ans, $holder[0]));
	my $fx_end = sprintf("%.4f", fx_solve($$ans, $holder[$length]));

	#Determine the sum of all fx values for the estimations
	until ($counter>$length-1){
		
		#If the number is even, add to the fx1 group
		if (0 == $counter % 2) {
			$fx2 = sprintf("%.4f", fx_solve($$ans, $holder[$counter]));
			$fx2 = $fx_old2 + $fx2;
			$fx_old2=$fx2;
		} else {
			$fx1 = sprintf("%.4f", fx_solve($$ans, $holder[$counter]));
			$fx1 = $fx_old1 + $fx1;
			$fx_old1= $fx1;
		}
		#Reset counters
		$counter=$counter + 1;
	}

	#Determine the integral value
	my $i =  sprintf("%.4f",(($fx_start + 4*$fx1 + 2*$fx2 + $fx_end )/(3*$$n))*($holder[$$n]-$holder[0]));

	return $i;
}

sub simpsons_rule_38{
#Initialize the variables
	my ($ans, $a, $b, $n)=@_;
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
	#Initialize values
	my ($ans, $ET, $a, $b, $n, $i)=@_;
	my $app; my $EA;
	
	#Solve error - EA values
	my $f1x0= f1x_solve($$ans, $$a);
	my $f1xn= f1x_solve($$ans, $$b);

	#Calculate the error depending on the problem provided
	if ($$ans==1){
		$app = ($f1xn-$f1x0)/($$b-$$a);
		$EA = (-($$b-$$a)**3)/(12*($$n**2))*$app;
	} elsif($$ans==2){
		$app = ($f1xn+$f1x0)/(2);
		$EA = ((-($$b-$$a)**5)/(180*$$n**4))*$app;
	} elsif($$ans==3){
		$app = ($f1xn+$f1x0)/(2);
		$EA = ((-$$b-$$a)**5)/(6480)*$app;
	}
	$EA = sprintf("%.4f", $EA);
	
	#Solve the ET Value
	my $ET_solve =  abs(sprintf("%.4f",(($$ET-$$i)/$$ET)*100));
	
	#Print answers to screen
	print "The ET for this problem is $ET_solve%\n";
	print "The EA for this problem is $EA\n";
}

sub fx_solve{
	#Initialize values
	my ($ans, $x)=@_;
	my $fx;
	
	###UPDATE Solve the equation, and return the solution
	if($ans==1 | $ans ==2) {
		$fx= 0.2 + 25*$x - 200*$x**2 + 675*$x**3 -900*$x**4 + 400*$x**5;
	} elsif ($ans==3){
		#$fx = $x * exp(2*$x);
		$fx = ($x + (1/$x))**2;
	}
	return $fx;
}

sub f1x_solve{
	#Initialize values
	my ($ans, $x)=@_;
	my $fx;
	
	###UPDATE Solve the equation, and return the solution
	if ($ans==1){
		$fx=-400*$x + 2025*$x**2 - 3600*$x**3 + 2000*$x**4;
	} elsif ($ans=2){
		$fx=-21600 + 48000*$x;
	}
	return $fx;
}