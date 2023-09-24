unit U_Service;

interface

uses
  U_function_sort,
  System.SysUtils;

const
  ncom = 35;

type
  tars = array of ansistring;
  tcom = array [1 .. ncom, 1 .. 3] of ansistring;

  trec_time = record
    sort_name: shortstring;
    count: uint32;
    lown, highn: int32;
    rand: int32;
    tr_min, tr_avg: real;
    tu_min, tu_avg: real;
    td_min, td_avg: real;
  end;

var
  ar_com: tcom = (
    ('Help', '������� ������', 'Help [<Name_com>]'),
    ('Outm', '����� �������','Outm <N1-����� ������� ��������> <N2 - ����������> <��� �����>|<"">'),
    ('Genm', '��������� �������  ��������� �����', 'Genm <������� ��������� � ��������> <��������� ����� � LB> <��������� ����� �� RB> <randseed> '),
    ('Ins0_u', '���������� ������� �������� �� �����������', 'Ins0_u'),
    ('Ins0_d', '���������� ������� �������� �� ��������', 'Ins0_d'),
    ('Ins1', '���������� ������� �������� �� ����������� + bin. search + move', 'Ins1'),
    ('Sel0', '���������� �������', 'Sel0'),
    ('Bubble0', '����������� ����������', 'Bubble0'),
    ('Bubble1', '����������� ���������� + swap', 'Bubble1'),
    ('Shaker0', '��������� ����������', 'Shaker'),
    ('Shaker1', '��������� ���������� + exit if no swap', 'Shaker'),
    ('Gnom0', '������ ����������', 'Gnom0'),
    ('Gnom1', '������ ���������� ����������������', 'Gnom1'),
    ('Shell0', '���������� ����� �� �����������', 'Shell0'),
    ('Shell1', '���������� ����� �� ����������� � d/3', 'Shell1'),
    ('Shell_t', '���������� ����� �� ����������� (������� ���������� ����������)','Shell_t'),
     ('Shell_topt', '���������� ����� �� ����������� (������� ���������� ����������) + ins', 'Shell_topt'),
     ('Shell_k', '���������� ����� � ���������� �����','Shell_k'),
     ('Shell_res', '���������� ����� (�������� ���������� ���������� � ������� d)',  '<Shell_res> <dmax> <dsub> <ddiv>'),
    ('Qsort', '���������� ����� (QwickSort)', 'Qsort'),
    ('Heap1', '���������� �������� ������� c �������������� sift_up+sift_d1', 'Heap1'),
    ('Heap2', '���������� �������� ������� c ������������� sift_d2+sift_d1', 'Heap2'),
    ('', '', ''),
    ('Build_tree_d','������� ��������������� �� �������� �������� ������ � ������� sift_d','Build_tree_d'),
    ('Build_tree_u','������� ��������������� �� �������� �������� ������ � ������� sift_u','Build_tree_u'),
    ('Out63', '������� ������ � ���� ��������� ������ (������� �� ����� 63 ���������)', 'out63 <������� - ��������>'),
    ('Create_t','��������� ����������� �������� ����� � �����','Create_t <��� �����-�����>'),
    ('End_t','��������� ����������� � ������� � ����','End_t <��� ����� � ������������>'),
    ('Use_str','������������ ������ �� ����� �����','Use_str'),
    ('Add_t', '������� ��� ������� �������� & ������������ ������� (������������� ����� ���������� ����������).','Add_t <r>//<u>//<d>'),
    ('Repeat', '������� ������ ����� ��� ������ �� �����', 'Repeat'),
    ('Until', '������� �������� ����� ��� ������ �� �����','Until <���-�� ��������>'),
    ('//', '�������� ����������� � �������', '//'),
    ('Exec', '��������� ������ ����', 'Exec <��� ������ �����>'),
    ('Exit', '����� �� ���������/������ �����', 'Exit'));

  // ��������� ���� ���� � ������
function str_to_mas(s: ansistring): tars;

// ���������� �������
function find_com(a: tcom; s: ansistring): uint8;

// ����� ���� ������ ��� ���������� ��������� �������
procedure help(a: tcom; arw: tars);

// �������� �����
procedure scripttokb(var ff: textfile; var f_name: ansistring; i: int32 = 0);

// ���������� ���������� ������
procedure init_rec_time(var r: trec_time);

// ���������� ������� � ������ ���� "trec_time"
procedure add_t(m: ansichar; var r_t: trec_time; dt: real);

// �������� ����� �������+���������� �������� ��������
procedure out_t(var rec_t: trec_time; var k: uint32);

// ��������� ������, ���������� � ������ - � ������
function rectostr(r_t:trec_time):ansistring;

// ����� ������� � ���� ��������� ������ (c k ��������)
procedure out63(const ar:tda; k:uint32);

implementation

function str_to_mas(s: ansistring): tars;
var
  c: ansichar;
  i: uint8;
begin
  result := nil;
  s := trim(s);
  setlength(result, 10);
  i := 0;
  for c in s do
  begin
    if c = ' ' then
    begin
      if result[i] <> '' then
        inc(i);
      continue;
    end
    else
      result[i] := result[i] + c;
  end;
  setlength(result, i + 1);
end;

function find_com(a: tcom; s: ansistring): uint8;
var
  i: uint8;
begin
  result := 0;
  for i := 1 to length(a) do
    if s = a[i][1] then
    begin
      result := i;
      break;
    end;
end;

procedure help(a: tcom; arw: tars);
var
  i, j: uint8;
begin
  if length(arw) > 2 then
    writeln('ERROR', #10,
      '������� "Help" ����� �������� ������ �� ���� ����������. (������� "Help" ��� ������ ��������)')
  else
  begin
    if (length(arw) = 2) then
    begin
      i := find_com(a, arw[1]);
      if i = 0 then
      begin
        writeln('ERROR', #10,
          '����� ������� �� ���������� (������� "Help" ��� ������ ��������)');
        exit
      end;
      writeln(a[i][2], #10, a[i][3]);
    end
    else
      for i := 1 to length(a) do
        writeln(a[i][1], ' - ', a[i][2]);
  end;
end;

procedure scripttokb(var ff: textfile; var f_name: ansistring; i: int32 = 0);
begin
  if i = 0 then
    closefile(ff);
  f_name := '';
  assignfile(ff, '');
  reset(ff);
end;

procedure init_rec_time(var r: trec_time);
begin
  with r do
  begin
    sort_name := '';
    count := 0;
    lown := 0;
    highn := 0;
    rand := 0;
    tr_min := 0.0;
    tr_avg := 0.0;
    tu_min := 0.0;
    tu_avg := 0.0;
    td_min := 0.0;
    td_avg := 0.0;
  end;
end;

procedure add_t(m: ansichar; var r_t: trec_time; dt: real);
begin
  with r_t do
  begin

    case m of
      'r':
        begin
          tr_avg := tr_avg + dt;
          if (dt < tr_min) or (tr_min = 0.0) then
            tr_min := dt;
        end;
      'u':
        begin
          tu_avg := tu_avg + dt;
          if (dt < tu_min) or (tu_min = 0.0) then
            tu_min := dt;
        end;
      'd':
        begin
          td_avg := td_avg + dt;
          if (dt < td_min) or (td_min = 0.0) then
            td_min := dt;
        end;
    end;
  end;
end;

procedure out_t(var rec_t: trec_time; var k: uint32);
begin
  with rec_t do
  begin
    tr_avg := tr_avg / k;
    tu_avg := tu_avg / k;
    td_avg := td_avg / k;
    sort_name:=inttostr(k)+' '+sort_name;
    writeln(#10, '��������� ����� ��������� ', k, ' ���');
    writeln('tr_min: ', rec_t.tr_min:0:3, 'ms', 'tr_avg: ':12, tr_avg:0:3, 'ms');
    writeln('tu_min: ', rec_t.tu_min:0:3, 'ms', 'tu_avg: ':12, tu_avg:0:3, 'ms');
    writeln('td_min: ', rec_t.td_min:0:3, 'ms', 'td_avg: ':12, td_avg:0:3, 'ms');
  end;
end;

function rectostr(r_t:trec_time):ansistring;
var len:uint8;
    s:ansistring;
begin
  with r_t do
  begin
  len:=length(sort_name);
  result:=sort_name+stringofchar(' ',16-len);
  result:=result+Format('%10d %5d %6d %5d',[count,lown,highn,rand]);
  result:=result+format('%10.3f%8.3f%10.3f%8.3f%10.3f%8.3f',[tr_avg,tr_min,tu_avg,tu_min,td_avg,td_min]);
  end;
end;


// ����� ����� ������� ��� ��������� ������
procedure out63(const ar:tda; k:uint32);
var i,j,n, n1,nlen:uint32;
  begin
    nlen:=128;
    n:=length(ar);
    writeln('�������� ������� :');
      for i:=0 to 5 do // ���� �� �������
        begin
        n1:=1 shl i ; // ���-�� ��������� ������ i
        nlen:=nlen div 2 ; // ����� �������� ������� �� ������
        // k - ������ ������� ��-�� i-�� ������
        for j:= k to k+n1-1 do  // ���� �� �������� ��������� i ������
          if j<n then  // ������ �� ������ �� ������� �������
            if j=k then write(ar[j]:(nlen+2))  // ������ ������ 1-�� �������
              else write(ar[j]:(2*nlen))
                else break;   // �������� �����������
        writeln(#10);  // ���������� 2 ������ ��� ������ ������������
        k:=2*k+1; // ������ 1-�� ������� ����. ������
        end;
  end;
end.
