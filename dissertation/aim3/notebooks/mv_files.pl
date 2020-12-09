#!/usr/bin/perl
#User: Samantha Sevilla Chill

use strict;
use warnings;
use Cwd;
use CPAN;
use File::chdir;
use File::Copy;
use File::Find;
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);

my $direction = "1";
#1 move from Drive to E
#2 move from E to drive

my $f_move = "\\manifest\\manifest.txt";
my @dir_move = ("\\data\\Project_folder","\\notebooks\\QIIME_pipeline_v2");
my $e_dir = "E:\\My Files\\My Files\\Dissertation\\Analysis\\Aim3";
my $g_dir = "C:\\Users\\slsevilla\\Google Drive\\MyDocuments_Current\\Education\\George Mason University\\Dissertation\\Analysis\\Aim3";

my ($full_path, $new_path) = "";

if ($direction==1){	
	foreach my $target (@dir_move){
		$full_path = $g_dir . $target;
		$new_path = $e_dir . $target;
		
		print("######## moving directory:");
		print($new_path);
		print("\n\n");
		dirmove($full_path,$new_path);		
	}
	
	$full_path = $g_dir . $f_move;
	$new_path = $e_dir . $f_move;
	print("######## moving files:");
	print($new_path);
	print("\n\n");

	fmove($full_path,$new_path);
	
} else{
	foreach my $target (@dir_move){
		$full_path = $e_dir . $target;
		$new_path = $g_dir . $target;
		dirmove($full_path,$new_path);		
	}
	
	$full_path = $e_dir . $f_move;
	$new_path = $g_dir . $f_move;
	fmove($full_path,$new_path);
}

