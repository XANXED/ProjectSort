unit U_function_sort;

interface

uses Windows, System.SysUtils;

type
  tda = array of int32;
  my_t = int32;

  // Генерация массиваслучайных чисел
function gen_ar(n, Lb, Rb, rand: int32): tda;

// Вывод элементов массива
procedure out_ar(ar: tda; n1, n2, mode: int32; fd_name: ansistring);

// Сортировка Ins0_u /\
procedure sort_ins0_u(var ar: tda; out dt: real);

// Сортировка Ins0_d \/
procedure sort_ins0_d(var ar: tda; out dt: real);

// Сортировка Ins1 /\ MOVE
procedure sort_ins1(var ar: tda; out dt: real);

// Сортировка Sel0_u /\
procedure sort_sel0(var ar: tda; out dt: real);

// Сортировка sort_bubble0 /\
procedure sort_bubble0(var ar: tda; out dt: real);

// Сортировка sort_bubble1 /\
procedure sort_bubble1(var ar: tda; out dt: real);

// Сортировка sort_shaker0 /\
procedure sort_shaker0(var ar: tda; out dt: real);

// Сортировка sort_shaker1 /\
procedure sort_shaker1(var ar: tda; out dt: real);

// Сортировка sort_gnom0 /\
procedure sort_gnom0(var ar: tda; out dt: real);

// Сортировка sort_gnom1 /\
procedure sort_gnom1(var ar: tda; out t: real);

// Сортировка sort_shell0 /\
procedure sort_shell0(var ar: tda; out t: real);

// Сортировка sort_shell1 /\
procedure sort_shell1(var ar: tda; out t: real);

// Сортировка shell_t /\
procedure sort_shell_t(a: tda; var dt: real);

// shell_topt  /\
procedure sort_shell_topt(a: tda; var dt: real);

// shell_k /\
procedure sort_shell_k(var a: tda; var dt: real);

// shell_research /\  (dmax research)
procedure sort_shell_research(var a: tda; var dt: real;
  dmax, ddiv, dsub: int32);

// Обёртка для основной процедуры Qsort (для измерения времени)
procedure QSort_dt(var a: tda; var dt: real);

// Qsort /\
procedure QSort(l, r: int32; var a: tda);

// shift_up для heap_sort
procedure sift_up(var ar: tda; i: int32);

// построение двоичного дерева с помощью sift_up
procedure build_tree_u(var ar: tda; var dt: real);

// sift_down для heap_sort
procedure sift_d1(var ar: tda; s: int32); // s = size of heap

// HEAP SORT (sift_up+sidt_d2) /\
procedure heapsort1(var m: tda; var dt: real);

// sift_down для heap_sort №2
procedure sift_d2(var ar: tda; i: int32);

// построение двоичного дерева с помощью sift_d2
procedure build_tree_d2(var ar: tda; var dt: real);

// HEAP SORT (sift_d1+sift_d2) /\

procedure heapsort2(var ar: tda; var dt: real);
/// ///////////////////////////////////////////////////////////////////////
implementation

// gen array
function gen_ar(n, Lb, Rb, rand: int32): tda;
var
  i: int32;
  m: my_t;
begin
  randseed := rand;
  m := Rb - Lb + 1;
  setlength(result, n);
  for i := 0 to n - 1 do
    result[i] := random(m) + Lb;
end;

// ins0_u
procedure sort_ins0_u(var ar: tda; out dt: real);
var
  x: my_t;
  i, j: int32;
  fr, t1, t2: int64;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  for i := 1 to length(ar) - 1 do
  begin
    if ar[i] < ar[i - 1] then
    begin
      j := i;
      x := ar[i];
      while (j > 0) and (ar[j - 1] > x) do
      begin
        ar[j] := ar[j - 1];
        dec(j);
      end;
      ar[j] := x;
    end;
  end;
  QueryPerformanceCounter(t2);
  dt := ((t2 - t1) * 1000) / fr;
end;

// ins0_d
procedure sort_ins0_d(var ar: tda; out dt: real);

var
  i, j: int32;
  fr, t1, t2: int64;
  x: my_t;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  for i := 1 to length(ar) - 1 do
  begin
    if ar[i] > ar[i - 1] then
    begin
      j := i;
      x := ar[i];
      while (j > 0) and (ar[j - 1] < x) do
      begin
        ar[j] := ar[j - 1];
        dec(j);
      end;
      ar[j] := x;
    end;
  end;
  QueryPerformanceCounter(t2);
  dt := ((t2 - t1) * 1000) / fr;
end;

// ins1_u
procedure sort_ins1(var ar: tda; out dt: real);
var
  i, r, l, m: int32;
  fr, t1, t2: int64;
  x: my_t;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  // сортируем
  for i := 1 to length(ar) - 1 do
  begin
    l := 0;
    r := i;
    x := ar[i];
    while (r - l) > 0 do
    begin
      m := (l + r) div 2;
      if x < ar[m] then
        r := m
      else
        l := m + 1;
    end;
    if i <> l then
      move(ar[r], ar[r + 1], (i - r) * sizeof(int32));
    ar[r] := x;
  end;
  QueryPerformanceCounter(t2);
  dt := ((t2 - t1) * 1000) / fr;
end;

// sel0
procedure sort_sel0(var ar: tda; out dt: real);
var
  fr, t1, t2: int64;
  i, min_i, j, last_ar: int32;
  min: my_t;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  for i := 0 to length(ar) - 1 do
  begin
    min := ar[i];
    min_i := i;
    for j := i + 1 to length(ar) - 1 do
      if ar[j] < min then
      begin
        min := ar[j];
        min_i := j;
      end;
    last_ar := ar[i];
    ar[i] := min;
    ar[min_i] := last_ar;
  end;
  QueryPerformanceCounter(t2);
  dt := ((t2 - t1) * 1000) / fr;
end;

// bubble0
procedure sort_bubble0(var ar: tda; out dt: real);

var
  fr, t1, t2: int64;
  i, j, n, index_last, index_now, p: int32;
  num: my_t;
begin
  n := length(ar);
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  for p := n - 1 downto 1 do
  begin
    for i := n - 1 downto index_last do
      if (i <> 0) and (ar[i - 1] > ar[i]) then
      begin
        num := ar[i];
        ar[i] := ar[i - 1];
        ar[i - 1] := num;
        index_now := i + 1;
      end;
    if index_now = index_last then
      break
    else
      index_last := index_now;
  end;
  QueryPerformanceCounter(t2);
  dt := ((t2 - t1) * 1000) / fr;
end;

procedure swap(var a, b: int32);
var
  c: int32;
begin
  c := a;
  a := b;
  b := c;
end;

// bubble1
procedure sort_bubble1(var ar: tda; out dt: real);
var
  i, j: int32;
  t1, t2, fr: int64;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);

  for i := 0 to length(ar) - 2 do
    for j := 0 to length(ar) - 2 - i do
      if ar[j] > ar[j + 1] then
        swap(ar[j], ar[j + 1]);

  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;
end;

// shaker 0
procedure sort_shaker0(var ar: tda; out dt: real);
var
  i, j, m, n: int32;
  t1, t2, fr: int64;
  k: my_t;
  go: boolean;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  n := length(ar);
  go := true;
  for i := 0 to n shr 1 do
  begin

    for j := i to n - 2 - i do
      if ar[j] > ar[j + 1] then
      begin
        k := ar[j];
        ar[j] := ar[j + 1];
        ar[j + 1] := k;
        go := false;
      end;

    for m := n - 2 - i downto i do
      if ar[m] > ar[m + 1] then
      begin
        k := ar[m];
        ar[m] := ar[m + 1];
        ar[m + 1] := k;
        go := false;
      end;

  end;
  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;

end;

// shaker 1 (can exit if no swap)
procedure sort_shaker1(var ar: tda; out dt: real);
var
  i, j, m, n: int32;
  t1, t2, fr: int64;
  k: my_t;
  go: boolean;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  n := length(ar);
  go := true;
  for i := 0 to n shr 1 do
  begin

    for j := i to n - 2 - i do
      if ar[j] > ar[j + 1] then
      begin
        k := ar[j];
        ar[j] := ar[j + 1];
        ar[j + 1] := k;
        go := false;
      end;

    if (go = false) then
      go := true
    else
      break;

    for m := n - 2 - i downto i do
      if ar[m] > ar[m + 1] then
      begin
        k := ar[m];
        ar[m] := ar[m + 1];
        ar[m + 1] := k;
        go := false;
      end;

    if (go = false) then
      go := true
    else
      break;
  end;
  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;

end;

// gnom0
procedure sort_gnom0(var ar: tda; out dt: real);
var
  i: int32;
  t1, t2, fr: int64;
  x: my_t;
begin
  i := 1;
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  while i < length(ar) do
  begin
    x := ar[i];
    if (ar[i - 1] <= x) or (i = 1) then
      inc(i)
    else
    begin
      ar[i] := ar[i - 1];
      ar[i - 1] := x;
      dec(i);
    end;
  end;
  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;
end;

// gnom1
procedure sort_gnom1(var ar: tda; out t: real);
var
  t1, t2, fr: int64;
  i, j: int32;
  x: my_t;

begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);

  i := 1;
  j := 2;
  while i < length(ar) do
  begin
    x := ar[i];
    if ar[i - 1] <= x then
    begin
      i := j;
      inc(j);
    end
    else
    begin
      ar[i] := ar[i - 1];
      ar[i - 1] := x;
      dec(i);
      if i = 0 then
      begin
        i := j;
        inc(j);
      end;
    end;
  end;

  QueryPerformanceCounter(t2);
  t := (t2 - t1) * 1000 / fr;
end;

// shell0
procedure sort_shell0(var ar: tda; out t: real);
var
  t1, t2, fr: int64;
  i, j, d, Rb, Lb, n: int32;
  num: my_t;
  f: boolean;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  n := length(ar);
  d := n shr 1;
  while d <> 0 do
  begin
    f := true;
    Lb := 0;
    Rb := d;
    while Rb <> n do
    begin
      if ar[Lb] > ar[Rb] then
      begin
        num := ar[Lb];
        ar[Lb] := ar[Rb];
        ar[Rb] := num;
        f := false;
      end;
      inc(Lb);
      inc(Rb);
    end;
    if f then
      d := d shr 1;
  end;

  QueryPerformanceCounter(t2);
  t := (t2 - t1) * 1000 / fr;
end;

// shell1
procedure sort_shell1(var ar: tda; out t: real);
var
  t1, t2, fr: int64;
  i, j, d, Rb, Lb, n: int32;
  num: my_t;
  f: boolean;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  n := length(ar);
  d := n shr 1;
  while d <> 0 do
  begin
    f := true;
    Lb := 0;
    Rb := d;
    while Rb <> n do
    begin
      if ar[Lb] > ar[Rb] then
      begin
        num := ar[Lb];
        ar[Lb] := ar[Rb];
        ar[Rb] := num;
        f := false;
      end;
      inc(Lb);
      inc(Rb);
    end;
    if f then
      if (d div 3) <> 0 then
        d := d div 3
      else
        d := d shr 1;
  end;

  QueryPerformanceCounter(t2);
  t := (t2 - t1) * 1000 / fr;
end;

// shell_t
procedure sort_shell_t(a: tda; var dt: real);
var
  i, j, n, d: int32;
  x: my_t;
  t1, t2, fr: int64;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  //
  n := length(a);
  d := n shr 1;
  while (d > 0) do
  begin
    for i := 0 to n - d - 1 do
    begin
      j := i;
      while (j >= 0) and (a[j] > a[j + d]) do
      begin
        x := a[j];
        a[j] := a[j + d];
        a[j + d] := x;
        j := j - d;
        // при больших i мы будем возвращаться назад и отсортировывать элементы раньше. (при течтировании на бумаге возьми большой i)
      end;
    end;
    d := d shr 1;
  end;
  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;
end;

// shell_topt
procedure sort_shell_topt(a: tda; var dt: real);
var
  i, j, n, d, c, k: int32;
  x: int32;
  t1, t2, fr: int64;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  //
  n := length(a);
  d := n shr 1;
  k := j - d;
  while (d > 0) do
  begin
    for i := d to n - 1 do
    begin
      x := a[i];
      j := i;
      k := j - d;
      while (j >= d) and (a[k] > x) do
      begin
        a[j] := a[k];
        j := k;
        k := k - d;
        // при больших i мы будем возвращаться назад и отсортировывать элементы раньше. (при течтировании на бумаге возьми большой i)
      end; // P.S. в книке ошибка
      a[j] := x;
    end;
    d := d shr 1;
  end;
  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;
end;

// Shell_k
procedure sort_shell_k(var a: tda; var dt: real);
const
  t = 7;
var
  i, j, d, m, s, n: integer;
  x: my_t;
  h: array [0 .. (t - 1)] of integer; // 9,5,3,1; di=2dj+1, j=i-1
  t1, t2, fr: int64;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  n := length(a);
  d := 127; // оптимально для n=10000
  while d > 1 do
  begin
    d := d shr 1; // ???
    for i := d to n - 1 do
    begin
      x := a[i];
      j := i - d;
      while (j >= d) and (x < a[j]) do // вместо флага- fl!!!
      begin
        a[j + d] := a[j];
        dec(j, d);
      end;
      if (j >= d) or (x >= a[j]) then
        a[j + d] := x
      else
      begin
        a[j + d] := a[j];
        a[j] := x;
      end;
    end;
  end;
  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;
end;

// Shell_research
procedure sort_shell_research(var a: tda; var dt: real;
  dmax, ddiv, dsub: int32);
var
  i, j, n, d, c, k: int32;
  x: my_t;
  t1, t2, fr: int64;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  //
  n := length(a);
  d := dmax; // добавлено
  while (d > 0) do
  begin
    for i := d to n - 1 do
    begin
      x := a[i];
      j := i;
      k := j - d;
      while (j >= d) and (a[k] > x) do
      begin
        a[j] := a[k];
        j := k;
        k := k - d;
      end;
      a[j] := x;
    end;
    d := (d - dsub) div ddiv; // изменено
  end;
  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;
end;

var
  k_calls, k_depth, k_max: uint16; // переменная для подсчёта стека

  // Qsort
procedure QSort(l, r: int32; var a: tda);
var
  i, j: int32;
  x, y: my_t;
  k: int32;
begin
  i := l;
  j := r;
  x := a[(i + j) shr 1];
  inc(k_calls);
  inc(k_depth);
  repeat
    while a[i] < x do
    begin
      inc(i);
    end;
    while a[j] > x do
    begin
      dec(j);
    end;
    if i <= j then
    begin
      y := a[i];
      a[i] := a[j];
      a[j] := y;
      inc(i);
      dec(j);
    end;
  until i > j;
  if i < r then
    QSort(i, r, a);
  if j > l then
    QSort(l, j, a);

  if k_depth > k_max then
    k_max := k_depth;
  dec(k_depth);
end;

// Qsort обёртка
procedure QSort_dt(var a: tda; var dt: real);
var
  t1, t2, fr: int64;
begin
  k_calls := 0;
  k_depth := 0;
  k_max := 0;
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  QSort(0, High(a), a);
  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;
  { TODO : Временный вывод }
  writeln('Стеков всего = ', k_calls);
  writeln('Максимальная глубина стека = ', k_max);
end;

// sift_up для heap_sort
procedure sift_up(var ar: tda; i: int32);
var
  j, ind, x: int32;
begin
  x := ar[i];
  j := (i - 1) shr 1;
  while (i > 0) and (x > ar[j]) do
  begin
    ar[i] := ar[j];
    i := j;
    j := (i - 1) shr 1;
  end;
  ar[i] := x;
end;

// sift_down для heap_sort
procedure sift_d1(var ar: tda; s: int32); // s = size of heap
var
  i, k, k1, x: int32;
  fr, t1, t2: int64;
begin
  x := ar[s - 1];
  i := 0;
  k := i shl 1 + 1;
  while k < s do
  begin
    k1 := k + 1;
    if k1 < s then
      if ar[k1] > ar[k] then
        k := k1;
    if x < ar[k] then
    begin
      ar[i] := ar[k];
      i := k;
      k := i shl 1 + 1;
    end
    else
      break;
  end;
  ar[i] := x;
  ar[s - 1] := x;
end;


// построение максимуальной двойчсной кучи для heap_sort        =

procedure build_tree_u(var ar: tda; var dt: real);
var
  i: int32;
  fr, t1, t2: int64;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  for i := 1 to high(ar) do
    sift_up(ar, i);
  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;
end;

// Сортировка кучей sift_up_sift_d1
procedure heapsort1(var m: tda; var dt: real);
var
  s, n: int32;
  x: my_t;
  fr, t1, t2: int64;
begin
  //
  n := length(m);
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  build_tree_u(m, dt);
  for s := n downto 2 do
  begin
    x := m[0]; // Extract max
    // m[s-1]:=x;//n-1 ..1
    sift_d1(m, s); // n..2
    m[s - 1] := x; // n-1 ..1
  end;
  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;
end;

// sift_down для heap_sort №2 (используется для построения максимальной кучи
procedure sift_d2(var ar: tda; i: int32);
var
  k, k1, s: int32;
  x: my_t;
begin
  k := i shl 1 + 1;
  s := length(ar);
  x := ar[i]; //
  while k < s do
  begin
    k1 := k + 1;
    if (k1 < s) and (ar[k1] > ar[k]) then
      k := k1;
    if x < ar[k] then
    begin
      ar[i] := ar[k];
      i := k;
      k := i shl 1 + 1;
    end
    else
      break;
  end;
  ar[i] := x;
end;

// Постороение максимального двоичного дерева с помощью sift_d2
procedure build_tree_d2(var ar: tda; var dt: real);
var
  i, k: int32;
  x: my_t;
  t1, t2, fr: int64;
begin
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  k := high(ar);
  for i := (k - 1) shr 1 downTo 0 do
    sift_d2(ar, i); // Sift_d2(m1,i, k+1, m1[i]);
  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;
end;

procedure heapsort2(var ar: tda; var dt: real);
var
  n, i: uint16;
  s, x: int32;
  t1, t2, fr: int64;
begin
  n := length(ar);
  QueryPerformanceFrequency(fr);
  QueryPerformanceCounter(t1);
  build_tree_d2(ar, dt);
  for s := n downto 2 do
  begin
    x := ar[0];
    sift_d1(ar, s); // n..2
    ar[s - 1] := x; // n-1 ..1
  end;
  QueryPerformanceCounter(t2);
  dt := (t2 - t1) * 1000 / fr;
end;

// out array
procedure out_ar(ar: tda; n1, n2, mode: int32; fd_name: ansistring);
var
  i, n: int32;
  f1: textfile;
begin
  if fd_name <> '' then
    fd_name := fd_name + '.txt';
  assignfile(f1, fd_name);
  rewrite(f1);
  case mode of
    1: // first n1 elements ... last n1 elements
      begin
        writeln(f1, 'first n1 elements and last n1 elements: ');
        if n1 > (length(ar) div 2) then
        begin
          write('Out of range (n1 > half of array)');
          exit;
        end;

        begin
          for i := 0 to n1 - 1 do
          begin
            write(f1, ar[i]:5);
            if ((i + 1) mod 10) = 0 then
              writeln(f1);
          end;

          for i := 1 to 10 do
            write(f1, '...':5);

          writeln;
          for i := length(ar) - n1 to length(ar) - 1 do
          begin
            write(f1, ar[i]:5);
            if ((i + 1) mod 10) = 0 then
              writeln(f1);
          end;
        end;
        writeln;
      end;
    2: // all elements

      begin
        writeln(f1, 'output all elements: ');
        for i := 0 to length(ar) - 1 do
        begin
          if i mod 10 = 0 then
            writeln(f1);
          write(f1, ar[i]:5);
        end;
        writeln;
      end;
    3: // output n2 elements fron n1

      begin
        // n1 - индекс первого элемента
        // n2 - количество элементов
        if fd_name <> '' then
          fd_name := fd_name + '.txt';
        assignfile(f1, fd_name);
        rewrite(f1);
        n := high(ar);
        if n1 < low(ar) then
          n1 := low(ar);
        if n1 > n then
        begin
          writeln('Заданного диапазона не существует в массиве!');
          exit;
        end;
        // считаем, что n1>=0
        if (n1 + n2 - 1) <= n then
          n := n1 + n2 - 1;
        writeln(f1, 'Elements array ', n1, '..', n + 1, ':');
        for i := n1 to n do
          if (i + 1 - n1) mod 10 = 0 then
            writeln(f1, ar[i]:5)
          else
            write(f1, ar[i]:5);
        writeln(f1);
        closefile(f1);
      end;
  end;
  closefile(f1);
end;

end.
