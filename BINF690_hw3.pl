#User: Samantha Sevilla
#Date: 10/2/17 updated
#Course: BINF690
#Ch5/6 homework -5.12, 6.4
#!/usr/bin/perl

use strict;
use warnings;
use GD::Graph::linespoints;

###########################################################################################
###										Main code										###
###########################################################################################
#Determine which method to use
print "Which method to use for solving h value?\n";
print "1) bisection method or 2)Newton Raphson:  ";
	my $ans = <STDIN>; chomp $ans;

#Determine which equation to use
print "Which equation do you want to use?\n";
print "1)-2*x^6 - 1.5*x^4 + 10*x + 2 (Ch 5)\n";
print "2).5*x^3 - 4*x^2 + 5.5*x - 1 (Ch 6)\n";
print "3) \n";
	my $iter = <STDIN>; chomp $iter;

#Run the bisection or NR method, dependent on input	
if($ans==1){
	bisection(\$iter);
} else{ NR(\$iter);}	
	
###########################################################################################
###										SUBROUTINES										###
###########################################################################################

#Performs the bisection method, taking in the upper and lower bounds from the CML and printing
#the max x value for those boundaries
sub bisection{
	my ($iter)=@_;

	##Graphically represent the data
	graph_data($$iter);
		print "\n*****Review the graph for more information on bounds******\n";
	
	#Initialize BISECTION inputs
	print "What is your initial Lower Bound (XL)?  ";
		my $XL=<STDIN>; chomp $XL;
	print "What is your initial Upper bound (XU)?  ";
		my $XU=<STDIN>; chomp $XU;
		
	#Initialize all other bisection variables
	my $EA_Min=5; my $EA=100;
	my $XR_new; my $XR_old=0;
	my $FR=0; my $FL=0; my $n=0;

	#Calculate values until EA MIN is reached
	until ($EA<$EA_Min){
		#Find XR
		$XR_new = ($XL+$XU)/2;
		
		#Find FL & FR
		$FL=f1_solve($XL,$$iter);
		$FR=f1_solve($XR_new,$$iter);
			#Find EA for each iteration
		if($n>0){
			$EA=sprintf("%.5f", abs(($XR_old-$XR_new)/$XR_new)*100);
		}
			
		#Set new XR values, based on range
		$XR_old=$XR_new;
		if($FL*$FR>0){
			$XL=$XR_new;
			$XR_new=($XL+$XU)/2;
		}else{
			$XU=$XR_new;
			$XR_new=($XL+$XU)/2;
		}
		$n++;
	}

	print "\nThe max x value is $XR_new\n";
}

#Performs the newman-R method, taking in the guess of the max from the CML and printing
#the max x value for those boundaries
sub NR{
	my ($iter)=@_;
	
	##Graphically represent the data
	graph_data($$iter);
		print "\n*****Review the graph for more information on bounds******\n";
	
	#Initialize BISECTION inputs from command line
	print "What is your guess? ";
		my $x = <STDIN>; chomp $x;

	#Initialize all other inputs
	my $ES_Min = .01;
	my $Xi_old=$x;
	my $Xi_new; my $EA=0;
	my $ES=100; my $n=0;
	my $fx; my $f1_fx;
	
	#Calculate range values
	until ($ES<$ES_Min){
		$fx= f_solve($x,$$iter);
		$f1_fx=f1_solve($x,$$iter);
		$Xi_new=$Xi_old-($fx/$f1_fx);
		$ES=(abs(($Xi_old-$Xi_new))/$Xi_new)*100;
		$x=$Xi_new;
		$Xi_old=$Xi_new;
		
	#Print iteration, f(x) and f'(x) values, and the ES
	#print "\nAt iteration $n, there is an EA: $EA\n";
	#print "       FX: $fx, F1_FX:$f1_fx \n";
	#print "       XI: $Xi_new, ES: $ES\n";
	
	$n++;
	}
	
	print "The max x is $Xi_new\n";
}	

#Solves the f(x) value, based on input for equation selection, returning f(x) value
sub f_solve{
	my($x,$iter)=@_;
	my $fx;	
	
	#Equations solved
	if($iter==1){
		$fx=(-2*$x**6)-(1.5*$x**4)+(10*$x)+2; ###5.12
	} elsif($iter==2){
		$fx=(.5*$x**3)-(4*$x**2)+(5.5*$x)-1; ##6.4
	} else{$fx=	1								;				###UPDATE NEW EQUATION
	}
	
	return $fx;
}

#Solves the f'(x) value, based on input for equation selection, returning f'(x) value
sub f1_solve{
	my($x,$iter)=@_;
	my $f1_fx;	

	#Equations solved
	if($iter==1){
		$f1_fx=(-12*$x**5)-(6*$x**3)+10; ##5.12
	} elsif($iter==2){
		$f1_fx=(1.5*$x**2)-(8*$x)+5.5; ##6.4
	} else{$f1_fx=1										; 		###UPDATE NEW EQUATION
	}
	return $f1_fx;
}

#Graphs data of f(x) function, and prints to file
sub graph_data{
	my ($iter)=@_;
	
	#Initialize variables
	my $x=-3;
	my @xval; my @yval;
	my @data; my $n=0;
	
	#Create file name
	my $file="Graph_EQ_"; $file.= $iter;
		
	#Create points for graph
	until ($x>10){
		my $fx = f_solve($x,$iter);
		push(@xval,$x);
		push(@yval,$fx);
		$x=$x+.5;
		$n++;
	}
	
	#Create dataset for graph
	@data = (\@xval,\@yval);
	my $vals = \@data;

	#Set graph dimensions and label information
	my $graph = GD::Graph::linespoints -> new(500,400);
	$graph -> set(
		types => 'Graph',
		show_values=>1,
		values_vertical=>"true",
		markers => 2,
		marker_size =>1,
		x_label => "X",
		y_label => "Y",
		zero_axis=>"true",
		title => "Graph of F(X)");

	#Create and save graph to gift file
	my $lineimage= $graph ->plot(\@data);
	open(IMG,"> $file.gif") or die$!;
		binmode IMG;
		print IMG $lineimage->gif;
		close IMG;
	
	#Empty arrays for next use
	@yval=(); @xval=();
}