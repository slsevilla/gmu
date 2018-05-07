#User: Samantha Sevilla
#Date: 08/28/17 
#Course: BINF690
#Homework Problem 1.13
#!/usr/bin/perl

use strict;
use warnings;
use GD::Graph::linespoints;

#Initialize Variables
	my $t_max; my $analytic_vol;
	my @volumes; my@times; my @data;
	my $final_rad; my $numeric;

##Text book requires to find Volume using a .25 step from T0 to T10
	$t_max=10;
	volume_time($t_max,\@volumes,\@times);
	$analytic_vol=@volumes[40];
##Part A: Plot V over time
	graph_data($t_max,\@volumes,\@times);
##Part B: As t>10, the graph begins to plateau, with it's slope decreasing over time
	$t_max=20;
	volume_time($t_max,\@volumes,\@times);
	graph_data($t_max,\@volumes,\@times);

sub volume_time{
	
	#Pass through variables
	my ($t_max,$volumes,$times)=@_;
	
	#Set Constant Values
	my $pie=3.14159265;	my $k = 0.08; my $rad=2.5;
	
	#Initialize values
	my $t_initial=0; my $v_final=0; my $n=0;
	my $v_current=0; my $dt=0; my $dvdt;
	my $t_final=0;
	
	#Run loop with steps
	until ($t_initial>$t_max){
	
		#Calculate volume at this time, round to 5 decimal places
		my $v_initial = sprintf("%.5f", (4/3)*($pie)*($rad**3));
		if ($v_current == 0){
			$v_current = $v_initial;
			$dt=0;}
		$dvdt = sprintf("%.5f",(-$k*(4)*$pie*(((3*$v_current)/(4*$pie))**(2/3))));
		$v_final=sprintf("%.5f",($v_current+$dvdt*($dt)));

		#Save time and volumes to arrays
		push(@times,$t_initial);
		push(@volumes,$v_final);
	
		#Set new time point and new volume point
		$v_current = $v_final; 
		$t_final= $t_final +.25; $t_initial=$t_final;
		$dt=0.25;
	}

	#Print values for each Time T
	foreach(@times){
		print "At $times[$n], volume is $volumes[$n]\n";
		$n++;
	}
}	

sub graph_data{

	#Create file name
	my ($t_max)=@_;
	my $file=$t_max;
	
	#Create dataset
	@data = (\@times,\@volumes);
	my $vals = \@data;

	#Set graph dimensions and label information
	my $graph = GD::Graph::linespoints -> new(1500,500);
	$graph -> set(
		types => 'points lines',
		markers => 2,
		marker_size =>2,
		show_values => $vals,
		x_label => "Time",
		y_label => "Volume",
		x_label_position => .5,
		
		title => "Volume change over time");

	#Create and save graph to gift file
	my $lineimage= $graph ->plot(\@data);
	open(IMG,"> Plot\_t\_$file.gif") or die$!;
		binmode IMG;
		print IMG $lineimage->gif;
		close IMG;
	
	#Empty arrays for next use
	@volumes=(); @times=();
}