#!/usr/bin/env perl

$full_list = $ARGV[0];
$test_list = $ARGV[1];
$train_list = $ARGV[2];

open FL, $full_list;
close FL;

open FL, $full_list;
open TESTLIST, ">$test_list";
open TRAINLIST, ">$train_list";
while ($l = <FL>)
{
	chomp($l);
	if (index($l, "SA01") == -1  && index($l, "SA10") == -1)
	{
		print TRAINLIST "$l\n";
	}
	else
	{
		print TESTLIST "$l\n";
	}
}
