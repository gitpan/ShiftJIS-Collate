# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

use strict;
use vars qw($loaded);
$^W = 1;

BEGIN { $| = 1; print "1..17\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::Collate;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

my $mod = "ShiftJIS::Collate";

my $Collator = $mod->new();

my $s;

my @data = (
 [qw/ いぬ キツネ さる たぬき ネコ ねずみ パンダ ひょう ライオン /],
 [qw/ データ デェタ デエタ データー データァ データア
   デェター デェタァ デェタア デエター デエタァ デエタア /],
 [qw/ さと さど さとう さどう さとうや サトー さとおや /],
 [qw/ ファール ぶあい ファゥル ファウル ファン ふあん フアン ぶあん /],
 [qw/ しょう しよう じょう じよう しょうし しょうじ しようじ
      じょうし じょうじ ショー ショオ ジョー じょおう ジョージ /],
 [qw/すす すず すゝき すすき す┼ゞき すずき すずこ /],
);

$s = 0;
for(@data){
  my %h;
  @h{ @$_ } =();
  $s ++ unless join(":", @$_) eq join(":", $Collator->sort(keys %h));
}
print ! $s ? "ok 2\n" : "not ok 2\n";

print $Collator->cmp("Perl", "Ｐｅｒｌ") == 0
   && $mod->new( level => 4 )->cmp("Perl", "Ｐｅｒｌ") == 0
   && $mod->new( level => 5 )->cmp("Perl", "Ｐｅｒｌ") == -1
    ? "ok 3\n" : "not ok 3\n";

print $Collator->cmp("PERL", "Ｐｅｒｌ") == 1
   && $mod->new( level => 3 )->cmp("PERL", "Ｐｅｒｌ") == 1
   && $mod->new( level => 2 )->cmp("PERL", "Ｐｅｒｌ") == 0
    ? "ok 4\n" : "not ok 4\n";

print $Collator->cmp("Perl", "ＰＥＲＬ") == -1
   && $mod->new( level => 3 )->cmp("Perl", "ＰＥＲＬ") == -1
   && $mod->new( level => 2 )->cmp("Perl", "ＰＥＲＬ") == 0
    ? "ok 5\n" : "not ok 5\n";

print $Collator->cmp("あいうえお", "アイウエオ") == -1
   && $mod->new( level => 3 )->cmp("あいうえお", "アイウエオ") == 0
   && $mod->new( katakana_before_hiragana => 1 )
          ->cmp("あいうえお", "アイウエオ") == 1
   && $mod->new( katakana_before_hiragana => 1,
            level => 3 )->cmp("あいうえお", "アイウエオ") == 0
   && $Collator->cmp("perl", "PERL") == -1
   && $mod->new( level => 2 )->cmp("perl", "PERL") == 0
   && $mod->new( upper_before_lower => 1 )
          ->cmp("perl", "PERL") == 1
   && $mod->new( upper_before_lower => 1,
            level => 2 )->cmp("perl", "PERL") == 0

    ? "ok 6\n" : "not ok 6\n";

print $Collator->cmp("ｱｲｳｴｵ", "アイウエオ") == 0
   && $mod->new( level => 5 )->cmp("ｱｲｳｴｵ", "アイウエオ") == 1
    ? "ok 7\n" : "not ok 7\n";

print $Collator->cmp("XYZ", "abc") == 1
   && $mod->new( level => 1 )->cmp("XYZ", "abc") == 1
    ? "ok 8\n" : "not ok 8\n";

print $Collator->cmp("XYZ", "ABC") == 1
   && $Collator->cmp("xyz", "ABC") == 1
    ? "ok 9\n" : "not ok 9\n";

print $Collator->gt("ああ", "あゝ")
   && $Collator->ge("ああ", "あゝ")
   && $Collator->ne("ああ", "あゝ")
   && $mod->new( level => 3 )->gt("ああ", "あゝ")
   && $mod->new( level => 3 )->ge("ああ", "あゝ")
   && $mod->new( level => 3 )->ne("ああ", "あゝ")
   && $mod->new( level => 3 )->lt("あぁ", "あゝ")
   && $mod->new( level => 3 )->le("あぁ", "あゝ")
   && $mod->new( level => 3 )->ne("あぁ", "あゝ")
   && $mod->new( level => 2 )->eq("ああ", "あゝ")
   && $mod->new( level => 2 )->ge("ああ", "あゝ")
   && $mod->new( level => 2 )->le("ああ", "あゝ")
   && $mod->new( level => 1 )->lt("ああ", "あゞ")
   && $mod->new( level => 1 )->le("ああ", "あゞ")
   && $mod->new( level => 1 )->ne("ああ", "あゞ")
   && $mod->new( level => 2 )->gt("ただ", "たゝ")
   && $mod->new( level => 2 )->ge("ただ", "たゝ")
   && $mod->new( level => 2 )->ne("ただ", "たゝ")
   && $mod->new( level => 2 )->eq("ただ", "たゞ")
   && $mod->new( level => 2 )->ge("ただ", "たゞ")
   && $mod->new( level => 2 )->le("ただ", "たゞ")
   && $mod->new( level => 1 )->eq("ただ", "たゝ")
   && $mod->new( level => 1 )->ge("ただ", "たゝ")
   && $mod->new( level => 1 )->le("ただ", "たゝ")
    ? "ok 10\n" : "not ok 10\n";

print $Collator->cmp("パアル", "パール") == 1
   && $mod->new( level => 3 )->cmp("パアル", "パール") == 1
   && $mod->new( level => 3 )->cmp("パァル", "パール") == 1
   && $mod->new( level => 2 )->cmp("パアル", "パール") == 0
    ? "ok 11\n" : "not ok 11\n";

print $Collator->cmp("", "") == 0
   && $mod->new( level => 1 )->cmp("", "") == 0
   && $mod->new( level => 2 )->cmp("", "") == 0
   && $mod->new( level => 3 )->cmp("", "") == 0
   && $mod->new( level => 4 )->cmp("", "") == 0
   && $mod->new( level => 5 )->cmp("", "") == 0
   && $Collator->cmp("", " ")  == -1
   && $Collator->cmp("", "\n") == 0
   && $Collator->cmp("\n ", "\n \r") == 0
   && $Collator->cmp(" ", "\n \r") == 0
    ? "ok 12\n" : "not ok 12\n";

print $Collator->cmp('Ａ', '亜') == -1
   && $mod->new( level => 1, kanji => 1 )->cmp('Ａ', '亜') == 1
   && $mod->new( level => 1, kanji => 2 )->cmp('Ａ', '亜', 1, 2) == -1
   && $mod->new( level => 1, kanji => 0 )->cmp('亜', '一', 1, 0) == -1
   && $mod->new( level => 1, kanji => 1 )->cmp('亜', '一', 1, 1) == 0
   && $mod->new( level => 1, kanji => 2 )->cmp('亜', '一', 1, 2) == -1
   && $Collator->cmp('〓', '熙') == 1
    ? "ok 13\n" : "not ok 13\n";

{
  my(@subject, $sorted);

  my $delProlong = sub {
      my $str = shift;
      $str =~ s/\G(
	(?:[\x00-\x7F\xA1-\xDF]|[\x81-\x9F\xE0-\xFC][\x40-\x7E\x80-\xFC])*?
	)\x81\x5B/$1/gox;
      $str;
    };

  my $delete_prolong = $mod->new(preprocess => $delProlong);

  my $ignore_prolong = $mod->new(ignoreChar => '^(?:\x81\x5B|\xB0)');

  my $jis    = new ShiftJIS::Collate;
  my $level2 = new ShiftJIS::Collate level => 2;
  my $level3 = new ShiftJIS::Collate level => 3;
  my $level4 = new ShiftJIS::Collate level => 4;
  my $level5 = new ShiftJIS::Collate level => 5;

  $sorted  = 'パイナップル ハット はな バーナー バナナ パール パロディ';
  @subject = qw(パロディ パイナップル バナナ ハット はな パール バーナー);

  print
      $sorted eq join(' ', $ignore_prolong->sort(@subject))
   && $sorted eq join(' ', $delete_prolong->sort(@subject))
   && $level2->cmp("パアル", "パール") == 0
   && $level3->cmp("パアル", "パール") == 1
   && $level3->cmp("パァル", "パール") == 1
   && $level4->cmp("ﾊﾟｰﾙ",   "パール") == 0
   && $level5->cmp("パール", "ﾊﾟｰﾙ",4) == -1
   && $level2->cmp("パパ", "ぱぱ") == 0
   && $jis->cmp("パパ", "ぱぱ") == 1
    ? "ok 14\n" : "not ok 14\n";
}


{
  my @hira = map "\x82".chr, 0x9F .. 0xF1;
  my @kata = map "\x83".chr, 0x40 .. 0x7E, 0x80 .. 0x96;
  my $i;

  my $jis = new ShiftJIS::Collate;
  my $kbh = new ShiftJIS::Collate katakana_before_hiragana => 1;
  my $lv3 = new ShiftJIS::Collate level => 3;

  for($i = 0; $i < @hira; $i++) {
    last unless $jis->le($hira[$i], $kata[$i]);
    last unless $kbh->ge($hira[$i], $kata[$i]);
    last unless $lv3->eq($hira[$i], $kata[$i]);
  }

  print $i == @hira ? "ok 15\n" : "not ok 15\n";
}

{
  my @lower = map "\x82".chr, 0x81 .. 0x9A;
  my @upper = map "\x82".chr, 0x60 .. 0x79;
  my $i;

  my $jis = new ShiftJIS::Collate;
  my $ubl = new ShiftJIS::Collate upper_before_lower => 1;
  my $lv2 = new ShiftJIS::Collate level => 2;
  my $lv3 = new ShiftJIS::Collate level => 3;
  my $ul3 = new ShiftJIS::Collate level => 3, upper_before_lower => 1;

  for($i = 0; $i < @lower; $i++) {
    last unless $jis->le($lower[$i], $upper[$i]);
    last unless $ubl->ge($lower[$i], $upper[$i]);
    last unless $lv2->eq($lower[$i], $upper[$i]);
    last unless $lv3->le($lower[$i], $upper[$i]);
    last unless $ul3->ge($lower[$i], $upper[$i]);
  }

  print $i == @lower ? "ok 16\n" : "not ok 16\n";
}

my $obs; # 'overrideCJK' is obsolete and to be croaked.
eval { $obs = new ShiftJIS::Collate overrideCJK => sub {}, level => 3; };

print $@ ? "ok 17\n" : "not ok 17\n";
