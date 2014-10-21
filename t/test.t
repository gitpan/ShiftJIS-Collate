use strict;
use vars qw($i $loaded $num);
BEGIN {
  use ShiftJIS::Collate;
  $| = 1;
  $num = 10 + 1;
  print "1..$num\n";
}
END {print "not ok 1\n" unless $loaded;}

$loaded = 1;
print "ok 1\n";

my $Collator = new ShiftJIS::Collate;

chomp(my @data = <DATA>);
unshift @data, "";
my $data = join ":",@data;

for $i (2..$num){
  my @arr  = shuffle(@data);
  my $arr  = join ":",@arr;
  my @sort = $Collator->sort(@arr);
  my $sort = join ":",@sort;
  print $sort eq $data ? "ok" : "not ok", " $i\n";
}

sub shuffle {
  my @array = @_;
  my $i;
  for ($i = @array; --$i; ) {
     my $j = int rand ($i+1);
     next if $i == $j;
     @array[$i,$j] = @array[$j,$i];
  }
  return @array;
}

1;
__DATA__
������
���q��
������
������
���q��
������
���s��
�W����
�W�s��
�W����
�W�s��
�W����
�W�s��
�W���W
�W�s�W
�ւ���
���q��
������
���q��
�q����
�q�q��
�q�s��
�����W
������
�����W
�s�q�W
�����W
�V���[��
�V���C
�V���B
�V����
���傱
���悱
�`���R���[�g
�ā[��
�e�[�^
�e�F�^
�Ă���
�Ł[��
�f�[�^
�f�F�^
�ł���
�e�[�^��
�Ă�����
�Ă����f
�e�F�^�f
�ā[���[
�e�[�^�@
�ā[����
�e�F�^�[
�Ă�����
�Ă����[
�Ł[���[
�f�[�^�@
�ŃF���@
�f���^��
�f�G�^�A
�Ђ�
�т゠
�҂゠
�т゠�[
�r���A�[
�҂゠�[
�s���A�[
�q���E
�q���E
�r���E�A
�т�[���[
�r���[�A�[
�r���E�A�[
�Ђ��
�҂��
�Ӂ[��
�t�[��
�ӂ���
�ӃD��
�ӃD��
�t�E��
�ԁ[��
�u�[��
�Ԃ���
�u�D��
�Ղ���
�v�E��
�Ӂ[��[
�t�D���[
�ӃD��B
�t������
�t�E���[
�ӂ��股
�u�E���C
�Ձ[��[
�ՃD��C
�Ղ���[
�v�E���C
�t�R
�ӁU
�ԁT
�Ԃ�
�ԃt
�u��
�u�t
�ԁU
�Ԃ�
�u��
�ՁT
�v�R
�Ղ�
