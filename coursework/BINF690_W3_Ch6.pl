#User: Samantha Sevilla
#Date: 08/28/17 
#Course: BINF690
#Chapter 6
#!/usr/bin/perl

my $dudx; my $dudy;
my $dvdx; my $dvdy;
my $Jacobian; my $EA_x; my $EA_y;
my $u; my $v; 

#Set X and Y true values
my $x_true = 2; my $y_true =3;
my $EA_max=0.05;
my $EA_check=100;

#Set X and Y guesses
my $x_est = 1.5; my $y_est = 3.5;

#Loop until highest EA falls below threshold
until ($EA_check<$EA_max){
	#Solve for U and V
	$u = $x_est**2 + $x_est*$y_est-10;
	$v = $y_est+3*$x_est*$y_est**2-57;

	#Define parital derivatives
	$dudx=2*$x_est+$y_est;
	$dudy=$x_est;
	$dvdx=3*$y_est**2;
	$dvdy=1+6*$x_est*$y_est;

	#Solve for Jacobian Denominator
	$Jacobian=$dudx*$dvdy-$dudy*$dvdx;

	#Solve for X and Y
	$x= sprintf("%.5f",$x_est-(($u*$dvdy-$v*$dudy)/($Jacobian)));
	$y= sprintf("%.5f",$y_est-(($v*$dudx-$u*$dvdy)/($Jacobian)));

	#Compare to true values
	$EA_x = sprintf("%.5f",abs((($x-$x_true)/$x_true)*100));
	$EA_y = sprintf("%.5f",abs((($y-$y_true)/$y_true)*100));
	
	print "\nFor the true value of X: $x_true, the X calculated was $x, with an EA of $EA_x\n";
	print "For the true value of Y: $y_true, the X calculated was $y, with an EA of $EA_y\n";
		
	#Repeat if not Error is too high
	if($EA_x>$EA_y){
		$EA_check = $EA_x;
	} else{$EA_check=$EA_y};
	$x_est=$x; $y_est=$y;
	print "This run fails to meet EA requirements";
}