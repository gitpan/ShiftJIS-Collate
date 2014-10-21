# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

use strict;
use vars qw($loaded);
$^W = 1;

BEGIN { $| = 1; print "1..15\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::Collate;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

my ($mod, $k, $kstr, $match, @tmp, @pos);
$mod = "ShiftJIS::Collate";
$kstr = "* �Ђ炪��  �ƃJ�^�J�i�̓��x���R�ł͓��������ȁB";
$k = "����";

@pos = (position_in_bytes => 1);

if (@tmp = $mod->new(@pos, level => 1)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
print $match eq '����' ? "ok" : "not ok", " 2\n";

if (@tmp = $mod->new(@pos, level => 2)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
  print $match eq '�J�i' ? "ok" : "not ok", " 3\n";

if (@tmp = $mod->new(@pos, level => 3)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
print $match eq '�J�i' ? "ok" : "not ok", " 4\n";

if (@tmp = $mod->new(@pos, level => 4)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
print $match eq '����' ? "ok" : "not ok", " 5\n";

if (@tmp = $mod->new(@pos, level => 5)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
print $match eq '����' ? "ok" : "not ok", " 6\n";

$kstr = "* �Ђ�ނ�  �ƃJ�^�J�i�̓��x���R�ł͓��������ȁB";
$k = "����";

if (@tmp = $mod->new(@pos, level => 1)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
print $match eq '�ނ�' ? "ok" : "not ok", " 7\n";

$kstr = "* �Ђ炪�ȂƃJ�^�J�i�̓��x���R�ł͓��������ȁB";
$k = "���";

if (@tmp = $mod->new(@pos, level => 1)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
print $match eq '����' ? "ok" : "not ok", " 8\n";

$kstr = "* �Ђ炪�ȂƃJ�^�J�i�̓��x���R�ł͓��������ȁB";
$k = "���";

$match = undef;
if (@tmp = $mod->new(@pos, level => 4)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
print ! defined $match ? "ok" : "not ok", " 9\n";

$kstr = '�p�[���v���O���~���O';
$k = '�A����';

$match = undef;
if (@tmp = $mod->new(@pos, level => 1)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
print $match eq '�[���v' ? "ok" : "not ok", " 10\n";

$match = undef;
if (@tmp = $mod->new(@pos, level => 3)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
print ! defined $match ? "ok" : "not ok", " 11\n";

$kstr = '�߰���۸���ݸ�'; # '��' is a single grapheme.
$k = '��۸';

$match = undef;
if (@tmp = $mod->new(@pos, level => 1)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
print $match eq '��۸�' ? "ok" : "not ok", " 12\n";

$match = undef;
if (@tmp = $mod->new(@pos, level => 2)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
print ! defined $match ? "ok" : "not ok", " 13\n";


$kstr = '�߰���۸���ݸ�';
$k = '�۸';
# '�' is treated as a grapheme only when it can't combin with preceding kana.
# but it's ignorable.

$match = undef;
if (@tmp = $mod->new(@pos, level => 1)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
print $match eq '۸�' ? "ok" : "not ok", " 14\n";

$kstr = '�߰ق��۸���ݸ�';
$k = '�۸';

$match = undef;
if (@tmp = $mod->new(@pos, level => 1)->index($kstr, $k)) {
    $match = substr($kstr, $tmp[0], $tmp[1]);
}
print $match eq '۸�' ? "ok" : "not ok", " 15\n";
