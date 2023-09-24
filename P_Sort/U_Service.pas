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
    ('Help', 'Команда помощи', 'Help [<Name_com>]'),
    ('Outm', 'Вывод матрицы','Outm <N1-номер первого элемента> <N2 - количество> <Имя файла>|<"">'),
    ('Genm', 'Генерация массива  рандомных чисел', 'Genm <Сколько элементов в массивае> <рандомные числа с LB> <рандомные числа до RB> <randseed> '),
    ('Ins0_u', 'Сортировка простой вставкой по возрастанию', 'Ins0_u'),
    ('Ins0_d', 'Сортировка простой вставкой по убыванию', 'Ins0_d'),
    ('Ins1', 'Сортировка простой вставкой по возрастанию + bin. search + move', 'Ins1'),
    ('Sel0', 'Сортировка выбором', 'Sel0'),
    ('Bubble0', 'Пузырьковая сортировка', 'Bubble0'),
    ('Bubble1', 'Пузырьковая сортировка + swap', 'Bubble1'),
    ('Shaker0', 'Шейкерная сортировка', 'Shaker'),
    ('Shaker1', 'Шейкерная сортировка + exit if no swap', 'Shaker'),
    ('Gnom0', 'Гномья сортировка', 'Gnom0'),
    ('Gnom1', 'Гномья сортировка оптимизированная', 'Gnom1'),
    ('Shell0', 'Сортировка Шелла по возрастанию', 'Shell0'),
    ('Shell1', 'Сортировка Шелла по возрастанию с d/3', 'Shell1'),
    ('Shell_t', 'Сортировка Шелла по возрастанию (варивнт реализации Третьякова)','Shell_t'),
     ('Shell_topt', 'Сортировка Шелла по возрастанию (варивнт реализации Третьякова) + ins', 'Shell_topt'),
     ('Shell_k', 'Сортировка Шелла в реализации Кнута','Shell_k'),
     ('Shell_res', 'Сортировка Шелла (вавриант реализации Третьякова с выбором d)',  '<Shell_res> <dmax> <dsub> <ddiv>'),
    ('Qsort', 'Сортировка Хоара (QwickSort)', 'Qsort'),
    ('Heap1', 'Сортировка двоичным деревом c использованием sift_up+sift_d1', 'Heap1'),
    ('Heap2', 'Сортировка двоичным деревом c использование sift_d2+sift_d1', 'Heap2'),
    ('', '', ''),
    ('Build_tree_d','Создать отсортированное по убыванию двоичное дерево с помощью sift_d','Build_tree_d'),
    ('Build_tree_u','Создать отсортированное по убыванию двоичное дерево с помощью sift_u','Build_tree_u'),
    ('Out63', 'Вывести массив в виде двоичного дерева (выводит не более 63 элементов)', 'out63 <элемент - родитель>'),
    ('Create_t','Выполнить эксперимент согласно плану в файле','Create_t <Имя плана-файла>'),
    ('End_t','Завершить эксперимент с записью в файл','End_t <Имя файла с результатами>'),
    ('Use_str','Использовать строку из файла плана','Use_str'),
    ('Add_t', 'Команда для расчёта среднего & минимального времени (испольлзуется после выполнения сортировки).','Add_t <r>//<u>//<d>'),
    ('Repeat', 'Команда начала цикла при работе от файла', 'Repeat'),
    ('Until', 'Команда закрытия цикла при работе от файла','Until <кол-во итераций>'),
    ('//', 'Добавить комментарий в консоль', '//'),
    ('Exec', 'Выполнить скрипт файл', 'Exec <имя скрипт файла>'),
    ('Exit', 'Выход из программы/скрипт файла', 'Exit'));

  // Занесение всех слов в массив
function str_to_mas(s: ansistring): tars;

// Нахождение команды
function find_com(a: tcom; s: ansistring): uint8;

// Вывод всех команд или синтаксиса отдельной команды
procedure help(a: tcom; arw: tars);

// Закрытие файла
procedure scripttokb(var ff: textfile; var f_name: ansistring; i: int32 = 0);

// Объявление переменных записи
procedure init_rec_time(var r: trec_time);

// Добавление времени в запись типа "trec_time"
procedure add_t(m: ansichar; var r_t: trec_time; dt: real);

// Красивый вывод времени+вычисление среднего значения
procedure out_t(var rec_t: trec_time; var k: uint32);

// Занесение данных, хронящихся в записи - в строку
function rectostr(r_t:trec_time):ansistring;

// Вывод массива в виде двоичного дерева (c k элемента)
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
      'Команда "Help" может состоять только из двуг параметров. (Введите "Help" для вывода анотации)')
  else
  begin
    if (length(arw) = 2) then
    begin
      i := find_com(a, arw[1]);
      if i = 0 then
      begin
        writeln('ERROR', #10,
          'Такой команды не существует (Введите "Help" для вывода анотации)');
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
    writeln(#10, 'Сртировки быыли выполнены ', k, ' раз');
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


// Вывод части массива как двоичного дерева
procedure out63(const ar:tda; k:uint32);
var i,j,n, n1,nlen:uint32;
  begin
    nlen:=128;
    n:=length(ar);
    writeln('Элементы массива :');
      for i:=0 to 5 do // цикл по уровням
        begin
        n1:=1 shl i ; // кол-во элементов уровня i
        nlen:=nlen div 2 ; // длина базового отрезка на экране
        // k - индекс первого эл-та i-го уровня
        for j:= k to k+n1-1 do  // цикл по индексам элементов i уровня
          if j<n then  // защита от выхода за пределы массива
            if j=k then write(ar[j]:(nlen+2))  // формат вывода 1-го элемета
              else write(ar[j]:(2*nlen))
                else break;   // элементы закончились
        writeln(#10);  // пропускаем 2 строки для лучшей визуализации
        k:=2*k+1; // индекс 1-го элемета след. уровня
        end;
  end;
end.
