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
'　' => [ 91,50,20,10,1],
'、' => [101,50,20,10,3],
'､'  => [101,50,20,10,4],
'。' => [102,50,20,10,3],
'｡'  => [102,50,20,10,4],
','  => [103,50,20,10,2],
'，' => [103,50,20,10,5],
'.'  => [104,50,20,10,2],
'．' => [104,50,20,10,5],
'・' => [105,50,20,10,3],
'･'  => [105,50,20,10,4],
':'  => [106,50,20,10,2],
'：' => [106,50,20,10,5],
';'  => [107,50,20,10,2],
'；' => [107,50,20,10,5],
'?'  => [108,50,20,10,2],
'？' => [108,50,20,10,5],
'!'  => [109,50,20,10,2],
'！' => [109,50,20,10,5],
'´' => [110,50,20,10,1],#added
'`'  => [111,50,20,10,2],#added
'｀' => [111,50,20,10,5],#added
'¨' => [112,50,20,10,1],#added
'^'  => [113,50,20,10,2],#added
'＾' => [113,50,20,10,5],#added
'~'  => [114,50,20,10,2],
'￣' => [114,50,20,10,5],
'_'  => [115,50,20,10,2],
'＿' => [115,50,20,10,5],
(qw/― /)[0]
     => [116,50,20,10,1],
'‐' => [117,50,20,10,1],
'/'  => [118,50,20,10,2],
'／' => [118,50,20,10,5],
'＼' => [119,50,20,10,1],
'〜' => [120,50,20,10,1],
'‖' => [121,50,20,10,1],
'|'  => [122,50,20,10,2],
'｜' => [122,50,20,10,5],
'…' => [123,50,20,10,1],
'‥' => [124,50,20,10,1],
q|‘|=> [201,50,20,10,1],
q|’|=> [202,50,20,10,1],
q|'| => [203,50,20,10,1],#added
q|“|=> [204,50,20,10,1],
q|”|=> [205,50,20,10,1],
q|"| => [206,50,20,10,1],#added
'('  => [207,50,20,10,2],
'（' => [207,50,20,10,5],
')'  => [208,50,20,10,2],
'）' => [208,50,20,10,5],
'〔' => [209,50,20,10,1],
'〕' => [210,50,20,10,1],
'['  => [211,50,20,10,2],
'［' => [211,50,20,10,5],
']'  => [212,50,20,10,2],
'］' => [212,50,20,10,5],
'{'  => [213,50,20,10,2],
'｛' => [213,50,20,10,5],
'}'  => [214,50,20,10,2],
'｝' => [214,50,20,10,5],
'〈' => [215,50,20,10,1],
'〉' => [216,50,20,10,1],
'《' => [217,50,20,10,1],
'》' => [218,50,20,10,1],
'「' => [219,50,20,10,3],
'｢'  => [219,50,20,10,4],
'」' => [220,50,20,10,3],
'｣'  => [220,50,20,10,4],
'『' => [221,50,20,10,1],
'』' => [222,50,20,10,1],
'【' => [223,50,20,10,1],
'】' => [224,50,20,10,1],
'+'  => [301,50,20,10,2],
'＋' => [301,50,20,10,5],
'-'  => [302,50,20,10,1],#added
'−' => [303,50,20,10,1],
'±' => [304,50,20,10,1],
'×' => [305,50,20,10,1],
'÷' => [306,50,20,10,1],
'='  => [307,50,20,10,2],
'＝' => [307,50,20,10,5],
'≠' => [308,50,20,10,1],
'<'  => [309,50,20,10,2],
'＜' => [309,50,20,10,5],
'>'  => [310,50,20,10,2],
'＞' => [310,50,20,10,5],
'≦' => [311,50,20,10,1],
'≧' => [312,50,20,10,1],
'≒' => [313,50,20,10,1],
'≪' => [314,50,20,10,1],
'≫' => [315,50,20,10,1],
'∝' => [316,50,20,10,1],
'∞' => [317,50,20,10,1],
'∂' => [318,50,20,10,1],
'∇' => [319,50,20,10,1],
'√' => [320,50,20,10,1],
'∫' => [321,50,20,10,1],
'∬' => [322,50,20,10,1],
'∠' => [323,50,20,10,1],
'⊥' => [324,50,20,10,1],
'⌒' => [325,50,20,10,1],
'≡' => [326,50,20,10,1],
'∽' => [327,50,20,10,1],
'∈' => [328,50,20,10,1],
'∋' => [329,50,20,10,1],
'⊆' => [330,50,20,10,1],
'⊇' => [331,50,20,10,1],
'⊂' => [332,50,20,10,1],
'⊃' => [333,50,20,10,1],
'∪' => [334,50,20,10,1],
'∩' => [335,50,20,10,1],
'∧' => [336,50,20,10,1],
'∨' => [337,50,20,10,1],
'¬' => [338,50,20,10,1],
'⇒' => [339,50,20,10,1],
'⇔' => [340,50,20,10,1],
'∀' => [341,50,20,10,1],
'∃' => [342,50,20,10,1],
'∴' => [343,50,20,10,1],
'∵' => [344,50,20,10,1],
'♂' => [345,50,20,10,1],
'♀' => [346,50,20,10,1],
'#'  => [401,50,20,10,2],
'＃' => [401,50,20,10,5],
'&'  => [402,50,20,10,2],
'＆' => [402,50,20,10,5],
'*'  => [403,50,20,10,2],
'＊' => [403,50,20,10,5],
'@'  => [404,50,20,10,2],
'＠' => [404,50,20,10,5],
'§' => [405,50,20,10,1],
'¶' => [406,50,20,10,1],
'※' => [407,50,20,10,1],
'†' => [408,50,20,10,1],
'‡' => [409,50,20,10,1],
'☆' => [410,50,20,10,1],
'★' => [411,50,20,10,1],
'○' => [412,50,20,10,1],
'●' => [413,50,20,10,1],
'◎' => [414,50,20,10,1],
'◇' => [415,50,20,10,1],
'◆' => [416,50,20,10,1],
'□' => [417,50,20,10,1],
'■' => [418,50,20,10,1],
'△' => [419,50,20,10,1],
'▲' => [420,50,20,10,1],
'▽' => [421,50,20,10,1],
'▼' => [422,50,20,10,1],
'〒' => [423,50,20,10,1],
'→' => [424,50,20,10,1],
'←' => [425,50,20,10,1],
'↑' => [426,50,20,10,1],
'↓' => [427,50,20,10,1],
'♯' => [428,50,20,10,1],
'♭' => [429,50,20,10,1],
'♪' => [430,50,20,10,1],
'°' => [461,50,20,10,1],
'′' => [462,50,20,10,1],
'″' => [463,50,20,10,1],
'℃' => [464,50,20,10,1],
'\\' => [465,50,20,10,2],
'￥' => [465,50,20,10,5],
'$'  => [466,50,20,10,2],
'＄' => [466,50,20,10,5],
'¢' => [467,50,20,10,1],
'£' => [468,50,20,10,1],
'%'  => [469,50,20,10,2],
'％' => [469,50,20,10,5],
'‰' => [470,50,20,10,1],
'Å' => [471,50,20,10,1],
'0'  => [501,50,20,10,2],
'０' => [501,50,20,10,5],
'1'  => [502,50,20,10,2],
'１' => [502,50,20,10,5],
'2'  => [503,50,20,10,2],
'２' => [503,50,20,10,5],
'3'  => [504,50,20,10,2],
'３' => [504,50,20,10,5],
'4'  => [505,50,20,10,2],
'４' => [505,50,20,10,5],
'5'  => [506,50,20,10,2],
'５' => [506,50,20,10,5],
'6'  => [507,50,20,10,2],
'６' => [507,50,20,10,5],
'7'  => [508,50,20,10,2],
'７' => [508,50,20,10,5],
'8'  => [509,50,20,10,2],
'８' => [509,50,20,10,5],
'9'  => [510,50,20,10,2],
'９' => [510,50,20,10,5],
'α' => [601,50,20,10,1],
'β' => [602,50,20,10,1],
'γ' => [603,50,20,10,1],
'δ' => [604,50,20,10,1],
'ε' => [605,50,20,10,1],
'ζ' => [606,50,20,10,1],
'η' => [607,50,20,10,1],
'θ' => [608,50,20,10,1],
'ι' => [609,50,20,10,1],
'κ' => [610,50,20,10,1],
'λ' => [611,50,20,10,1],
'μ' => [612,50,20,10,1],
'ν' => [613,50,20,10,1],
'ξ' => [614,50,20,10,1],
'ο' => [615,50,20,10,1],
'π' => [616,50,20,10,1],
'ρ' => [617,50,20,10,1],
'σ' => [618,50,20,10,1],
'τ' => [619,50,20,10,1],
'υ' => [620,50,20,10,1],
'φ' => [621,50,20,10,1],
'χ' => [622,50,20,10,1],
'ψ' => [623,50,20,10,1],
'ω' => [624,50,20,10,1],
'Α' => [651,50,20,10,1],
'Β' => [652,50,20,10,1],
'Γ' => [653,50,20,10,1],
'Δ' => [654,50,20,10,1],
'Ε' => [655,50,20,10,1],
'Ζ' => [656,50,20,10,1],
'Η' => [657,50,20,10,1],
'Θ' => [658,50,20,10,1],
'Ι' => [659,50,20,10,1],
'Κ' => [660,50,20,10,1],
'Λ' => [661,50,20,10,1],
'Μ' => [662,50,20,10,1],
'Ν' => [663,50,20,10,1],
'Ξ' => [664,50,20,10,1],
'Ο' => [665,50,20,10,1],
'Π' => [666,50,20,10,1],
'Ρ' => [667,50,20,10,1],
'Σ' => [668,50,20,10,1],
'Τ' => [669,50,20,10,1],
'Υ' => [670,50,20,10,1],
'Φ' => [671,50,20,10,1],
'Χ' => [672,50,20,10,1],
'Ψ' => [673,50,20,10,1],
'Ω' => [674,50,20,10,1],
'а' => [701,50,20,10,1],
'б' => [702,50,20,10,1],
'в' => [703,50,20,10,1],
'г' => [704,50,20,10,1],
'д' => [705,50,20,10,1],
'е' => [706,50,20,10,1],
'ё' => [707,50,20,10,1],
'ж' => [708,50,20,10,1],
'з' => [709,50,20,10,1],
'и' => [710,50,20,10,1],
'й' => [711,50,20,10,1],
'к' => [712,50,20,10,1],
'л' => [713,50,20,10,1],
'м' => [714,50,20,10,1],
'н' => [715,50,20,10,1],
'о' => [716,50,20,10,1],
'п' => [717,50,20,10,1],
'р' => [718,50,20,10,1],
'с' => [719,50,20,10,1],
'т' => [720,50,20,10,1],
'у' => [721,50,20,10,1],
'ф' => [722,50,20,10,1],
'х' => [723,50,20,10,1],
'ц' => [724,50,20,10,1],
'ч' => [725,50,20,10,1],
'ш' => [726,50,20,10,1],
'щ' => [727,50,20,10,1],
'ъ' => [728,50,20,10,1],
'ы' => [729,50,20,10,1],
'ь' => [730,50,20,10,1],
'э' => [731,50,20,10,1],
'ю' => [732,50,20,10,1],
'я' => [733,50,20,10,1],
'А' => [751,50,20,10,1],
'Б' => [752,50,20,10,1],
'В' => [753,50,20,10,1],
'Г' => [754,50,20,10,1],
'Д' => [755,50,20,10,1],
'Е' => [756,50,20,10,1],
'Ё' => [757,50,20,10,1],
'Ж' => [758,50,20,10,1],
'З' => [759,50,20,10,1],
'И' => [760,50,20,10,1],
'Й' => [761,50,20,10,1],
'К' => [762,50,20,10,1],
'Л' => [763,50,20,10,1],
'М' => [764,50,20,10,1],
'Н' => [765,50,20,10,1],
'О' => [766,50,20,10,1],
'П' => [767,50,20,10,1],
'Р' => [768,50,20,10,1],
'С' => [769,50,20,10,1],
'Т' => [770,50,20,10,1],
'У' => [771,50,20,10,1],
'Ф' => [772,50,20,10,1],
'Х' => [773,50,20,10,1],
'Ц' => [774,50,20,10,1],
'Ч' => [775,50,20,10,1],
'Ш' => [776,50,20,10,1],
'Щ' => [777,50,20,10,1],
'Ъ' => [778,50,20,10,1],
(qw/Ы /)[0]
     => [779,50,20,10,1],
'Ь' => [780,50,20,10,1],
'Э' => [781,50,20,10,1],
'Ю' => [782,50,20,10,1],
'Я' => [783,50,20,10,1],
'a'  => [801,60,21,10,2],
'ａ' => [801,60,21,10,5],
'A'  => [801,60,22,10,2],
'Ａ' => [801,60,22,10,5],
'b'  => [802,60,21,10,2],
'ｂ' => [802,60,21,10,5],
'B'  => [802,60,22,10,2],
'Ｂ' => [802,60,22,10,5],
'c'  => [803,60,21,10,2],
'ｃ' => [803,60,21,10,5],
'C'  => [803,60,22,10,2],
'Ｃ' => [803,60,22,10,5],
'd'  => [804,60,21,10,2],
'ｄ' => [804,60,21,10,5],
'D'  => [804,60,22,10,2],
'Ｄ' => [804,60,22,10,5],
'e'  => [805,60,21,10,2],
'ｅ' => [805,60,21,10,5],
'E'  => [805,60,22,10,2],
'Ｅ' => [805,60,22,10,5],
'f'  => [806,60,21,10,2],
'ｆ' => [806,60,21,10,5],
'F'  => [806,60,22,10,2],
'Ｆ' => [806,60,22,10,5],
'g'  => [807,60,21,10,2],
'ｇ' => [807,60,21,10,5],
'G'  => [807,60,22,10,2],
'Ｇ' => [807,60,22,10,5],
'h'  => [808,60,21,10,2],
'ｈ' => [808,60,21,10,5],
'H'  => [808,60,22,10,2],
'Ｈ' => [808,60,22,10,5],
'i'  => [809,60,21,10,2],
'ｉ' => [809,60,21,10,5],
'I'  => [809,60,22,10,2],
'Ｉ' => [809,60,22,10,5],
'j'  => [810,60,21,10,2],
'ｊ' => [810,60,21,10,5],
'J'  => [810,60,22,10,2],
'Ｊ' => [810,60,22,10,5],
'k'  => [811,60,21,10,2],
'ｋ' => [811,60,21,10,5],
'K'  => [811,60,22,10,2],
'Ｋ' => [811,60,22,10,5],
'l'  => [812,60,21,10,2],
'ｌ' => [812,60,21,10,5],
'L'  => [812,60,22,10,2],
'Ｌ' => [812,60,22,10,5],
'm'  => [813,60,21,10,2],
'ｍ' => [813,60,21,10,5],
'M'  => [813,60,22,10,2],
'Ｍ' => [813,60,22,10,5],
'n'  => [814,60,21,10,2],
'ｎ' => [814,60,21,10,5],
'N'  => [814,60,22,10,2],
'Ｎ' => [814,60,22,10,5],
'o'  => [815,60,21,10,2],
'ｏ' => [815,60,21,10,5],
'O'  => [815,60,22,10,2],
'Ｏ' => [815,60,22,10,5],
'p'  => [816,60,21,10,2],
'ｐ' => [816,60,21,10,5],
'P'  => [816,60,22,10,2],
'Ｐ' => [816,60,22,10,5],
'q'  => [817,60,21,10,2],
'ｑ' => [817,60,21,10,5],
'Q'  => [817,60,22,10,2],
'Ｑ' => [817,60,22,10,5],
'r'  => [818,60,21,10,2],
'ｒ' => [818,60,21,10,5],
'R'  => [818,60,22,10,2],
'Ｒ' => [818,60,22,10,5],
's'  => [819,60,21,10,2],
'ｓ' => [819,60,21,10,5],
'S'  => [819,60,22,10,2],
'Ｓ' => [819,60,22,10,5],
't'  => [820,60,21,10,2],
'ｔ' => [820,60,21,10,5],
'T'  => [820,60,22,10,2],
'Ｔ' => [820,60,22,10,5],
'u'  => [821,60,21,10,2],
'ｕ' => [821,60,21,10,5],
'U'  => [821,60,22,10,2],
'Ｕ' => [821,60,22,10,5],
'v'  => [822,60,21,10,2],
'ｖ' => [822,60,21,10,5],
'V'  => [822,60,22,10,2],
'Ｖ' => [822,60,22,10,5],
'w'  => [823,60,21,10,2],
'ｗ' => [823,60,21,10,5],
'W'  => [823,60,22,10,2],
'Ｗ' => [823,60,22,10,5],
'x'  => [824,60,21,10,2],
'ｘ' => [824,60,21,10,5],
'X'  => [824,60,22,10,2],
'Ｘ' => [824,60,22,10,5],
'y'  => [825,60,21,10,2],
'ｙ' => [825,60,21,10,5],
'Y'  => [825,60,22,10,2],
'Ｙ' => [825,60,22,10,5],
'z'  => [826,60,21,10,2],
'ｚ' => [826,60,21,10,5],
'Z'  => [826,60,22,10,2],
'Ｚ' => [826,60,22,10,5],
'ぁ' => [901,70,32,16,3],
'ァ' => [901,70,32,17,3],
'ｧ'  => [901,70,32,17,4],
'あ' => [901,70,36,16,3],
'ア' => [901,70,36,17,3],
'ｱ'  => [901,70,36,17,4],
'ぃ' => [902,70,32,16,3],
'ィ' => [902,70,32,17,3],
'ｨ'  => [902,70,32,17,4],
'い' => [902,70,36,16,3],
'イ' => [902,70,36,17,3],
'ｲ'  => [902,70,36,17,4],
'ぅ' => [903,70,32,16,3],
'ゥ' => [903,70,32,17,3],
'ｩ'  => [903,70,32,17,4],
'う' => [903,70,36,16,3],
'ウ' => [903,70,36,17,3],
'ｳ'  => [903,70,36,17,4],
'ヴ' => [903,72,36,17,3],
'ｳﾞ' => [903,72,36,17,4],
'ぇ' => [904,70,32,16,3],
'ェ' => [904,70,32,17,3],
'ｪ'  => [904,70,32,17,4],
'え' => [904,70,36,16,3],
'エ' => [904,70,36,17,3],
'ｴ'  => [904,70,36,17,4],
'ぉ' => [905,70,32,16,3],
'ォ' => [905,70,32,17,3],
'ｫ'  => [905,70,32,17,4],
'お' => [905,70,36,16,3],
'オ' => [905,70,36,17,3],
'ｵ'  => [905,70,36,17,4],
'ヵ' => [911,70,32,17,3],
'か' => [911,70,36,16,3],
'カ' => [911,70,36,17,3],
'ｶ'  => [911,70,36,17,4],
'が' => [911,72,36,16,3],
'ガ' => [911,72,36,17,3],
'ｶﾞ' => [911,72,36,17,4],
'き' => [912,70,36,16,3],
'キ' => [912,70,36,17,3],
'ｷ'  => [912,70,36,17,4],
'ぎ' => [912,72,36,16,3],
'ギ' => [912,72,36,17,3],
'ｷﾞ' => [912,72,36,17,4],
'く' => [913,70,36,16,3],
'ク' => [913,70,36,17,3],
'ｸ'  => [913,70,36,17,4],
'ぐ' => [913,72,36,16,3],
'グ' => [913,72,36,17,3],
'ｸﾞ' => [913,72,36,17,4],
'ヶ' => [914,70,32,17,3],
'け' => [914,70,36,16,3],
'ケ' => [914,70,36,17,3],
'ｹ'  => [914,70,36,17,4],
'げ' => [914,72,36,16,3],
'ゲ' => [914,72,36,17,3],
'ｹﾞ' => [914,72,36,17,4],
'こ' => [915,70,36,16,3],
'コ' => [915,70,36,17,3],
'ｺ'  => [915,70,36,17,4],
'ご' => [915,72,36,16,3],
'ゴ' => [915,72,36,17,3],
'ｺﾞ' => [915,72,36,17,4],
'さ' => [921,70,36,16,3],
'サ' => [921,70,36,17,3],
'ｻ'  => [921,70,36,17,4],
'ざ' => [921,72,36,16,3],
'ザ' => [921,72,36,17,3],
'ｻﾞ' => [921,72,36,17,4],
'し' => [922,70,36,16,3],
'シ' => [922,70,36,17,3],
'ｼ'  => [922,70,36,17,4],
'じ' => [922,72,36,16,3],
'ジ' => [922,72,36,17,3],
'ｼﾞ' => [922,72,36,17,4],
'す' => [923,70,36,16,3],
'ス' => [923,70,36,17,3],
'ｽ'  => [923,70,36,17,4],
'ず' => [923,72,36,16,3],
'ズ' => [923,72,36,17,3],
'ｽﾞ' => [923,72,36,17,4],
'せ' => [924,70,36,16,3],
'セ' => [924,70,36,17,3],
'ｾ'  => [924,70,36,17,4],
'ぜ' => [924,72,36,16,3],
'ゼ' => [924,72,36,17,3],
'ｾﾞ' => [924,72,36,17,4],
'そ' => [925,70,36,16,3],
(qw/ソ /)[0]
     => [925,70,36,17,3],
'ｿ'  => [925,70,36,17,4],
'ぞ' => [925,72,36,16,3],
'ゾ' => [925,72,36,17,3],
'ｿﾞ' => [925,72,36,17,4],
'た' => [931,70,36,16,3],
'タ' => [931,70,36,17,3],
'ﾀ'  => [931,70,36,17,4],
'だ' => [931,72,36,16,3],
'ダ' => [931,72,36,17,3],
'ﾀﾞ' => [931,72,36,17,4],
'ち' => [932,70,36,16,3],
'チ' => [932,70,36,17,3],
'ﾁ'  => [932,70,36,17,4],
'ぢ' => [932,72,36,16,3],
'ヂ' => [932,72,36,17,3],
'ﾁﾞ' => [932,72,36,17,4],
'っ' => [933,70,32,16,3],
'ッ' => [933,70,32,17,3],
'ｯ'  => [933,70,32,17,4],
'つ' => [933,70,36,16,3],
'ツ' => [933,70,36,17,3],
'ﾂ'  => [933,70,36,17,4],
'づ' => [933,72,36,16,3],
'ヅ' => [933,72,36,17,3],
'ﾂﾞ' => [933,72,36,17,4],
'て' => [934,70,36,16,3],
'テ' => [934,70,36,17,3],
'ﾃ'  => [934,70,36,17,4],
'で' => [934,72,36,16,3],
'デ' => [934,72,36,17,3],
'ﾃﾞ' => [934,72,36,17,4],
'と' => [935,70,36,16,3],
'ト' => [935,70,36,17,3],
'ﾄ'  => [935,70,36,17,4],
'ど' => [935,72,36,16,3],
'ド' => [935,72,36,17,3],
'ﾄﾞ' => [935,72,36,17,4],
'な' => [941,70,36,16,3],
'ナ' => [941,70,36,17,3],
'ﾅ'  => [941,70,36,17,4],
'に' => [942,70,36,16,3],
'ニ' => [942,70,36,17,3],
'ﾆ'  => [942,70,36,17,4],
'ぬ' => [943,70,36,16,3],
'ヌ' => [943,70,36,17,3],
'ﾇ'  => [943,70,36,17,4],
'ね' => [944,70,36,16,3],
'ネ' => [944,70,36,17,3],
'ﾈ'  => [944,70,36,17,4],
'の' => [945,70,36,16,3],
'ノ' => [945,70,36,17,3],
'ﾉ'  => [945,70,36,17,4],
'は' => [951,70,36,16,3],
'ハ' => [951,70,36,17,3],
'ﾊ'  => [951,70,36,17,4],
'ば' => [951,72,36,16,3],
'バ' => [951,72,36,17,3],
'ﾊﾞ' => [951,72,36,17,4],
'ぱ' => [951,74,36,16,3],
'パ' => [951,74,36,17,3],
'ﾊﾟ' => [951,74,36,17,4],
'ひ' => [952,70,36,16,3],
'ヒ' => [952,70,36,17,3],
'ﾋ'  => [952,70,36,17,4],
'び' => [952,72,36,16,3],
'ビ' => [952,72,36,17,3],
'ﾋﾞ' => [952,72,36,17,4],
'ぴ' => [952,74,36,16,3],
'ピ' => [952,74,36,17,3],
'ﾋﾟ' => [952,74,36,17,4],
'ふ' => [953,70,36,16,3],
'フ' => [953,70,36,17,3],
'ﾌ'  => [953,70,36,17,4],
'ぶ' => [953,72,36,16,3],
'ブ' => [953,72,36,17,3],
'ﾌﾞ' => [953,72,36,17,4],
'ぷ' => [953,74,36,16,3],
'プ' => [953,74,36,17,3],
'ﾌﾟ' => [953,74,36,17,4],
'へ' => [954,70,36,16,3],
'ヘ' => [954,70,36,17,3],
'ﾍ'  => [954,70,36,17,4],
'べ' => [954,72,36,16,3],
'ベ' => [954,72,36,17,3],
'ﾍﾞ' => [954,72,36,17,4],
'ぺ' => [954,74,36,16,3],
'ペ' => [954,74,36,17,3],
'ﾍﾟ' => [954,74,36,17,4],
'ほ' => [955,70,36,16,3],
'ホ' => [955,70,36,17,3],
'ﾎ'  => [955,70,36,17,4],
'ぼ' => [955,72,36,16,3],
'ボ' => [955,72,36,17,3],
'ﾎﾞ' => [955,72,36,17,4],
'ぽ' => [955,74,36,16,3],
'ポ' => [955,74,36,17,3],
'ﾎﾟ' => [955,74,36,17,4],
'ま' => [961,70,36,16,3],
'マ' => [961,70,36,17,3],
'ﾏ'  => [961,70,36,17,4],
'み' => [962,70,36,16,3],
'ミ' => [962,70,36,17,3],
'ﾐ'  => [962,70,36,17,4],
'む' => [963,70,36,16,3],
'ム' => [963,70,36,17,3],
'ﾑ'  => [963,70,36,17,4],
'め' => [964,70,36,16,3],
'メ' => [964,70,36,17,3],
'ﾒ'  => [964,70,36,17,4],
'も' => [965,70,36,16,3],
'モ' => [965,70,36,17,3],
'ﾓ'  => [965,70,36,17,4],
'ゃ' => [971,70,32,16,3],
'ャ' => [971,70,32,17,3],
'ｬ'  => [971,70,32,17,4],
'や' => [971,70,36,16,3],
'ヤ' => [971,70,36,17,3],
'ﾔ'  => [971,70,36,17,4],
'ゅ' => [973,70,32,16,3],
'ュ' => [973,70,32,17,3],
'ｭ'  => [973,70,32,17,4],
'ゆ' => [973,70,36,16,3],
'ユ' => [973,70,36,17,3],
'ﾕ'  => [973,70,36,17,4],
'ょ' => [975,70,32,16,3],
'ョ' => [975,70,32,17,3],
'ｮ'  => [975,70,32,17,4],
'よ' => [975,70,36,16,3],
'ヨ' => [975,70,36,17,3],
'ﾖ'  => [975,70,36,17,4],
'ら' => [981,70,36,16,3],
'ラ' => [981,70,36,17,3],
'ﾗ'  => [981,70,36,17,4],
'り' => [982,70,36,16,3],
'リ' => [982,70,36,17,3],
'ﾘ'  => [982,70,36,17,4],
'る' => [983,70,36,16,3],
'ル' => [983,70,36,17,3],
'ﾙ'  => [983,70,36,17,4],
'れ' => [984,70,36,16,3],
'レ' => [984,70,36,17,3],
'ﾚ'  => [984,70,36,17,4],
'ろ' => [985,70,36,16,3],
'ロ' => [985,70,36,17,3],
'ﾛ'  => [985,70,36,17,4],
'ゎ' => [991,70,32,16,3],
'ヮ' => [991,70,32,17,3],
'わ' => [991,70,36,16,3],
'ワ' => [991,70,36,17,3],
'ﾜ'  => [991,70,36,17,4],
'ゐ' => [992,70,36,16,3],
'ヰ' => [992,70,36,17,3],
'ゑ' => [994,70,36,16,3],
'ヱ' => [994,70,36,17,3],
'を' => [995,70,36,16,3],
'ヲ' => [995,70,36,17,3],
'ｦ'  => [995,70,36,17,4],
'ん' => [996,70,36,16,3],
'ン' => [996,70,36,17,3],
'ﾝ'  => [996,70,36,17,4],
'ゝ' => [997,70,34,16,3],
'ヽ' => [997,70,34,17,3],
'ゞ' => [997,72,34,16,3],
'ヾ' => [997,72,34,17,3],
'ー' => [998,70,30,17,3],
'ｰ'  => [998,70,30,17,4],
'〃' => [1001,50,20,10,1],
'々' => [1002,50,20,10,1],
'仝' => [1003,50,20,10,1],
'〆' => [1004,50,20,10,1],
'〇' => [1005,50,20,10,1],
'〓' => [65534,50,20,10,1],
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
my @Replaced = qw( ー  ｰ  ゝ  ヽ  ゞ  ヾ );
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
    $c eq 'ー'
      ? [ $p%10 == 6 ? 996 : 900 + $p%10, 70,30,17,3 ]
    : $c eq 'ｰ'
      ? [ $p%10 == 6 ? 996 : 900 + $p%10, 70,30,17,4 ]
    : $c eq 'ゝ'
      ? [ $p, 70,34,16,3 ]
    : $c eq 'ヽ'
      ? [ $p, 70,34,17,3 ]
    : $c eq 'ゞ' && _hasDakuHiragana($p)
      ? [ $p, 72,34,16,3 ]
    : $c eq 'ヾ' && _hasDakuKatakana($p)
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

