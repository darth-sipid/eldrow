#!/usr/bin/perl

open(W, "<", "./data/en_words_1_5-5.txt");
W: while (<W>) {
	chomp;
	@parts = split(/ /, $_);
	$word = $parts[0];
    print "$word\n" if $word =~ /[a-z]{5}/;
}
