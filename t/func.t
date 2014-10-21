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
 [qw/ ���� �L�c�l ���� ���ʂ� �l�R �˂��� �p���_ �Ђ傤 ���C�I�� /],
 [qw/ �f�[�^ �f�F�^ �f�G�^ �f�[�^�[ �f�[�^�@ �f�[�^�A
   �f�F�^�[ �f�F�^�@ �f�F�^�A �f�G�^�[ �f�G�^�@ �f�G�^�A /],
 [qw/ ���� ���� ���Ƃ� ���ǂ� ���Ƃ��� �T�g�[ ���Ƃ��� /],
 [qw/ �t�@�[�� �Ԃ��� �t�@�D�� �t�@�E�� �t�@�� �ӂ��� �t�A�� �Ԃ��� /],
 [qw/ ���傤 ���悤 ���傤 ���悤 ���傤�� ���傤�� ���悤��
      ���傤�� ���傤�� �V���[ �V���I �W���[ ���储�� �W���[�W /],
 [qw/���� ���� ���T�� ������ �����U�� ������ ������ /],
);

$s = 0;
for(@data){
  my %h;
  @h{ @$_ } =();
  $s ++ unless join(":", @$_) eq join(":", $Collator->sort(keys %h));
}
print ! $s ? "ok 2\n" : "not ok 2\n";

print $Collator->cmp("Perl", "�o������") == 0
   && $mod->new( level => 4 )->cmp("Perl", "�o������") == 0
   && $mod->new( level => 5 )->cmp("Perl", "�o������") == -1
    ? "ok 3\n" : "not ok 3\n";

print $Collator->cmp("PERL", "�o������") == 1
   && $mod->new( level => 3 )->cmp("PERL", "�o������") == 1
   && $mod->new( level => 2 )->cmp("PERL", "�o������") == 0
    ? "ok 4\n" : "not ok 4\n";

print $Collator->cmp("Perl", "�o�d�q�k") == -1
   && $mod->new( level => 3 )->cmp("Perl", "�o�d�q�k") == -1
   && $mod->new( level => 2 )->cmp("Perl", "�o�d�q�k") == 0
    ? "ok 5\n" : "not ok 5\n";

print $Collator->cmp("����������", "�A�C�E�G�I") == -1
   && $mod->new( level => 3 )->cmp("����������", "�A�C�E�G�I") == 0
   && $mod->new( katakana_before_hiragana => 1 )
          ->cmp("����������", "�A�C�E�G�I") == 1
   && $mod->new( katakana_before_hiragana => 1,
            level => 3 )->cmp("����������", "�A�C�E�G�I") == 0
   && $Collator->cmp("perl", "PERL") == -1
   && $mod->new( level => 2 )->cmp("perl", "PERL") == 0
   && $mod->new( upper_before_lower => 1 )
          ->cmp("perl", "PERL") == 1
   && $mod->new( upper_before_lower => 1,
            level => 2 )->cmp("perl", "PERL") == 0

    ? "ok 6\n" : "not ok 6\n";

print $Collator->cmp("�����", "�A�C�E�G�I") == 0
   && $mod->new( level => 5 )->cmp("�����", "�A�C�E�G�I") == 1
    ? "ok 7\n" : "not ok 7\n";

print $Collator->cmp("XYZ", "abc") == 1
   && $mod->new( level => 1 )->cmp("XYZ", "abc") == 1
    ? "ok 8\n" : "not ok 8\n";

print $Collator->cmp("XYZ", "ABC") == 1
   && $Collator->cmp("xyz", "ABC") == 1
    ? "ok 9\n" : "not ok 9\n";

print $Collator->gt("����", "���T")
   && $Collator->ge("����", "���T")
   && $Collator->ne("����", "���T")
   && $mod->new( level => 3 )->gt("����", "���T")
   && $mod->new( level => 3 )->ge("����", "���T")
   && $mod->new( level => 3 )->ne("����", "���T")
   && $mod->new( level => 3 )->lt("����", "���T")
   && $mod->new( level => 3 )->le("����", "���T")
   && $mod->new( level => 3 )->ne("����", "���T")
   && $mod->new( level => 2 )->eq("����", "���T")
   && $mod->new( level => 2 )->ge("����", "���T")
   && $mod->new( level => 2 )->le("����", "���T")
   && $mod->new( level => 1 )->lt("����", "���U")
   && $mod->new( level => 1 )->le("����", "���U")
   && $mod->new( level => 1 )->ne("����", "���U")
   && $mod->new( level => 2 )->gt("����", "���T")
   && $mod->new( level => 2 )->ge("����", "���T")
   && $mod->new( level => 2 )->ne("����", "���T")
   && $mod->new( level => 2 )->eq("����", "���U")
   && $mod->new( level => 2 )->ge("����", "���U")
   && $mod->new( level => 2 )->le("����", "���U")
   && $mod->new( level => 1 )->eq("����", "���T")
   && $mod->new( level => 1 )->ge("����", "���T")
   && $mod->new( level => 1 )->le("����", "���T")
    ? "ok 10\n" : "not ok 10\n";

print $Collator->cmp("�p�A��", "�p�[��") == 1
   && $mod->new( level => 3 )->cmp("�p�A��", "�p�[��") == 1
   && $mod->new( level => 3 )->cmp("�p�@��", "�p�[��") == 1
   && $mod->new( level => 2 )->cmp("�p�A��", "�p�[��") == 0
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

print $Collator->cmp('�`', '��') == -1
   && $mod->new( level => 1, kanji => 1 )->cmp('�`', '��') == 1
   && $mod->new( level => 1, kanji => 2 )->cmp('�`', '��', 1, 2) == -1
   && $mod->new( level => 1, kanji => 0 )->cmp('��', '��', 1, 0) == -1
   && $mod->new( level => 1, kanji => 1 )->cmp('��', '��', 1, 1) == 0
   && $mod->new( level => 1, kanji => 2 )->cmp('��', '��', 1, 2) == -1
   && $Collator->cmp('��', '�') == 1
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

  $sorted  = '�p�C�i�b�v�� �n�b�g �͂� �o�[�i�[ �o�i�i �p�[�� �p���f�B';
  @subject = qw(�p���f�B �p�C�i�b�v�� �o�i�i �n�b�g �͂� �p�[�� �o�[�i�[);

  print
      $sorted eq join(' ', $ignore_prolong->sort(@subject))
   && $sorted eq join(' ', $delete_prolong->sort(@subject))
   && $level2->cmp("�p�A��", "�p�[��") == 0
   && $level3->cmp("�p�A��", "�p�[��") == 1
   && $level3->cmp("�p�@��", "�p�[��") == 1
   && $level4->cmp("�߰�",   "�p�[��") == 0
   && $level5->cmp("�p�[��", "�߰�",4) == -1
   && $level2->cmp("�p�p", "�ς�") == 0
   && $jis->cmp("�p�p", "�ς�") == 1
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
