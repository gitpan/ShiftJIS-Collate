# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

use strict;
use vars qw($loaded);
$^W = 1;

BEGIN { $| = 1; print "1..11\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::Collate;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

my $mod = "ShiftJIS::Collate";

my $str = "* �Ђ炪��  �ƃJ�^�J�i�̓��x���R�ł͓��������ȁB";
my $sub = "����";
my $match;

my @tmp;
my @pos = (position_in_bytes => 1);

if(@tmp = $mod->new(@pos, level => 1)->index($str, $sub))
{
  $match = substr($str, $tmp[0], $tmp[1]);
}
print $match eq '����' ? "ok" : "not ok", " 2\n";

if(@tmp = $mod->new(@pos, level => 2)->index($str, $sub))
{
  $match = substr($str, $tmp[0], $tmp[1]);
}
print $match eq '�J�i' ? "ok" : "not ok", " 3\n";

if(@tmp = $mod->new(@pos, level => 3)->index($str, $sub))
{
  $match = substr($str, $tmp[0], $tmp[1]);
}
print $match eq '�J�i' ? "ok" : "not ok", " 4\n";

if(@tmp = $mod->new(@pos, level => 4)->index($str, $sub))
{
  $match = substr($str, $tmp[0], $tmp[1]);
}
print $match eq '����' ? "ok" : "not ok", " 5\n";

if(@tmp = $mod->new(@pos, level => 5)->index($str, $sub))
{
  $match = substr($str, $tmp[0], $tmp[1]);
}
print $match eq '����' ? "ok" : "not ok", " 6\n";

$str = "* �Ђ�ނ�  �ƃJ�^�J�i�̓��x���R�ł͓��������ȁB";
$sub = "����";

if(@tmp = $mod->new(@pos, level => 1)->index($str, $sub))
{
  $match = substr($str, $tmp[0], $tmp[1]);
}
print $match eq '�ނ�' ? "ok" : "not ok", " 7\n";

$str = "* �Ђ炪�ȂƃJ�^�J�i�̓��x���R�ł͓��������ȁB";
$sub = "���";

if(@tmp = $mod->new(@pos, level => 1)->index($str, $sub))
{
  $match = substr($str, $tmp[0], $tmp[1]);
}
print $match eq '����' ? "ok" : "not ok", " 8\n";

$str = "* �Ђ炪�ȂƃJ�^�J�i�̓��x���R�ł͓��������ȁB";
$sub = "���";

$match = undef;
if(@tmp = $mod->new(@pos, level => 4)->index($str, $sub))
{
  $match = substr($str, $tmp[0], $tmp[1]);
}
print ! defined $match ? "ok" : "not ok", " 9\n";

$str = '�p�[���v���O���~���O';
$sub = '�A����';

$match = undef;
if(@tmp = $mod->new(@pos, level => 1)->index($str, $sub))
{
  $match = substr($str, $tmp[0], $tmp[1]);
}
print $match eq '�[���v' ? "ok" : "not ok", " 10\n";

$match = undef;
if(@tmp = $mod->new(@pos, level => 3)->index($str, $sub))
{
  $match = substr($str, $tmp[0], $tmp[1]);
}
print ! defined $match ? "ok" : "not ok", " 11\n";
