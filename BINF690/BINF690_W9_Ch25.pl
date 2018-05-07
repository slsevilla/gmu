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
print "  4) Ralston's RK 2nd order\n";
print "  5) Ralston's RK 4th order\n";
print "ANS:";
	my $ans = <STDIN>; chomp $ans;

if ($ans==1){
	
	#UPDATE Variables
	my $step = .5; my $x0 = 0; my $x1 = 4; 
	my $xi = 0;	my $yi = 0;	
	
	#Initialize Variables
	my @x_val; my @y_true; my @y_euler;
	
	#Call subroutines
	Eulers_method(\@y_euler, \@y_true, \@x_val, \$step, \$x0, \$x1, \$xi, \$yi, \$ans);
	graph_data(\@x_val, \@y_true, \@y_euler, \@x_val, $ans, $ans);
	
} elsif($ans==2){
	
	###UPDATE variables
	my $step = 1;
	my $x0 = 0;
	my $x1 = 4;
	my $xi = 0;
	my $yi = 2;
	
	#Initialize Variables
	my @x_val; my @y_true; my @y_heuns;
	
	#Call subroutines
	Heun_Method(\@y_heuns, \@y_true, \@x_val, \$step,$x0, \$x1, \$xi, \$yi, \$ans);
	graph_data(\@x_val, \@y_true, \@y_heuns, \@x_val, $ans, $ans);

} elsif($ans==3){
	
	###UPDATE variables
	my $step = .5;
	my $x0 = 0;
	my $x1 = 4;
	my $xi = 0;
	my $yi = 0;
	
	#Initialize Variables
	my @x_val; my @y_true; my @y_euler; my @y_heuns;

	#Call subroutines
	Eulers_method(\@y_euler, \@y_true, \@x_val, \$step, \$x0, \$x1, \$xi, \$yi, \$ans);
	Heun_Method(\@y_heuns, \@y_true, \@x_val, \$step,$x0, \$x1, \$xi, \$yi, \$ans);
	graph_data(\@x_val, \@y_true, \@y_heuns, \@y_euler, $ans, $ans);

} elsif($ans==4){
	
	###UPDATE variables
	my $step = .5;
	my $x0 = 0;
	my $x1 = 4;
	my $xi = 0;
	my $yi = 1;
	
	#Initialize Variables
	my @x_val; my @y_true;my @y_euler; my @y_rk;
	my $order =2; my $eq=1;
	
	#Call subroutines
	RK_Method(\@y_rk, \@y_true, \@x_val, \$step, \$x0, \$x1, \$xi, \$yi, \$eq, \$order);
	graph_data(\@x_val, \@y_true, \@y_rk, \@x_val, $ans, $ans);

}elsif($ans==5){
	###UPDATE variables
	my $step = 2;
	my $x0 = 0;
	my $x1 = 2;
	my $xi = 0;
	my $yi = 2;
	
	#Initialize Variables
	my @x_val; my @y_true;my @y_euler; my @y_rk;
	my $order =4; my $eq=2;
	
	#Call subroutines
	RK_Method(\@y_rk, \@y_true, \@x_val, \$step, \$x0, \$x1, \$xi, \$yi, \$eq, \$order);
	graph_data(\@x_val, \@y_true, \@y_rk, \@x_val, $ans, $ans);

}

######################################################################################
								##Subroutines##
######################################################################################
#Subroutine graphs g' data for visual reference, and prints to file
sub graph_data{
	my ($data1_in, $data2_in, $data3_in, $data4_in, $ans, $eq)=@_;
	
	#Initialize Variables
	my @data; my @xval; my @xval2; my @yval; my @yval2; my @yval3;
	
	#Create file name
	my $file="Graph_EQ";
	$file .= $eq;
	
	#Check answers to determine if multiple x inputs, or y inputs
	#1 and #2 = Two inputs with two graphs
	#3 = Three inputs and three lines
	if ($ans==1 | $ans==2 | $ans==4| $ans==5){
		@xval= @$data1_in;
		@yval = @$data2_in;
		@yval2 = @$data3_in;
		@data = (\@xval,\@yval, \@yval2, \@yval, \@yval2);
	} elsif($ans==3){
		@xval= @$data1_in;
		@yval = @$data2_in;
		@yval2 = @$data3_in;
		@yval3 = @$data4_in;
		@data = (\@xval, \@yval, \@yval2, \@yval3, \@yval, \@yval2, \@yval3);
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
	if ($ans==1 | $ans==2 | $ans==4 | $ans==5){
		$graph -> set(
			types =>[qw(points points lines lines)],
			markers => [qw(1,3)],
			marker_size =>3,
			dclrs=>[ qw(purple red)],
			x_label => "X",
			y_label => "Y",
			zero_axis=>"true",
			title => "Graph of Comparison | Red = True, Purple = Approx");
	} elsif($ans==3){
			$graph -> set(
			types =>[qw(points points points lines lines lines)],
			markers => [qw(1,3)],
			marker_size =>3,
			dclrs=>[ qw(purple red orange)],
			x_label => "X",
			y_label => "Y",
			zero_axis=>"true",
			title => "Comparison | Red = True, Purple = Heuns, Orange = Euler");
	}
	
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
	#1 and #3) 25.1 Example
	#2) 25.5 Example
	
	#Equations solved
	if($eq==1 | $eq==3){
		$fx=-.5*$x**4 + 4*$x**3 -  10*$x**2 + 8.5*$x +1;
	} elsif($eq==2){
		$fx=(4/1.3)*(exp(.8*$x)-exp(-.5*$x)) + 2*exp(-.5*$x);
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
	#1 and #3) 25.1 Example
	#2) 25.5 Example

	#Equations solved
	if($eq==1 | $eq==3){
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

	#Empty true array if repeating with Heuns method
	if ($$eq==3){
		@$y_true=();
		@$x_val=();
	}
	
}

sub Heun_Method{
	#Pass in Variables
	my ($y_heun, $y_true, $x_val, $step, $x0, $x1, $xi, $yi, $eq)=@_;
	
	#Initialize Variables
	my $Et; my $ETtotal; my $iter = 1; 
	my $fleft; my $fright; my $fp; my $fsol;
		
	#Set starting values
	my $x = $$xi+1; my $y= $$yi; my $der =1;
	my $f1x = fder_solve($x, $y, $$eq, $der);
	my $fx_true;
	
	until ($x>$$x1){
		
		#Solve the Equations for Euler with the Corrector and Error
		$fleft = fder_solve($x-1,$y, $$eq, $der);
		$fp = $y + $fleft*$$step;
		$fright = fder_solve($x, $fp, $$eq, $der);
		$fx_true = fx_solve($x, $y+$$step, $$eq);

		#Solve Heun's
		$fsol = sprintf("%.3f",$y + $$step*(($fleft + $fright)/2));
		
		#Determine the Error This
		$Et = abs(sprintf("%.3f",(($fx_true - $fsol)/$fx_true) * 100));

		#print "The Heun's approx is $fsol, with an Et of $Et%\n";

		#Set counters for next iteration
		$x = $x+$$step; $y=$fsol;
		$iter=$iter+1;
		
		#Push values to array for later graphing
		push (@$y_heun, $fsol);
		push (@$y_true, $fx_true);
		push (@$x_val, $x);
	}
	

	print "\n#################################################\n";
	print "The Heun's approx is $fsol, with an Et of $Et%\n";
	print "\n#################################################\n";
}

sub RK_Method{
	#Pass in Variables
	my ($y_rk, $y_true, $x_val, $step, $x0, $x1, $xi, $yi, $eq, $order)=@_;
	
	#Initialize Variables
	my $k1; my $k2; my $k3; my $k4;
	my $der=1; my $x; my $y; my $fsol; my $fx_true;
	
	if($$order==2){
		for ($$x0; $$x0<$$x1; $$x0+$$step){
			$k1 = fder_solve($$x0,$$yi, $$eq, $der);
				$x = $$x0 + (3/4)*$$step;
				$y = $$yi + (3/4)*$$step*$k1;
			$k2 = fder_solve($x,$y, $$eq, $der);
			$fsol = sprintf("%.4f", $$yi + ((1/3)*$k1 + (2/3)*$k2)*$$step);
			
			#Increase the increment and determine the error
			$$yi=$fsol;
			$$x0=$$x0+$$step;
			$fx_true = fx_solve($$x0,$$yi, $$eq, $der);

			#Push values to array for later graphing
			push (@$y_rk, $fsol);
			push (@$y_true, $fx_true);
			push (@$x_val, $x);
		}

		#Calculate the error
		my $ET = (($fx_true - $fsol)/ $fx_true)*100;
		
		print "\n#################################################\n";
		print "The final RK 2nd order solution is is $fsol with and Et of $ET%\n";
		print "\n#################################################\n";
	} else{
		for ($$x0; $$x0<$$x1; $$x0+$$step){
			$k1 = fder_solve($$x0,$$yi, $$eq, $der);
				$x = $$x0+ (1/2)*$$step;
				$y = $$yi + (1/2)*$$step*$k1;
			$k2 = fder_solve($x,$y, $$eq, $der);
				$x = $$x0 + (1/2)*$$step;
				$y = $$yi + (1/2)*$$step*$k2;
			$k3= fder_solve($x,$y, $$eq, $der);
				$x = $$x0 + $$step;
				$y = $$yi + $$step*$k3;
			$k4= fder_solve($x,$y, $$eq, $der);
			$fsol = sprintf("%.4f", $$yi + (1/6)*($k1 + 2*$k2+2*$k3+$k4)*$$step);
			
			#Increase the increment and determine the error
			$$yi=$fsol;
			$$x0=$$x0+$$step;
			$fx_true = fx_solve($$x0,$$yi, $$eq, $der);
			
			#Push values to array for later graphing
			push (@$y_rk, $fsol);
			push (@$y_true, $fx_true);
			push (@$x_val, $x);
		}

		#Calculate the error
		my $ET = sprintf("%.4f",(($fx_true - $fsol)/ $fx_true)*100);
		
		print "\n#################################################\n";
		print "The RK 4th order solution is $fsol with and Et of $ET%\n";
		print "\n#################################################\n";
	}
	
	
}