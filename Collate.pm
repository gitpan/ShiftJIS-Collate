package ShiftJIS::Collate;

use Carp;
use strict;
use vars qw($VERSION $PACKAGE @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION = '0.04';

$PACKAGE = 'ShiftJIS::Collate'; # __PACKAGE__

my $Level = 4;
my $Kanji = 2;

sub new {
    my $class = shift;
    my $self  = bless { @_ }, $class;

    $self->{level} ||= $Level;
    $self->{kanji} ||= $Kanji;

    if ($self->{kanji} == 3) {
	croak qq|$PACKAGE "tounicode" coderef is not defined|
	    unless $self->{tounicode} && ref($self->{tounicode}) eq 'CODE';
    }
    if (exists $self->{overrideCJK}) {
	croak qq|$PACKAGE : Sorry, "overrideCJK" is obsolete.|;
    }
    return $self;
}


my $Char = '[\xB3\xB6-\xC4]\xDE|[\xCA-\xCE][\xDE\xDF]|'
    . '[\x00-\x7F\xA1-\xDF]|[\x81-\x9F\xE0-\xFC][\x40-\x7E\x80-\xFC]';

my $CJK = '\x88[\x9F-\xFC]|\x98[\x40-\x72\x9F-\xFC]|'
    . '[\x89-\x97\x99-\x9F\xE0-\xE9][\x40-\x7E\x80-\xFC]|'
    . '\xEA[\x40-\x7E\x80-\xA4]';


#
# 1st weights
#
#  /[\x41-\xFF]{2}/
#
# 2nd weights
#  "\x32" : unaffected
#  "\x33" : normal latin
#  "\x34" : voiceless kana
#  "\x35" : voiced kana
#  "\x36" : semivoiced kana
#
# 3rd weights
#  "\x14" : unaffected
#  "\x15" : lower latin
#  "\x16" : upper latin
#  "\x1a" : prolonged kana
#  "\x1b" : small kana
#  "\x1c" : iteration kana
#  "\x1d" : normal kana
#
# 4th weights
#  "\x0a" : unaffected
#  "\x10" : hiragana
#  "\x11" : katakana
#
# 5th weights
#  "\x01" : unaffected
#  "\x02" : normal ascii
#  "\x03" : normal kana
#  "\x04" : compat kana
#  "\x05" : compat ascii
#
my %Order = (

' '  => "\x70\x41\x32\x14\x0a\x01",
'�@' => "\x70\x42\x32\x14\x0a\x01",
'�A' => "\x71\x41\x32\x14\x0a\x03",
'�'  => "\x71\x41\x32\x14\x0a\x04",
'�B' => "\x71\x42\x32\x14\x0a\x03",
'�'  => "\x71\x42\x32\x14\x0a\x04",
','  => "\x71\x43\x32\x14\x0a\x02",
'�C' => "\x71\x43\x32\x14\x0a\x05",
'.'  => "\x71\x44\x32\x14\x0a\x02",
'�D' => "\x71\x44\x32\x14\x0a\x05",
'�E' => "\x71\x45\x32\x14\x0a\x03",
'�'  => "\x71\x45\x32\x14\x0a\x04",
':'  => "\x71\x46\x32\x14\x0a\x02",
'�F' => "\x71\x46\x32\x14\x0a\x05",
';'  => "\x71\x47\x32\x14\x0a\x02",
'�G' => "\x71\x47\x32\x14\x0a\x05",
'?'  => "\x71\x48\x32\x14\x0a\x02",
'�H' => "\x71\x48\x32\x14\x0a\x05",
'!'  => "\x71\x49\x32\x14\x0a\x02",
'�I' => "\x71\x49\x32\x14\x0a\x05",
'�L' => "\x71\x4a\x32\x14\x0a\x01",#added
'`'  => "\x71\x4b\x32\x14\x0a\x02",#added
'�M' => "\x71\x4b\x32\x14\x0a\x05",#added
'�N' => "\x71\x4c\x32\x14\x0a\x01",#added
'^'  => "\x71\x4d\x32\x14\x0a\x02",#added
'�O' => "\x71\x4d\x32\x14\x0a\x05",#added
'~'  => "\x71\x4e\x32\x14\x0a\x02",
'�P' => "\x71\x4e\x32\x14\x0a\x05",
'_'  => "\x71\x4f\x32\x14\x0a\x02",
'�Q' => "\x71\x4f\x32\x14\x0a\x05",
(qw/�\ /)[0]
     => "\x71\x50\x32\x14\x0a\x01",
'�]' => "\x71\x51\x32\x14\x0a\x01",
'/'  => "\x71\x52\x32\x14\x0a\x02",
'�^' => "\x71\x52\x32\x14\x0a\x05",
'�_' => "\x71\x53\x32\x14\x0a\x01",
'�`' => "\x71\x54\x32\x14\x0a\x01",
'�a' => "\x71\x55\x32\x14\x0a\x01",
'|'  => "\x71\x56\x32\x14\x0a\x02",
'�b' => "\x71\x56\x32\x14\x0a\x05",
'�c' => "\x71\x57\x32\x14\x0a\x01",
'�d' => "\x71\x58\x32\x14\x0a\x01",
q|�e|=> "\x72\x41\x32\x14\x0a\x01",
q|�f|=> "\x72\x42\x32\x14\x0a\x01",
q|'| => "\x72\x43\x32\x14\x0a\x01",#added
q|�g|=> "\x72\x44\x32\x14\x0a\x01",
q|�h|=> "\x72\x45\x32\x14\x0a\x01",
q|"| => "\x72\x46\x32\x14\x0a\x01",#added
'('  => "\x72\x47\x32\x14\x0a\x02",
'�i' => "\x72\x47\x32\x14\x0a\x05",
')'  => "\x72\x48\x32\x14\x0a\x02",
'�j' => "\x72\x48\x32\x14\x0a\x05",
'�k' => "\x72\x49\x32\x14\x0a\x01",
'�l' => "\x72\x4a\x32\x14\x0a\x01",
'['  => "\x72\x4b\x32\x14\x0a\x02",
'�m' => "\x72\x4b\x32\x14\x0a\x05",
']'  => "\x72\x4c\x32\x14\x0a\x02",
'�n' => "\x72\x4c\x32\x14\x0a\x05",
'{'  => "\x72\x4d\x32\x14\x0a\x02",
'�o' => "\x72\x4d\x32\x14\x0a\x05",
'}'  => "\x72\x4e\x32\x14\x0a\x02",
'�p' => "\x72\x4e\x32\x14\x0a\x05",
'�q' => "\x72\x4f\x32\x14\x0a\x01",
'�r' => "\x72\x50\x32\x14\x0a\x01",
'�s' => "\x72\x51\x32\x14\x0a\x01",
'�t' => "\x72\x52\x32\x14\x0a\x01",
'�u' => "\x72\x53\x32\x14\x0a\x03",
'�'  => "\x72\x53\x32\x14\x0a\x04",
'�v' => "\x72\x54\x32\x14\x0a\x03",
'�'  => "\x72\x54\x32\x14\x0a\x04",
'�w' => "\x72\x55\x32\x14\x0a\x01",
'�x' => "\x72\x56\x32\x14\x0a\x01",
'�y' => "\x72\x57\x32\x14\x0a\x01",
'�z' => "\x72\x58\x32\x14\x0a\x01",
'+'  => "\x73\x41\x32\x14\x0a\x02",
'�{' => "\x73\x41\x32\x14\x0a\x05",
'-'  => "\x73\x42\x32\x14\x0a\x01",#added
'�|' => "\x73\x43\x32\x14\x0a\x01",
'�}' => "\x73\x44\x32\x14\x0a\x01",
'�~' => "\x73\x45\x32\x14\x0a\x01",
'��' => "\x73\x46\x32\x14\x0a\x01",
'='  => "\x73\x47\x32\x14\x0a\x02",
'��' => "\x73\x47\x32\x14\x0a\x05",
'��' => "\x73\x48\x32\x14\x0a\x01",
'<'  => "\x73\x49\x32\x14\x0a\x02",
'��' => "\x73\x49\x32\x14\x0a\x05",
'>'  => "\x73\x4a\x32\x14\x0a\x02",
'��' => "\x73\x4a\x32\x14\x0a\x05",
'��' => "\x73\x4b\x32\x14\x0a\x01",
'��' => "\x73\x4c\x32\x14\x0a\x01",
'��' => "\x73\x4d\x32\x14\x0a\x01",
'��' => "\x73\x4e\x32\x14\x0a\x01",
'��' => "\x73\x4f\x32\x14\x0a\x01",
'��' => "\x73\x50\x32\x14\x0a\x01",
'��' => "\x73\x51\x32\x14\x0a\x01",
'��' => "\x73\x52\x32\x14\x0a\x01",
'��' => "\x73\x53\x32\x14\x0a\x01",
'��' => "\x73\x54\x32\x14\x0a\x01",
'��' => "\x73\x55\x32\x14\x0a\x01",
'��' => "\x73\x56\x32\x14\x0a\x01",
'��' => "\x73\x57\x32\x14\x0a\x01",
'��' => "\x73\x58\x32\x14\x0a\x01",
'��' => "\x73\x59\x32\x14\x0a\x01",
'��' => "\x73\x5a\x32\x14\x0a\x01",
'��' => "\x73\x5b\x32\x14\x0a\x01",
'��' => "\x73\x5c\x32\x14\x0a\x01",
'��' => "\x73\x5d\x32\x14\x0a\x01",
'��' => "\x73\x5e\x32\x14\x0a\x01",
'��' => "\x73\x5f\x32\x14\x0a\x01",
'��' => "\x73\x60\x32\x14\x0a\x01",
'��' => "\x73\x61\x32\x14\x0a\x01",
'��' => "\x73\x62\x32\x14\x0a\x01",
'��' => "\x73\x63\x32\x14\x0a\x01",
'��' => "\x73\x64\x32\x14\x0a\x01",
'��' => "\x73\x65\x32\x14\x0a\x01",
'��' => "\x73\x66\x32\x14\x0a\x01",
'��' => "\x73\x67\x32\x14\x0a\x01",
'��' => "\x73\x68\x32\x14\x0a\x01",
'��' => "\x73\x69\x32\x14\x0a\x01",
'��' => "\x73\x6a\x32\x14\x0a\x01",
'��' => "\x73\x6b\x32\x14\x0a\x01",
'��' => "\x73\x6c\x32\x14\x0a\x01",
'��' => "\x73\x6d\x32\x14\x0a\x01",
'��' => "\x73\x6e\x32\x14\x0a\x01",
'#'  => "\x74\x41\x32\x14\x0a\x02",
'��' => "\x74\x41\x32\x14\x0a\x05",
'&'  => "\x74\x42\x32\x14\x0a\x02",
'��' => "\x74\x42\x32\x14\x0a\x05",
'*'  => "\x74\x43\x32\x14\x0a\x02",
'��' => "\x74\x43\x32\x14\x0a\x05",
'@'  => "\x74\x44\x32\x14\x0a\x02",
'��' => "\x74\x44\x32\x14\x0a\x05",
'��' => "\x74\x45\x32\x14\x0a\x01",
'��' => "\x74\x46\x32\x14\x0a\x01",
'��' => "\x74\x47\x32\x14\x0a\x01",
'��' => "\x74\x48\x32\x14\x0a\x01",
'��' => "\x74\x49\x32\x14\x0a\x01",
'��' => "\x74\x4a\x32\x14\x0a\x01",
'��' => "\x74\x4b\x32\x14\x0a\x01",
'��' => "\x74\x4c\x32\x14\x0a\x01",
'��' => "\x74\x4d\x32\x14\x0a\x01",
'��' => "\x74\x4e\x32\x14\x0a\x01",
'��' => "\x74\x4f\x32\x14\x0a\x01",
'��' => "\x74\x50\x32\x14\x0a\x01",
'��' => "\x74\x51\x32\x14\x0a\x01",
'��' => "\x74\x52\x32\x14\x0a\x01",
'��' => "\x74\x53\x32\x14\x0a\x01",
'��' => "\x74\x54\x32\x14\x0a\x01",
'��' => "\x74\x55\x32\x14\x0a\x01",
'��' => "\x74\x56\x32\x14\x0a\x01",
'��' => "\x74\x57\x32\x14\x0a\x01",
'��' => "\x74\x58\x32\x14\x0a\x01",
'��' => "\x74\x59\x32\x14\x0a\x01",
'��' => "\x74\x5a\x32\x14\x0a\x01",
'��' => "\x74\x5b\x32\x14\x0a\x01",
'��' => "\x74\x5c\x32\x14\x0a\x01",
'��' => "\x74\x5d\x32\x14\x0a\x01",
'��' => "\x74\x5e\x32\x14\x0a\x01",
'��' => "\x75\x41\x32\x14\x0a\x01",
'��' => "\x75\x42\x32\x14\x0a\x01",
'��' => "\x75\x43\x32\x14\x0a\x01",
'��' => "\x75\x44\x32\x14\x0a\x01",
'\\' => "\x75\x45\x32\x14\x0a\x02",
'��' => "\x75\x45\x32\x14\x0a\x05",
'$'  => "\x75\x46\x32\x14\x0a\x02",
'��' => "\x75\x46\x32\x14\x0a\x05",
'��' => "\x75\x47\x32\x14\x0a\x01",
'��' => "\x75\x48\x32\x14\x0a\x01",
'%'  => "\x75\x49\x32\x14\x0a\x02",
'��' => "\x75\x49\x32\x14\x0a\x05",
'��' => "\x75\x4a\x32\x14\x0a\x01",
'��' => "\x75\x4b\x32\x14\x0a\x01",
'0'  => "\x76\x41\x32\x14\x0a\x02",
'�O' => "\x76\x41\x32\x14\x0a\x05",
'1'  => "\x76\x42\x32\x14\x0a\x02",
'�P' => "\x76\x42\x32\x14\x0a\x05",
'2'  => "\x76\x43\x32\x14\x0a\x02",
'�Q' => "\x76\x43\x32\x14\x0a\x05",
'3'  => "\x76\x44\x32\x14\x0a\x02",
'�R' => "\x76\x44\x32\x14\x0a\x05",
'4'  => "\x76\x45\x32\x14\x0a\x02",
'�S' => "\x76\x45\x32\x14\x0a\x05",
'5'  => "\x76\x46\x32\x14\x0a\x02",
'�T' => "\x76\x46\x32\x14\x0a\x05",
'6'  => "\x76\x47\x32\x14\x0a\x02",
'�U' => "\x76\x47\x32\x14\x0a\x05",
'7'  => "\x76\x48\x32\x14\x0a\x02",
'�V' => "\x76\x48\x32\x14\x0a\x05",
'8'  => "\x76\x49\x32\x14\x0a\x02",
'�W' => "\x76\x49\x32\x14\x0a\x05",
'9'  => "\x76\x4a\x32\x14\x0a\x02",
'�X' => "\x76\x4a\x32\x14\x0a\x05",
'��' => "\x77\x41\x32\x14\x0a\x01",
'��' => "\x77\x42\x32\x14\x0a\x01",
'��' => "\x77\x43\x32\x14\x0a\x01",
'��' => "\x77\x44\x32\x14\x0a\x01",
'��' => "\x77\x45\x32\x14\x0a\x01",
'��' => "\x77\x46\x32\x14\x0a\x01",
'��' => "\x77\x47\x32\x14\x0a\x01",
'��' => "\x77\x48\x32\x14\x0a\x01",
'��' => "\x77\x49\x32\x14\x0a\x01",
'��' => "\x77\x4a\x32\x14\x0a\x01",
'��' => "\x77\x4b\x32\x14\x0a\x01",
'��' => "\x77\x4c\x32\x14\x0a\x01",
'��' => "\x77\x4d\x32\x14\x0a\x01",
'��' => "\x77\x4e\x32\x14\x0a\x01",
'��' => "\x77\x4f\x32\x14\x0a\x01",
'��' => "\x77\x50\x32\x14\x0a\x01",
'��' => "\x77\x51\x32\x14\x0a\x01",
'��' => "\x77\x52\x32\x14\x0a\x01",
'��' => "\x77\x53\x32\x14\x0a\x01",
'��' => "\x77\x54\x32\x14\x0a\x01",
'��' => "\x77\x55\x32\x14\x0a\x01",
'��' => "\x77\x56\x32\x14\x0a\x01",
'��' => "\x77\x57\x32\x14\x0a\x01",
'��' => "\x77\x58\x32\x14\x0a\x01",
'��' => "\x77\x61\x32\x14\x0a\x01",
'��' => "\x77\x62\x32\x14\x0a\x01",
'��' => "\x77\x63\x32\x14\x0a\x01",
'��' => "\x77\x64\x32\x14\x0a\x01",
'��' => "\x77\x65\x32\x14\x0a\x01",
'��' => "\x77\x66\x32\x14\x0a\x01",
'��' => "\x77\x67\x32\x14\x0a\x01",
'��' => "\x77\x68\x32\x14\x0a\x01",
'��' => "\x77\x69\x32\x14\x0a\x01",
'��' => "\x77\x6a\x32\x14\x0a\x01",
'��' => "\x77\x6b\x32\x14\x0a\x01",
'��' => "\x77\x6c\x32\x14\x0a\x01",
'��' => "\x77\x6d\x32\x14\x0a\x01",
'��' => "\x77\x6e\x32\x14\x0a\x01",
'��' => "\x77\x6f\x32\x14\x0a\x01",
'��' => "\x77\x70\x32\x14\x0a\x01",
'��' => "\x77\x71\x32\x14\x0a\x01",
'��' => "\x77\x72\x32\x14\x0a\x01",
'��' => "\x77\x73\x32\x14\x0a\x01",
'��' => "\x77\x74\x32\x14\x0a\x01",
'��' => "\x77\x75\x32\x14\x0a\x01",
'��' => "\x77\x76\x32\x14\x0a\x01",
'��' => "\x77\x77\x32\x14\x0a\x01",
'��' => "\x77\x78\x32\x14\x0a\x01",
'�p' => "\x77\x81\x32\x14\x0a\x01",
'�q' => "\x77\x82\x32\x14\x0a\x01",
'�r' => "\x77\x83\x32\x14\x0a\x01",
'�s' => "\x77\x84\x32\x14\x0a\x01",
'�t' => "\x77\x85\x32\x14\x0a\x01",
'�u' => "\x77\x86\x32\x14\x0a\x01",
'�v' => "\x77\x87\x32\x14\x0a\x01",
'�w' => "\x77\x88\x32\x14\x0a\x01",
'�x' => "\x77\x89\x32\x14\x0a\x01",
'�y' => "\x77\x8a\x32\x14\x0a\x01",
'�z' => "\x77\x8b\x32\x14\x0a\x01",
'�{' => "\x77\x8c\x32\x14\x0a\x01",
'�|' => "\x77\x8d\x32\x14\x0a\x01",
'�}' => "\x77\x8e\x32\x14\x0a\x01",
'�~' => "\x77\x8f\x32\x14\x0a\x01",
'��' => "\x77\x90\x32\x14\x0a\x01",
'��' => "\x77\x91\x32\x14\x0a\x01",
'��' => "\x77\x92\x32\x14\x0a\x01",
'��' => "\x77\x93\x32\x14\x0a\x01",
'��' => "\x77\x94\x32\x14\x0a\x01",
'��' => "\x77\x95\x32\x14\x0a\x01",
'��' => "\x77\x96\x32\x14\x0a\x01",
'��' => "\x77\x97\x32\x14\x0a\x01",
'��' => "\x77\x98\x32\x14\x0a\x01",
'��' => "\x77\x99\x32\x14\x0a\x01",
'��' => "\x77\x9a\x32\x14\x0a\x01",
'��' => "\x77\x9b\x32\x14\x0a\x01",
'��' => "\x77\x9c\x32\x14\x0a\x01",
'��' => "\x77\x9d\x32\x14\x0a\x01",
'��' => "\x77\x9e\x32\x14\x0a\x01",
'��' => "\x77\x9f\x32\x14\x0a\x01",
'��' => "\x77\xa0\x32\x14\x0a\x01",
'��' => "\x77\xa1\x32\x14\x0a\x01",
'�@' => "\x77\xb1\x32\x14\x0a\x01",
'�A' => "\x77\xb2\x32\x14\x0a\x01",
'�B' => "\x77\xb3\x32\x14\x0a\x01",
'�C' => "\x77\xb4\x32\x14\x0a\x01",
'�D' => "\x77\xb5\x32\x14\x0a\x01",
'�E' => "\x77\xb6\x32\x14\x0a\x01",
'�F' => "\x77\xb7\x32\x14\x0a\x01",
'�G' => "\x77\xb8\x32\x14\x0a\x01",
'�H' => "\x77\xb9\x32\x14\x0a\x01",
'�I' => "\x77\xba\x32\x14\x0a\x01",
'�J' => "\x77\xbb\x32\x14\x0a\x01",
'�K' => "\x77\xbc\x32\x14\x0a\x01",
'�L' => "\x77\xbd\x32\x14\x0a\x01",
'�M' => "\x77\xbe\x32\x14\x0a\x01",
'�N' => "\x77\xbf\x32\x14\x0a\x01",
'�O' => "\x77\xc0\x32\x14\x0a\x01",
'�P' => "\x77\xc1\x32\x14\x0a\x01",
'�Q' => "\x77\xc2\x32\x14\x0a\x01",
'�R' => "\x77\xc3\x32\x14\x0a\x01",
'�S' => "\x77\xc4\x32\x14\x0a\x01",
'�T' => "\x77\xc5\x32\x14\x0a\x01",
'�U' => "\x77\xc6\x32\x14\x0a\x01",
'�V' => "\x77\xc7\x32\x14\x0a\x01",
'�W' => "\x77\xc8\x32\x14\x0a\x01",
'�X' => "\x77\xc9\x32\x14\x0a\x01",
'�Y' => "\x77\xca\x32\x14\x0a\x01",
'�Z' => "\x77\xcb\x32\x14\x0a\x01",
'�[' => "\x77\xcc\x32\x14\x0a\x01",
(qw/�\ /)[0]
     => "\x77\xcd\x32\x14\x0a\x01",
'�]' => "\x77\xce\x32\x14\x0a\x01",
'�^' => "\x77\xcf\x32\x14\x0a\x01",
'�_' => "\x77\xd0\x32\x14\x0a\x01",
'�`' => "\x77\xd1\x32\x14\x0a\x01",
'a'  => "\x78\x41\x33\x15\x0a\x02",
'��' => "\x78\x41\x33\x15\x0a\x05",
'A'  => "\x78\x41\x33\x16\x0a\x02",
'�`' => "\x78\x41\x33\x16\x0a\x05",
'b'  => "\x78\x42\x33\x15\x0a\x02",
'��' => "\x78\x42\x33\x15\x0a\x05",
'B'  => "\x78\x42\x33\x16\x0a\x02",
'�a' => "\x78\x42\x33\x16\x0a\x05",
'c'  => "\x78\x43\x33\x15\x0a\x02",
'��' => "\x78\x43\x33\x15\x0a\x05",
'C'  => "\x78\x43\x33\x16\x0a\x02",
'�b' => "\x78\x43\x33\x16\x0a\x05",
'd'  => "\x78\x44\x33\x15\x0a\x02",
'��' => "\x78\x44\x33\x15\x0a\x05",
'D'  => "\x78\x44\x33\x16\x0a\x02",
'�c' => "\x78\x44\x33\x16\x0a\x05",
'e'  => "\x78\x45\x33\x15\x0a\x02",
'��' => "\x78\x45\x33\x15\x0a\x05",
'E'  => "\x78\x45\x33\x16\x0a\x02",
'�d' => "\x78\x45\x33\x16\x0a\x05",
'f'  => "\x78\x46\x33\x15\x0a\x02",
'��' => "\x78\x46\x33\x15\x0a\x05",
'F'  => "\x78\x46\x33\x16\x0a\x02",
'�e' => "\x78\x46\x33\x16\x0a\x05",
'g'  => "\x78\x47\x33\x15\x0a\x02",
'��' => "\x78\x47\x33\x15\x0a\x05",
'G'  => "\x78\x47\x33\x16\x0a\x02",
'�f' => "\x78\x47\x33\x16\x0a\x05",
'h'  => "\x78\x48\x33\x15\x0a\x02",
'��' => "\x78\x48\x33\x15\x0a\x05",
'H'  => "\x78\x48\x33\x16\x0a\x02",
'�g' => "\x78\x48\x33\x16\x0a\x05",
'i'  => "\x78\x49\x33\x15\x0a\x02",
'��' => "\x78\x49\x33\x15\x0a\x05",
'I'  => "\x78\x49\x33\x16\x0a\x02",
'�h' => "\x78\x49\x33\x16\x0a\x05",
'j'  => "\x78\x4a\x33\x15\x0a\x02",
'��' => "\x78\x4a\x33\x15\x0a\x05",
'J'  => "\x78\x4a\x33\x16\x0a\x02",
'�i' => "\x78\x4a\x33\x16\x0a\x05",
'k'  => "\x78\x4b\x33\x15\x0a\x02",
'��' => "\x78\x4b\x33\x15\x0a\x05",
'K'  => "\x78\x4b\x33\x16\x0a\x02",
'�j' => "\x78\x4b\x33\x16\x0a\x05",
'l'  => "\x78\x4c\x33\x15\x0a\x02",
'��' => "\x78\x4c\x33\x15\x0a\x05",
'L'  => "\x78\x4c\x33\x16\x0a\x02",
'�k' => "\x78\x4c\x33\x16\x0a\x05",
'm'  => "\x78\x4d\x33\x15\x0a\x02",
'��' => "\x78\x4d\x33\x15\x0a\x05",
'M'  => "\x78\x4d\x33\x16\x0a\x02",
'�l' => "\x78\x4d\x33\x16\x0a\x05",
'n'  => "\x78\x4e\x33\x15\x0a\x02",
'��' => "\x78\x4e\x33\x15\x0a\x05",
'N'  => "\x78\x4e\x33\x16\x0a\x02",
'�m' => "\x78\x4e\x33\x16\x0a\x05",
'o'  => "\x78\x4f\x33\x15\x0a\x02",
'��' => "\x78\x4f\x33\x15\x0a\x05",
'O'  => "\x78\x4f\x33\x16\x0a\x02",
'�n' => "\x78\x4f\x33\x16\x0a\x05",
'p'  => "\x78\x50\x33\x15\x0a\x02",
'��' => "\x78\x50\x33\x15\x0a\x05",
'P'  => "\x78\x50\x33\x16\x0a\x02",
'�o' => "\x78\x50\x33\x16\x0a\x05",
'q'  => "\x78\x51\x33\x15\x0a\x02",
'��' => "\x78\x51\x33\x15\x0a\x05",
'Q'  => "\x78\x51\x33\x16\x0a\x02",
'�p' => "\x78\x51\x33\x16\x0a\x05",
'r'  => "\x78\x52\x33\x15\x0a\x02",
'��' => "\x78\x52\x33\x15\x0a\x05",
'R'  => "\x78\x52\x33\x16\x0a\x02",
'�q' => "\x78\x52\x33\x16\x0a\x05",
's'  => "\x78\x53\x33\x15\x0a\x02",
'��' => "\x78\x53\x33\x15\x0a\x05",
'S'  => "\x78\x53\x33\x16\x0a\x02",
'�r' => "\x78\x53\x33\x16\x0a\x05",
't'  => "\x78\x54\x33\x15\x0a\x02",
'��' => "\x78\x54\x33\x15\x0a\x05",
'T'  => "\x78\x54\x33\x16\x0a\x02",
'�s' => "\x78\x54\x33\x16\x0a\x05",
'u'  => "\x78\x55\x33\x15\x0a\x02",
'��' => "\x78\x55\x33\x15\x0a\x05",
'U'  => "\x78\x55\x33\x16\x0a\x02",
'�t' => "\x78\x55\x33\x16\x0a\x05",
'v'  => "\x78\x56\x33\x15\x0a\x02",
'��' => "\x78\x56\x33\x15\x0a\x05",
'V'  => "\x78\x56\x33\x16\x0a\x02",
'�u' => "\x78\x56\x33\x16\x0a\x05",
'w'  => "\x78\x57\x33\x15\x0a\x02",
'��' => "\x78\x57\x33\x15\x0a\x05",
'W'  => "\x78\x57\x33\x16\x0a\x02",
'�v' => "\x78\x57\x33\x16\x0a\x05",
'x'  => "\x78\x58\x33\x15\x0a\x02",
'��' => "\x78\x58\x33\x15\x0a\x05",
'X'  => "\x78\x58\x33\x16\x0a\x02",
'�w' => "\x78\x58\x33\x16\x0a\x05",
'y'  => "\x78\x59\x33\x15\x0a\x02",
'��' => "\x78\x59\x33\x15\x0a\x05",
'Y'  => "\x78\x59\x33\x16\x0a\x02",
'�x' => "\x78\x59\x33\x16\x0a\x05",
'z'  => "\x78\x5a\x33\x15\x0a\x02",
'��' => "\x78\x5a\x33\x15\x0a\x05",
'Z'  => "\x78\x5a\x33\x16\x0a\x02",
'�y' => "\x78\x5a\x33\x16\x0a\x05",
'��' => "\x79\x41\x34\x1b\x10\x03",
'�@' => "\x79\x41\x34\x1b\x11\x03",
'�'  => "\x79\x41\x34\x1b\x11\x04",
'��' => "\x79\x41\x34\x1d\x10\x03",
'�A' => "\x79\x41\x34\x1d\x11\x03",
'�'  => "\x79\x41\x34\x1d\x11\x04",
'��' => "\x79\x42\x34\x1b\x10\x03",
'�B' => "\x79\x42\x34\x1b\x11\x03",
'�'  => "\x79\x42\x34\x1b\x11\x04",
'��' => "\x79\x42\x34\x1d\x10\x03",
'�C' => "\x79\x42\x34\x1d\x11\x03",
'�'  => "\x79\x42\x34\x1d\x11\x04",
'��' => "\x79\x43\x34\x1b\x10\x03",
'�D' => "\x79\x43\x34\x1b\x11\x03",
'�'  => "\x79\x43\x34\x1b\x11\x04",
'��' => "\x79\x43\x34\x1d\x10\x03",
'�E' => "\x79\x43\x34\x1d\x11\x03",
'�'  => "\x79\x43\x34\x1d\x11\x04",
'��' => "\x79\x43\x35\x1d\x11\x03",
'��' => "\x79\x43\x35\x1d\x11\x04",
'��' => "\x79\x44\x34\x1b\x10\x03",
'�F' => "\x79\x44\x34\x1b\x11\x03",
'�'  => "\x79\x44\x34\x1b\x11\x04",
'��' => "\x79\x44\x34\x1d\x10\x03",
'�G' => "\x79\x44\x34\x1d\x11\x03",
'�'  => "\x79\x44\x34\x1d\x11\x04",
'��' => "\x79\x45\x34\x1b\x10\x03",
'�H' => "\x79\x45\x34\x1b\x11\x03",
'�'  => "\x79\x45\x34\x1b\x11\x04",
'��' => "\x79\x45\x34\x1d\x10\x03",
'�I' => "\x79\x45\x34\x1d\x11\x03",
'�'  => "\x79\x45\x34\x1d\x11\x04",
'��' => "\x79\x51\x34\x1b\x11\x03",
'��' => "\x79\x51\x34\x1d\x10\x03",
'�J' => "\x79\x51\x34\x1d\x11\x03",
'�'  => "\x79\x51\x34\x1d\x11\x04",
'��' => "\x79\x51\x35\x1d\x10\x03",
'�K' => "\x79\x51\x35\x1d\x11\x03",
'��' => "\x79\x51\x35\x1d\x11\x04",
'��' => "\x79\x52\x34\x1d\x10\x03",
'�L' => "\x79\x52\x34\x1d\x11\x03",
'�'  => "\x79\x52\x34\x1d\x11\x04",
'��' => "\x79\x52\x35\x1d\x10\x03",
'�M' => "\x79\x52\x35\x1d\x11\x03",
'��' => "\x79\x52\x35\x1d\x11\x04",
'��' => "\x79\x53\x34\x1d\x10\x03",
'�N' => "\x79\x53\x34\x1d\x11\x03",
'�'  => "\x79\x53\x34\x1d\x11\x04",
'��' => "\x79\x53\x35\x1d\x10\x03",
'�O' => "\x79\x53\x35\x1d\x11\x03",
'��' => "\x79\x53\x35\x1d\x11\x04",
'��' => "\x79\x54\x34\x1b\x11\x03",
'��' => "\x79\x54\x34\x1d\x10\x03",
'�P' => "\x79\x54\x34\x1d\x11\x03",
'�'  => "\x79\x54\x34\x1d\x11\x04",
'��' => "\x79\x54\x35\x1d\x10\x03",
'�Q' => "\x79\x54\x35\x1d\x11\x03",
'��' => "\x79\x54\x35\x1d\x11\x04",
'��' => "\x79\x55\x34\x1d\x10\x03",
'�R' => "\x79\x55\x34\x1d\x11\x03",
'�'  => "\x79\x55\x34\x1d\x11\x04",
'��' => "\x79\x55\x35\x1d\x10\x03",
'�S' => "\x79\x55\x35\x1d\x11\x03",
'��' => "\x79\x55\x35\x1d\x11\x04",
'��' => "\x79\x61\x34\x1d\x10\x03",
'�T' => "\x79\x61\x34\x1d\x11\x03",
'�'  => "\x79\x61\x34\x1d\x11\x04",
'��' => "\x79\x61\x35\x1d\x10\x03",
'�U' => "\x79\x61\x35\x1d\x11\x03",
'��' => "\x79\x61\x35\x1d\x11\x04",
'��' => "\x79\x62\x34\x1d\x10\x03",
'�V' => "\x79\x62\x34\x1d\x11\x03",
'�'  => "\x79\x62\x34\x1d\x11\x04",
'��' => "\x79\x62\x35\x1d\x10\x03",
'�W' => "\x79\x62\x35\x1d\x11\x03",
'��' => "\x79\x62\x35\x1d\x11\x04",
'��' => "\x79\x63\x34\x1d\x10\x03",
'�X' => "\x79\x63\x34\x1d\x11\x03",
'�'  => "\x79\x63\x34\x1d\x11\x04",
'��' => "\x79\x63\x35\x1d\x10\x03",
'�Y' => "\x79\x63\x35\x1d\x11\x03",
'��' => "\x79\x63\x35\x1d\x11\x04",
'��' => "\x79\x64\x34\x1d\x10\x03",
'�Z' => "\x79\x64\x34\x1d\x11\x03",
'�'  => "\x79\x64\x34\x1d\x11\x04",
'��' => "\x79\x64\x35\x1d\x10\x03",
'�[' => "\x79\x64\x35\x1d\x11\x03",
'��' => "\x79\x64\x35\x1d\x11\x04",
'��' => "\x79\x65\x34\x1d\x10\x03",
(qw/�\ /)[0]
     => "\x79\x65\x34\x1d\x11\x03",
'�'  => "\x79\x65\x34\x1d\x11\x04",
'��' => "\x79\x65\x35\x1d\x10\x03",
'�]' => "\x79\x65\x35\x1d\x11\x03",
'��' => "\x79\x65\x35\x1d\x11\x04",
'��' => "\x79\x71\x34\x1d\x10\x03",
'�^' => "\x79\x71\x34\x1d\x11\x03",
'�'  => "\x79\x71\x34\x1d\x11\x04",
'��' => "\x79\x71\x35\x1d\x10\x03",
'�_' => "\x79\x71\x35\x1d\x11\x03",
'��' => "\x79\x71\x35\x1d\x11\x04",
'��' => "\x79\x72\x34\x1d\x10\x03",
'�`' => "\x79\x72\x34\x1d\x11\x03",
'�'  => "\x79\x72\x34\x1d\x11\x04",
'��' => "\x79\x72\x35\x1d\x10\x03",
'�a' => "\x79\x72\x35\x1d\x11\x03",
'��' => "\x79\x72\x35\x1d\x11\x04",
'��' => "\x79\x73\x34\x1b\x10\x03",
'�b' => "\x79\x73\x34\x1b\x11\x03",
'�'  => "\x79\x73\x34\x1b\x11\x04",
'��' => "\x79\x73\x34\x1d\x10\x03",
'�c' => "\x79\x73\x34\x1d\x11\x03",
'�'  => "\x79\x73\x34\x1d\x11\x04",
'��' => "\x79\x73\x35\x1d\x10\x03",
'�d' => "\x79\x73\x35\x1d\x11\x03",
'��' => "\x79\x73\x35\x1d\x11\x04",
'��' => "\x79\x74\x34\x1d\x10\x03",
'�e' => "\x79\x74\x34\x1d\x11\x03",
'�'  => "\x79\x74\x34\x1d\x11\x04",
'��' => "\x79\x74\x35\x1d\x10\x03",
'�f' => "\x79\x74\x35\x1d\x11\x03",
'��' => "\x79\x74\x35\x1d\x11\x04",
'��' => "\x79\x75\x34\x1d\x10\x03",
'�g' => "\x79\x75\x34\x1d\x11\x03",
'�'  => "\x79\x75\x34\x1d\x11\x04",
'��' => "\x79\x75\x35\x1d\x10\x03",
'�h' => "\x79\x75\x35\x1d\x11\x03",
'��' => "\x79\x75\x35\x1d\x11\x04",
'��' => "\x79\x81\x34\x1d\x10\x03",
'�i' => "\x79\x81\x34\x1d\x11\x03",
'�'  => "\x79\x81\x34\x1d\x11\x04",
'��' => "\x79\x82\x34\x1d\x10\x03",
'�j' => "\x79\x82\x34\x1d\x11\x03",
'�'  => "\x79\x82\x34\x1d\x11\x04",
'��' => "\x79\x83\x34\x1d\x10\x03",
'�k' => "\x79\x83\x34\x1d\x11\x03",
'�'  => "\x79\x83\x34\x1d\x11\x04",
'��' => "\x79\x84\x34\x1d\x10\x03",
'�l' => "\x79\x84\x34\x1d\x11\x03",
'�'  => "\x79\x84\x34\x1d\x11\x04",
'��' => "\x79\x85\x34\x1d\x10\x03",
'�m' => "\x79\x85\x34\x1d\x11\x03",
'�'  => "\x79\x85\x34\x1d\x11\x04",
'��' => "\x79\x91\x34\x1d\x10\x03",
'�n' => "\x79\x91\x34\x1d\x11\x03",
'�'  => "\x79\x91\x34\x1d\x11\x04",
'��' => "\x79\x91\x35\x1d\x10\x03",
'�o' => "\x79\x91\x35\x1d\x11\x03",
'��' => "\x79\x91\x35\x1d\x11\x04",
'��' => "\x79\x91\x36\x1d\x10\x03",
'�p' => "\x79\x91\x36\x1d\x11\x03",
'��' => "\x79\x91\x36\x1d\x11\x04",
'��' => "\x79\x92\x34\x1d\x10\x03",
'�q' => "\x79\x92\x34\x1d\x11\x03",
'�'  => "\x79\x92\x34\x1d\x11\x04",
'��' => "\x79\x92\x35\x1d\x10\x03",
'�r' => "\x79\x92\x35\x1d\x11\x03",
'��' => "\x79\x92\x35\x1d\x11\x04",
'��' => "\x79\x92\x36\x1d\x10\x03",
'�s' => "\x79\x92\x36\x1d\x11\x03",
'��' => "\x79\x92\x36\x1d\x11\x04",
'��' => "\x79\x93\x34\x1d\x10\x03",
'�t' => "\x79\x93\x34\x1d\x11\x03",
'�'  => "\x79\x93\x34\x1d\x11\x04",
'��' => "\x79\x93\x35\x1d\x10\x03",
'�u' => "\x79\x93\x35\x1d\x11\x03",
'��' => "\x79\x93\x35\x1d\x11\x04",
'��' => "\x79\x93\x36\x1d\x10\x03",
'�v' => "\x79\x93\x36\x1d\x11\x03",
'��' => "\x79\x93\x36\x1d\x11\x04",
'��' => "\x79\x94\x34\x1d\x10\x03",
'�w' => "\x79\x94\x34\x1d\x11\x03",
'�'  => "\x79\x94\x34\x1d\x11\x04",
'��' => "\x79\x94\x35\x1d\x10\x03",
'�x' => "\x79\x94\x35\x1d\x11\x03",
'��' => "\x79\x94\x35\x1d\x11\x04",
'��' => "\x79\x94\x36\x1d\x10\x03",
'�y' => "\x79\x94\x36\x1d\x11\x03",
'��' => "\x79\x94\x36\x1d\x11\x04",
'��' => "\x79\x95\x34\x1d\x10\x03",
'�z' => "\x79\x95\x34\x1d\x11\x03",
'�'  => "\x79\x95\x34\x1d\x11\x04",
'��' => "\x79\x95\x35\x1d\x10\x03",
'�{' => "\x79\x95\x35\x1d\x11\x03",
'��' => "\x79\x95\x35\x1d\x11\x04",
'��' => "\x79\x95\x36\x1d\x10\x03",
'�|' => "\x79\x95\x36\x1d\x11\x03",
'��' => "\x79\x95\x36\x1d\x11\x04",
'��' => "\x79\xa1\x34\x1d\x10\x03",
'�}' => "\x79\xa1\x34\x1d\x11\x03",
'�'  => "\x79\xa1\x34\x1d\x11\x04",
'��' => "\x79\xa2\x34\x1d\x10\x03",
'�~' => "\x79\xa2\x34\x1d\x11\x03",
'�'  => "\x79\xa2\x34\x1d\x11\x04",
'��' => "\x79\xa3\x34\x1d\x10\x03",
'��' => "\x79\xa3\x34\x1d\x11\x03",
'�'  => "\x79\xa3\x34\x1d\x11\x04",
'��' => "\x79\xa4\x34\x1d\x10\x03",
'��' => "\x79\xa4\x34\x1d\x11\x03",
'�'  => "\x79\xa4\x34\x1d\x11\x04",
'��' => "\x79\xa5\x34\x1d\x10\x03",
'��' => "\x79\xa5\x34\x1d\x11\x03",
'�'  => "\x79\xa5\x34\x1d\x11\x04",
'��' => "\x79\xb1\x34\x1b\x10\x03",
'��' => "\x79\xb1\x34\x1b\x11\x03",
'�'  => "\x79\xb1\x34\x1b\x11\x04",
'��' => "\x79\xb1\x34\x1d\x10\x03",
'��' => "\x79\xb1\x34\x1d\x11\x03",
'�'  => "\x79\xb1\x34\x1d\x11\x04",
'��' => "\x79\xb3\x34\x1b\x10\x03",
'��' => "\x79\xb3\x34\x1b\x11\x03",
'�'  => "\x79\xb3\x34\x1b\x11\x04",
'��' => "\x79\xb3\x34\x1d\x10\x03",
'��' => "\x79\xb3\x34\x1d\x11\x03",
'�'  => "\x79\xb3\x34\x1d\x11\x04",
'��' => "\x79\xb5\x34\x1b\x10\x03",
'��' => "\x79\xb5\x34\x1b\x11\x03",
'�'  => "\x79\xb5\x34\x1b\x11\x04",
'��' => "\x79\xb5\x34\x1d\x10\x03",
'��' => "\x79\xb5\x34\x1d\x11\x03",
'�'  => "\x79\xb5\x34\x1d\x11\x04",
'��' => "\x79\xc1\x34\x1d\x10\x03",
'��' => "\x79\xc1\x34\x1d\x11\x03",
'�'  => "\x79\xc1\x34\x1d\x11\x04",
'��' => "\x79\xc2\x34\x1d\x10\x03",
'��' => "\x79\xc2\x34\x1d\x11\x03",
'�'  => "\x79\xc2\x34\x1d\x11\x04",
'��' => "\x79\xc3\x34\x1d\x10\x03",
'��' => "\x79\xc3\x34\x1d\x11\x03",
'�'  => "\x79\xc3\x34\x1d\x11\x04",
'��' => "\x79\xc4\x34\x1d\x10\x03",
'��' => "\x79\xc4\x34\x1d\x11\x03",
'�'  => "\x79\xc4\x34\x1d\x11\x04",
'��' => "\x79\xc5\x34\x1d\x10\x03",
'��' => "\x79\xc5\x34\x1d\x11\x03",
'�'  => "\x79\xc5\x34\x1d\x11\x04",
'��' => "\x79\xd1\x34\x1b\x10\x03",
'��' => "\x79\xd1\x34\x1b\x11\x03",
'��' => "\x79\xd1\x34\x1d\x10\x03",
'��' => "\x79\xd1\x34\x1d\x11\x03",
'�'  => "\x79\xd1\x34\x1d\x11\x04",
'��' => "\x79\xd2\x34\x1d\x10\x03",
'��' => "\x79\xd2\x34\x1d\x11\x03",
'��' => "\x79\xd4\x34\x1d\x10\x03",
'��' => "\x79\xd4\x34\x1d\x11\x03",
'��' => "\x79\xd5\x34\x1d\x10\x03",
'��' => "\x79\xd5\x34\x1d\x11\x03",
'�'  => "\x79\xd5\x34\x1d\x11\x04",
'��' => "\x79\xd6\x34\x1d\x10\x03",
'��' => "\x79\xd6\x34\x1d\x11\x03",
'�'  => "\x79\xd6\x34\x1d\x11\x04",
'�T' => "\x79\xd7\x34\x1c\x10\x03",
'�R' => "\x79\xd7\x34\x1c\x11\x03",
'�U' => "\x79\xd7\x35\x1c\x10\x03",
'�S' => "\x79\xd7\x35\x1c\x11\x03",
'�[' => "\x79\xd8\x34\x1a\x11\x03",
'�'  => "\x79\xd8\x34\x1a\x11\x04",
'�V' => "\x7a\x41\x32\x14\x0a\x01",
'�X' => "\x7a\x42\x32\x14\x0a\x01",
'�W' => "\x7a\x43\x32\x14\x0a\x01",
'�Y' => "\x7a\x44\x32\x14\x0a\x01",
'�Z' => "\x7a\x45\x32\x14\x0a\x01",
'��' => "\xfe\xfc\x32\x14\x0a\x01",
);

sub _getOrder { wantarray ? %Order : \%Order }

sub _getClass($) {
    my $w = ord shift; # weight
    return
	$w <  0x70 ?  0 : # ignorable
	$w == 0x70 ?  1 : # space
	$w == 0x71 ?  2 : # kijutsu kigou   : descriptive symbols
	$w == 0x72 ?  3 : # kakko kigou     : quotes and parentheses
	$w == 0x73 ?  4 : # gakujutsu kigou : math. operators and sci. symbols
	$w == 0x74 ?  5 : # ippan kigou     : general symbols
	$w == 0x75 ?  6 : # unit symbols
	$w == 0x76 ?  7 : # arabic digits
	$w == 0x77 ?  8 : # ooji kigou      : Greek and Cyrillic alphabets
	$w == 0x78 ?  9 : # Latin alphabets
	$w == 0x79 ? 10 : # kana
	$w <= 0xfc ? 11 : # kanji
	             12 ; # geta
}

my %Replaced;
my @Replaced = qw( �[  �  �T  �R  �U  �S );
@Replaced{@Replaced} = (1) x @Replaced;

sub _replaced($$) {
    my $c = shift; # current element
    my $p = unpack('n', shift);
      # weight at the 1st level of the previous element
    return unless 0x7941 <= $p && $p <= 0x79d6;

    my $d = $p % 16; # dan : a-i-u-e-o or others
    my $n = pack('n', $p);
    return
	$c eq '�['
	    ? "\x79".chr($d == 6 ? 0xd6 : 0x40 + $d)."\x34\x1a\x11\x03" :
	$c eq '�'
	    ? "\x79".chr($d == 6 ? 0xd6 : 0x40 + $d)."\x34\x1a\x11\x04" :
	$c eq '�T'
	    ? "$n\x34\x1c\x10\x03" :
	$c eq '�R'
	    ? "$n\x34\x1c\x11\x03" :
	$c eq '�U' && # has Daku Hiragana
		 $n =~ /^\x79[\x51-\x55\x61-\x65\x71-\x75\x91-\x95]/
	    ? "$n\x35\x1c\x10\x03" :
	$c eq '�S' && # has Daku Katakana
		 $n =~ /^\x79[\x43\x51-\x55\x61-\x65\x71-\x75\x91-\x95]/
	    ? "$n\x35\x1c\x11\x03" :
	    undef;
}

sub _length {
    my $str = shift;
    0 + $str =~ s/[\x81-\x9F\xE0-\xFC][\x00-\xFF]|[\x00-\xFF]//g;
}

sub getWtCJK {
    my $self = shift;
    my $c    = shift;
    if ($self->{kanji} == 3) {
	my $u = &{ $self->{tounicode} }($c);
	croak "A passed codepoint of kanji is outside CJK Unified Ideographs"
	    unless 0x4E00 <= $u && $u <= 0x9FFF;
	my $d = $u - 0x4E00;
	chr(int($d / 192) + 0x80).chr($d % 192 + 0x40)."\x32\x14\x0a\x01";
    } else {
	"$c\x32\x14\x0a\x01";
    }
}

sub getWt {
    my $self = shift;
    my $str  = $self->{preprocess} ? &{ $self->{preprocess} }(shift) : shift;
    my $kan  = $self->{kanji};
    my $ign  = $self->{ignoreChar};

    if ($str !~ m/^(?:$Char)*$/o) {
	carp $PACKAGE . " Malformed Shift_JIS character";
    }

    my($c, @buf);
    foreach $c ($str =~ m/$Char/go) {
	next unless $Order{$c} || $kan > 1 && $c =~ /^$CJK$/o;
	next if defined $ign && $c =~ /$ign/;

	my $replaced;
	$replaced = _replaced($c, $buf[-1]) if $Replaced{$c} && @buf;

	push @buf,
	    $replaced  ? $replaced  :
	    $Order{$c} ? $Order{$c} :
	    $kan > 1   ? $self->getWtCJK($c) : ();
    }
    return wantarray ? @buf : join('', @buf);
}

sub getSortKey {
    my $self = shift;
    my $wt   = $self->getWt(shift);
    my $lev  = $self->{level};
    my @ret;

    ($ret[0] = $wt) =~ tr/\x40-\xff//cd if 0 < $lev;
    ($ret[1] = $wt) =~ tr/\x32-\x36//cd if 1 < $lev;
    ($ret[2] = $wt) =~ tr/\x14-\x1d//cd if 2 < $lev;
    ($ret[3] = $wt) =~ tr/\x0a-\x11//cd if 3 < $lev;
    ($ret[4] = $wt) =~ tr/\x01-\x05//cd if 4 < $lev;

    # 3rd level
    $ret[2] =~ tr/\x15\x16/\x16\x15/
	if 2 < $lev && $self->{upper_before_lower};

    # 4th level
    $ret[3] =~ tr/\x10\x11/\x11\x10/
	if 3 < $lev && $self->{katakana_before_hiragana};

    join "\0\0", @ret[0..$lev-1];
}

sub cmp { $_[0]->getSortKey($_[1]) cmp $_[0]->getSortKey($_[2]) }
sub eq  { $_[0]->getSortKey($_[1]) eq  $_[0]->getSortKey($_[2]) }
sub ne  { $_[0]->getSortKey($_[1]) ne  $_[0]->getSortKey($_[2]) }
sub gt  { $_[0]->getSortKey($_[1]) gt  $_[0]->getSortKey($_[2]) }
sub ge  { $_[0]->getSortKey($_[1]) ge  $_[0]->getSortKey($_[2]) }
sub lt  { $_[0]->getSortKey($_[1]) lt  $_[0]->getSortKey($_[2]) }
sub le  { $_[0]->getSortKey($_[1]) le  $_[0]->getSortKey($_[2]) }

sub sort {
    my $obj = shift;
    my(%hyoki);
    foreach (@_) {
	$hyoki{$_} = $obj->getSortKey($_);
    }
    return sort{ $hyoki{$a} cmp $hyoki{$b} } @_;
}

sub sortYomi {
    my $obj = shift;
    my (%hyoki, %yomi);
    my @str = @_;
    foreach (@str) {
	$hyoki{ $_->[0] } = $obj->getSortKey($_->[0]);
	$yomi{  $_->[1] } = $obj->getSortKey($_->[1]);
    }

    return sort {
	    $yomi{ $a->[1] } cmp $yomi{ $b->[1] }
	 || $hyoki{ $a->[0] } cmp $hyoki{ $b->[0] }
	} @str;
}

sub sortDaihyo {
    my $obj = shift;
    my (%class, %hyoki, %yomi, %daihyo, %kashira);
    my @str = @_;
    foreach (@str) {
	$hyoki{   $_->[0] } = $obj->getSortKey(  $_->[0] ); # string
	$yomi{    $_->[1] } = $obj->getSortKey(  $_->[1] ); # string
	$daihyo{  $_->[1] } = unpack('n', $yomi{ $_->[1]}); # number
	$kashira{ $_->[0] } = unpack('n', $hyoki{$_->[0]}); # number
	$class{   $_->[0] } = _getClass( $hyoki{$_->[0]} ); # number
    }

    sort{ $class{  $a->[0] } <=> $class{  $b->[0] }
	|| $daihyo{ $a->[1] } <=> $daihyo{ $b->[1] }
	|| $kashira{$a->[0] } <=> $kashira{$b->[0] }
	|| $yomi{   $a->[1] } cmp $yomi{   $b->[1] }
	|| $hyoki{  $a->[0] } cmp $hyoki{  $b->[0] }
    } @str;
}

##
## int = index(string, substring)
##
sub index {
    my $self = shift;
    my $str  = $self->{preprocess} ? &{ $self->{preprocess} }(shift) : shift;
    my $sub  = shift;
    my $byte = $self->{position_in_bytes};
    my $kan  = $self->{kanji};
    my $ign  = $self->{ignoreChar};
    my $lev  = $self->{level};

    my @subWt = $self->getWt($sub);
    return wantarray ? (0,0) : 0 if ! @subWt;
    return wantarray ?  ()  : -1 if $str eq '';

    if ($str !~ m/^(?:$Char)*$/o) {
	carp $PACKAGE . " Malformed Shift_JIS character";
    }

    my $count = 0;
    my($c, $prev, @strWt, @strPt);
    foreach $c ($str =~ m/$Char/go) {
	my $cur;
	next if defined $ign && $c =~ /$ign/;
	if ($Order{$c} || $kan > 1 && $c =~ /^$CJK$/o) {
	    $cur   = _replaced($c, $strWt[-1]) if $Replaced{$c} && @strWt;
	    $cur ||= $Order{$c} ? $Order{$c} :
	    $kan > 1   ? $self->getWtCJK($c) : undef;
	}

	if ($cur) {
	    push @strWt, $cur;
	    push @strPt, $count;
	}
	$count += $byte ? length($c) : _length($c);

	while (@strWt >= @subWt) {
	    if (_eqArray(\@strWt, \@subWt, $lev)) {
		my $pos = $strPt[0];
		return wantarray ? ($pos, $count-$pos) : $pos;
	    }
	    shift @strWt;
	    shift @strPt;
	}
    }
    return wantarray ? () : -1;
}

##
## bool _eqArray(arrayref, arrayref, level)
##
sub _eqArray($$$) {
    my $a   = shift; # length $a >= length $b;
    my $b   = shift;
    my $len = 1 + shift; # 1 + level

    my($c);
    foreach $c (0..@$b-1) {
	return if substr($a->[$c], 0, $len) ne substr($b->[$c], 0, $len);
    }
    return 1;
}

1;

__END__

=head1 NAME

ShiftJIS::Collate - collation of Shift_JIS strings

=head1 SYNOPSIS

  use ShiftJIS::Collate;

  @sorted = ShiftJIS::Collate->new(%tailoring)->sort(@not_sorted);

=head1 ABOUT THIS POD

This POD is written in Shift_JIS.

Do you see 'C<��>' as C<HIRAGANA LETTER A>?
or 'C<\>' as C<YEN SIGN>, not as C<REVERSE SOLIDUS>?
Otherwise you'd change your font to an appropriate one.
(or the POD might be badly converted.)

=head1 DESCRIPTION

This module provides some functions to compare and sort strings
in Shift_JIS based on the collation of Japanese character strings.

This module is an implementation of B<JIS X 4061:1996> and
the collation rules are based on that standard.
See L<Conformance on the Standard>.

=head2 Constructor and Tailoring

The C<new> method returns a collator object.

   $Collator = ShiftJIS::Collate->new(
      ignoreChar => $regexIgnoredChar,
      kanji => $kanji_class,
      katakana_before_hiragana => $bool,
      level => $collationLevel,
      position_in_bytes => $bool,
      tounicode  => \&sjis_to_unicode,
      preprocess => \&preprocess,
      upper_before_lower => $bool,
   );
   # if %tailoring is false (empty),
   # $Collator should do the default collation.

=over 4

=item ignoreChar

If specified as a regular expression,
any characters that match it are ignored on collation.

e.g. If you want to ignore KATAKANA PROLONGED SOUND MARK
and its halfwidth form, say

   ignoreChar => '^(?:\x81\x5B|\xB0)',

=item katakana_before_hiragana

By default, hiragana is before katakana.

If the parameter is true, this is reversed.

=item kanji

Set the kanji class. See L<Kanji Classes>.

  Level 1: 'saisho' (minimal)
  Level 2: 'kihon' (basic)
  Level 3: 'kakucho' (extended)

The kanji class is specified as 1, 2, or 3. If omitted, class 2 is applied.

This module does not provide collation of 'kakucho' kanji class
since the repertory Shift_JIS does not define
all the Unicode CJK unified ideographs.

But if the kanji class 3 is specified, you can collate kanji
in the unicode order. In this case you must provide
L<tounicode> coderef which gives a unicode codepoint
from a Shift_JIS character.

=item level

Set the maximum level. See L<Collation Levels>.
Any higher levels than the specified one are ignored.

  Level 1: alphabetic ordering
  Level 2: diacritic ordering
  Level 3: case ordering
  Level 4: script ordering
  Level 5: width ordering

The collation level is specified as a number
between 1 and 5. If omitted, level 4 is applied.

=item tounicode

If you want to collate kanji in the unicode order,
specify a coderef which gives a unicode codepoint
from a Shift_JIS character.

Such a subroutine should map a string comprising of
a kanji of level 1 and 2 in Shift_JIS to a codepoint
in the range between 0x4E00 and 0x9FFF.

=item position_in_bytes

By default, the C<index> method returns its results in characters.

If this parameter is true, it returns the results in bytes.

=item preprocess

If specified, the coderef is used to preprocess
before the formation of sort keys.

=item upper_before_lower

By default, lowercase is before uppercase.

If the parameter is true, this is reversed.

=back

=head2 Comparison

=over 4

=item C<$result = $Collator-E<gt>cmp($a, $b)>

Returns 1 (when C<$a> is greater than C<$b>)
or 0 (when C<$a> is equal to C<$b>)
or -1 (when C<$a> is lesser than C<$b>).

=item C<$result = $Collator-E<gt>eq($a, $b)>

=item C<$result = $Collator-E<gt>ne($a, $b)>

=item C<$result = $Collator-E<gt>gt($a, $b)>

=item C<$result = $Collator-E<gt>ge($a, $b)>

=item C<$result = $Collator-E<gt>lt($a, $b)>

=item C<$result = $Collator-E<gt>le($a, $b)>

They works like the same name operators as theirs.

=back

=head2 Sorting

=over 4

=item C<@sorted = $Collator-E<gt>sort(@not_sorted)>

Sorts a list of strings by B<tanjun shogo>: 'the simple collation'.

=item C<@sorted = $Collator-E<gt>sortYomi(@not_sorted)>

Sorts a list of references to arrays of (spell, reading)
by B<yomi-hyoki shogo>: 'the collation using readings and spells'.

=item C<@sorted = $Collator-E<gt>sortDaihyo(@not_sorted)>

Sorts a list of references to arrays of (spell, reading)
by B<kan'i-daihyo-yomi shogo>:
'the simplified representative reading collation'.

=item C<$sortKey = $Collator-E<gt>getSortKey($string)>

Returns a sort key.

You compare the sort keys using a binary comparison
and get the result of the comparison of the strings.

   $Collator->getSortKey($a) cmp $Collator->getSortKey($b)

      is equivalent to

   $Collator->cmp($a, $b)

=back

=head2 Searching

=over 4

=item C<$position = $Collator-E<gt>index($string, $substring)>

=item C<($position, $length) = $Collator-E<gt>index($string, $substring)>

If C<$substring> matches a part of C<$string>, returns
the position of the first occurrence of the matching part in scalar context;
in list context, returns a two-element list of
the position and the length of the matching part.

B<Notice> that the length of the matching part may differ from
the length of C<$substring>.

If C<$substring> does not match any part of C<$string>,
returns C<-1> in scalar context and
an empty list in list context.

e.g. you say

  use ShiftJIS::Collate;
  use ShiftJIS::String qw(substr);

  my $Col = ShiftJIS::Collate->new( level => $level );
  my $str = "* �Ђ炪�ȂƃJ�^�J�i�̓��x���R�ł͓��������ȁB";
  my $sub = "����";
  my $match;
  if (my @tmp = $Col->index($str, $sub)) {
    $match = substr($str, $tmp[0], $tmp[1]);
  }

If C<$level> is 1, you get C<"����">;
if C<$level> is 2 or 3, you get C<"�J�i">;
if C<$level> is 4 or 5, you get C<"����">.

If your C<substr> function is not oriented to Shift_JIS,
specify true as C<position_in_bytes>. See L<Constructor and Tailoring>.

=back

=head1 NOTE

=head2 Collation Levels

The following criteria are considered in order
until the collation order is determined.
By default, Levels 1 to 4 are applied and Level 5 is ignored
(as JIS does).

=over 4

=item Level 1: alphabetic ordering.

The character class early appeared in the following list is smaller.

    Space characters, Symbols and Punctuations, Digits, Greek Letters,
    Cyrillic Letters, Latin letters, Kana letters, Kanji ideographs,
    and Geta mark.

In the class, alphabets are collated alphabetically;
kana letters are AIUEO-betically (in the Gozyuon order);
kanji are in the JIS X 0208 order.

Characters that do not belong to any character class are
ignored and skipped for collation.

=item Level 2: diacritic ordering.

In kana, the order is as shown the following list.

    A voiceless kana, the voiced, then the semi-voiced (if exists).
     (eg. Ka < Ga; Ha < Ba < Pa)

=item Level 3: case ordering.

A small Latin is lesser than the corresponding Capital.

In kana, the order is as shown the following list.
see L<Replacement of PROLONGED SOUND MARK and ITERATION MARKs>.

    Replaced PROLONGED SOUND MARK (U+30FC);
    Small Kana;
    Replaced ITERATION MARK (U+309D, U+309E, U+30FD or U+30FE);
    then, Normal Kana.

=item Level 4: script ordering.

Any hiragana is lesser than the corresponding katakana.

=item Level 5: width ordering.

A character that belongs to the block
C<Halfwidth and Fullwidth Forms>
is greater than the corresponding normal character.

B<BN:> JIS does not mention this level. Extenstion by this module.

=back

=head2 Kanji Classes

There are three kanji classes. This modules provides the Classes 1 and 2.

=over 4

=item Class 1: the 'saisho' (minimal) kanji class

It comprises five kanji-like characters,
i.e. U+3003, U+3005, U+4EDD, U+3006, U+3007.
Any kanji except U+4EDD are ignored on collation.

=item Class 2: the 'kihon' (basic) kanji class

It comprises JIS level 1 and 2 kanji in addition to
the minimal kanji class. Sorted in the JIS codepoint order.
Any kanji excepting those defined by JIS X 0208 are ignored on collation.

=item Class 3: the 'kakucho' (extended) kanji class

All the CJK Unified Ideographs in addition to
the minimal kanji class. Sorted in the Unicode codepoint order.

=back

=head2 Replacement of PROLONGED SOUND MARK and ITERATION MARKs

        Character    UCS
	  '�T'    U+309D  HIRAGANA ITERATION MARK
	  '�U'    U+309E  HIRAGANA VOICED ITERATION MARK
	  '�['    U+30FC  KATAKANA-HIRAGANA PROLONGED SOUND MARK
	  '�R'    U+30FD  KATAKANA ITERATION MARK
	  '�S'    U+30FE  KATAKANA VOICED ITERATION MARK

These characters, if replaced, are secondary equal to
the replacing kana, while ternary not equal to.

=over 4

=item KATAKANA-HIRAGANA PROLONGED SOUND MARK

The PROLONGED MARK is repleced to a normal vowel or nasal
katakana corresponding to the preceding kana if exists.

  eg.	'�J�['   to '�J�A'
	'�с['   to '�уC'
	'����[' to '����A'
	'�s���[' to '�s���E'
	'���['   to '����'

=item HIRAGANA- and KATAKANA ITERATION MARKs

The ITERATION MARKs (VOICELESS) are repleced
to a normal kana corresponding to the preceding kana if exists.

  eg.	'���T'   to '����'
	'�h�T'   to '�h��'
	'��T'   to '���'
	'�J�R'   to '�J�J'
	'�΁R'   to '�΃n'
	'�v�R'   to '�v�t'
	'���B�R' to '���B�C'
	'�s���T' to '�s����'

=item HIRAGANA- and KATAKANA VOICED ITERATION MARKs

The VOICED ITERATION MARKs are repleced to a voiced kana
corresponding to the preceding kana if exists.

  eg.	'�́U'   to '�͂�'
	'�v�U'   to '�v��'
	'�v�S'   to '�v�u'
	'���S'   to '���S'
	'�E�S'   to '�E��'

=item Cases of no replacement

Otherwise, no replacement occurs. Especially in the
cases when these marks follow any character except kana.

The unreplaced characters are primary greater than any kana.

  eg.	CJK Ideograph followed by PROLONGED SOUND MARK
	Digit followed by ITERATION MARK
	'�A�S' ('�A' has no voiced variant)

=item Example

For example, the Japanese string C<'�p�[��'> (C<Perl> in kana)
has three collation elements: C<KATAKANA PA>,
C<PROLONGED SOUND MARK replaced by KATAKANA A>, and C<KATAKANA RU>.

	'�p�[��' is converted to '�p�A��' by replacement.
		primary equal to '�͂���'.
		secondary equal to '�ς���', greater than '�͂���'.
		tertiary equal to '�ρ[��', lesser than '�p�A��'.
		quartenary greater than '�ρ[��'.

=back

=head2 Conformance to the Standard

    [cf. the article 6.2, JIS X 4061]

  (1) charset: Shift_JIS.

  (2) No limit of the number of characters in the string considered
      to collate.

  (3) No character class is added.

  (4) The following characters are added as collation elements.

      IDEOGRAPHIC SPACE in the space class.

      ACUTE ACCENT, GRAVE ACCENT, DIAERESIS, CIRCUMFLEX ACCENT
      in the class of descriptive symbols.

      APOSTROPHE, QUOTATION MARK in the class of parentheses.

      HYPHEN-MINUS in the class of mathematical symbols.

  (5) Collation of Latin alphabets with macron and with circumflex
      is not supported.

  (6) Kanji Classes:
       the minimal kanji class (Five kanji-like chars).
       the basic kanji class (Levels 1 and 2 kanji, JIS)..

=head1 AUTHOR

Tomoyuki SADAHIRO

Copyright (C) 2001-2002. All rights reserved.

bqw10602@nifty.com  http://homepage1.nifty.com/nomenclator/perl/

This module is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

=over 4

=item *

JIS X 4061 [Collation of Japanese character strings]

=item *

JIS X 0208 [7-bits and 8-bits double byte coded Kanji sets
for information interchange]

=item *

JIS X 0221 [Information technology - Universal Multiple-Octet Coded
Character Set (UCS) - part 1 : Architectute and Basic Multilingual Plane].
This is a translation of ISO/IEC 10646-1.

=item *

L<ShiftJIS::String>

=item *

L<ShiftJIS::Regexp>

=back

=cut
