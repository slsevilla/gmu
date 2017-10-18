#User: Samantha Sevilla
#Date: 10/10
#Course: BINF690
#Chapter 17/18
#!/usr/bin/perl
use strict;
use GD::Graph::mixed;


######################################################################################
								##NOTES##
######################################################################################
#In order to run the code, search for ###UPDATE and update the information, as needed for chapters 17 and 18.
##1)Linear regression takes in x and y data points and generates a line using linear regression. It then calculate the error rate of this line to accurately predict the data points provided and generates a graph based on the data.
##2)Takes the transformed power equation data, and calculates the line. It then will determine the true power equation, transformed the information back to it's original form. 
##3)Takes linear data and uses guassian elimination to solve the equation.
##4)Takes polynomial data and uses guassian elimination to solve the equation.

#Search for ###UPDATE to update necessary inputs before running

######################################################################################
								##CODE##
######################################################################################
#Chose the problem
print "What type of problem?\n";
print "  1)Linear Regression\n";
print "  2)Linearization of Power Equation\n";
print "  3)Polynomial linear regression using Gaussian elimniation\n";
print "  4) Multiple linear regressions\n";
print "  5) Interpolation - Newton\n";
print "  6) Interpolation - Lagrange\n";
print "ANS: ";
my $ans = <STDIN>; chomp $ans;

if ($ans==1){
	#Initialize needed values
	my $ymean; my $xmean;
	my $a0; my $a1; my $a2;
		
	#Create arrays with x input
	###UPDATE
		my @x1vals = qw(1 2 3 4 5 6 7); ### 17.1
		my @yvals = qw(.5 2.5 2 4 3.5 6 5.5); ### 17.1
		my @x2vals=0;
		
	#Determine how many data points
	my $xnum = scalar @x1vals;
	
	#Run linear regression
	lin_reg(\@x1vals, \@x2vals, \@yvals, \$xnum, \$ymean, \$xmean, \$a0, \$a1, \$a2, \$ans);
	error_linreg(\@x1vals, \@x2vals, \@yvals, \$xnum, \$ymean, \$a0, \$a1, \$a2, \$ans);
	graph_data(\@x1vals, \@yvals, $a0, $a1, $a2, $xnum, $ans);
	print "\n**Review the graph for goodness of fit**\n";
} 
elsif($ans==2){
	#Initialize needed values
	my $ymean; my $xmean;
	my $a0; my $a1; my $a2;
		
	#Create arrays with x input
	###UPDATE
		my @x1vals = qw(0 0.301 .477 .602 .699); ### 17.3
		my @yvals = qw(-.301 .226 .534 .753 .922); ### 17.3
		my @x2vals=0;
	#Determine how many data points
	my $xnum = scalar @x1vals;
	
	#Run linear regression and power transformation
	lin_reg(\@x1vals, \@x2vals, \@yvals, \$xnum, \$ymean, \$xmean, \$a0, \$a1, \$a2, \$ans);
	transform_power(\$a0, \$a1);
	
	#Create arrays with x input
	###UPDATE
		my @x1vals = qw(1 2 3 4 5); ### 17.3
		my @yvals = qw(.5 1.7 3.4 5.7 8.4); ### 17.3
		
	graph_data(\@x1vals, \@yvals, $a0, $a1, $a2, $xnum, $ans);
	print "\n**Review the graph for goodness of fit**\n";
} 
elsif($ans==3){
	#initialize variables
	my $ymean; my $xmean;
	my $a0; my $a1; my $a2;

	#Create arrays with x input
	###UPDATE
	my @x1vals = qw(0 1 2 3 4 5); ### 17.4
	my @yvals = qw(2.1 7.7 13.6 27.2 40.9 61.1); ### 17.4
	my @x2vals=0;
	
	#Determine how many data points
	my $xnum = scalar @x1vals;
	
	#Run linear regression, then Gaussian Elimination
	lin_reg(\@x1vals, \@x2vals, \@yvals, \$xnum, \$ymean, \$xmean, \$a0, \$a1, \$a2, \$ans);
	error_linreg(\@x1vals, \@x2vals, \@yvals, \$xnum, \$ymean, \$a0, \$a1, \$a2, \$ans);

	graph_data(\@x1vals, \@yvals, $a0, $a1, $a2, $xnum, $ans);
	print "\n**Review the graph for goodness of fit**\n";
}
elsif($ans==4){
	#initialize variables
	my $ymean; my $xmean;
	my $a0; my $a1; my $a2;
		
	#Create arrays with x input
	###UPDATE
	my @x1vals = qw(0 2 2.5 1 4 7); ### 17.6
	my @yvals = qw(5 10 9 0 3 27); ### 17.6
	my @x2vals= qw(0 1 2 3 6 2); ### 17.6
	
	#Determine how many data points
	my $xnum = scalar @x1vals;
	
	#Run linear regression, then Gaussian Elimination
	lin_reg(\@x1vals, \@x2vals, \@yvals, \$xnum, \$ymean, \$xmean, \$a0, \$a1, \$a2, \$ans);
}
elsif($ans==5){
	
	#Initialize Values
	my $fx;
	
	###UPDATE
	#my @xvals = qw(1 6); ##18.1
	#my @yvals = qw(0 1.791759); ##18.1
	#my $truex = 2; my $truey = .69; ##18.1
	my @xvals = qw(1 4 6); ##18.2
	my @yvals = qw(0 1.38 1.791759); ##18.2
	my $truex = 2; my $truey = .69; ##18.2
	
	#Determine which model to follow
	print "Is it quadratic?\n";
		print "Ans:";
	my $quad = <STDIN>; chomp $quad;
	
	if($quad=~"N"){
		$fx = $yvals[0] + (($yvals[1]-$yvals[0])/($xvals[1]-$xvals[0]))*($truex-$xvals[0]);
	} else{
		my $b0 = $yvals[0];
		my $b1 = ($yvals[1]-$yvals[0]) / ($xvals[1]-$xvals[0]);
		my $b2 = (($yvals[2]-$yvals[1])/($xvals[2]-$xvals[1]) - $b1 ) /($xvals[2]-$xvals[0]);
		$fx = $b0 + $b1*($truex-$xvals[0]) + $b2*($truex-$xvals[0])*($truex-$xvals[1]);
	}
	
	#Determine error rates
	my $error = (($truey-$fx)/$truey)*100;
	print "The fx value is $fx with an error rate of $error\n";
}
elsif($ans==6){
#Initialize Values
	my $fx=0;
	
	###UPDATE
	my @xvals = qw(1 4 6); ##18.6
	my @yvals = qw(0 1.386294 1.791759); ##18.6
	my $truex = 2; my $truey = .69; ##18.6
	
	#Determine which model to follow
	print "Is it first order?\n";
		print "Ans:";
	my $quad = <STDIN>; chomp $quad;
	
	if($quad=~"Y"){
		$fx = (($truex - $xvals[1])/($xvals[0]-$xvals[1]))*$yvals[0] + (($truex-$xvals[0])/($xvals[1]-$xvals[0]))*$yvals[1];
	} else{
		$fx = ((($truex - $xvals[1])*($truex - $xvals[2]))/(($xvals[0]-$xvals[1])*($xvals[0]-$xvals[2])))*$yvals[0];
		$fx = $fx + ((($truex - $xvals[0])*($truex - $xvals[2]))/(($xvals[1]-$xvals[0])*($xvals[1]-$xvals[2])))*$yvals[1];
		$fx = $fx + ((($truex - $xvals[0])*($truex - $xvals[1]))/(($xvals[2]-$xvals[0])*($xvals[2]-$xvals[1])))*$yvals[2];
	}
	
	#Determine error rates
	my $error = (($truey-$fx)/$truey)*100;
	print "The fx value is $fx with an error rate of $error\n";



}

######################################################################################
								##Subroutines##
######################################################################################
#Solves the linear regression line for a given set of data points
sub lin_reg{
	my ($x1vals, $x2vals, $yvals, $xnum, $ymean, $xmean, $a0, $a1, $a2, $ans)=@_;
	my $x1sum; my $ysum; my $x1_2sum; my $x1_3sum; my $x1_4sum; 
	my $x1ysum; my $x1_2ysum; my $n=0; my $x2sum; my $x2_2sum;
	my $x1_2sum; my $x1x2sum; my $x2ysum;
	
	my $n=0; my $e=1;my $v=1; my $i=0;
	my %variables; my %variables_ori;
	my @ans; my @pos; my @terms;
	
	#Calculate the sum of x and y values, the product sum of x * y and x**2
	foreach my $tempx1 (@$x1vals){
		
		#Iterate through the x2 and y values
		my $tempy = @$yvals[$n];
		my $tempx2 = @$x2vals[$n];
		
		#Calculate the sums
		$x1sum=$x1sum+$tempx1;
		$x1_2sum=$x1_2sum+$tempx1**2;
		$x1_3sum=$x1_3sum+$tempx1**3;
		$x1_4sum=$x1_4sum+$tempx1**4;
		$x1ysum = $tempx1*$tempy + $x1ysum;
		$x1_2ysum = $tempx1**2 * $tempy + $x1_2ysum;
		$x2sum=$x2sum+$tempx2;
		$x2_2sum=$x2_2sum+$tempx2**2;
		$x2ysum=$x2ysum + $tempx2*$tempy;
		$x1x2sum= $x1x2sum + $tempx1*$tempx2;
		$ysum=$ysum+$tempy;
		$n++;
	}

	#Determine x and y means
	$$xmean = $x1sum / $$xnum; $$ymean = $ysum / $$xnum;
	
	#Calculate the A1 and A0
	$$a1 = sprintf("%.4f", (($$xnum*$x1ysum) - ($x1sum*$ysum))/ ($$xnum*$x1_2sum - $x1sum**2));
	$$a0 = sprintf("%.4f", ($$ymean - $$a1*$$xmean));
	
	if ($ans==1 | $ans==2){
		#Print the raw values
		print "\n\n************SOLUTION**************\n";
		print "Y = $$a0 + $$a1 x\n";
		
		###TESTING
		#print "\nThe X Sum: $x1sum | the Y Sum: $ysum\n";
		#print "The XY Sum: $x1ysum | the X^2 Sum: $x1_2sum\n";
		#print "The A0: $$a0 | the a1: $$a1\n";
	}
	
	#If polynomial equations are used, perform summation for gaussian equations
	elsif ($$ans==3){
	
		#Create Gaussian equations
		my $eq = 3; my $var = 3; my $n=0;
		my @pos = qw(a11 a12 a13 b1 a21 a22 a23 b2 a31 a32 a33 b3);
	
		#Create array with sum values needed
		my @terms = ($$xnum, $x1sum, $x1_2sum, $ysum, $x1sum, $x1_2sum, $x1_3sum, $x1ysum, $x1_2sum, $x1_3sum, $x1_4sum, $x1_2ysum);
		
		#Build the key with each position, and solved sums as a hash
		foreach my $i (@pos){
			my $temp = $terms[$n];
			$variables{@pos[$n]}=$temp;
			$n++;
		}
		
		#Save the original hash for verification later
		%variables_ori=%variables;

		#Call variables to manipulate equations, and then solve for X's
		eq_man(\%variables, \@pos, \$eq, \$var);
		eq_solve(\%variables, \@pos, \@terms, \@ans, \$eq, \$var);
		eq_verify(\%variables_ori, \@pos, \@ans, \$eq, \$var);
		
		#Redefine a0, a1, a2 in terms of solved Guassian Equations
		$$a0=@ans[2]; $$a1=@ans[1]; $$a2=@ans[0];
	}
	
	elsif($$ans==4){
	
		#Create Gaussian equations
		my $eq = 3; my $var = 3; my $n=0;
		my @pos = qw(a11 a12 a13 b1 a21 a22 a23 b2 a31 a32 a33 b3);
	
		#Create array with sum values needed
		my @terms = ($$xnum, $x1sum, $x2sum, $ysum, $x1sum, $x1_2sum, $x1x2sum, $x1ysum, $x2sum, $x1x2sum, $x2_2sum, $x2ysum);

		#Build the key with each position, and solved sums as a hash
		foreach my $i (@pos){
			my $temp = $terms[$n];
			$variables{@pos[$n]}=$temp;
			$n++;
		}
		
		#Save the original hash for verification later
		%variables_ori=%variables;

		#Call variables to manipulate equations, and then solve for X's
		eq_man(\%variables, \@pos, \$eq, \$var);
		eq_solve(\%variables, \@pos, \@terms, \@ans, \$eq, \$var);
		eq_verify(\%variables_ori, \@pos, \@ans, \$eq, \$var);
		
		#Redefine a0, a1, a2 in terms of solved Guassian Equations
		$$a0=@ans[2]; $$a1=@ans[1]; $$a2=@ans[0];
	}
	
}

#Calculates the Error statistics related to linear regression lines
sub error_linreg{
	
	#Initialize Error variables
	my ($x1vals, $x2vals, $yvals, $xnum, $ymean, $a0, $a1, $a2, $ans)=@_;
	my $sqres; my $n=0;	my $ydev; my $xystderror;
	
	foreach my $temp (@$yvals){
	
		#Iterate through the x values
		$ydev = ($temp-$$ymean)**2 + $ydev;
		
		#calculate the squares, depending on the problem type, with 1 = linear and 3f = polynomial
		if($$ans==1){
			$sqres= ($temp - $$a0 - $$a1*@$x1vals[$n])**2 + $sqres;
		} elsif($$ans==3){
			$sqres= ($temp - $$a0 - $$a1*@$x1vals[$n] - $$a2*@$x1vals[$n]**2)**2 + $sqres;
		} elsif($$ans==4){
			$sqres= ($temp - $$a0 - $$a1*@$x1vals[$n] - $$a2*@$x2vals[$n])**2 + $sqres;
		}
		$n++;
	}
		
	#Calculate Y residual deviation
	my $ystderror = sprintf("%.5f", ($ydev/($$xnum-@$x1vals[1]))**(1/2));
	
	#Calculate XY Residual Deviation, depending on the problem type, with 1 = linear and 3f = polynomial
	if($$ans==1){
		$xystderror = sprintf("%.5f",($sqres/($$xnum -2))**(1/2));
	} elsif($$ans==3){
		$xystderror = sprintf("%.5f",($sqres/($$xnum -3))**(1/2));
	} elsif($$ans==4){
		$xystderror = sprintf("%.5f",($sqres/($$xnum -4))**(1/2));
	}
	
	#Determine the value of the data
	if($xystderror<$ystderror){
		
		#Calculate the correleation coefficient	
		my $r2 = sprintf("%.5f",(($ydev - $sqres)/$ydev)*100);
		my $r = sprintf("%.5f",($r2/100)**(1/2));
		
		#Print the resulting percentage
		print "\n**This line has merit**\n";
		print "  The Sy/x value is $xystderror\n";
		print "  The correlation coefficient is $r\n";
		print "  The accuracy (R^2 value) is about $r2 percent of uncertainty explained\n";
	} else {print "This line DOES NOT have merit with a $ystderror and $xystderror";}
}

#Solves the f(x) value, based on input for equation selection, returning f(x) value
sub f_solve{
	my($ans, $x, $a0, $a1, $a2)=@_;
	my $fx;
	
	if ($ans==1){
		$fx=$a0 + $a1*$x;
	} elsif($ans==2){
		my $newa0=10**($a0);
		$fx=$newa0*$x**$a1;
	} elsif($ans==3){
		$fx = $a0 + $a1*$x + $a2*($x**2);
	}
	return $fx;
}

#Graphs data of f(x) function, and prints to file
sub graph_data{
	my ($x1vals, $yvals,$a0, $a1, $a2, $xnum, $ans)=@_;
	
	#Initialize variables
	my $x=@$x1vals[0];
	my @xval; my @yval;	my @data; 
	
	#Create file name
	my $file="Graph_EQ";
	$file .= $ans;
		
	#Create line from solutions
	until ($x>$xnum){
		my $fx = f_solve($ans, $x,$a0, $a1, $a2);
		push(@xval,$x);
		push(@yval,$fx);
		$x=$x+1;
	}
	
	#Create dataset for graph from given points, and line data
	if ($ans==1 ){
		@data = (\@xval,\@yval,\@$x1vals);
	} elsif($ans=2| $ans==3){
		@data = (\@$x1vals,\@$yvals,\@yval);
	};

	#Set graph dimensions and label information for the points provided and linear
	#regression line
	my $graph = GD::Graph::mixed -> new(500,400);
	$graph -> set(
		types =>[qw(lines points)],
		markers => 2,
		marker_size =>1,
		x_label => "X",
		y_label => "Y",
		zero_axis=>"true",
		title => "Graph of Data Points and Regression Line");

	#Create and save graph to gift file
	my $lineimage= $graph ->plot(\@data);
	open(IMG,"> $file.gif") or die$!;
		binmode IMG;
		print IMG $lineimage->gif;
		close IMG;
	
	#Empty arrays for next use
	@yval=(); @xval=();
}

sub transform_power{
	
	#Initialize variables
	my ($a0, $a1)=@_;
	my $newa0=sprintf("%.4f",10**$$a0);
	print "The transformed line is y = $newa0 x ^ $$a1\n";
}

sub eq_man{
	
	#Initialize Variables
	my ($variables, $pos, $eq, $var)=@_;
	my $n=0; my $fac; my $temp;
	my $pairs = 0; my $iter=0;
	my $rounds=0; my $prim=0; my $prim_old=0;
	my $sec=$$var+1;
	my @primary; my @secondary; 
		
	#Eliminate variables moving through each variable
	until($rounds>$$eq-2){
		
		#For each equation pair, determine the factor, and eliminate one variable until the secondary N equals the N of equations
		until ($pairs>$$eq-2){
			
			#Create array of primary and secondary positions
			until ($iter > $$var) {
				$temp=@$pos[$prim]; push (@primary,$temp);
				$prim=$prim+1;

				$temp=@$pos[$sec]; push (@secondary,$temp);
				$sec=$sec+1; $iter=$iter+1;
			}
			
			#Calculate factor
			$fac = $$variables{$secondary[$rounds]} / $$variables{$primary[$rounds]};
		
			#For each equation, multiple the factor and eliminate the variable
			until($n>$$var){
				$$variables{$secondary[$n]}= $$variables{$secondary[$n]}-$$variables{$primary[$n]}*$fac;
				
				#Increase the counter
				$n++;
			}
			
			#Increase/reset the counters
			$pairs = $pairs +1;
			$n=0; $prim =$prim_old;
			$iter=0; @secondary=();
			@primary=(); 
		}
		
		#Set the next equation as the primary equation
		$prim=$prim_old+$$var+1; ##Sets the new primary equation location
		$prim_old = $prim;		##Saves this location for iterations
		
		$rounds = $rounds+1; ##Increases the round
		$pairs = $rounds;	#Sets the pair number as the round
		$sec=$$var+1+$prim; ##Sets the new secondary equation position
	}
	
	###TESTING
	#for my $pos (keys %$variables){
	#	print "the value of '$pos' is $variables{$pos}\n"; }
}

sub eq_solve{
	
	#Initialize Values
	my ($variables, $pos, $terms, $ans, $eq, $var)=@_;
	my $n=0; my $add=1; my $num=0;
	my $length=scalar @$pos - 1;
	my $den; my $sol=$$eq;

	#Determine the solution for each equation
	until ($n==$$eq){
		
		##For each variable, multiply times EQ+1's solution
		foreach my $line (@$ans){
			$num = $num+$line*$$variables{@$pos[$length-$add]};
			$add = $add+1;
		}
		
		#Subtract EQ's B value to determine numerator
		$num = $$variables{@$pos[$length]}-$num;

		#Determine the denominator
		$den = $$variables{@$pos[$length-$add]};

		#Push the answer to Answer Array
		push(@$ans,sprintf("%.3f",$num/$den));
		
		#Move to the next line of equations, set counters
		$length=$length-$$var-1;
		$add=1; $num=0;
		$n++;
	}

	#Print the final solution
	print "\n************SOLUTION**************\n";
	foreach my $line (@$ans){
		print "X$sol: $line\n";
		$sol=$sol-1;
	}
}

sub eq_verify{
	
	#Initialize Variables
	my ($variables_ori, $pos, $ans, $eq, $var)=@_;
	my $sol=0; my $n=1; my $i=1; my $count=0;
	my $iter=$$var-1;
	print "\n************Verification**************\n";
	
	#For each equation verify the answers solved above
	until ($n>$$eq){
		
		#For each variable, multiple term by answer
		until ($i>$$var){
			$sol = $sol + $$variables_ori{@$pos[$count]}*@$ans[$iter];
			$i++;
			$count = $count+1;
			$iter=$iter-1;
		}
		
		#Print the solved solution, and equation solution
		print "EQ$n: Calulated Sol using ans:$sol verifies to EQ Sol $$variables_ori{@$pos[$count]}\n";
		
		#Reset and increase counters
		$count = $count+1;
		$n++; $sol=0; $i=1;
		$iter=$$var-1;
	}
}

