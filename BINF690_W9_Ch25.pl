#!/usr/bin/perl
#User: Samantha Sevilla
#BINF690
#Chapter 25

use strict;
use GD::Graph::mixed;
use GD::Graph::colour

######################################################################################
								##NOTES##
######################################################################################
##This script was created from Ch25 problems



######################################################################################
								##Main Code##
######################################################################################
#Standard input from CML
print "What would you like to do?\n";
print "  1) Euler's Method\n";
print "  2) Heun's Method \n";
print "  3) Euler's Compared to Heun's\n";
print "ANS:";
	my $ans = <STDIN>; chomp $ans;

if ($ans==1){
	
	#UPDATE Variables
	my $step = .5; my $x0 = 0; my $x1 = 4; 
	my $xi = 0;	my $yi = 0;	
	
	#Initialize Variables
	my @x_val; my @y_true; my @y_euler;
	
	Eulers_method(\@y_euler, \@y_true, \@x_val, \$step, \$x0, \$x1, \$xi, \$yi, \$ans);
	graph_data(\@x_val, \@y_true, \@y_euler, $ans, $ans);
	
} elsif($ans==2){
	
	#Initialize Variables
	my $step = 1;
	my $x0 = 0;
	my $x1 = 4;
	my $xi = 0;
	my $yi = 2;
	
	#Initialize Variables
	my @x_val; my @y_true; my @y_euler;
	Heun_Method(\@y_euler, \@y_true, \@x_val, \$step,$x0, \$x1, \$xi, \$yi, \$ans);

} elsif($ans==3){
	
	#Initialize Variables
	my $step = .5;
	my $x0 = 0;
	my $x1 = 4;
	my $xi = 0;
	my $yi = 0;
	my $eq=1;
	
	#Initialize Variables
	my @x_val; my @y_true; my @y_euler;
	Eulers_method(\@y_euler, \@y_true, \@x_val, \$step, \$x0, \$x1, \$xi, \$yi, \$eq);
	graph_data(\@x_val, \@y_true, \@y_euler, $ans, $ans);
	Heun_Method(\@y_euler, \@y_true, \@x_val, \$step,$x0, \$x1, \$xi, \$yi, \$ans);



}

######################################################################################
								##Subroutines##
######################################################################################
#Subroutine graphs g' data for visual reference, and prints to file
sub graph_data{
	my ($data1_in, $data2_in, $data3_in, $ans, $eq)=@_;
	
	#Initialize Variables
	my @data; my @xval; my @xval2; my @yval; my @yval2; 
	
	#Create file name
	my $file="Graph_EQ";
	$file .= $eq;
	
	#Check answers to determine if multiple x inputs, or y inputs
	#1 = Multiple y inputs and 2 = Multiple x inputs 3 = Generate data
	if ($ans==1 | $ans==3){
		@xval= @$data1_in;
		@yval = @$data2_in;
		@yval2 = @$data3_in;
		my @set1 =(@xval, @yval);
		my @set2 = (@xval, @yval2);
		@data = (\@xval,\@yval, \@yval2, \@yval, \@yval2);
		
		#@data = (\@yval,\@xval,\@yval2); print "using 1\n";
	} elsif($ans==2){
		@xval= @$data1_in;
		@yval = @$data2_in;
		@yval2 = @$data3_in;
		@data = (\@xval,\@yval,\@yval2);
	} else{
		my $x = 0; my $y =0;
		until ($x>10){
			my $fx = fx_solve($x, $y, $eq);
			push(@xval,$x);
			push(@yval,$fx);
			$x=$x+1;
		}
		@data = (\@xval,\@yval);
	}

	#Set graph dimensions and label information for the points provided and linear
	#regression line
	my $graph = GD::Graph::mixed -> new(500,400);
	$graph -> set(
		types =>[qw(points points lines lines)],
		markers => [qw(1,3)],
		marker_size =>3,
		dclrs=>[ qw(purple red)],
		x_label => "X",
		y_label => "Y",
		zero_axis=>"true",
		title => "Graph of Euler | Red = Euler, Purple = True");

	#Create and save graph to gift file
	my $lineimage= $graph ->plot(\@data);
	open(IMG,"> $file.gif") or die$!;
		binmode IMG;
		print IMG $lineimage->gif;
		close IMG;
}

sub fx_solve{
	my($x, $y, $eq)=@_;
	my $fx;	
	
	###UPDATE NEW EQUATIONS
	#1) 25.1 Example
	
	#Equations solved
	if($eq==1){
		$fx=-.5*$x**4 + 4*$x**3 -  10*$x**2 + 8.5*$x +1;
	} elsif($eq==2){
		$fx=(4/1.3)*(exp(.08*$x)-exp(-.5*$x)) + 2*exp(-.5*$x);
	} elsif($eq==3){
		$fx=0;
	} else{
		$fx=0;
	}
	
	return $fx;
}

#Subroutine solves the f'(x) value, returning f'(x) value (Y value)
sub fder_solve{
	my($x, $y, $eq, $der)=@_;
	my $f1_fx;	
	
	###UPDATE NEW EQUATION
	#1) 25.1 Example

	#Equations solved
	if($eq==1){
		if($der==1){
			$f1_fx=-2*$x**3 + 12*$x**2 - 20*$x + 8.5;
		} elsif($der==2){
			$f1_fx=-6*$x**2 + 24*$x - 20;
		} elsif($der==3){
			$f1_fx=-12*$x + 24;
		} else{
			$f1_fx = -12;
		}
	} elsif($eq==2){
		if($der==1){
			$f1_fx=4*exp(0.8*$x)-0.5*$y;
		} 	
	}

	return $f1_fx;
}

sub Eulers_method{
	#Pass in Variables
	my ($y_euler, $y_true, $x_val, $step, $x0, $x1, $xi, $yi, $eq)=@_;
	
	#Initialize Variables
	my $f1x; my $fx_true; my $Et; my $euler; my $ETtotal;
	my $iter = 1; my $level=4;
		
	#Set starting values
	my $x = $$xi; my $y= $$yi;	my $der =1;
	my $fx = fx_solve($x,$$eq, $der);
	
	until ($x==$$x1){
		
		#Solve the Equations for Euler and Error
		$f1x = fder_solve($x, $y, $$eq, $der);
		$fx_true = fx_solve($x+$$step, $y+$$step, $$eq);
		
		#Solve Euler
		$euler = $fx + $f1x * $$step;
		
		#Determine the Error This
		$Et = sprintf("%.3f",(($fx_true - $euler)/$fx_true) * 100);
		
		#Set counters for next iteration
		$x = $x+$$step; $y=$y+$$step;
		$fx = $euler;
		$iter=$iter+1;
		
		#Push values to array for later graphing
		push (@$y_euler, $euler);
		push (@$y_true, $fx_true);
		push (@$x_val, $x);

	}
	print "\n#################################################\n";
	print "The Euler's approx is $euler, with an Et of $Et%\n";
	print "\n#################################################\n";
	print "y true @$y_true\n";
	print "x true @$x_val\n";
	print "y solve @$y_euler\n";
	
	#Calculate the truncation error
	for (my $i=2; $i<=$level; $i++){
			
		#Calcualte the factorial values
		my $fact=$i; my $n = $i-1;
		for ($n; $n>0; $n--){
			$fact = $fact * $n;	
		}
		
		#Use the truncation formula to determine total error
		my $temp = fder_solve($$xi, $$yi, $$eq, $i); 
		my $Etrunc = ($temp / $fact) * ($$step**$i);
		$ETtotal = $ETtotal + $Etrunc;
	}
	print "#################################################\n";
	print "\n The Total truncation error is $ETtotal\n";
	print "\n#################################################\n";

}

sub Heun_Method{
	#Pass in Variables
	my ($y_euler, $y_true, $x_val, $step, $x0, $x1, $xi, $yi, $eq)=@_;
	
	#Initialize Variables
	my $f1x; my $fx_true; my $Et; my $ETtotal;
	my $iter = 1; my $f10x;
		
	#Set starting values
	my $x = $$xi; my $y= $$yi; my $der =1;
	my $f1x = fder_solve($x, $y, $$eq, $der);
	my $euler= $$yi + $f1x*$$step;
	
	until ($x==$$x1){
		
		#Solve the Equations for Euler with the Corrector and Error
		$f10x =  fder_solve($x+1, $euler, $$eq, $der);
		$f1x = fder_solve($x, $y, $$eq, $der);
		$fx_true = fx_solve($x+$$step, $y+$$step, $$eq);

		#Solve Euler
		$euler = sprintf("%.3f", $$yi + (($f1x + $f10x) / 2) * $$step);
		
		#Determine the Error This
		#$Et = sprintf("%.3f",(($fx_true - $euler)/$fx_true) * 100);

		print "The Euler's approx is $euler, with an Et of $Et%\n";

		#Set counters for next iteration
		$x = $x+$$step; $y=$y+$$step;
		$iter=$iter+1;
		
		#Push values to array for later graphing
		push (@$y_euler, $euler);
		push (@$y_true, $fx_true);
		push (@$x_val, $x);
	}
	print "\n#################################################\n";
	print "The Euler's approx is $euler, with an Et of $Et%\n";
	print "\n#################################################\n";

	#Calculate the truncation error
	my $temp = fder_solve($$xi, $$yi, $$eq, $der); 
	my $Etrunc = (-$temp / 12) * ($$step**3);
	
	print "#################################################\n";
	print "\n The Total truncation error is $Etrunc\n";
	print "\n#################################################\n";

}