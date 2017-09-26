#User: Samantha Sevilla
#Date: 
#Course: BINF690
#Ch5/6 homework -5.12, 6.4
#!/usr/bin/perl

use strict;
use warnings;
use GD::Graph::linespoints;

#Determine which problem to solve
print "Which question? 1) 5.12 or 2)6.4   ";
my $ans = <STDIN>; chomp $ans;

##Question 5.12
if($ans==1){
	#Inputs
	my $x=0; my $XL=0;
	my $XU=1; 
	my $EA_Min=5;

	#Set Chapter for equations
	my $ch=5;
		
	#Initialize
	my $XR_new=0; my $XR_old=0;
	my $EA=100;my $n=0;
	my $FR=0; my $FL=0;
	my $final;

	#Graphically represent the data
	graph_data($x,$ch);
	
	#Calculate values until EA MIN is reached
	until ($EA<$EA_Min){
		#Find XR
		$XR_new = ($XL+$XU)/2;
		
		#Find FL
		$FL=f1_solve($XL,$ch);
		
		#Find FR
		$FR=f1_solve($XR_new,$ch);
		
		#Find EA
		if($n>0){
			$EA=sprintf("%.5f", abs(($XR_old-$XR_new)/$XR_new)*100);
		}
		
		#Calculate final value
		$final = sprintf("%.5f",f_solve($XR_new,$ch));
		
		#Print Values
		print "At iteration $n:\n";
		print "         FL:$FL, FR:$FR\n";
		print "         XL:$XL, XR:$XR_new, XU:$XU, the EA is $EA\n\n";

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
	print "The solution is $final\n\n";
}
	
##Question 6.4
if($ans==2){
	#Inputs
	my $ES_Min = .01;
	
	#Take in guess from CML
	print "What is your guess? ";
	my $x = <STDIN>; chomp $x;
	my $Xi_old=$x;
		
	#Set Ch for equations
	my $ch=6;
	
	#Initialize
	my $Xi_new; my $EA=0;
	my $ES=100; my $n=0;
	my $fx; my $f1_fx;
	
	#Graphically represent the data
	graph_data($x,$ch);
	
	#Calculate range values
	until ($ES<$ES_Min){
		$fx= f_solve($x,$ch);
		$f1_fx=f1_solve($x,$ch);
		$Xi_new=$Xi_old-($fx/$f1_fx);
		$ES=(abs(($Xi_old-$Xi_new))/$Xi_new)*100;
		$x=$Xi_new;
		$Xi_old=$Xi_new;
		
		#Print iteration, f(x) and f'(x) values, and the ES
		print "\nAt iteration $n, there is an EA: $EA\n";
		print "       FX: $fx, F1_FX:$f1_fx \n";
		print "       XI: $Xi_new, ES: $ES\n";
		$n++;
	
	}
}	
	
	
############################################################################################################
###############################  SUBROUTINES  ##############################################################
############################################################################################################

#Subroutine solves the f(x) value, based on chapter input, returning f(x) value
sub f_solve{
	my($x,$ch)=@_;
	my $fx;	
	
	#Inputs
	if($ch==5){
		$fx=(-2*$x**6)-(1.5*$x**4)+(10*$x)+2; ###5.12
	} else{$fx=(.5*$x**3)-(4*$x**2)+(5.5*$x)-1; ##6.4
	};
	
	return $fx;
}

#Subroutine solves the f'(x) value, based on chapter input, returning f'(x) value
sub f1_solve{
	my($x,$ch)=@_;
	my $f1_fx;	
	
	#Inputs
	if($ch==5){
		$f1_fx=(-12*$x**5)-(6*$x**3)+10; ##5.12
	} else{$f1_fx=(1.5*$x**2)-(8*$x)+5.5; ##6.4
	};
	
	return $f1_fx;
}

#Subroutine graphs data for visual reference, and prints to file
sub graph_data{

	#Create file name
	my ($x,$ch)=@_;
	my $file="Graph"; $file.=$ch;
	my @xval, my @yval;
	my @data;
	
	#Create dataset
	until ($x>9){
		my $fx = f_solve($x,$ch);
		push(@xval,$x);
		push(@yval,$fx);
		$x=$x+1;
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
		#x_min_value=>-1,
		x_max_value=>1,
		y_max_value=>10,
		y_min_value=>0,
			
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