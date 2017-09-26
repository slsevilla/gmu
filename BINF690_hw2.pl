#User: Samantha Sevilla
#Date: 
#Course: BINF690
#Ch4 homework - 4.6
#!/usr/bin/perl

#Inputs
my $x=1; 
my $pred = 2.5;
my $true=.916291;

#Initalize
my $h= $pred-$x;
my $fx, my $f1_fx, my $f2_fx;
my $f3_fx, my $f4_fx; my $fx_current;
my $ET;

#Equations to update (as initial changes)
$fx = log($x);
$f1_fx = 1/$x;
$f2_fx = -1/($x**2);
$f3_fx=2/($x**3);
$f4_fx=-6/($x**6);

print "For the Pred: $pred, and X = $x\n";

#Zero Order
$fx_current=$fx;
$ET=abs(($true-$fx)/$true)*100;
print "Zero order ET is $ET\n";

#First Order
$fx_current=$fx_current + $f1_fx*$h;
$ET=abs(($true-$fx_current)/$true)*100;
print "1st order ET is $ET\n";

#Second Order
$fx_current=$fx_current + ($f2_fx/(2*1))*($h**2);
$ET=abs(($true-$fx_current)/$true)*100;
print "2nd order ET is $ET\n";
	
#Third Order
$fx_current=$fx_current + ($f3_fx/(3*2*1))*($h**3);
$ET=abs(($true-$fx_current)/$true)*100;
print "3rd order ET is $ET\n";	

#Fourth Order
$fx_current=$fx_current + ($f4_fx/(4*3*2*1))*($h**4);
$ET=abs(($true-$fx_current)/$true)*100;
print "4th order ET is $ET\n";	

