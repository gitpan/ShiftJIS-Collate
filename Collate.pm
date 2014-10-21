package ShiftJIS::Collate;

use Carp;
use strict;
use vars qw($VERSION $PACKAGE @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION = '0.01';

$PACKAGE = 'ShiftJIS::Collate'; # __PACKAGE__

my $Level = 4;
my $Kanji = 2;

sub new
{
  my $class = shift;
  my $self  = bless { @_ }, $class;

  $self->{level} ||= $Level;
  $self->{kanji} ||= $Kanji;

  return $self;
}


my $Char = '[\xB3\xB6-\xC4]\xDE|[\xCA-\xCE][\xDE\xDF]|'
 . '[\x00-\x7F\xA1-\xDF]|[\x81-\x9F\xE0-\xFC][\x40-\x7E\x80-\xFC]';

my $CJK = '\x88[\x9F-\xFC]|\x98[\x40-\x72\x9F-\xFC]|'
 . '[\x89-\x97\x99-\x9F\xE0-\xE9][\x40-\x7E\x80-\xFC]|'
 . '\xEA[\x40-\x7E\x80-\xA4]';


#
# 2nd weights
#   50 unaffected
#   60 normal latin
#   70 voiceless kana
#   72 voiced kana
#   74 semivoiced kana
#
# 3rd weights
#   20 unaffected
#   21 lower latin
#   22 upper latin
#   30 prolonged kana
#   32 small kana
#   34 iteration kana
#   36 normal kana
#
# 4th weights
#   10 unaffected
#   16 hiragana
#   17 katakana
#
# 5th weights
#    1 unaffected
#    2 normal ascii
#    3 normal kana
#    4 compat kana
#    5 compat ascii
#
my %Order = (

' '  => [ 90,50,20,10,1],
'�@' => [ 91,50,20,10,1],
'�A' => [101,50,20,10,3],
'�'  => [101,50,20,10,4],
'�B' => [102,50,20,10,3],
'�'  => [102,50,20,10,4],
','  => [103,50,20,10,2],
'�C' => [103,50,20,10,5],
'.'  => [104,50,20,10,2],
'�D' => [104,50,20,10,5],
'�E' => [105,50,20,10,3],
'�'  => [105,50,20,10,4],
':'  => [106,50,20,10,2],
'�F' => [106,50,20,10,5],
';'  => [107,50,20,10,2],
'�G' => [107,50,20,10,5],
'?'  => [108,50,20,10,2],
'�H' => [108,50,20,10,5],
'!'  => [109,50,20,10,2],
'�I' => [109,50,20,10,5],
'�L' => [110,50,20,10,1],#added
'`'  => [111,50,20,10,2],#added
'�M' => [111,50,20,10,5],#added
'�N' => [112,50,20,10,1],#added
'^'  => [113,50,20,10,2],#added
'�O' => [113,50,20,10,5],#added
'~'  => [114,50,20,10,2],
'�P' => [114,50,20,10,5],
'_'  => [115,50,20,10,2],
'�Q' => [115,50,20,10,5],
(qw/�\ /)[0]
     => [116,50,20,10,1],
'�]' => [117,50,20,10,1],
'/'  => [118,50,20,10,2],
'�^' => [118,50,20,10,5],
'�_' => [119,50,20,10,1],
'�`' => [120,50,20,10,1],
'�a' => [121,50,20,10,1],
'|'  => [122,50,20,10,2],
'�b' => [122,50,20,10,5],
'�c' => [123,50,20,10,1],
'�d' => [124,50,20,10,1],
q|�e|=> [201,50,20,10,1],
q|�f|=> [202,50,20,10,1],
q|'| => [203,50,20,10,1],#added
q|�g|=> [204,50,20,10,1],
q|�h|=> [205,50,20,10,1],
q|"| => [206,50,20,10,1],#added
'('  => [207,50,20,10,2],
'�i' => [207,50,20,10,5],
')'  => [208,50,20,10,2],
'�j' => [208,50,20,10,5],
'�k' => [209,50,20,10,1],
'�l' => [210,50,20,10,1],
'['  => [211,50,20,10,2],
'�m' => [211,50,20,10,5],
']'  => [212,50,20,10,2],
'�n' => [212,50,20,10,5],
'{'  => [213,50,20,10,2],
'�o' => [213,50,20,10,5],
'}'  => [214,50,20,10,2],
'�p' => [214,50,20,10,5],
'�q' => [215,50,20,10,1],
'�r' => [216,50,20,10,1],
'�s' => [217,50,20,10,1],
'�t' => [218,50,20,10,1],
'�u' => [219,50,20,10,3],
'�'  => [219,50,20,10,4],
'�v' => [220,50,20,10,3],
'�'  => [220,50,20,10,4],
'�w' => [221,50,20,10,1],
'�x' => [222,50,20,10,1],
'�y' => [223,50,20,10,1],
'�z' => [224,50,20,10,1],
'+'  => [301,50,20,10,2],
'�{' => [301,50,20,10,5],
'-'  => [302,50,20,10,1],#added
'�|' => [303,50,20,10,1],
'�}' => [304,50,20,10,1],
'�~' => [305,50,20,10,1],
'��' => [306,50,20,10,1],
'='  => [307,50,20,10,2],
'��' => [307,50,20,10,5],
'��' => [308,50,20,10,1],
'<'  => [309,50,20,10,2],
'��' => [309,50,20,10,5],
'>'  => [310,50,20,10,2],
'��' => [310,50,20,10,5],
'��' => [311,50,20,10,1],
'��' => [312,50,20,10,1],
'��' => [313,50,20,10,1],
'��' => [314,50,20,10,1],
'��' => [315,50,20,10,1],
'��' => [316,50,20,10,1],
'��' => [317,50,20,10,1],
'��' => [318,50,20,10,1],
'��' => [319,50,20,10,1],
'��' => [320,50,20,10,1],
'��' => [321,50,20,10,1],
'��' => [322,50,20,10,1],
'��' => [323,50,20,10,1],
'��' => [324,50,20,10,1],
'��' => [325,50,20,10,1],
'��' => [326,50,20,10,1],
'��' => [327,50,20,10,1],
'��' => [328,50,20,10,1],
'��' => [329,50,20,10,1],
'��' => [330,50,20,10,1],
'��' => [331,50,20,10,1],
'��' => [332,50,20,10,1],
'��' => [333,50,20,10,1],
'��' => [334,50,20,10,1],
'��' => [335,50,20,10,1],
'��' => [336,50,20,10,1],
'��' => [337,50,20,10,1],
'��' => [338,50,20,10,1],
'��' => [339,50,20,10,1],
'��' => [340,50,20,10,1],
'��' => [341,50,20,10,1],
'��' => [342,50,20,10,1],
'��' => [343,50,20,10,1],
'��' => [344,50,20,10,1],
'��' => [345,50,20,10,1],
'��' => [346,50,20,10,1],
'#'  => [401,50,20,10,2],
'��' => [401,50,20,10,5],
'&'  => [402,50,20,10,2],
'��' => [402,50,20,10,5],
'*'  => [403,50,20,10,2],
'��' => [403,50,20,10,5],
'@'  => [404,50,20,10,2],
'��' => [404,50,20,10,5],
'��' => [405,50,20,10,1],
'��' => [406,50,20,10,1],
'��' => [407,50,20,10,1],
'��' => [408,50,20,10,1],
'��' => [409,50,20,10,1],
'��' => [410,50,20,10,1],
'��' => [411,50,20,10,1],
'��' => [412,50,20,10,1],
'��' => [413,50,20,10,1],
'��' => [414,50,20,10,1],
'��' => [415,50,20,10,1],
'��' => [416,50,20,10,1],
'��' => [417,50,20,10,1],
'��' => [418,50,20,10,1],
'��' => [419,50,20,10,1],
'��' => [420,50,20,10,1],
'��' => [421,50,20,10,1],
'��' => [422,50,20,10,1],
'��' => [423,50,20,10,1],
'��' => [424,50,20,10,1],
'��' => [425,50,20,10,1],
'��' => [426,50,20,10,1],
'��' => [427,50,20,10,1],
'��' => [428,50,20,10,1],
'��' => [429,50,20,10,1],
'��' => [430,50,20,10,1],
'��' => [461,50,20,10,1],
'��' => [462,50,20,10,1],
'��' => [463,50,20,10,1],
'��' => [464,50,20,10,1],
'\\' => [465,50,20,10,2],
'��' => [465,50,20,10,5],
'$'  => [466,50,20,10,2],
'��' => [466,50,20,10,5],
'��' => [467,50,20,10,1],
'��' => [468,50,20,10,1],
'%'  => [469,50,20,10,2],
'��' => [469,50,20,10,5],
'��' => [470,50,20,10,1],
'��' => [471,50,20,10,1],
'0'  => [501,50,20,10,2],
'�O' => [501,50,20,10,5],
'1'  => [502,50,20,10,2],
'�P' => [502,50,20,10,5],
'2'  => [503,50,20,10,2],
'�Q' => [503,50,20,10,5],
'3'  => [504,50,20,10,2],
'�R' => [504,50,20,10,5],
'4'  => [505,50,20,10,2],
'�S' => [505,50,20,10,5],
'5'  => [506,50,20,10,2],
'�T' => [506,50,20,10,5],
'6'  => [507,50,20,10,2],
'�U' => [507,50,20,10,5],
'7'  => [508,50,20,10,2],
'�V' => [508,50,20,10,5],
'8'  => [509,50,20,10,2],
'�W' => [509,50,20,10,5],
'9'  => [510,50,20,10,2],
'�X' => [510,50,20,10,5],
'��' => [601,50,20,10,1],
'��' => [602,50,20,10,1],
'��' => [603,50,20,10,1],
'��' => [604,50,20,10,1],
'��' => [605,50,20,10,1],
'��' => [606,50,20,10,1],
'��' => [607,50,20,10,1],
'��' => [608,50,20,10,1],
'��' => [609,50,20,10,1],
'��' => [610,50,20,10,1],
'��' => [611,50,20,10,1],
'��' => [612,50,20,10,1],
'��' => [613,50,20,10,1],
'��' => [614,50,20,10,1],
'��' => [615,50,20,10,1],
'��' => [616,50,20,10,1],
'��' => [617,50,20,10,1],
'��' => [618,50,20,10,1],
'��' => [619,50,20,10,1],
'��' => [620,50,20,10,1],
'��' => [621,50,20,10,1],
'��' => [622,50,20,10,1],
'��' => [623,50,20,10,1],
'��' => [624,50,20,10,1],
'��' => [651,50,20,10,1],
'��' => [652,50,20,10,1],
'��' => [653,50,20,10,1],
'��' => [654,50,20,10,1],
'��' => [655,50,20,10,1],
'��' => [656,50,20,10,1],
'��' => [657,50,20,10,1],
'��' => [658,50,20,10,1],
'��' => [659,50,20,10,1],
'��' => [660,50,20,10,1],
'��' => [661,50,20,10,1],
'��' => [662,50,20,10,1],
'��' => [663,50,20,10,1],
'��' => [664,50,20,10,1],
'��' => [665,50,20,10,1],
'��' => [666,50,20,10,1],
'��' => [667,50,20,10,1],
'��' => [668,50,20,10,1],
'��' => [669,50,20,10,1],
'��' => [670,50,20,10,1],
'��' => [671,50,20,10,1],
'��' => [672,50,20,10,1],
'��' => [673,50,20,10,1],
'��' => [674,50,20,10,1],
'�p' => [701,50,20,10,1],
'�q' => [702,50,20,10,1],
'�r' => [703,50,20,10,1],
'�s' => [704,50,20,10,1],
'�t' => [705,50,20,10,1],
'�u' => [706,50,20,10,1],
'�v' => [707,50,20,10,1],
'�w' => [708,50,20,10,1],
'�x' => [709,50,20,10,1],
'�y' => [710,50,20,10,1],
'�z' => [711,50,20,10,1],
'�{' => [712,50,20,10,1],
'�|' => [713,50,20,10,1],
'�}' => [714,50,20,10,1],
'�~' => [715,50,20,10,1],
'��' => [716,50,20,10,1],
'��' => [717,50,20,10,1],
'��' => [718,50,20,10,1],
'��' => [719,50,20,10,1],
'��' => [720,50,20,10,1],
'��' => [721,50,20,10,1],
'��' => [722,50,20,10,1],
'��' => [723,50,20,10,1],
'��' => [724,50,20,10,1],
'��' => [725,50,20,10,1],
'��' => [726,50,20,10,1],
'��' => [727,50,20,10,1],
'��' => [728,50,20,10,1],
'��' => [729,50,20,10,1],
'��' => [730,50,20,10,1],
'��' => [731,50,20,10,1],
'��' => [732,50,20,10,1],
'��' => [733,50,20,10,1],
'�@' => [751,50,20,10,1],
'�A' => [752,50,20,10,1],
'�B' => [753,50,20,10,1],
'�C' => [754,50,20,10,1],
'�D' => [755,50,20,10,1],
'�E' => [756,50,20,10,1],
'�F' => [757,50,20,10,1],
'�G' => [758,50,20,10,1],
'�H' => [759,50,20,10,1],
'�I' => [760,50,20,10,1],
'�J' => [761,50,20,10,1],
'�K' => [762,50,20,10,1],
'�L' => [763,50,20,10,1],
'�M' => [764,50,20,10,1],
'�N' => [765,50,20,10,1],
'�O' => [766,50,20,10,1],
'�P' => [767,50,20,10,1],
'�Q' => [768,50,20,10,1],
'�R' => [769,50,20,10,1],
'�S' => [770,50,20,10,1],
'�T' => [771,50,20,10,1],
'�U' => [772,50,20,10,1],
'�V' => [773,50,20,10,1],
'�W' => [774,50,20,10,1],
'�X' => [775,50,20,10,1],
'�Y' => [776,50,20,10,1],
'�Z' => [777,50,20,10,1],
'�[' => [778,50,20,10,1],
(qw/�\ /)[0]
     => [779,50,20,10,1],
'�]' => [780,50,20,10,1],
'�^' => [781,50,20,10,1],
'�_' => [782,50,20,10,1],
'�`' => [783,50,20,10,1],
'a'  => [801,60,21,10,2],
'��' => [801,60,21,10,5],
'A'  => [801,60,22,10,2],
'�`' => [801,60,22,10,5],
'b'  => [802,60,21,10,2],
'��' => [802,60,21,10,5],
'B'  => [802,60,22,10,2],
'�a' => [802,60,22,10,5],
'c'  => [803,60,21,10,2],
'��' => [803,60,21,10,5],
'C'  => [803,60,22,10,2],
'�b' => [803,60,22,10,5],
'd'  => [804,60,21,10,2],
'��' => [804,60,21,10,5],
'D'  => [804,60,22,10,2],
'�c' => [804,60,22,10,5],
'e'  => [805,60,21,10,2],
'��' => [805,60,21,10,5],
'E'  => [805,60,22,10,2],
'�d' => [805,60,22,10,5],
'f'  => [806,60,21,10,2],
'��' => [806,60,21,10,5],
'F'  => [806,60,22,10,2],
'�e' => [806,60,22,10,5],
'g'  => [807,60,21,10,2],
'��' => [807,60,21,10,5],
'G'  => [807,60,22,10,2],
'�f' => [807,60,22,10,5],
'h'  => [808,60,21,10,2],
'��' => [808,60,21,10,5],
'H'  => [808,60,22,10,2],
'�g' => [808,60,22,10,5],
'i'  => [809,60,21,10,2],
'��' => [809,60,21,10,5],
'I'  => [809,60,22,10,2],
'�h' => [809,60,22,10,5],
'j'  => [810,60,21,10,2],
'��' => [810,60,21,10,5],
'J'  => [810,60,22,10,2],
'�i' => [810,60,22,10,5],
'k'  => [811,60,21,10,2],
'��' => [811,60,21,10,5],
'K'  => [811,60,22,10,2],
'�j' => [811,60,22,10,5],
'l'  => [812,60,21,10,2],
'��' => [812,60,21,10,5],
'L'  => [812,60,22,10,2],
'�k' => [812,60,22,10,5],
'm'  => [813,60,21,10,2],
'��' => [813,60,21,10,5],
'M'  => [813,60,22,10,2],
'�l' => [813,60,22,10,5],
'n'  => [814,60,21,10,2],
'��' => [814,60,21,10,5],
'N'  => [814,60,22,10,2],
'�m' => [814,60,22,10,5],
'o'  => [815,60,21,10,2],
'��' => [815,60,21,10,5],
'O'  => [815,60,22,10,2],
'�n' => [815,60,22,10,5],
'p'  => [816,60,21,10,2],
'��' => [816,60,21,10,5],
'P'  => [816,60,22,10,2],
'�o' => [816,60,22,10,5],
'q'  => [817,60,21,10,2],
'��' => [817,60,21,10,5],
'Q'  => [817,60,22,10,2],
'�p' => [817,60,22,10,5],
'r'  => [818,60,21,10,2],
'��' => [818,60,21,10,5],
'R'  => [818,60,22,10,2],
'�q' => [818,60,22,10,5],
's'  => [819,60,21,10,2],
'��' => [819,60,21,10,5],
'S'  => [819,60,22,10,2],
'�r' => [819,60,22,10,5],
't'  => [820,60,21,10,2],
'��' => [820,60,21,10,5],
'T'  => [820,60,22,10,2],
'�s' => [820,60,22,10,5],
'u'  => [821,60,21,10,2],
'��' => [821,60,21,10,5],
'U'  => [821,60,22,10,2],
'�t' => [821,60,22,10,5],
'v'  => [822,60,21,10,2],
'��' => [822,60,21,10,5],
'V'  => [822,60,22,10,2],
'�u' => [822,60,22,10,5],
'w'  => [823,60,21,10,2],
'��' => [823,60,21,10,5],
'W'  => [823,60,22,10,2],
'�v' => [823,60,22,10,5],
'x'  => [824,60,21,10,2],
'��' => [824,60,21,10,5],
'X'  => [824,60,22,10,2],
'�w' => [824,60,22,10,5],
'y'  => [825,60,21,10,2],
'��' => [825,60,21,10,5],
'Y'  => [825,60,22,10,2],
'�x' => [825,60,22,10,5],
'z'  => [826,60,21,10,2],
'��' => [826,60,21,10,5],
'Z'  => [826,60,22,10,2],
'�y' => [826,60,22,10,5],
'��' => [901,70,32,16,3],
'�@' => [901,70,32,17,3],
'�'  => [901,70,32,17,4],
'��' => [901,70,36,16,3],
'�A' => [901,70,36,17,3],
'�'  => [901,70,36,17,4],
'��' => [902,70,32,16,3],
'�B' => [902,70,32,17,3],
'�'  => [902,70,32,17,4],
'��' => [902,70,36,16,3],
'�C' => [902,70,36,17,3],
'�'  => [902,70,36,17,4],
'��' => [903,70,32,16,3],
'�D' => [903,70,32,17,3],
'�'  => [903,70,32,17,4],
'��' => [903,70,36,16,3],
'�E' => [903,70,36,17,3],
'�'  => [903,70,36,17,4],
'��' => [903,72,36,17,3],
'��' => [903,72,36,17,4],
'��' => [904,70,32,16,3],
'�F' => [904,70,32,17,3],
'�'  => [904,70,32,17,4],
'��' => [904,70,36,16,3],
'�G' => [904,70,36,17,3],
'�'  => [904,70,36,17,4],
'��' => [905,70,32,16,3],
'�H' => [905,70,32,17,3],
'�'  => [905,70,32,17,4],
'��' => [905,70,36,16,3],
'�I' => [905,70,36,17,3],
'�'  => [905,70,36,17,4],
'��' => [911,70,32,17,3],
'��' => [911,70,36,16,3],
'�J' => [911,70,36,17,3],
'�'  => [911,70,36,17,4],
'��' => [911,72,36,16,3],
'�K' => [911,72,36,17,3],
'��' => [911,72,36,17,4],
'��' => [912,70,36,16,3],
'�L' => [912,70,36,17,3],
'�'  => [912,70,36,17,4],
'��' => [912,72,36,16,3],
'�M' => [912,72,36,17,3],
'��' => [912,72,36,17,4],
'��' => [913,70,36,16,3],
'�N' => [913,70,36,17,3],
'�'  => [913,70,36,17,4],
'��' => [913,72,36,16,3],
'�O' => [913,72,36,17,3],
'��' => [913,72,36,17,4],
'��' => [914,70,32,17,3],
'��' => [914,70,36,16,3],
'�P' => [914,70,36,17,3],
'�'  => [914,70,36,17,4],
'��' => [914,72,36,16,3],
'�Q' => [914,72,36,17,3],
'��' => [914,72,36,17,4],
'��' => [915,70,36,16,3],
'�R' => [915,70,36,17,3],
'�'  => [915,70,36,17,4],
'��' => [915,72,36,16,3],
'�S' => [915,72,36,17,3],
'��' => [915,72,36,17,4],
'��' => [921,70,36,16,3],
'�T' => [921,70,36,17,3],
'�'  => [921,70,36,17,4],
'��' => [921,72,36,16,3],
'�U' => [921,72,36,17,3],
'��' => [921,72,36,17,4],
'��' => [922,70,36,16,3],
'�V' => [922,70,36,17,3],
'�'  => [922,70,36,17,4],
'��' => [922,72,36,16,3],
'�W' => [922,72,36,17,3],
'��' => [922,72,36,17,4],
'��' => [923,70,36,16,3],
'�X' => [923,70,36,17,3],
'�'  => [923,70,36,17,4],
'��' => [923,72,36,16,3],
'�Y' => [923,72,36,17,3],
'��' => [923,72,36,17,4],
'��' => [924,70,36,16,3],
'�Z' => [924,70,36,17,3],
'�'  => [924,70,36,17,4],
'��' => [924,72,36,16,3],
'�[' => [924,72,36,17,3],
'��' => [924,72,36,17,4],
'��' => [925,70,36,16,3],
(qw/�\ /)[0]
     => [925,70,36,17,3],
'�'  => [925,70,36,17,4],
'��' => [925,72,36,16,3],
'�]' => [925,72,36,17,3],
'��' => [925,72,36,17,4],
'��' => [931,70,36,16,3],
'�^' => [931,70,36,17,3],
'�'  => [931,70,36,17,4],
'��' => [931,72,36,16,3],
'�_' => [931,72,36,17,3],
'��' => [931,72,36,17,4],
'��' => [932,70,36,16,3],
'�`' => [932,70,36,17,3],
'�'  => [932,70,36,17,4],
'��' => [932,72,36,16,3],
'�a' => [932,72,36,17,3],
'��' => [932,72,36,17,4],
'��' => [933,70,32,16,3],
'�b' => [933,70,32,17,3],
'�'  => [933,70,32,17,4],
'��' => [933,70,36,16,3],
'�c' => [933,70,36,17,3],
'�'  => [933,70,36,17,4],
'��' => [933,72,36,16,3],
'�d' => [933,72,36,17,3],
'��' => [933,72,36,17,4],
'��' => [934,70,36,16,3],
'�e' => [934,70,36,17,3],
'�'  => [934,70,36,17,4],
'��' => [934,72,36,16,3],
'�f' => [934,72,36,17,3],
'��' => [934,72,36,17,4],
'��' => [935,70,36,16,3],
'�g' => [935,70,36,17,3],
'�'  => [935,70,36,17,4],
'��' => [935,72,36,16,3],
'�h' => [935,72,36,17,3],
'��' => [935,72,36,17,4],
'��' => [941,70,36,16,3],
'�i' => [941,70,36,17,3],
'�'  => [941,70,36,17,4],
'��' => [942,70,36,16,3],
'�j' => [942,70,36,17,3],
'�'  => [942,70,36,17,4],
'��' => [943,70,36,16,3],
'�k' => [943,70,36,17,3],
'�'  => [943,70,36,17,4],
'��' => [944,70,36,16,3],
'�l' => [944,70,36,17,3],
'�'  => [944,70,36,17,4],
'��' => [945,70,36,16,3],
'�m' => [945,70,36,17,3],
'�'  => [945,70,36,17,4],
'��' => [951,70,36,16,3],
'�n' => [951,70,36,17,3],
'�'  => [951,70,36,17,4],
'��' => [951,72,36,16,3],
'�o' => [951,72,36,17,3],
'��' => [951,72,36,17,4],
'��' => [951,74,36,16,3],
'�p' => [951,74,36,17,3],
'��' => [951,74,36,17,4],
'��' => [952,70,36,16,3],
'�q' => [952,70,36,17,3],
'�'  => [952,70,36,17,4],
'��' => [952,72,36,16,3],
'�r' => [952,72,36,17,3],
'��' => [952,72,36,17,4],
'��' => [952,74,36,16,3],
'�s' => [952,74,36,17,3],
'��' => [952,74,36,17,4],
'��' => [953,70,36,16,3],
'�t' => [953,70,36,17,3],
'�'  => [953,70,36,17,4],
'��' => [953,72,36,16,3],
'�u' => [953,72,36,17,3],
'��' => [953,72,36,17,4],
'��' => [953,74,36,16,3],
'�v' => [953,74,36,17,3],
'��' => [953,74,36,17,4],
'��' => [954,70,36,16,3],
'�w' => [954,70,36,17,3],
'�'  => [954,70,36,17,4],
'��' => [954,72,36,16,3],
'�x' => [954,72,36,17,3],
'��' => [954,72,36,17,4],
'��' => [954,74,36,16,3],
'�y' => [954,74,36,17,3],
'��' => [954,74,36,17,4],
'��' => [955,70,36,16,3],
'�z' => [955,70,36,17,3],
'�'  => [955,70,36,17,4],
'��' => [955,72,36,16,3],
'�{' => [955,72,36,17,3],
'��' => [955,72,36,17,4],
'��' => [955,74,36,16,3],
'�|' => [955,74,36,17,3],
'��' => [955,74,36,17,4],
'��' => [961,70,36,16,3],
'�}' => [961,70,36,17,3],
'�'  => [961,70,36,17,4],
'��' => [962,70,36,16,3],
'�~' => [962,70,36,17,3],
'�'  => [962,70,36,17,4],
'��' => [963,70,36,16,3],
'��' => [963,70,36,17,3],
'�'  => [963,70,36,17,4],
'��' => [964,70,36,16,3],
'��' => [964,70,36,17,3],
'�'  => [964,70,36,17,4],
'��' => [965,70,36,16,3],
'��' => [965,70,36,17,3],
'�'  => [965,70,36,17,4],
'��' => [971,70,32,16,3],
'��' => [971,70,32,17,3],
'�'  => [971,70,32,17,4],
'��' => [971,70,36,16,3],
'��' => [971,70,36,17,3],
'�'  => [971,70,36,17,4],
'��' => [973,70,32,16,3],
'��' => [973,70,32,17,3],
'�'  => [973,70,32,17,4],
'��' => [973,70,36,16,3],
'��' => [973,70,36,17,3],
'�'  => [973,70,36,17,4],
'��' => [975,70,32,16,3],
'��' => [975,70,32,17,3],
'�'  => [975,70,32,17,4],
'��' => [975,70,36,16,3],
'��' => [975,70,36,17,3],
'�'  => [975,70,36,17,4],
'��' => [981,70,36,16,3],
'��' => [981,70,36,17,3],
'�'  => [981,70,36,17,4],
'��' => [982,70,36,16,3],
'��' => [982,70,36,17,3],
'�'  => [982,70,36,17,4],
'��' => [983,70,36,16,3],
'��' => [983,70,36,17,3],
'�'  => [983,70,36,17,4],
'��' => [984,70,36,16,3],
'��' => [984,70,36,17,3],
'�'  => [984,70,36,17,4],
'��' => [985,70,36,16,3],
'��' => [985,70,36,17,3],
'�'  => [985,70,36,17,4],
'��' => [991,70,32,16,3],
'��' => [991,70,32,17,3],
'��' => [991,70,36,16,3],
'��' => [991,70,36,17,3],
'�'  => [991,70,36,17,4],
'��' => [992,70,36,16,3],
'��' => [992,70,36,17,3],
'��' => [994,70,36,16,3],
'��' => [994,70,36,17,3],
'��' => [995,70,36,16,3],
'��' => [995,70,36,17,3],
'�'  => [995,70,36,17,4],
'��' => [996,70,36,16,3],
'��' => [996,70,36,17,3],
'�'  => [996,70,36,17,4],
'�T' => [997,70,34,16,3],
'�R' => [997,70,34,17,3],
'�U' => [997,72,34,16,3],
'�S' => [997,72,34,17,3],
'�[' => [998,70,30,17,3],
'�'  => [998,70,30,17,4],
'�V' => [1001,50,20,10,1],
'�X' => [1002,50,20,10,1],
'�W' => [1003,50,20,10,1],
'�Y' => [1004,50,20,10,1],
'�Z' => [1005,50,20,10,1],
'��' => [65534,50,20,10,1],
);

sub _getOrder{wantarray ? %Order : \%Order}

sub _getClass($)
{
  my $w = shift; # 1st weight
  return
    $w <  90 ? 0 : # ignorable
    $w < 100 ? 1 : # space
    $w < 200 ? 2 : # kijutsu kigou   : descriptive symbols
    $w < 300 ? 3 : # kakko kigou     : quotes and parentheses
    $w < 400 ? 4 : # gakujutsu kigou : 
                   #   mathematic operators and scientific symbols
    $w < 450 ? 5 : # ippan kigou     : general symbols
    $w < 500 ? 6 : # unit symbols
    $w < 600 ? 7 : # arabic digits
    $w < 800 ? 8 : # ooji kigou      : Greek and Cyrillic alphabets 
    $w < 900 ? 9 : # Latin alphabets
    $w < 1000  ? 10 : # kana
    $w < 65534 ? 11 : # kanji
                 12 ; # geta
}

my %Replaced;
my @Replaced = qw( �[  �  �T  �R  �U  �S );
@Replaced{@Replaced} = (1) x @Replaced;

sub _hasDakuHiragana($)
{
  my $n = shift;
  911 <= $n && $n <= 935 || 951 <= $n && $n <= 955
}

sub _hasDakuKatakana($)
{
  my $n = shift;
  911 <= $n && $n <= 935 || 951 <= $n && $n <= 955 || $n == 903
}

sub _replaced($$)
{
  my $c = shift; # current element
  my $p = shift; # weight at the 1st level of the previous element
  return unless 901 <= $p && $p <= 996;

  return 
    $c eq '�['
      ? [ $p%10 == 6 ? 996 : 900 + $p%10, 70,30,17,3 ]
    : $c eq '�'
      ? [ $p%10 == 6 ? 996 : 900 + $p%10, 70,30,17,4 ]
    : $c eq '�T'
      ? [ $p, 70,34,16,3 ]
    : $c eq '�R'
      ? [ $p, 70,34,17,3 ]
    : $c eq '�U' && _hasDakuHiragana($p)
      ? [ $p, 72,34,16,3 ]
    : $c eq '�S' && _hasDakuKatakana($p)
      ? [ $p, 72,34,17,3 ]
    : undef;
}

sub _length{
  scalar( (my $str = shift) =~ s/$Char//go );
}

sub getWtCJK
{
  my $self = shift;
  my $c    = shift;
  $self->{overrideCJK}
    ? &{ $self->{overrideCJK} }($c)
    : [ unpack('n', $c), 50,20,10,1 ];
}


sub getWt
{
  my $self = shift;
  my $str  = $self->{preprocess} ? &{ $self->{preprocess} }(shift) : shift;
  my $kan  = $self->{kanji};

  if($str !~ m/^(?:$Char)*$/o){
    carp $PACKAGE . " Malformed Shift_JIS character";
  }

  my($c, @buf);
  for $c ($str =~ m/$Char/go){
    next unless $Order{$c} || $kan > 1 && $c =~ /^$CJK$/o;
    my $replaced;
    $replaced = _replaced($c, $buf[-1][0]) if $Replaced{$c} && @buf;

    push @buf,
      $replaced  ? $replaced  :
      $Order{$c} ? $Order{$c} :
      $kan > 1   ? $self->getWtCJK($c) : ();
  }
  return wantarray ? @buf : \@buf;
}

sub getSortKey
{
  my $self = shift;
  my $wt   = $self->getWt(shift);
  my $lev  = $self->{level};

  my @ret = ([],[],[],[],[]);

  my($v,$w);
  foreach $v (0..$lev-1){
    foreach $w (@$wt){
      push @{ $ret[$v] }, $w->[$v] if $w->[$v];
    }
  }

  if($self->{upper_before_lower}){
    foreach (@{ $ret[2] }){ # 3rd
      $_ == 21 ? $_++ : # lower
      $_ == 22 ? $_-- : # upper
                     1; # no-op
    }
  }
  if($self->{katakana_before_hiragana}){
    foreach (@{ $ret[3] }){ # 4th
      $_ == 16 ? $_++ : # hiragana
      $_ == 17 ? $_-- : # katakana
                    1 ; # no-op
    }
  }

  join "\0\0", map pack('n*', @$_), @ret;
}

sub cmp
{
  my $obj = shift;
  my $a   = shift;
  my $b   = shift;
  $obj->getSortKey($a) cmp $obj->getSortKey($b);
}

sub sort
{
  my $obj = shift;
  my(%hyoki);
  for(@_){
    $hyoki{$_} = $obj->getSortKey($_);
  }
  sort{ $hyoki{$a} cmp $hyoki{$b} } @_;
}

sub sortYomi
{
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

sub sortDaihyo
{
  my $obj = shift;
  my (%class, %hyoki, %yomi, %daihyo, %kashira);
  my @str = @_;
  for(@str){
    $hyoki{   $_->[0] } = $obj->getSortKey(  $_->[0] ); # string
    $yomi{    $_->[1] } = $obj->getSortKey(  $_->[1] ); # string
    $daihyo{  $_->[1] } = unpack('n', $yomi{ $_->[1]}); # number
    $kashira{ $_->[0] } = unpack('n', $hyoki{$_->[0]}); # number
    $class{   $_->[0] } = _getClass($kashira{$_->[0]}); # number
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

    if($Order{$c} || $kan > 1 && $c =~ /^$CJK$/o){
      $cur   = _replaced($c, $prev->[0]) if $Replaced{$c} && $prev;
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
  my $lev = shift;
  my($c,$v);
  for $v (0..$lev-1){
    for $c (0..@$b-1){
      return if $a->[$c][$v] != $b->[$c][$v];
    }
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

This module is an implementation of JIS X 4061-1996 and
the collation rules are based on that standard.
See L<Informations for Conformance>.

=head2 Constructor and Tailoring

The C<new> method returns a collator object.

   $Collator = ShiftJIS::Collate->new(
      kanji => $kanji_class,
      katakana_before_hiragana => $bool,
      level => $collationLevel,
      overrideCJK => \&overrideCJK,
      position_in_bytes => $bool,
      preprocess => \&preprocess,
      upper_before_lower => $bool,
   );
   # if %tailoring is false (empty),
   # $Collator should do the default collation.

=over 4

=item katakana_before_hiragana

By default, hiragana is before katakana.

If the parameter is true, this is reversed.

=item kanji

Set the kanji class. See L<Kanji Classes>.

  Level 1: 'saisho' (minimal)
  Level 2: 'kihon' (basic)
  Level 3: 'kakucho' (extended)

This module does not provide collation of 'kakucho' kanji class
since the repertory Shift_JIS does not define
all the Unicode CJK unified ideographs.

The kanji class is specified as 1 or 2. If omitted, class 2 is applied.

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

=item overrideCJK

By default, mapping of CJK Unified Ideographs
uses the JIS codepoint order.

The mapping of CJK Unified Ideographs may be overrided by this parameter.

ex. CJK Unified Ideographs in the Unicode codepoint order.

  overrideCJK => sub {
    my $c = shift;               # get Shift_JIS kanji
    my $s = your_sjis_to_utf16_converter($c); # convert
    my $n = unpack('n', $s);     # convert utf16 to short
    [ $n, 50, 20, 10, 1 ];       # return collation element
  },

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

=head2 Other Methods

=over 4

=item C<$result = $Collator-E<gt>cmp($a, $b)>

Returns 1 (when C<$a> is greater than C<$b>)
or 0 (when C<$a> is equal to C<$b>)
or -1 (when C<$a> is lesser than C<$b>).

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
  if(my @tmp = $Col->index($str, $sub)){
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
     (eg. Ka before Ga; Ha before Ba before Pa)

=item Level 3: case ordering.

A small Latin is lesser than the corresponding Capital.

In kana, the order is as shown the following list.
see L<Replacement of PROLONGED SOUND MARK and ITERATION MARKs>.

    Replaced PROLONGED SOUND MARK (U+30FC);
    Small Kana;
    Replaced ITERATION MARK (U+309D, U+309E, U+30FD or U+30FE);
    then Normal Kana.

=item Level 4: script ordering.

Hiragana is lesser than katakana.

=item Level 5: width ordering.

A character that belongs to the block 
C<Halfwidth and Fullwidth Forms>
is greater than the corresponding normal character.

B<BN:> According to the JIS standard, the level 5 should be ignored.

=back

=head2 Kanji Classes

There are three kanji classes. This modules provides the Classes 1 and 2.

=over 4

=item Class 1: the 'saisho' (minimum) kanji class

It comprises five kanji-like chars,
i.e. U+3003, U+3005, U+4EDD, U+3006, U+3007.
Any kanji except U+4EDD are ignored on collation.

=item Class 2: the 'kihon' (basic) kanji class

It comprises JIS levels 1 and 2 kanji in addition to 
the minimum kanji class. Sorted in the JIS order.
Any kanji excepting those defined by JIS X 0208 are ignored on collation.

=item Class 3: the 'kakucho' (extended) kanji class

All the CJK Unified Ideographs in addition to 
the minimum kanji class. Sorted in the unicode order.

=back


=head2 Replacement of PROLONGED SOUND MARK and ITERATION MARKs

        RFC1345 UCS
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

The PROLONGED MARK is repleced to normal vowel or nasal
katakana corresponding to the preceding kana if exists.

  eg.	[Ka][-6] to [Ka][A6]
	[bi][-6] to [bi][I6]
	[Pi][YU][-6] to [Pi][YU][U6]
	[N6][-6] to [N6][N6]

=item HIRAGANA- and KATAKANA ITERATION MARKs

The ITERATION MARKs (VOICELESS) are repleced 
to normal kana corresponding to the preceding kana if exists.

  eg.	[Ka][*6] to [Ka][Ka]
	[Do][*5] to [Do][to]
	[n5][*5] to [n5][n5]
	[Pu][*6] to [Pu][Hu]
	[Pi][YU][*6] to [Pi][YU][Yu]

=item HIRAGANA- and KATAKANA VOICED ITERATION MARKs

The VOICED ITERATION MARKs are repleced to the voiced kana
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

=head2 Informations for Conformance

    [according to the article 6.2, JIS X 4061]

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

  (6) Selected kanji class:
       the minimum kanji class (Five kanji-like chars).
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
That is translated from ISO/IEC 10646-1 and introduced into JIS.

=item *

RFC 1345 [Character Mnemonics & Character Sets]

=item *

L<ShiftJIS::String>

=item *

L<ShiftJIS::Regexp>

=back

=cut

