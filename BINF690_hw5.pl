#User: Samantha Sevilla
#Date: 10/02/17
#Course: BINF690
#Ch 14.8
#!/usr/bin/perl

#use strict;
#use warnings;
use GD::Graph::linespoints;

######################################################################################
								##NOTES##
######################################################################################
#In order to run the code, search for ###UPDATE and update the fxfy, and partial derivatives
#of the x and y equations, as well as the second partial equations

######################################################################################
								##CODE##
######################################################################################

#Initialize global inputs ###UPDATE
my $x =0; my $y=0;

#Initialize all other variables
my $x_new=$x; my $y_new=$y;
my $par_x=0; my $par_y=0;
my $h;

#Determine which method to use
print "Which method to use for solving h value?\n";
print "1) bisection method or 2)Newton Raphson\n";
print "Ans:  ";
	my $ans = <STDIN>; chomp $ans;

#Determine which equation to use
print "Which equation do you want to use?\n";
print "		1)-2*x^6 - 1.5*x^4 + 10*x + 2 (Ch 5)\n";
print "		2).5*x^3 - 4*x^2 + 5.5*x - 1 (Ch 6)\n";
print "		3) 832*$x**2 + 208*$x \n";
print "Ans:  ";
	my $eq = <STDIN>; chomp $eq;

#Run the bisection or NR method, dependent on input	
if($ans==1){
	$h= bisection(\$eq);
} else{ $h=NR(\$eq);}

#If completing an optimization problem, determine the max x and y values
if($eq==3){	
	##Use h to determine the x and y values
	maxmin(\$x_new, \$y_new, \$h);
	print "Max/Min: ($x_new, $y_new)\n\n\n";
}
###########################################################################################
###										SUBROUTINES										###
###########################################################################################
sub bisection{
	my ($eq)=@_;

	##Graphically represent the data
	graph_data($$eq);
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
		$FL=f1_solve($XL,$$eq);
		$FR=f1_solve($XR_new,$$eq);
			#Find EA for each eqation
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
	
	#Print out the answer, depending on what method is being employed
	if ($$eq==3){ 
		print "\nThe max h value is $XR_new\n";
		return $XR_new;
	} else{print "\nThe max x value is $XR_new\n";}
}

sub NR{
	my ($eq)=@_;
	
	##Graphically represent the data
	graph_data($$eq);
		print "\n*****Review the graph for more information on bounds******\n";
	
	#Initialize BISECTION inputs from command line
	print "What is your guess? ";
		my $x = <STDIN>; chomp $x;

	#Initialize all other inputs
	my $ES_Min = .01; my $ES=100; 
	my $Xi_old=$x; my $Xi_new;
	my $fx; my $f1_fx;
	
	#Calculate range values
	until ($ES<$ES_Min){
		
		#Solve for f(x) and f'(x)
		$fx= f_solve($x,$$eq);
		$f1_fx=f1_solve($x,$$eq);
		
		#Determine new x value
		$Xi_new=sprintf("%.5f",$Xi_old-($fx/$f1_fx));
		$x=$Xi_new; $Xi_old=$Xi_new;		
		
		#Calculate error to determine stopping point
		$ES=(abs(($Xi_old-$Xi_new)/$Xi_new))*100;
	}
	
	#Print out the answer, depending on what method is being employed
	if ($$eq==3){ 
 		print "\nThe max h value is $Xi_new\n";
		return $Xi_new;
	} else{print "\nThe max x value is $Xi_new\n";}
}

sub f_solve{
	my($x,$eq)=@_;
	my $fx;	
	
	#Equations solved
	if($eq==1){
		$fx=(-2*$x**6)-(1.5*$x**4)+(10*$x)+2; ###5.12
	} elsif($eq==2){
		$fx=(.5*$x**3)-(4*$x**2)+(5.5*$x)-1; ##6.4
	} elsif($eq==3){
		$fx=832*$x**2 + 208*$x;	##14.8
	} else{$fx=0;						###UPDATE NEW EQUATION
	}
	
	return $fx;
}

#Subroutine solves the g'(x) value, returning g'(x) value (Y value)
sub f1_solve{
	my($x,$eq)=@_;
	my $f1_fx;	
	
	#Equations solved
	if($eq==1){
		$f1_fx=(-12*$x**5)-(6*$x**3)+10; ##5.12
	} elsif($eq==2){
		$f1_fx=(1.5*$x**2)-(8*$x)+5.5; ##6.4
	} elsif($eq==3){
		$f1_fx=1644*$x + 208;						###UPDATE NEW EQUATION
	} else{$f1_x;
	}

	return $f1_fx;
}
#Subroutine determines x and y values using the optimal gradient method, printing out the x,y values
sub maxmin{
	#Initialize values
	my ($x_new, $y_new,$h)=@_;
	my $count;
	
	#Solve the partial derivatives
	$count =1; 
		$par_x = partials($count,$$x_new, $$y_new);
	$count=2; 
		$par_y = partials($count,$$x_new, $$y_new);
	
	#Determine the new x and y values
	$$x_new = sprintf("%.1f", $x + $par_x*$$h);
	$$y_new = sprintf("%.1f", $y + $par_y*$$h);
	
	#Set initial x/y values to the newly determined values
	$x=$$x_new;
	$y=$$y_new;
}

#Subroutine determines the partial derivatives for the X OR Y and returns value
sub partials{
	#Initialize
	my ($ans, $x, $y)=@_;
	my $par; 

	##eqate equations, depending on if partial x or partial y
	if ($ans==1){
		$par = -8 + 2*$x - 2*$y; 	###UPDATE with partial f'x
	} else{$par = 12 + 8*$y -2*$x; 	}	###UPDATE with partial f'y
	return $par;
}

#Subroutine graphs g' data for visual reference, and prints to file
sub graph_data{
	my ($eq)=@_;
	
	#Create file name
	my $x=-5;
	my $file="Graph_"; $file.=$eq;
	my @xval; my @yval;
	my @data; my $n=0;
	
	#Create dataset
	until ($x>5){
		my $fx = f1_solve($x, $eq);
		push(@xval,$x);
		push(@yval,$fx);
		$x=$x+.5;
		$n++;
	}
	
	@data = (\@xval,\@yval);
	my $vals = \@data;

	#Set graph dimensions and label information
	my $graph = GD::Graph::linespoints -> new(500,400);
	$graph -> set(
		types => 'Graph',
		markers => 2,
		marker_size =>1,
		x_label => "X",
		y_label => "Y",
		zero_axis=>true,
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

