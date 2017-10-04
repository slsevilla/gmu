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
my $max_old = fxfy($x,$y);
my $x_new=$x; my $y_new=$y;
my $par_x=0; my $par_y=0;
my $h;

#Determine which method to use
print "Which method to use for solving h value?\n";
print "1) bisection method or 2)Newton Raphson:  ";
	my $ans = <STDIN>; chomp $ans;

###########################################################################################
###								First and Second iterations								###
###########################################################################################

#Run through the first iteration of the problem
	my $iter=1;

	##Graphically represent the data
	graph_data(\$iter);
		print "\n*****Review the graph for more information on bounds******\n";

	##Perform the selected method to find h	
	if($ans==1){
		$h = bisection(\$iter);
	}

	##Use h to determine the x and y values
	maxmin(\$x_new, \$y_new, \$h);
		print "Iteration $iter: ($x_new, $y_new)\n\n\n";

#Run through the second iteration of the problem
	my $iter=2;

	##Graphically represent the data
	graph_data(\$iter);
		print "\n*****Review the graph for more information on bounds******\n";

	##Perform the selected method to find h	
	if($ans==1){
		$h = bisection(\$iter);
	}
	
	##Use h to determine the x and y values
	maxmin(\$x_new, \$y_new, \$h);
		print "Iteration $iter: ($x_new, $y_new)\n\n\n";

###########################################################################################
###										SUBROUTINES										###
###########################################################################################
sub bisection{
	my ($iter)=@_;

	#Initialize BISECTION inputs
	print "What is your initial Lower Bound (XL)?  ";
		my $XL=<STDIN>; chomp $XL;
	print "What is your initial Upper bound (XU)?  ";
		my $XU=<STDIN>; chomp $XU;
		
	#Initialize all other bisection variables
	my $EA_Min=5; my $EA=100;
	my $XR_new; my $XR_old=0;
	my $FR=0; my $FL=0; my $n=0;

	if($ans==1){
		
		#Calculate values until EA MIN is reached
		#for (my $i; $i<10; $i++){
		until ($EA<$EA_Min){
			#Find XR
			$XR_new = ($XL+$XU)/2;
			
			#Find FL & FR
			$FL=g1_solve($XL,$$iter);
			$FR=g1_solve($XR_new,$$iter);

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

		print "\nThe h value is $XR_new\n";
		return $XR_new;
	}
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

##Subroutine calculates and returns fxfy value for X and Y inputs
sub fxfy{
	#Initialize
	my ($x,$y)=@_;
		##Inputs
		my $fxfy = -8*$x + $x**2 + 12*$y + 4*$y**2 - 2*$x*$y; ###UPDATE with full equation
	return $fxfy;
}

#Subroutine determines the partial derivatives for the X OR Y and returns value
sub partials{
	#Initialize
	my ($ans, $x, $y)=@_;
	my $par; 

	##Iterate equations, depending on if partial x or partial y
	if ($ans==1){
		$par = -8 + 2*$x - 2*$y; 	###UPDATE with partial f'x
	} else{$par = 12 + 8*$y -2*$x; 	}	###UPDATE with partial f'y
	return $par;
}

#Subroutine solves the g'(x) value, returning g'(x) value (Y value)
sub g1_solve{
	my($x,$iter)=@_;
	my $g1_x;
	
	#Solve for Y, using the the two g'h formulas Iter1 or Iter2
	if ($iter==1){
		$g1_x=1644*$x + 208; ###Update with g(h)' equation
	} else {$g1_x=13*$x}; ###Update with g(h)' equation
	return $g1_x;
}

#Subroutine graphs g' data for visual reference, and prints to file
sub graph_data{
	my ($iter)=@_;
	
	#Create file name
	my $x=-5;
	my $file="Graph_"; $file.= $$iter;
	my @xval; my @yval;
	my @data; my $n=0;
	
	#Create dataset
	until ($x>5){
		my $fx = g1_solve($x,$$iter);
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