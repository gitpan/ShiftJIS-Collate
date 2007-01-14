use strict;
use vars qw($i $loaded $num $comp $cord $data $order $class);
BEGIN {
  use ShiftJIS::Collate;
  $| = 1;
  $num = 1 + 3 * (1 + 24 + 22 + 45 + 30 + 11 + 10 + 114 + 52 + 174 + 5 + 1);
  print "1..$num\n";
}
END {print "not ok 1\n" unless $loaded;}

$loaded = 1;
print "ok 1\n";

my $Collator  = new ShiftJIS::Collate;
my $ColLevel1 = new ShiftJIS::Collate(level => 1);

$comp = '';
$cord = '0-0';

while (<DATA>) {
  if (/^(..)# ((\d+)\-\d+)/) {
    $data = $1;
    $order = $2;
    $class = $3;

    print $Collator->lt($comp,$data)
      ? "ok" : "not ok", " ", ++$loaded, "\n";

    if ($cord eq $order) {
      print $ColLevel1->eq($comp,$data)
        ? "ok" : "not ok", " ", ++$loaded, "\n";
    } else {
      print $ColLevel1->lt($comp,$data)
        ? "ok" : "not ok", " ", ++$loaded, "\n";
    }

    print $Collator->getClass($data) == $class
      ? "ok" : "not ok", " ", ++$loaded, "\n";
  }

  $comp = $data;
  $cord = $order;
};

1;
__DATA__
�@# 1-1
�A# 2-1
�B# 2-2
�C# 2-3
�D# 2-4
�E# 2-5
�F# 2-6
�G# 2-7
�H# 2-8
�I# 2-9
�L# 2-91 added
�M# 2-92 added
�N# 2-93 added
�O# 2-94 added
�P# 2-10
�Q# 2-11
�\# 2-12
�]# 2-13
�^# 2-14
�_# 2-15
�`# 2-16
�a# 2-17
�b# 2-18
�c# 2-19
�d# 2-20
�e# 3-1
�f# 3-2
�g# 3-3
�h# 3-4
�i# 3-5
�j# 3-6
�k# 3-7
�l# 3-8
�m# 3-9
�n# 3-10
�o# 3-11
�p# 3-12
�q# 3-13
�r# 3-14
�s# 3-15
�t# 3-16
�u# 3-17
�v# 3-18
�w# 3-19
�x# 3-20
�y# 3-21
�z# 3-22
�{# 4-1
�|# 4-2
�}# 4-3
�~# 4-4
��# 4-5
��# 4-6
��# 4-7
��# 4-8
��# 4-9
��# 4-10
��# 4-11
��# 4-12
��# 4-13
��# 4-14
��# 4-15
��# 4-16
��# 4-17
��# 4-18
��# 4-19
��# 4-20
��# 4-21
��# 4-22
��# 4-23
��# 4-24
��# 4-25
��# 4-26
��# 4-27
��# 4-28
��# 4-29
��# 4-30
��# 4-31
��# 4-32
��# 4-33
��# 4-34
��# 4-35
��# 4-36
��# 4-37
��# 4-38
��# 4-39
��# 4-40
��# 4-41
��# 4-42
��# 4-43
��# 4-44
��# 4-45
��# 5-1
��# 5-2
��# 5-3
��# 5-4
��# 5-5
��# 5-6
��# 5-7
��# 5-8
��# 5-9
��# 5-10
��# 5-11
��# 5-12
��# 5-13
��# 5-14
��# 5-15
��# 5-16
��# 5-17
��# 5-18
��# 5-19
��# 5-20
��# 5-21
��# 5-22
��# 5-23
��# 5-24
��# 5-25
��# 5-26
��# 5-27
��# 5-28
��# 5-29
��# 5-30
��# 6-1
��# 6-2
��# 6-3
��# 6-4
��# 6-5
��# 6-6
��# 6-7
��# 6-8
��# 6-9
��# 6-10
��# 6-11
�O# 7-1
�P# 7-2
�Q# 7-3
�R# 7-4
�S# 7-5
�T# 7-6
�U# 7-7
�V# 7-8
�W# 7-9
�X# 7-10
��# 8-1
��# 8-2
��# 8-3
��# 8-4
��# 8-5
��# 8-6
��# 8-7
��# 8-8
��# 8-9
��# 8-10
��# 8-11
��# 8-12
��# 8-13
��# 8-14
��# 8-15
��# 8-16
��# 8-17
��# 8-18
��# 8-19
��# 8-20
��# 8-21
��# 8-22
��# 8-23
��# 8-24
��# 8-25
��# 8-26
��# 8-27
��# 8-28
��# 8-29
��# 8-30
��# 8-31
��# 8-32
��# 8-33
��# 8-34
��# 8-35
��# 8-36
��# 8-37
��# 8-38
��# 8-39
��# 8-40
��# 8-41
��# 8-42
��# 8-43
��# 8-44
��# 8-45
��# 8-46
��# 8-47
��# 8-48
�p# 8-49
�q# 8-50
�r# 8-51
�s# 8-52
�t# 8-53
�u# 8-54
�v# 8-55
�w# 8-56
�x# 8-57
�y# 8-58
�z# 8-59
�{# 8-60
�|# 8-61
�}# 8-62
�~# 8-63
��# 8-64
��# 8-65
��# 8-66
��# 8-67
��# 8-68
��# 8-69
��# 8-70
��# 8-71
��# 8-72
��# 8-73
��# 8-74
��# 8-75
��# 8-76
��# 8-77
��# 8-78
��# 8-79
��# 8-80
��# 8-81
�@# 8-82
�A# 8-83
�B# 8-84
�C# 8-85
�D# 8-86
�E# 8-87
�F# 8-88
�G# 8-89
�H# 8-90
�I# 8-91
�J# 8-92
�K# 8-93
�L# 8-94
�M# 8-95
�N# 8-96
�O# 8-97
�P# 8-98
�Q# 8-99
�R# 8-100
�S# 8-101
�T# 8-102
�U# 8-103
�V# 8-104
�W# 8-105
�X# 8-106
�Y# 8-107
�Z# 8-108
�[# 8-109
�\# 8-110
�]# 8-111
�^# 8-112
�_# 8-113
�`# 8-114
��# 9-1-1
�`# 9-1-2
��# 9-2-1
�a# 9-2-2
��# 9-3-1
�b# 9-3-2
��# 9-4-1
�c# 9-4-2
��# 9-5-1
�d# 9-5-2
��# 9-6-1
�e# 9-6-2
��# 9-7-1
�f# 9-7-2
��# 9-8-1
�g# 9-8-2
��# 9-9-1
�h# 9-9-2
��# 9-10-1
�i# 9-10-2
��# 9-11-1
�j# 9-11-2
��# 9-12-1
�k# 9-12-2
��# 9-13-1
�l# 9-13-2
��# 9-14-1
�m# 9-14-2
��# 9-15-1
�n# 9-15-2
��# 9-16-1
�o# 9-16-2
��# 9-17-1
�p# 9-17-2
��# 9-18-1
�q# 9-18-2
��# 9-19-1
�r# 9-19-2
��# 9-20-1
�s# 9-20-2
��# 9-21-1
�t# 9-21-2
��# 9-22-1
�u# 9-22-2
��# 9-23-1
�v# 9-23-2
��# 9-24-1
�w# 9-24-2
��# 9-25-1
�x# 9-25-2
��# 9-26-1
�y# 9-26-2
��# 10-1-1
�@# 10-1-2
��# 10-1-3
�A# 10-1-4
��# 10-2-1
�B# 10-2-2
��# 10-2-3
�C# 10-2-4
��# 10-3-1
�D# 10-3-2
��# 10-3-3
�E# 10-3-4
��# 10-3-5
��# 10-4-1
�F# 10-4-2
��# 10-4-3
�G# 10-4-4
��# 10-5-1
�H# 10-5-2
��# 10-5-3
�I# 10-5-4
��# 10-6-1
��# 10-6-2
�J# 10-6-3
��# 10-6-4
�K# 10-6-5
��# 10-7-1
�L# 10-7-2
��# 10-7-3
�M# 10-7-4
��# 10-8-1
�N# 10-8-2
��# 10-8-3
�O# 10-8-4
��# 10-9-1
��# 10-9-2
�P# 10-9-3
��# 10-9-4
�Q# 10-9-5
��# 10-10-1
�R# 10-10-2
��# 10-10-3
�S# 10-10-4
��# 10-11-1
�T# 10-11-2
��# 10-11-3
�U# 10-11-4
��# 10-12-1
�V# 10-12-2
��# 10-12-3
�W# 10-12-4
��# 10-13-1
�X# 10-13-2
��# 10-13-3
�Y# 10-13-4
��# 10-14-1
�Z# 10-14-2
��# 10-14-3
�[# 10-14-4
��# 10-15-1
�\# 10-15-2
��# 10-15-3
�]# 10-15-4
��# 10-16-1
�^# 10-16-2
��# 10-16-3
�_# 10-16-4
��# 10-17-1
�`# 10-17-2
��# 10-17-3
�a# 10-17-4
��# 10-18-1
�b# 10-18-2
��# 10-18-3
�c# 10-18-4
��# 10-18-5
�d# 10-18-6
��# 10-19-1
�e# 10-19-2
��# 10-19-3
�f# 10-19-4
��# 10-20-1
�g# 10-20-2
��# 10-20-3
�h# 10-20-4
��# 10-21-1
�i# 10-21-2
��# 10-22-1
�j# 10-22-2
��# 10-23-1
�k# 10-23-2
��# 10-24-1
�l# 10-24-2
��# 10-25-1
�m# 10-25-2
��# 10-26-1
�n# 10-26-2
��# 10-26-3
�o# 10-26-4
��# 10-26-5
�p# 10-26-6
��# 10-27-1
�q# 10-27-2
��# 10-27-3
�r# 10-27-4
��# 10-27-5
�s# 10-27-6
��# 10-28-1
�t# 10-28-2
��# 10-28-3
�u# 10-28-4
��# 10-28-5
�v# 10-28-6
��# 10-29-1
�w# 10-29-2
��# 10-29-3
�x# 10-29-4
��# 10-29-5
�y# 10-29-6
��# 10-30-1
�z# 10-30-2
��# 10-30-3
�{# 10-30-4
��# 10-30-5
�|# 10-30-6
��# 10-31-1
�}# 10-31-2
��# 10-32-1
�~# 10-32-2
��# 10-33-1
��# 10-33-2
��# 10-34-1
��# 10-34-2
��# 10-35-1
��# 10-35-2
��# 10-36-1
��# 10-36-2
��# 10-36-3
��# 10-36-4
��# 10-37-1
��# 10-37-2
��# 10-37-3
��# 10-37-4
��# 10-38-1
��# 10-38-2
��# 10-38-3
��# 10-38-4
��# 10-39-1
��# 10-39-2
��# 10-40-1
��# 10-40-2
��# 10-41-1
��# 10-41-2
��# 10-42-1
��# 10-42-2
��# 10-43-1
��# 10-43-2
��# 10-44-1
��# 10-44-2
��# 10-44-3
��# 10-44-4
��# 10-45-1
��# 10-45-2
��# 10-46-1
��# 10-46-2
��# 10-47-1
��# 10-47-2
��# 10-48-1
��# 10-48-2
�T# 10-49-1
�R# 10-49-2
�U# 10-49-3
�S# 10-49-4
�[# 10-50-1
�V# 11-1
�W# 11-2
�X# 11-3
�Y# 11-4
�Z# 11-5
��# 12-1