package ShiftJIS::Collate;

use Carp;
use strict;
use vars qw($VERSION $PACKAGE @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION = '0.03';

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
'　' => "\x70\x42\x32\x14\x0a\x01",
'、' => "\x71\x41\x32\x14\x0a\x03",
'､'  => "\x71\x41\x32\x14\x0a\x04",
'。' => "\x71\x42\x32\x14\x0a\x03",
'｡'  => "\x71\x42\x32\x14\x0a\x04",
','  => "\x71\x43\x32\x14\x0a\x02",
'，' => "\x71\x43\x32\x14\x0a\x05",
'.'  => "\x71\x44\x32\x14\x0a\x02",
'．' => "\x71\x44\x32\x14\x0a\x05",
'・' => "\x71\x45\x32\x14\x0a\x03",
'･'  => "\x71\x45\x32\x14\x0a\x04",
':'  => "\x71\x46\x32\x14\x0a\x02",
'：' => "\x71\x46\x32\x14\x0a\x05",
';'  => "\x71\x47\x32\x14\x0a\x02",
'；' => "\x71\x47\x32\x14\x0a\x05",
'?'  => "\x71\x48\x32\x14\x0a\x02",
'？' => "\x71\x48\x32\x14\x0a\x05",
'!'  => "\x71\x49\x32\x14\x0a\x02",
'！' => "\x71\x49\x32\x14\x0a\x05",
'´' => "\x71\x4a\x32\x14\x0a\x01",#added
'`'  => "\x71\x4b\x32\x14\x0a\x02",#added
'｀' => "\x71\x4b\x32\x14\x0a\x05",#added
'¨' => "\x71\x4c\x32\x14\x0a\x01",#added
'^'  => "\x71\x4d\x32\x14\x0a\x02",#added
'＾' => "\x71\x4d\x32\x14\x0a\x05",#added
'~'  => "\x71\x4e\x32\x14\x0a\x02",
'￣' => "\x71\x4e\x32\x14\x0a\x05",
'_'  => "\x71\x4f\x32\x14\x0a\x02",
'＿' => "\x71\x4f\x32\x14\x0a\x05",
(qw/― /)[0]
     => "\x71\x50\x32\x14\x0a\x01",
'‐' => "\x71\x51\x32\x14\x0a\x01",
'/'  => "\x71\x52\x32\x14\x0a\x02",
'／' => "\x71\x52\x32\x14\x0a\x05",
'＼' => "\x71\x53\x32\x14\x0a\x01",
'〜' => "\x71\x54\x32\x14\x0a\x01",
'‖' => "\x71\x55\x32\x14\x0a\x01",
'|'  => "\x71\x56\x32\x14\x0a\x02",
'｜' => "\x71\x56\x32\x14\x0a\x05",
'…' => "\x71\x57\x32\x14\x0a\x01",
'‥' => "\x71\x58\x32\x14\x0a\x01",
q|‘|=> "\x72\x41\x32\x14\x0a\x01",
q|’|=> "\x72\x42\x32\x14\x0a\x01",
q|'| => "\x72\x43\x32\x14\x0a\x01",#added
q|“|=> "\x72\x44\x32\x14\x0a\x01",
q|”|=> "\x72\x45\x32\x14\x0a\x01",
q|"| => "\x72\x46\x32\x14\x0a\x01",#added
'('  => "\x72\x47\x32\x14\x0a\x02",
'（' => "\x72\x47\x32\x14\x0a\x05",
')'  => "\x72\x48\x32\x14\x0a\x02",
'）' => "\x72\x48\x32\x14\x0a\x05",
'〔' => "\x72\x49\x32\x14\x0a\x01",
'〕' => "\x72\x4a\x32\x14\x0a\x01",
'['  => "\x72\x4b\x32\x14\x0a\x02",
'［' => "\x72\x4b\x32\x14\x0a\x05",
']'  => "\x72\x4c\x32\x14\x0a\x02",
'］' => "\x72\x4c\x32\x14\x0a\x05",
'{'  => "\x72\x4d\x32\x14\x0a\x02",
'｛' => "\x72\x4d\x32\x14\x0a\x05",
'}'  => "\x72\x4e\x32\x14\x0a\x02",
'｝' => "\x72\x4e\x32\x14\x0a\x05",
'〈' => "\x72\x4f\x32\x14\x0a\x01",
'〉' => "\x72\x50\x32\x14\x0a\x01",
'《' => "\x72\x51\x32\x14\x0a\x01",
'》' => "\x72\x52\x32\x14\x0a\x01",
'「' => "\x72\x53\x32\x14\x0a\x03",
'｢'  => "\x72\x53\x32\x14\x0a\x04",
'」' => "\x72\x54\x32\x14\x0a\x03",
'｣'  => "\x72\x54\x32\x14\x0a\x04",
'『' => "\x72\x55\x32\x14\x0a\x01",
'』' => "\x72\x56\x32\x14\x0a\x01",
'【' => "\x72\x57\x32\x14\x0a\x01",
'】' => "\x72\x58\x32\x14\x0a\x01",
'+'  => "\x73\x41\x32\x14\x0a\x02",
'＋' => "\x73\x41\x32\x14\x0a\x05",
'-'  => "\x73\x42\x32\x14\x0a\x01",#added
'−' => "\x73\x43\x32\x14\x0a\x01",
'±' => "\x73\x44\x32\x14\x0a\x01",
'×' => "\x73\x45\x32\x14\x0a\x01",
'÷' => "\x73\x46\x32\x14\x0a\x01",
'='  => "\x73\x47\x32\x14\x0a\x02",
'＝' => "\x73\x47\x32\x14\x0a\x05",
'≠' => "\x73\x48\x32\x14\x0a\x01",
'<'  => "\x73\x49\x32\x14\x0a\x02",
'＜' => "\x73\x49\x32\x14\x0a\x05",
'>'  => "\x73\x4a\x32\x14\x0a\x02",
'＞' => "\x73\x4a\x32\x14\x0a\x05",
'≦' => "\x73\x4b\x32\x14\x0a\x01",
'≧' => "\x73\x4c\x32\x14\x0a\x01",
'≒' => "\x73\x4d\x32\x14\x0a\x01",
'≪' => "\x73\x4e\x32\x14\x0a\x01",
'≫' => "\x73\x4f\x32\x14\x0a\x01",
'∝' => "\x73\x50\x32\x14\x0a\x01",
'∞' => "\x73\x51\x32\x14\x0a\x01",
'∂' => "\x73\x52\x32\x14\x0a\x01",
'∇' => "\x73\x53\x32\x14\x0a\x01",
'√' => "\x73\x54\x32\x14\x0a\x01",
'∫' => "\x73\x55\x32\x14\x0a\x01",
'∬' => "\x73\x56\x32\x14\x0a\x01",
'∠' => "\x73\x57\x32\x14\x0a\x01",
'⊥' => "\x73\x58\x32\x14\x0a\x01",
'⌒' => "\x73\x59\x32\x14\x0a\x01",
'≡' => "\x73\x5a\x32\x14\x0a\x01",
'∽' => "\x73\x5b\x32\x14\x0a\x01",
'∈' => "\x73\x5c\x32\x14\x0a\x01",
'∋' => "\x73\x5d\x32\x14\x0a\x01",
'⊆' => "\x73\x5e\x32\x14\x0a\x01",
'⊇' => "\x73\x5f\x32\x14\x0a\x01",
'⊂' => "\x73\x60\x32\x14\x0a\x01",
'⊃' => "\x73\x61\x32\x14\x0a\x01",
'∪' => "\x73\x62\x32\x14\x0a\x01",
'∩' => "\x73\x63\x32\x14\x0a\x01",
'∧' => "\x73\x64\x32\x14\x0a\x01",
'∨' => "\x73\x65\x32\x14\x0a\x01",
'¬' => "\x73\x66\x32\x14\x0a\x01",
'⇒' => "\x73\x67\x32\x14\x0a\x01",
'⇔' => "\x73\x68\x32\x14\x0a\x01",
'∀' => "\x73\x69\x32\x14\x0a\x01",
'∃' => "\x73\x6a\x32\x14\x0a\x01",
'∴' => "\x73\x6b\x32\x14\x0a\x01",
'∵' => "\x73\x6c\x32\x14\x0a\x01",
'♂' => "\x73\x6d\x32\x14\x0a\x01",
'♀' => "\x73\x6e\x32\x14\x0a\x01",
'#'  => "\x74\x41\x32\x14\x0a\x02",
'＃' => "\x74\x41\x32\x14\x0a\x05",
'&'  => "\x74\x42\x32\x14\x0a\x02",
'＆' => "\x74\x42\x32\x14\x0a\x05",
'*'  => "\x74\x43\x32\x14\x0a\x02",
'＊' => "\x74\x43\x32\x14\x0a\x05",
'@'  => "\x74\x44\x32\x14\x0a\x02",
'＠' => "\x74\x44\x32\x14\x0a\x05",
'§' => "\x74\x45\x32\x14\x0a\x01",
'¶' => "\x74\x46\x32\x14\x0a\x01",
'※' => "\x74\x47\x32\x14\x0a\x01",
'†' => "\x74\x48\x32\x14\x0a\x01",
'‡' => "\x74\x49\x32\x14\x0a\x01",
'☆' => "\x74\x4a\x32\x14\x0a\x01",
'★' => "\x74\x4b\x32\x14\x0a\x01",
'○' => "\x74\x4c\x32\x14\x0a\x01",
'●' => "\x74\x4d\x32\x14\x0a\x01",
'◎' => "\x74\x4e\x32\x14\x0a\x01",
'◇' => "\x74\x4f\x32\x14\x0a\x01",
'◆' => "\x74\x50\x32\x14\x0a\x01",
'□' => "\x74\x51\x32\x14\x0a\x01",
'■' => "\x74\x52\x32\x14\x0a\x01",
'△' => "\x74\x53\x32\x14\x0a\x01",
'▲' => "\x74\x54\x32\x14\x0a\x01",
'▽' => "\x74\x55\x32\x14\x0a\x01",
'▼' => "\x74\x56\x32\x14\x0a\x01",
'〒' => "\x74\x57\x32\x14\x0a\x01",
'→' => "\x74\x58\x32\x14\x0a\x01",
'←' => "\x74\x59\x32\x14\x0a\x01",
'↑' => "\x74\x5a\x32\x14\x0a\x01",
'↓' => "\x74\x5b\x32\x14\x0a\x01",
'♯' => "\x74\x5c\x32\x14\x0a\x01",
'♭' => "\x74\x5d\x32\x14\x0a\x01",
'♪' => "\x74\x5e\x32\x14\x0a\x01",
'°' => "\x75\x41\x32\x14\x0a\x01",
'′' => "\x75\x42\x32\x14\x0a\x01",
'″' => "\x75\x43\x32\x14\x0a\x01",
'℃' => "\x75\x44\x32\x14\x0a\x01",
'\\' => "\x75\x45\x32\x14\x0a\x02",
'￥' => "\x75\x45\x32\x14\x0a\x05",
'$'  => "\x75\x46\x32\x14\x0a\x02",
'＄' => "\x75\x46\x32\x14\x0a\x05",
'¢' => "\x75\x47\x32\x14\x0a\x01",
'£' => "\x75\x48\x32\x14\x0a\x01",
'%'  => "\x75\x49\x32\x14\x0a\x02",
'％' => "\x75\x49\x32\x14\x0a\x05",
'‰' => "\x75\x4a\x32\x14\x0a\x01",
'Å' => "\x75\x4b\x32\x14\x0a\x01",
'0'  => "\x76\x41\x32\x14\x0a\x02",
'０' => "\x76\x41\x32\x14\x0a\x05",
'1'  => "\x76\x42\x32\x14\x0a\x02",
'１' => "\x76\x42\x32\x14\x0a\x05",
'2'  => "\x76\x43\x32\x14\x0a\x02",
'２' => "\x76\x43\x32\x14\x0a\x05",
'3'  => "\x76\x44\x32\x14\x0a\x02",
'３' => "\x76\x44\x32\x14\x0a\x05",
'4'  => "\x76\x45\x32\x14\x0a\x02",
'４' => "\x76\x45\x32\x14\x0a\x05",
'5'  => "\x76\x46\x32\x14\x0a\x02",
'５' => "\x76\x46\x32\x14\x0a\x05",
'6'  => "\x76\x47\x32\x14\x0a\x02",
'６' => "\x76\x47\x32\x14\x0a\x05",
'7'  => "\x76\x48\x32\x14\x0a\x02",
'７' => "\x76\x48\x32\x14\x0a\x05",
'8'  => "\x76\x49\x32\x14\x0a\x02",
'８' => "\x76\x49\x32\x14\x0a\x05",
'9'  => "\x76\x4a\x32\x14\x0a\x02",
'９' => "\x76\x4a\x32\x14\x0a\x05",
'α' => "\x77\x41\x32\x14\x0a\x01",
'β' => "\x77\x42\x32\x14\x0a\x01",
'γ' => "\x77\x43\x32\x14\x0a\x01",
'δ' => "\x77\x44\x32\x14\x0a\x01",
'ε' => "\x77\x45\x32\x14\x0a\x01",
'ζ' => "\x77\x46\x32\x14\x0a\x01",
'η' => "\x77\x47\x32\x14\x0a\x01",
'θ' => "\x77\x48\x32\x14\x0a\x01",
'ι' => "\x77\x49\x32\x14\x0a\x01",
'κ' => "\x77\x4a\x32\x14\x0a\x01",
'λ' => "\x77\x4b\x32\x14\x0a\x01",
'μ' => "\x77\x4c\x32\x14\x0a\x01",
'ν' => "\x77\x4d\x32\x14\x0a\x01",
'ξ' => "\x77\x4e\x32\x14\x0a\x01",
'ο' => "\x77\x4f\x32\x14\x0a\x01",
'π' => "\x77\x50\x32\x14\x0a\x01",
'ρ' => "\x77\x51\x32\x14\x0a\x01",
'σ' => "\x77\x52\x32\x14\x0a\x01",
'τ' => "\x77\x53\x32\x14\x0a\x01",
'υ' => "\x77\x54\x32\x14\x0a\x01",
'φ' => "\x77\x55\x32\x14\x0a\x01",
'χ' => "\x77\x56\x32\x14\x0a\x01",
'ψ' => "\x77\x57\x32\x14\x0a\x01",
'ω' => "\x77\x58\x32\x14\x0a\x01",
'Α' => "\x77\x61\x32\x14\x0a\x01",
'Β' => "\x77\x62\x32\x14\x0a\x01",
'Γ' => "\x77\x63\x32\x14\x0a\x01",
'Δ' => "\x77\x64\x32\x14\x0a\x01",
'Ε' => "\x77\x65\x32\x14\x0a\x01",
'Ζ' => "\x77\x66\x32\x14\x0a\x01",
'Η' => "\x77\x67\x32\x14\x0a\x01",
'Θ' => "\x77\x68\x32\x14\x0a\x01",
'Ι' => "\x77\x69\x32\x14\x0a\x01",
'Κ' => "\x77\x6a\x32\x14\x0a\x01",
'Λ' => "\x77\x6b\x32\x14\x0a\x01",
'Μ' => "\x77\x6c\x32\x14\x0a\x01",
'Ν' => "\x77\x6d\x32\x14\x0a\x01",
'Ξ' => "\x77\x6e\x32\x14\x0a\x01",
'Ο' => "\x77\x6f\x32\x14\x0a\x01",
'Π' => "\x77\x70\x32\x14\x0a\x01",
'Ρ' => "\x77\x71\x32\x14\x0a\x01",
'Σ' => "\x77\x72\x32\x14\x0a\x01",
'Τ' => "\x77\x73\x32\x14\x0a\x01",
'Υ' => "\x77\x74\x32\x14\x0a\x01",
'Φ' => "\x77\x75\x32\x14\x0a\x01",
'Χ' => "\x77\x76\x32\x14\x0a\x01",
'Ψ' => "\x77\x77\x32\x14\x0a\x01",
'Ω' => "\x77\x78\x32\x14\x0a\x01",
'а' => "\x77\x81\x32\x14\x0a\x01",
'б' => "\x77\x82\x32\x14\x0a\x01",
'в' => "\x77\x83\x32\x14\x0a\x01",
'г' => "\x77\x84\x32\x14\x0a\x01",
'д' => "\x77\x85\x32\x14\x0a\x01",
'е' => "\x77\x86\x32\x14\x0a\x01",
'ё' => "\x77\x87\x32\x14\x0a\x01",
'ж' => "\x77\x88\x32\x14\x0a\x01",
'з' => "\x77\x89\x32\x14\x0a\x01",
'и' => "\x77\x8a\x32\x14\x0a\x01",
'й' => "\x77\x8b\x32\x14\x0a\x01",
'к' => "\x77\x8c\x32\x14\x0a\x01",
'л' => "\x77\x8d\x32\x14\x0a\x01",
'м' => "\x77\x8e\x32\x14\x0a\x01",
'н' => "\x77\x8f\x32\x14\x0a\x01",
'о' => "\x77\x90\x32\x14\x0a\x01",
'п' => "\x77\x91\x32\x14\x0a\x01",
'р' => "\x77\x92\x32\x14\x0a\x01",
'с' => "\x77\x93\x32\x14\x0a\x01",
'т' => "\x77\x94\x32\x14\x0a\x01",
'у' => "\x77\x95\x32\x14\x0a\x01",
'ф' => "\x77\x96\x32\x14\x0a\x01",
'х' => "\x77\x97\x32\x14\x0a\x01",
'ц' => "\x77\x98\x32\x14\x0a\x01",
'ч' => "\x77\x99\x32\x14\x0a\x01",
'ш' => "\x77\x9a\x32\x14\x0a\x01",
'щ' => "\x77\x9b\x32\x14\x0a\x01",
'ъ' => "\x77\x9c\x32\x14\x0a\x01",
'ы' => "\x77\x9d\x32\x14\x0a\x01",
'ь' => "\x77\x9e\x32\x14\x0a\x01",
'э' => "\x77\x9f\x32\x14\x0a\x01",
'ю' => "\x77\xa0\x32\x14\x0a\x01",
'я' => "\x77\xa1\x32\x14\x0a\x01",
'А' => "\x77\xb1\x32\x14\x0a\x01",
'Б' => "\x77\xb2\x32\x14\x0a\x01",
'В' => "\x77\xb3\x32\x14\x0a\x01",
'Г' => "\x77\xb4\x32\x14\x0a\x01",
'Д' => "\x77\xb5\x32\x14\x0a\x01",
'Е' => "\x77\xb6\x32\x14\x0a\x01",
'Ё' => "\x77\xb7\x32\x14\x0a\x01",
'Ж' => "\x77\xb8\x32\x14\x0a\x01",
'З' => "\x77\xb9\x32\x14\x0a\x01",
'И' => "\x77\xba\x32\x14\x0a\x01",
'Й' => "\x77\xbb\x32\x14\x0a\x01",
'К' => "\x77\xbc\x32\x14\x0a\x01",
'Л' => "\x77\xbd\x32\x14\x0a\x01",
'М' => "\x77\xbe\x32\x14\x0a\x01",
'Н' => "\x77\xbf\x32\x14\x0a\x01",
'О' => "\x77\xc0\x32\x14\x0a\x01",
'П' => "\x77\xc1\x32\x14\x0a\x01",
'Р' => "\x77\xc2\x32\x14\x0a\x01",
'С' => "\x77\xc3\x32\x14\x0a\x01",
'Т' => "\x77\xc4\x32\x14\x0a\x01",
'У' => "\x77\xc5\x32\x14\x0a\x01",
'Ф' => "\x77\xc6\x32\x14\x0a\x01",
'Х' => "\x77\xc7\x32\x14\x0a\x01",
'Ц' => "\x77\xc8\x32\x14\x0a\x01",
'Ч' => "\x77\xc9\x32\x14\x0a\x01",
'Ш' => "\x77\xca\x32\x14\x0a\x01",
'Щ' => "\x77\xcb\x32\x14\x0a\x01",
'Ъ' => "\x77\xcc\x32\x14\x0a\x01",
(qw/Ы /)[0]
     => "\x77\xcd\x32\x14\x0a\x01",
'Ь' => "\x77\xce\x32\x14\x0a\x01",
'Э' => "\x77\xcf\x32\x14\x0a\x01",
'Ю' => "\x77\xd0\x32\x14\x0a\x01",
'Я' => "\x77\xd1\x32\x14\x0a\x01",
'a'  => "\x78\x41\x33\x15\x0a\x02",
'ａ' => "\x78\x41\x33\x15\x0a\x05",
'A'  => "\x78\x41\x33\x16\x0a\x02",
'Ａ' => "\x78\x41\x33\x16\x0a\x05",
'b'  => "\x78\x42\x33\x15\x0a\x02",
'ｂ' => "\x78\x42\x33\x15\x0a\x05",
'B'  => "\x78\x42\x33\x16\x0a\x02",
'Ｂ' => "\x78\x42\x33\x16\x0a\x05",
'c'  => "\x78\x43\x33\x15\x0a\x02",
'ｃ' => "\x78\x43\x33\x15\x0a\x05",
'C'  => "\x78\x43\x33\x16\x0a\x02",
'Ｃ' => "\x78\x43\x33\x16\x0a\x05",
'd'  => "\x78\x44\x33\x15\x0a\x02",
'ｄ' => "\x78\x44\x33\x15\x0a\x05",
'D'  => "\x78\x44\x33\x16\x0a\x02",
'Ｄ' => "\x78\x44\x33\x16\x0a\x05",
'e'  => "\x78\x45\x33\x15\x0a\x02",
'ｅ' => "\x78\x45\x33\x15\x0a\x05",
'E'  => "\x78\x45\x33\x16\x0a\x02",
'Ｅ' => "\x78\x45\x33\x16\x0a\x05",
'f'  => "\x78\x46\x33\x15\x0a\x02",
'ｆ' => "\x78\x46\x33\x15\x0a\x05",
'F'  => "\x78\x46\x33\x16\x0a\x02",
'Ｆ' => "\x78\x46\x33\x16\x0a\x05",
'g'  => "\x78\x47\x33\x15\x0a\x02",
'ｇ' => "\x78\x47\x33\x15\x0a\x05",
'G'  => "\x78\x47\x33\x16\x0a\x02",
'Ｇ' => "\x78\x47\x33\x16\x0a\x05",
'h'  => "\x78\x48\x33\x15\x0a\x02",
'ｈ' => "\x78\x48\x33\x15\x0a\x05",
'H'  => "\x78\x48\x33\x16\x0a\x02",
'Ｈ' => "\x78\x48\x33\x16\x0a\x05",
'i'  => "\x78\x49\x33\x15\x0a\x02",
'ｉ' => "\x78\x49\x33\x15\x0a\x05",
'I'  => "\x78\x49\x33\x16\x0a\x02",
'Ｉ' => "\x78\x49\x33\x16\x0a\x05",
'j'  => "\x78\x4a\x33\x15\x0a\x02",
'ｊ' => "\x78\x4a\x33\x15\x0a\x05",
'J'  => "\x78\x4a\x33\x16\x0a\x02",
'Ｊ' => "\x78\x4a\x33\x16\x0a\x05",
'k'  => "\x78\x4b\x33\x15\x0a\x02",
'ｋ' => "\x78\x4b\x33\x15\x0a\x05",
'K'  => "\x78\x4b\x33\x16\x0a\x02",
'Ｋ' => "\x78\x4b\x33\x16\x0a\x05",
'l'  => "\x78\x4c\x33\x15\x0a\x02",
'ｌ' => "\x78\x4c\x33\x15\x0a\x05",
'L'  => "\x78\x4c\x33\x16\x0a\x02",
'Ｌ' => "\x78\x4c\x33\x16\x0a\x05",
'm'  => "\x78\x4d\x33\x15\x0a\x02",
'ｍ' => "\x78\x4d\x33\x15\x0a\x05",
'M'  => "\x78\x4d\x33\x16\x0a\x02",
'Ｍ' => "\x78\x4d\x33\x16\x0a\x05",
'n'  => "\x78\x4e\x33\x15\x0a\x02",
'ｎ' => "\x78\x4e\x33\x15\x0a\x05",
'N'  => "\x78\x4e\x33\x16\x0a\x02",
'Ｎ' => "\x78\x4e\x33\x16\x0a\x05",
'o'  => "\x78\x4f\x33\x15\x0a\x02",
'ｏ' => "\x78\x4f\x33\x15\x0a\x05",
'O'  => "\x78\x4f\x33\x16\x0a\x02",
'Ｏ' => "\x78\x4f\x33\x16\x0a\x05",
'p'  => "\x78\x50\x33\x15\x0a\x02",
'ｐ' => "\x78\x50\x33\x15\x0a\x05",
'P'  => "\x78\x50\x33\x16\x0a\x02",
'Ｐ' => "\x78\x50\x33\x16\x0a\x05",
'q'  => "\x78\x51\x33\x15\x0a\x02",
'ｑ' => "\x78\x51\x33\x15\x0a\x05",
'Q'  => "\x78\x51\x33\x16\x0a\x02",
'Ｑ' => "\x78\x51\x33\x16\x0a\x05",
'r'  => "\x78\x52\x33\x15\x0a\x02",
'ｒ' => "\x78\x52\x33\x15\x0a\x05",
'R'  => "\x78\x52\x33\x16\x0a\x02",
'Ｒ' => "\x78\x52\x33\x16\x0a\x05",
's'  => "\x78\x53\x33\x15\x0a\x02",
'ｓ' => "\x78\x53\x33\x15\x0a\x05",
'S'  => "\x78\x53\x33\x16\x0a\x02",
'Ｓ' => "\x78\x53\x33\x16\x0a\x05",
't'  => "\x78\x54\x33\x15\x0a\x02",
'ｔ' => "\x78\x54\x33\x15\x0a\x05",
'T'  => "\x78\x54\x33\x16\x0a\x02",
'Ｔ' => "\x78\x54\x33\x16\x0a\x05",
'u'  => "\x78\x55\x33\x15\x0a\x02",
'ｕ' => "\x78\x55\x33\x15\x0a\x05",
'U'  => "\x78\x55\x33\x16\x0a\x02",
'Ｕ' => "\x78\x55\x33\x16\x0a\x05",
'v'  => "\x78\x56\x33\x15\x0a\x02",
'ｖ' => "\x78\x56\x33\x15\x0a\x05",
'V'  => "\x78\x56\x33\x16\x0a\x02",
'Ｖ' => "\x78\x56\x33\x16\x0a\x05",
'w'  => "\x78\x57\x33\x15\x0a\x02",
'ｗ' => "\x78\x57\x33\x15\x0a\x05",
'W'  => "\x78\x57\x33\x16\x0a\x02",
'Ｗ' => "\x78\x57\x33\x16\x0a\x05",
'x'  => "\x78\x58\x33\x15\x0a\x02",
'ｘ' => "\x78\x58\x33\x15\x0a\x05",
'X'  => "\x78\x58\x33\x16\x0a\x02",
'Ｘ' => "\x78\x58\x33\x16\x0a\x05",
'y'  => "\x78\x59\x33\x15\x0a\x02",
'ｙ' => "\x78\x59\x33\x15\x0a\x05",
'Y'  => "\x78\x59\x33\x16\x0a\x02",
'Ｙ' => "\x78\x59\x33\x16\x0a\x05",
'z'  => "\x78\x5a\x33\x15\x0a\x02",
'ｚ' => "\x78\x5a\x33\x15\x0a\x05",
'Z'  => "\x78\x5a\x33\x16\x0a\x02",
'Ｚ' => "\x78\x5a\x33\x16\x0a\x05",
'ぁ' => "\x79\x41\x34\x1b\x10\x03",
'ァ' => "\x79\x41\x34\x1b\x11\x03",
'ｧ'  => "\x79\x41\x34\x1b\x11\x04",
'あ' => "\x79\x41\x34\x1d\x10\x03",
'ア' => "\x79\x41\x34\x1d\x11\x03",
'ｱ'  => "\x79\x41\x34\x1d\x11\x04",
'ぃ' => "\x79\x42\x34\x1b\x10\x03",
'ィ' => "\x79\x42\x34\x1b\x11\x03",
'ｨ'  => "\x79\x42\x34\x1b\x11\x04",
'い' => "\x79\x42\x34\x1d\x10\x03",
'イ' => "\x79\x42\x34\x1d\x11\x03",
'ｲ'  => "\x79\x42\x34\x1d\x11\x04",
'ぅ' => "\x79\x43\x34\x1b\x10\x03",
'ゥ' => "\x79\x43\x34\x1b\x11\x03",
'ｩ'  => "\x79\x43\x34\x1b\x11\x04",
'う' => "\x79\x43\x34\x1d\x10\x03",
'ウ' => "\x79\x43\x34\x1d\x11\x03",
'ｳ'  => "\x79\x43\x34\x1d\x11\x04",
'ヴ' => "\x79\x43\x35\x1d\x11\x03",
'ｳﾞ' => "\x79\x43\x35\x1d\x11\x04",
'ぇ' => "\x79\x44\x34\x1b\x10\x03",
'ェ' => "\x79\x44\x34\x1b\x11\x03",
'ｪ'  => "\x79\x44\x34\x1b\x11\x04",
'え' => "\x79\x44\x34\x1d\x10\x03",
'エ' => "\x79\x44\x34\x1d\x11\x03",
'ｴ'  => "\x79\x44\x34\x1d\x11\x04",
'ぉ' => "\x79\x45\x34\x1b\x10\x03",
'ォ' => "\x79\x45\x34\x1b\x11\x03",
'ｫ'  => "\x79\x45\x34\x1b\x11\x04",
'お' => "\x79\x45\x34\x1d\x10\x03",
'オ' => "\x79\x45\x34\x1d\x11\x03",
'ｵ'  => "\x79\x45\x34\x1d\x11\x04",
'ヵ' => "\x79\x51\x34\x1b\x11\x03",
'か' => "\x79\x51\x34\x1d\x10\x03",
'カ' => "\x79\x51\x34\x1d\x11\x03",
'ｶ'  => "\x79\x51\x34\x1d\x11\x04",
'が' => "\x79\x51\x35\x1d\x10\x03",
'ガ' => "\x79\x51\x35\x1d\x11\x03",
'ｶﾞ' => "\x79\x51\x35\x1d\x11\x04",
'き' => "\x79\x52\x34\x1d\x10\x03",
'キ' => "\x79\x52\x34\x1d\x11\x03",
'ｷ'  => "\x79\x52\x34\x1d\x11\x04",
'ぎ' => "\x79\x52\x35\x1d\x10\x03",
'ギ' => "\x79\x52\x35\x1d\x11\x03",
'ｷﾞ' => "\x79\x52\x35\x1d\x11\x04",
'く' => "\x79\x53\x34\x1d\x10\x03",
'ク' => "\x79\x53\x34\x1d\x11\x03",
'ｸ'  => "\x79\x53\x34\x1d\x11\x04",
'ぐ' => "\x79\x53\x35\x1d\x10\x03",
'グ' => "\x79\x53\x35\x1d\x11\x03",
'ｸﾞ' => "\x79\x53\x35\x1d\x11\x04",
'ヶ' => "\x79\x54\x34\x1b\x11\x03",
'け' => "\x79\x54\x34\x1d\x10\x03",
'ケ' => "\x79\x54\x34\x1d\x11\x03",
'ｹ'  => "\x79\x54\x34\x1d\x11\x04",
'げ' => "\x79\x54\x35\x1d\x10\x03",
'ゲ' => "\x79\x54\x35\x1d\x11\x03",
'ｹﾞ' => "\x79\x54\x35\x1d\x11\x04",
'こ' => "\x79\x55\x34\x1d\x10\x03",
'コ' => "\x79\x55\x34\x1d\x11\x03",
'ｺ'  => "\x79\x55\x34\x1d\x11\x04",
'ご' => "\x79\x55\x35\x1d\x10\x03",
'ゴ' => "\x79\x55\x35\x1d\x11\x03",
'ｺﾞ' => "\x79\x55\x35\x1d\x11\x04",
'さ' => "\x79\x61\x34\x1d\x10\x03",
'サ' => "\x79\x61\x34\x1d\x11\x03",
'ｻ'  => "\x79\x61\x34\x1d\x11\x04",
'ざ' => "\x79\x61\x35\x1d\x10\x03",
'ザ' => "\x79\x61\x35\x1d\x11\x03",
'ｻﾞ' => "\x79\x61\x35\x1d\x11\x04",
'し' => "\x79\x62\x34\x1d\x10\x03",
'シ' => "\x79\x62\x34\x1d\x11\x03",
'ｼ'  => "\x79\x62\x34\x1d\x11\x04",
'じ' => "\x79\x62\x35\x1d\x10\x03",
'ジ' => "\x79\x62\x35\x1d\x11\x03",
'ｼﾞ' => "\x79\x62\x35\x1d\x11\x04",
'す' => "\x79\x63\x34\x1d\x10\x03",
'ス' => "\x79\x63\x34\x1d\x11\x03",
'ｽ'  => "\x79\x63\x34\x1d\x11\x04",
'ず' => "\x79\x63\x35\x1d\x10\x03",
'ズ' => "\x79\x63\x35\x1d\x11\x03",
'ｽﾞ' => "\x79\x63\x35\x1d\x11\x04",
'せ' => "\x79\x64\x34\x1d\x10\x03",
'セ' => "\x79\x64\x34\x1d\x11\x03",
'ｾ'  => "\x79\x64\x34\x1d\x11\x04",
'ぜ' => "\x79\x64\x35\x1d\x10\x03",
'ゼ' => "\x79\x64\x35\x1d\x11\x03",
'ｾﾞ' => "\x79\x64\x35\x1d\x11\x04",
'そ' => "\x79\x65\x34\x1d\x10\x03",
(qw/ソ /)[0]
     => "\x79\x65\x34\x1d\x11\x03",
'ｿ'  => "\x79\x65\x34\x1d\x11\x04",
'ぞ' => "\x79\x65\x35\x1d\x10\x03",
'ゾ' => "\x79\x65\x35\x1d\x11\x03",
'ｿﾞ' => "\x79\x65\x35\x1d\x11\x04",
'た' => "\x79\x71\x34\x1d\x10\x03",
'タ' => "\x79\x71\x34\x1d\x11\x03",
'ﾀ'  => "\x79\x71\x34\x1d\x11\x04",
'だ' => "\x79\x71\x35\x1d\x10\x03",
'ダ' => "\x79\x71\x35\x1d\x11\x03",
'ﾀﾞ' => "\x79\x71\x35\x1d\x11\x04",
'ち' => "\x79\x72\x34\x1d\x10\x03",
'チ' => "\x79\x72\x34\x1d\x11\x03",
'ﾁ'  => "\x79\x72\x34\x1d\x11\x04",
'ぢ' => "\x79\x72\x35\x1d\x10\x03",
'ヂ' => "\x79\x72\x35\x1d\x11\x03",
'ﾁﾞ' => "\x79\x72\x35\x1d\x11\x04",
'っ' => "\x79\x73\x34\x1b\x10\x03",
'ッ' => "\x79\x73\x34\x1b\x11\x03",
'ｯ'  => "\x79\x73\x34\x1b\x11\x04",
'つ' => "\x79\x73\x34\x1d\x10\x03",
'ツ' => "\x79\x73\x34\x1d\x11\x03",
'ﾂ'  => "\x79\x73\x34\x1d\x11\x04",
'づ' => "\x79\x73\x35\x1d\x10\x03",
'ヅ' => "\x79\x73\x35\x1d\x11\x03",
'ﾂﾞ' => "\x79\x73\x35\x1d\x11\x04",
'て' => "\x79\x74\x34\x1d\x10\x03",
'テ' => "\x79\x74\x34\x1d\x11\x03",
'ﾃ'  => "\x79\x74\x34\x1d\x11\x04",
'で' => "\x79\x74\x35\x1d\x10\x03",
'デ' => "\x79\x74\x35\x1d\x11\x03",
'ﾃﾞ' => "\x79\x74\x35\x1d\x11\x04",
'と' => "\x79\x75\x34\x1d\x10\x03",
'ト' => "\x79\x75\x34\x1d\x11\x03",
'ﾄ'  => "\x79\x75\x34\x1d\x11\x04",
'ど' => "\x79\x75\x35\x1d\x10\x03",
'ド' => "\x79\x75\x35\x1d\x11\x03",
'ﾄﾞ' => "\x79\x75\x35\x1d\x11\x04",
'な' => "\x79\x81\x34\x1d\x10\x03",
'ナ' => "\x79\x81\x34\x1d\x11\x03",
'ﾅ'  => "\x79\x81\x34\x1d\x11\x04",
'に' => "\x79\x82\x34\x1d\x10\x03",
'ニ' => "\x79\x82\x34\x1d\x11\x03",
'ﾆ'  => "\x79\x82\x34\x1d\x11\x04",
'ぬ' => "\x79\x83\x34\x1d\x10\x03",
'ヌ' => "\x79\x83\x34\x1d\x11\x03",
'ﾇ'  => "\x79\x83\x34\x1d\x11\x04",
'ね' => "\x79\x84\x34\x1d\x10\x03",
'ネ' => "\x79\x84\x34\x1d\x11\x03",
'ﾈ'  => "\x79\x84\x34\x1d\x11\x04",
'の' => "\x79\x85\x34\x1d\x10\x03",
'ノ' => "\x79\x85\x34\x1d\x11\x03",
'ﾉ'  => "\x79\x85\x34\x1d\x11\x04",
'は' => "\x79\x91\x34\x1d\x10\x03",
'ハ' => "\x79\x91\x34\x1d\x11\x03",
'ﾊ'  => "\x79\x91\x34\x1d\x11\x04",
'ば' => "\x79\x91\x35\x1d\x10\x03",
'バ' => "\x79\x91\x35\x1d\x11\x03",
'ﾊﾞ' => "\x79\x91\x35\x1d\x11\x04",
'ぱ' => "\x79\x91\x36\x1d\x10\x03",
'パ' => "\x79\x91\x36\x1d\x11\x03",
'ﾊﾟ' => "\x79\x91\x36\x1d\x11\x04",
'ひ' => "\x79\x92\x34\x1d\x10\x03",
'ヒ' => "\x79\x92\x34\x1d\x11\x03",
'ﾋ'  => "\x79\x92\x34\x1d\x11\x04",
'び' => "\x79\x92\x35\x1d\x10\x03",
'ビ' => "\x79\x92\x35\x1d\x11\x03",
'ﾋﾞ' => "\x79\x92\x35\x1d\x11\x04",
'ぴ' => "\x79\x92\x36\x1d\x10\x03",
'ピ' => "\x79\x92\x36\x1d\x11\x03",
'ﾋﾟ' => "\x79\x92\x36\x1d\x11\x04",
'ふ' => "\x79\x93\x34\x1d\x10\x03",
'フ' => "\x79\x93\x34\x1d\x11\x03",
'ﾌ'  => "\x79\x93\x34\x1d\x11\x04",
'ぶ' => "\x79\x93\x35\x1d\x10\x03",
'ブ' => "\x79\x93\x35\x1d\x11\x03",
'ﾌﾞ' => "\x79\x93\x35\x1d\x11\x04",
'ぷ' => "\x79\x93\x36\x1d\x10\x03",
'プ' => "\x79\x93\x36\x1d\x11\x03",
'ﾌﾟ' => "\x79\x93\x36\x1d\x11\x04",
'へ' => "\x79\x94\x34\x1d\x10\x03",
'ヘ' => "\x79\x94\x34\x1d\x11\x03",
'ﾍ'  => "\x79\x94\x34\x1d\x11\x04",
'べ' => "\x79\x94\x35\x1d\x10\x03",
'ベ' => "\x79\x94\x35\x1d\x11\x03",
'ﾍﾞ' => "\x79\x94\x35\x1d\x11\x04",
'ぺ' => "\x79\x94\x36\x1d\x10\x03",
'ペ' => "\x79\x94\x36\x1d\x11\x03",
'ﾍﾟ' => "\x79\x94\x36\x1d\x11\x04",
'ほ' => "\x79\x95\x34\x1d\x10\x03",
'ホ' => "\x79\x95\x34\x1d\x11\x03",
'ﾎ'  => "\x79\x95\x34\x1d\x11\x04",
'ぼ' => "\x79\x95\x35\x1d\x10\x03",
'ボ' => "\x79\x95\x35\x1d\x11\x03",
'ﾎﾞ' => "\x79\x95\x35\x1d\x11\x04",
'ぽ' => "\x79\x95\x36\x1d\x10\x03",
'ポ' => "\x79\x95\x36\x1d\x11\x03",
'ﾎﾟ' => "\x79\x95\x36\x1d\x11\x04",
'ま' => "\x79\xa1\x34\x1d\x10\x03",
'マ' => "\x79\xa1\x34\x1d\x11\x03",
'ﾏ'  => "\x79\xa1\x34\x1d\x11\x04",
'み' => "\x79\xa2\x34\x1d\x10\x03",
'ミ' => "\x79\xa2\x34\x1d\x11\x03",
'ﾐ'  => "\x79\xa2\x34\x1d\x11\x04",
'む' => "\x79\xa3\x34\x1d\x10\x03",
'ム' => "\x79\xa3\x34\x1d\x11\x03",
'ﾑ'  => "\x79\xa3\x34\x1d\x11\x04",
'め' => "\x79\xa4\x34\x1d\x10\x03",
'メ' => "\x79\xa4\x34\x1d\x11\x03",
'ﾒ'  => "\x79\xa4\x34\x1d\x11\x04",
'も' => "\x79\xa5\x34\x1d\x10\x03",
'モ' => "\x79\xa5\x34\x1d\x11\x03",
'ﾓ'  => "\x79\xa5\x34\x1d\x11\x04",
'ゃ' => "\x79\xb1\x34\x1b\x10\x03",
'ャ' => "\x79\xb1\x34\x1b\x11\x03",
'ｬ'  => "\x79\xb1\x34\x1b\x11\x04",
'や' => "\x79\xb1\x34\x1d\x10\x03",
'ヤ' => "\x79\xb1\x34\x1d\x11\x03",
'ﾔ'  => "\x79\xb1\x34\x1d\x11\x04",
'ゅ' => "\x79\xb3\x34\x1b\x10\x03",
'ュ' => "\x79\xb3\x34\x1b\x11\x03",
'ｭ'  => "\x79\xb3\x34\x1b\x11\x04",
'ゆ' => "\x79\xb3\x34\x1d\x10\x03",
'ユ' => "\x79\xb3\x34\x1d\x11\x03",
'ﾕ'  => "\x79\xb3\x34\x1d\x11\x04",
'ょ' => "\x79\xb5\x34\x1b\x10\x03",
'ョ' => "\x79\xb5\x34\x1b\x11\x03",
'ｮ'  => "\x79\xb5\x34\x1b\x11\x04",
'よ' => "\x79\xb5\x34\x1d\x10\x03",
'ヨ' => "\x79\xb5\x34\x1d\x11\x03",
'ﾖ'  => "\x79\xb5\x34\x1d\x11\x04",
'ら' => "\x79\xc1\x34\x1d\x10\x03",
'ラ' => "\x79\xc1\x34\x1d\x11\x03",
'ﾗ'  => "\x79\xc1\x34\x1d\x11\x04",
'り' => "\x79\xc2\x34\x1d\x10\x03",
'リ' => "\x79\xc2\x34\x1d\x11\x03",
'ﾘ'  => "\x79\xc2\x34\x1d\x11\x04",
'る' => "\x79\xc3\x34\x1d\x10\x03",
'ル' => "\x79\xc3\x34\x1d\x11\x03",
'ﾙ'  => "\x79\xc3\x34\x1d\x11\x04",
'れ' => "\x79\xc4\x34\x1d\x10\x03",
'レ' => "\x79\xc4\x34\x1d\x11\x03",
'ﾚ'  => "\x79\xc4\x34\x1d\x11\x04",
'ろ' => "\x79\xc5\x34\x1d\x10\x03",
'ロ' => "\x79\xc5\x34\x1d\x11\x03",
'ﾛ'  => "\x79\xc5\x34\x1d\x11\x04",
'ゎ' => "\x79\xd1\x34\x1b\x10\x03",
'ヮ' => "\x79\xd1\x34\x1b\x11\x03",
'わ' => "\x79\xd1\x34\x1d\x10\x03",
'ワ' => "\x79\xd1\x34\x1d\x11\x03",
'ﾜ'  => "\x79\xd1\x34\x1d\x11\x04",
'ゐ' => "\x79\xd2\x34\x1d\x10\x03",
'ヰ' => "\x79\xd2\x34\x1d\x11\x03",
'ゑ' => "\x79\xd4\x34\x1d\x10\x03",
'ヱ' => "\x79\xd4\x34\x1d\x11\x03",
'を' => "\x79\xd5\x34\x1d\x10\x03",
'ヲ' => "\x79\xd5\x34\x1d\x11\x03",
'ｦ'  => "\x79\xd5\x34\x1d\x11\x04",
'ん' => "\x79\xd6\x34\x1d\x10\x03",
'ン' => "\x79\xd6\x34\x1d\x11\x03",
'ﾝ'  => "\x79\xd6\x34\x1d\x11\x04",
'ゝ' => "\x79\xd7\x34\x1c\x10\x03",
'ヽ' => "\x79\xd7\x34\x1c\x11\x03",
'ゞ' => "\x79\xd7\x35\x1c\x10\x03",
'ヾ' => "\x79\xd7\x35\x1c\x11\x03",
'ー' => "\x79\xd8\x34\x1a\x11\x03",
'ｰ'  => "\x79\xd8\x34\x1a\x11\x04",
'〃' => "\x7a\x41\x32\x14\x0a\x01",
'々' => "\x7a\x42\x32\x14\x0a\x01",
'仝' => "\x7a\x43\x32\x14\x0a\x01",
'〆' => "\x7a\x44\x32\x14\x0a\x01",
'〇' => "\x7a\x45\x32\x14\x0a\x01",
'〓' => "\xfe\xfc\x32\x14\x0a\x01",
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
my @Replaced = qw( ー  ｰ  ゝ  ヽ  ゞ  ヾ );
@Replaced{@Replaced} = (1) x @Replaced;

sub _hasDakuHiragana($) {
  $_[0] =~ /^\x79[\x51-\x55\x61-\x65\x71-\x75\x91-\x95]/;
}

sub _hasDakuKatakana($) {
  $_[0] =~ /^\x79[\x43\x51-\x55\x61-\x65\x71-\x75\x91-\x95]/;
}

sub _replaced($$)
{
  my $c = shift; # current element
  my $p = unpack('n', shift); # weight at the 1st level of the previous element
  return unless 0x7941 <= $p && $p <= 0x79d6;

  my $d = $p % 16; # dan : a-i-u-e-o or others
  my $n = pack('n', $p);
  return 
    $c eq 'ー' ? "\x79".chr($d == 6 ? 0xd6 : 0x40 + $d)."\x34\x1a\x11\x03" :
    $c eq 'ｰ'  ? "\x79".chr($d == 6 ? 0xd6 : 0x40 + $d)."\x34\x1a\x11\x04" :
    $c eq 'ゝ'                         ? "$n\x34\x1c\x10\x03" :
    $c eq 'ヽ'                         ? "$n\x34\x1c\x11\x03" :
    $c eq 'ゞ' && _hasDakuHiragana($n) ? "$n\x35\x1c\x10\x03" :
    $c eq 'ヾ' && _hasDakuKatakana($n) ? "$n\x35\x1c\x11\x03" :
    undef;
}

sub _length{
  my $str = shift;
  0 + $str =~ s/[\x81-\x9F\xE0-\xFC][\x00-\xFF]|[\x00-\xFF]//g;
}

sub getWtCJK
{
  my $self = shift;
  my $c    = shift;
  if($self->{kanji} == 3) {
    my $u = &{ $self->{tounicode} }($c);
    croak "A passed codepoint of kanji is outside CJK Unified Ideographs"
	unless 0x4E00 <= $u && $u <= 0x9FFF;
    my $d = $u - 0x4E00;
    chr(int($d / 192) + 0x80).chr($d % 192 + 0x40)."\x32\x14\x0a\x01";
  } else {
    "$c\x32\x14\x0a\x01";
  }
}


sub getWt
{
  my $self = shift;
  my $str  = $self->{preprocess} ? &{ $self->{preprocess} }(shift) : shift;
  my $kan  = $self->{kanji};
  my $ign  = $self->{ignoreChar};

  if($str !~ m/^(?:$Char)*$/o){
    carp $PACKAGE . " Malformed Shift_JIS character";
  }

  my($c, @buf);
  for $c ($str =~ m/$Char/go){
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

sub getSortKey
{
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
  for(@_){
    $hyoki{$_} = $obj->getSortKey($_);
  }
  sort{ $hyoki{$a} cmp $hyoki{$b} } @_;
}

sub sortYomi {
  my $obj = shift;
  my (%hyoki, %yomi);
  my @str = @_;
  for(@str){
    $hyoki{ $_->[0] } = $obj->getSortKey($_->[0]);
    $yomi{  $_->[1] } = $obj->getSortKey($_->[1]);
  }

  sort{ $yomi{  $a->[1] } cmp $yomi{  $b->[1] }
     || $hyoki{ $a->[0] } cmp $hyoki{ $b->[0] } 
     } @str;
}

sub sortDaihyo {
  my $obj = shift;
  my (%class, %hyoki, %yomi, %daihyo, %kashira);
  my @str = @_;
  for(@str){
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
sub index
{
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

  if($str !~ m/^(?:$Char)*$/o){
    carp $PACKAGE . " Malformed Shift_JIS character";
  }

  my $count = 0;
  my($c, $prev, @strWt, @strPt);
  for $c ($str =~ m/$Char/go){
    my $cur;
    next if defined $ign && $c =~ /$ign/;
    if($Order{$c} || $kan > 1 && $c =~ /^$CJK$/o){
      $cur   = _replaced($c, $strWt[-1]) if $Replaced{$c} && @strWt;
      $cur ||= $Order{$c} ? $Order{$c} :
               $kan > 1   ? $self->getWtCJK($c) : undef;
    }

    if($cur){
      push @strWt, $cur;
      push @strPt, $count; 
    }
    $count += $byte ? length($c) : _length($c);

    while(@strWt >= @subWt){
      if(_eqArray(\@strWt, \@subWt, $lev)){
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
sub _eqArray($$$)
{
  my $a   = shift; # length $a >= length $b;
  my $b   = shift;
  my $len = 1 + shift; # 1 + level

  my($c);
  for $c (0..@$b-1){
    return if substr($a->[$c], 0, $len) ne substr($b->[$c], 0, $len);
  }
  return 1;
}

1;

__END__

=head1 NAME

ShiftJIS::Collate - collation of ShiftJIS strings

=head1 SYNOPSIS

  use ShiftJIS::Collate;

  @sorted = ShiftJIS::Collate->new(%tailoring)->sort(@not_sorted);

=head1 DESCRIPTION

This module provides some functions to compare and sort strings
in the ShiftJIS encoding
using the collation of Japanese character strings.

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

If specified as a regex,
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
  my $str = "* ひらがなとカタカナはレベル３では等しいかな。";
  my $sub = "かな";
  my $match;
  if(my @tmp = $Col->index($str, $sub)){
    $match = substr($str, $tmp[0], $tmp[1]);
  }

If C<$level> is 1, you get C<"がな">;
if C<$level> is 2 or 3, you get C<"カナ">;
if C<$level> is 4 or 5, you get C<"かな">.

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

B<BN:> According to the JIS standard, the level 5 should be ignored.

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

        RFC1345  UCS
	[*5]    U+309D  HIRAGANA ITERATION MARK
	[+5]    U+309E  HIRAGANA VOICED ITERATION MARK
	[-6]    U+30FC  KATAKANA-HIRAGANA PROLONGED SOUND MARK
	[*6]    U+30FD  KATAKANA ITERATION MARK
	[+6]    U+30FE  KATAKANA VOICED ITERATION MARK

To represent Japanese characters,
RFC 1345 Mnemonic characters enclosed by brackets
are used below.

These characters, if replaced, are secondary equal to
the replacing kana, while ternary not equal to.

=over 4

=item KATAKANA-HIRAGANA PROLONGED SOUND MARK

The PROLONGED MARK is repleced to a normal vowel or nasal
katakana corresponding to the preceding kana if exists.

  eg.	[Ka][-6] to [Ka][A6]
	[bi][-6] to [bi][I6]
	[Pi][YU][-6] to [Pi][YU][U6]
	[N6][-6] to [N6][N6]

=item HIRAGANA- and KATAKANA ITERATION MARKs

The ITERATION MARKs (VOICELESS) are repleced 
to a normal kana corresponding to the preceding kana if exists.

  eg.	[Ka][*6] to [Ka][Ka]
	[Do][*5] to [Do][to]
	[n5][*5] to [n5][n5]
	[Pu][*6] to [Pu][Hu]
	[Pi][YU][*6] to [Pi][YU][Yu]

=item HIRAGANA- and KATAKANA VOICED ITERATION MARKs

The VOICED ITERATION MARKs are repleced to a voiced kana
corresponding to the preceding kana if exists.

  eg.	[ha][+5] to [ha][ba]
	[Pu][+5] to [Pu][bu]
	[Ko][+6] to [Ko][Go]
	[U6][+6] to [U6][Vu]

=item Cases of no replacement

Otherwise, no replacement occurs. Especially in the 
cases when these marks follow any character except kana.

The unreplaced characters are primary greater than any kana.

  eg.	CJK Ideograph followed by PROLONGED SOUND MARK
	Digit followed by ITERATION MARK
	[A6][+6] ([A6] has no voiced variant)

=item Example

For example, the Japanese string C<[Pa][-6][Ru]> (C<Perl> in kana)
has three collation elements: C<KATAKANA PA>, 
C<PROLONGED SOUND MARK replaced by KATAKANA A>, and C<KATAKANA RU>.

   [Pa][-6][Ru] is converted to [Pa][A6][Ru] by replacement.
		primary equal to [ha][a5][ru].
		secondary equal to [pa][a5][ru], greater than [ha][a5][ru].
		tertiary equal to [pa][-6][ru], lesser than [Pa][A6][Ru].
		quartenary greater than [pa][-6][ru].

=back

=head2 Conformance on the Standard

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

  (6) L<Kanji Classes>:
       the minimal kanji class (Five kanji-like chars).
       the basic kanji class (Levels 1 and 2 kanji, JIS)..

=head1 AUTHOR

Tomoyuki SADAHIRO

  bqw10602@nifty.com
  http://homepage1.nifty.com/nomenclator/perl/

 This program is free software; you can redistribute it and/or 
 modify it under the same terms as Perl itself.

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

RFC 1345 [Character Mnemonics & Character Sets]

=item *

L<ShiftJIS::String>

=item *

L<ShiftJIS::Regexp>

=back

=cut

