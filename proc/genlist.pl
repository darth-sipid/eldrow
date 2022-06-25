#!/usr/bin/perl

open(W, "<", "./data/en_words_1_5-5.dat");
W: while (<W>) {
	chomp;
	$word = $_;
	open(E, "<", "./en5.txt");
	while (<E>) {
		chomp;
		if ($_ eq $word) {
			print "$word\n";
			close E;
			next W;
		}
	}
	close E;
}
