#User: Samantha Sevilla
#Date: 12/13/17
#Course: BINF690
#Final Exam
#!/usr/bin/perl
use strict;
use GD::Graph::mixed;

######################################################################################
								##NOTES##
######################################################################################
#1) Calculate the Interpolating Polynomials for 1st through 4th orderWill
#2) Integrate (21.15)
#3) Solve Differential using Euler and RK Methods
#4) Euler to solve system of differential equations

#Search for ###UPDATE to update necessary inputs before running

######################################################################################
								##CODE##
######################################################################################
#Chose the problem
print "Which problem would you like to complete?\n";
print "1) Integrate over 1st through 4th order\n";
print "2) Integrate (21.15)\n";
print "3) Solve Differential using Euler and RK Methods\n";
print "4) Euler to solve system of differential equations\n";
print "ANS: ";
my $ans = <STDIN>; chomp $ans;


if($ans==1){
	my @xvals = qw(3 5 2 7 1);
	my @yvals = qw(19 99 6 291 3);
	my $x = 4;
	
	newton_div(\@xvals,\@yvals, \$x);	
		
	
} elsif($ans==2){
	
	###UPDATE with input variables
	my $a = -2; my $b = 2;
	my $ET=-160;
	
	#Ask the level of sectioning to perform
	print "What is your n?\n";
	print "ANS: ";
		my $n = <STDIN>; chomp $n;

	#Perform 1/3 rule with error analysis
	my $i = simpsons_rule_13(\$ans, \$a, \$b, \$n);
	print "The I value is $i\n";
	error(\$ans, \$ET, \$a, \$b, \$n, \$i);

} elsif($ans==3){

	###UPDATE variables
	my $step = .25;
	my $xmin = 0;
	my $xmax = 3;
	my $xi = 0;
	my $yi = 0;
	
	#Initialize Variables
	my @x_val; my @y_true = -23.1711; my @y_euler;
	my @y_rk;
	
	#Call subroutines for Euler's Method
	Eulers_method_single(\@y_euler, \@y_true, \@x_val, \$step, \$xmin, \$xmax, \$xi, \$yi, \$ans);
	
	#Re-Initialize Variables
	my @x_val;
	
	#Call subroutine for RK Method
	RK_Method(\@y_rk, \@y_true, \@x_val, \$step, \$xmin, \$xmax, \$xi, \$yi, \$ans);
	
} elsif($ans==4){

	###UPDATE variables
	my $step = .1;
	my $xmin = 0;
	my $xmax = 10;
	my $xi = 0;
	my $yi1 = 0;
	my $yi2 = 1;
	
	#Call subroutines for Euler's Method
	Eulers_method_multiple(\$step, \$xmin, \$xmax, \$xi, \$yi1, \$yi2);
	
}

######################################################################################
								##Subroutines##
######################################################################################
sub newton_div{
	my ($xvals, $yvals, $x)=@_;
	
	#Create Temp arrays
	my @tempx=@$xvals; my @tempy=@$yvals;
	
	#Initalize Variables
	my @interpol; my @solution;
	my $iter =1;
	my $n=0; my $i=0;
	my @order = qw (first second third fourth);
	
	until ($iter==5){
		
		#Determine the length of the Y array
		my $length = scalar @tempy -1; 

		#Run a loop for the length of y variables - 1
		for (my $i=0; $i < $length; $i++){
			
			#Calculate the divided difference
			my $temp = ($tempy[$i+1]-$tempy[$i])/($tempx[$i+$iter]-$tempx[$i]);
			
			#Save differences to array
			push(@interpol, sprintf("%.8f",$temp));
			push(@solution, sprintf("%.8f",$temp));
		}
		
		#Print the divided differences
		print "\n The $order[$iter-1] divided differences are\n";
		foreach(@interpol){
			print "$interpol[$i]\n";
			$i++;
		}
		
		#Save the differences as the new Y values and increase/reset counters
		@tempy = @interpol;
		@interpol=();
		$iter = $iter+1; $i=0;
	}

	#Determine the answer for the given X
	my $ans = @$yvals[0] + $solution[0]*($$x-@$xvals[0])+ $solution[4]*($$x-@$xvals[0])*($$x-@$xvals[1])+ $solution[7]*($$x-@$xvals[0])*($$x-@$xvals[1])*($$x-@$xvals[2]);
	
	print "\n\n******************************************\n";
	print "The final solution for f($$x) is $ans\n";
	print "******************************************\n\n";

}

sub simpsons_rule_13{
#Initialize the variables
	my ($ans, $a, $b, $n)=@_;
	my $fx1; my $fx2;  my $h;
	my $fx_old1=0; my $fx_old2=0;
	my $counter = 1; my $cap=$$a;
	my $length = $$n; my @holder;
		
	#Solve for H
	$h=($$b-$$a)/$$n;
	
	#Create array of values
	until ($cap >$$b){
			my $segs = $cap;
			push(@holder, $segs);
			$cap = $cap + $h;
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

sub error{
	#Initialize values
	my ($ans, $ET, $a, $b, $n, $i)=@_;
	my $app; my $EA;
	
	#Solve error - EA values
	my $f1x0= f1x_solve($$ans, $$a);
	my $f1xn= f1x_solve($$ans, $$b);

	#Calculate the error depending on the problem provided
		$app = ($f1xn-$f1x0)/($$b-$$a);
		$EA = ((-($$b-$$a)**5)/(2880))*$app;
		$EA = sprintf("%.4f", $EA);
	
	#Solve the ET Value
	my $ET_solve =  abs(sprintf("%.4f",(($$ET-$$i)/$$ET)*100));
	
	#Print answers to screen
	print "The ET for this problem is $ET_solve%\n";
}

sub fx_solve{
	#Initialize values
	my ($ans,$x, $y)=@_;
	my $fx;
	
	###UPDATE Solve the equation, and return the solution
	if ($ans==2){
		$fx= (-40-24*$x);
		return $fx;
	} elsif($ans==3){
		$fx=exp((($x**3)/3)-1.1*$x);
		return $fx;
	}
}

sub f1x_solve{
	#Initialize values
	my ($ans, $x, $y1, $y2)=@_;
	my $fx;
	
	###UPDATE Solve the equation, and return the solution
	if ($ans==2){
		$fx= (-40*$x-12*$x);
		return $fx;
	} elsif($ans==3){
		$fx= $y1 -$x**2;
		return $fx;
	} elsif($ans==4){
		$fx = -.5*$y2;
		return $fx;
	} elsif($ans==5){
		$fx = $y1;
		return $fx;
	}
}

sub Eulers_method_single{
	#Pass in Variables
	my ($y_euler, $y_true, $x_val, $step, $xmin, $xmax, $xi, $yi, $eq)=@_;
	my $x = $$xi; my $euler = $$yi; my $y;
	
	#Move steps until max x is reached
	until ($x == $$xmax){
		
		#Save old x and increase counter
		my $x_old = $x; $x = $x + $$step;
		my $y_old = $euler;
		
		#Find the Derivative
		my $f1x = f1x_solve($$eq, $x_old, $y_old);
		
		#Find the Euler Approx
		$euler = sprintf("%4f", $y_old + $f1x*$$step);
	}
	
	#Calculate the error
	my $ET = sprintf("%.4f",((@$y_true[0] - $euler)/ @$y_true[0])*100);
	
	print "\n#################################################\n";
	print "The Euler's approx is $euler with and Et of $ET%\n";
	print "\n#################################################\n";
}

sub RK_Method{
	#Pass in Variables
	my ($y_rk, $y_true, $x_val, $step, $x0, $x1, $xi, $yi, $eq)=@_;
	
	#Initialize Variables
	my $k1; my $k2; my $k3; my $k4;
	my $x; my $y; my $fsol; my $fx_true;
	
	for ($$x0; $$x0<$$x1; $$x0+$$step){
		$k1 = f1x_solve($$eq, $$x0, $$yi);
			$x = $$x0+ (1/2)*$$step;
			$y = $$yi + (1/2)*$$step*$k1;
		$k2 = f1x_solve($$eq, $x,$y);
			$x = $$x0 + (1/2)*$$step;
			$y = $$yi + (1/2)*$$step*$k2;
		$k3= f1x_solve($$eq, $x,$y);
			$x = $$x0 + $$step;
			$y = $$yi + $$step*$k3;
		$k4= f1x_solve($$eq, $x,$y);
		$fsol = sprintf("%.4f", $$yi + (1/6)*($k1 + 2*$k2+2*$k3+$k4)*$$step);
		
		#Increase the increment and determine the error
		$$yi=$fsol; $$x0=$$x0+$$step;
	}

	#Calculate the error
	my $ET = sprintf("%.4f",((@$y_true[0] - $fsol)/ @$y_true[0])*100);
		
	print "\n#################################################\n";
	print "The RK 4th order solution is $fsol with and Et of $ET%\n";
	print "\n#################################################\n";
}

sub Eulers_method_multiple{
	#Pass in Variables
	my ($step, $xmin, $xmax, $xi, $yi1, $yi2)=@_;
	my $x = $$xi; my $euler1 = $$yi1; my $euler2 = $$yi2;
	my $y1; my $y2; my $x_old; my $y_old1; my $y_old2;

	#Move steps until max x is reached
	until ($x >10){
	
		#Save old x and increase counter
		$x_old = $x; 
		$x = sprintf("%.1f", $x + $$step); 
		$y_old1 = $euler1;
		$y_old2 = $euler2;
		
		#Find the Derivatives
		my $f1x1 = f1x_solve(4, $x_old, $y_old1, $y_old2);
		my $f1x2 = f1x_solve(5, $x_old, $y_old1, $y_old2);
		
		#Find the Euler Approx
		$euler1 = sprintf("%4f", $y_old1 + $f1x1*$$step);
		$euler2 = sprintf("%4f", $y_old2 + $f1x2*$$step);
	}
	
	print "\n#################################################\n";
	print "The Euler's approx of Y at t=10 is $euler1\n";
	print "The Euler's approx of X at t=10 is $euler2\n";
	print "\n#################################################\n";
}