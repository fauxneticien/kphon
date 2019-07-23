#! /usr/bin/perl

=head1 NAME
 orth_to_ipa.pl

=head1 SYNOPSIS
 Convert orthographic representations of Kaytetye words to phonological forms.
 Apply ordered rules to lexical list, to generate corresponding hyopthesised forms in IPA.

=head1 DESCRIPTION
 useage: orth_to_ipa.pl <infile> <outfile>
 <infile>	(string) wordlist in orthographic form, one word per line
 <outfile>	(string) orthographic + /IPA/ + [IPA] representation of input lexicon

=head1 BUGS
 none known

=head1 AUTHOR
 Michael Proctor <mike.i.proctor@gmail.com>

=cut

#use utf8;

my $usage	= "\n useage: orth_to_ipa.pl <infile> <outfile>\n\n";
my $infile	= shift or die $usage;
my $outfile	= shift or die $usage;

print "\n opening <$infile> ...\n";
open(FH_OLD, "< $infile")  or die "cannot open $infile\n";
open(FH_NEW, "> $outfile") or die "cannot open $outfile\n";

	my @text  = <FH_OLD>;
	foreach (@text) {

		chomp;
		if (/([\w+ \-\+\.]+)/) {
		
			$wd		= 	$1;
			$phon 	=	lc $wd;
			
			# digraph sonorants
			$phon	=~	s/ng/ŋ/g;					# 'ng' = velar nasal
			$phon	=~	s/rr/ɾ/g;					# 'rr' = tap/trill
			
			# approximants
			$phon	=~	s/r([aei])/ɹ$1/g;			# 'rV' = rhotic approximant
			$phon	=~	s/([aei])h([aei])/$1ɰ$2/g;	# status of 'h' = /ɰ/ uncertain
			
			# dentals
			$phon	=~	s/tnh/ṯṉ/g;					# clusters
			$phon	=~	s/nth/ṉṯ/g;
			$phon	=~	s/tlh/ṯḻ/g;
			$phon	=~	s/lth/ḻṯ/g;
			$phon	=~	s/th/ṯ/g;					# 'th' = dental stop
			$phon	=~	s/nh/ṉ/g;					# 'nh' = dental nasal
			$phon	=~	s/lh/ḻ/g;					# 'nh' = dental lateral
			
			# retroflexs
			$phon	=~	s/rtn/ʈɳ/g;					# retroflex clusters
			$phon	=~	s/rnt/ɳʈ/g;
			$phon	=~	s/rtl/ʈɭ/g;
			$phon	=~	s/rlt/ɭʈ/g;
			$phon	=~	s/rt/ʈ/g;					# 'rt' = retroflex stop
			$phon	=~	s/rn/ɳ/g;					# 'rn' = retroflex nasal
			$phon	=~	s/rl/ɭ/g;					# 'rl' = retroflex lateral
			
			# retroflexs
			$phon	=~	s/tny/cɲ/g;					# palatal clusters
			$phon	=~	s/nty/ɲc/g;
			$phon	=~	s/tly/cʎ/g;
			$phon	=~	s/lty/ʎc/g;
			$phon	=~	s/ty/c/g;					# 'ty' = palatal stop
			$phon	=~	s/ny/ɲ/g;					# 'ny' = palatal nasal
			$phon	=~	s/ly/ʎ/g;					# 'ly' = palatal lateral
			
			# glides
			$phon	=~	s/ay/ɐi/g;					# rising diphthong
			$phon	=~	s/y/j/g;					# remaining 'y' = palatal approximant
			
			# vowels
			$phon	=~	s/[ea]$/ə/g;				# all final V = /ə/
			$phon	=~	s/e/ə/g;					# all other 'e' = non-low V
			$phon	=~	s/a/ɐ/g;					# low V

			
			# adjust phonetic forms
			$phon	=~	s/\s+$//g;					# trim trailing whitespace
			$phonet =	$phon;
			$phonet	=~	s/i/iː/g;					# phonological status of high front V unclear
			$phon	=~	s/wə/u/g;					# /wə/ = /u/
			$phonet	=~	s/^ə/ɪ/g;					# initial non-low V realized as high-front
			$phonet	=~	s/ɐɰɐ/ɐː/g;					# status of 'h' uncertain: 'VhV' realized as long vowel
			$phonet	=~	s/ɐɰə/ɐː/g;
			$phonet	=~	s/əjɐ$/iː/g;				# word-final 'eye' realized as long high vowel
			$phonet	=~	s/əjə$/iː/g;

			print FH_NEW "$wd\t/$phon/\t[$phonet]\n" or die "cannot write to $newfile: $!";
			
		}

	}

close (FH_NEW);
close (FH_OLD);

print " output file <$outfile> created.\n\n";

