program P_sort;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Windows,
  Classes,
  U_function_sort in 'U_function_sort.pas',
  U_Service in 'U_Service.pas';

var
  ff, fd: textfile;
  f_name: ansistring = ''; // script file
  fd_name: ansistring = ''; // output file
  s, ers: ansistring; // String
  rand, i, n1, n2, n3, n4, nc, np, mode, len: int32;// np - ����� ���������; nc - ����� �������; mode - ����� ������
  no: uint8;
  dt: real; // dt - ��������� �������
  arWords: tars; // Convert input string to array of words
  arDigits: tda;
  c: ansichar;

  // ���������� ��� ��������� V ���������� ��� ������ ��������
  K_rpt: uint32 = 0; // ������� ��� ������ ����������� ����
  K_t, n_line: uint32;
// k_t - ������� ��� ���������� ����; n_line - ����� ������, ������� ����� ������; f_pos - ������� � ������� ��������� ������� repeat
  f_pos: int32 = -1;
  file_er: int32 = 0; // ������ ��� ������ � ������
  S_list, plan_ex: TStringList;
  f_plan: ansistring = '';
  plan_line: uint32;
  plan_pos: int32 = -1;
  str_plan: ansistring;
  sort_name: shortstring = ''; // ��� ����������
  rec_t: trec_time; // ������ ��� �������

label Use_str;

begin
  SetConsoleTitle(Pchar('������������ ���������� ����������'));
  assignfile(ff, '');
  reset(ff);
  repeat
    try
      arWords := nil;
      if f_name = '' then
        write('>> ');
      // if (f_name <> '') and Eof(ff) then
      // scripttokb(ff, f_name)
      // else
      // readln(ff, s);
      if f_name = '' then
        readln(s);
      if f_name <> '' then
        if (S_list.count > n_line) then
          s := S_list[n_line];
    Use_str: // ����� ��� GOTO
      if s = '' then
        continue;

      arWords := str_to_mas(s); // Get array of words
      np := length(arWords);
      nc := find_Com(ar_com, arWords[0]);

      case nc of

        // Help
        1:
          help(ar_com, arWords);

        // Output array
        2:
          begin
            no := 1;
            if ((np > 5) or (np < 3)) then
              raise ERangeError.Create
                ('����������� ���������� ���������� � �������');
            n1 := strtoint(arWords[1]);
            inc(no);
            n2 := strtoint(arWords[2]);
            if arWords[3] = '' then
            begin
              writeln('�������� �����:', #10,
                '1 - �����t N1 ��������� � ��������� N1 ���������', #10,
                '2 - ������� ��� ��������', #10,
                '3 - ������� � N1 ��������� ������� N2 ���������');
              readln(arWords[3]);
            end;
            mode := strtoint(arWords[3]);
            if np = 5 then
              fd_name := arWords[4]
            else
              fd_name := '';
            out_ar(arDigits, n1, n2, mode, fd_name);
          end;

        // Generate array
        3:
          begin
            if np <> 5 then
              raise EConvertError.Create('������������ ���������� ����������');
            n1 := strtoint(arWords[1]); // n
            n2 := strtoint(arWords[2]); // lb
            n3 := strtoint(arWords[3]); // lr
            n4 := strtoint(arWords[4]); // ranseed
            arDigits := nil; // !!!
            arDigits := gen_ar(n1, n2, n3, n4);
            if (K_t = 1) and (rec_t.count = 0) then
            begin
              rec_t.count := n1;
              rec_t.lown := n2;
              rec_t.highn := n3;
              rec_t.rand := n4;
            end;
          end;
        // insert sort /\
        4:
          begin
            sort_ins0_u(arDigits, dt);
            writeln('insert_sort �� �����������. Time = ', dt:0:3, 'ms');
          end;
        // insert sort \/
        5:
          begin
            sort_ins0_d(arDigits, dt);
            writeln('insert_sort �� ��������. Time = ', dt:0:3, 'ms');
          end;
        // ins sort+move /\
        6:
          begin
            sort_ins1(arDigits, dt);
            writeln('insert_sort+bin. search+move �� ����������� = ',
              dt:0:3, 'ms');
          end;
        // sel sort /\
        7:
          begin
            sort_sel0(arDigits, dt);
            writeln('selection_sort �� �����������. Time = ', dt:0:3, 'ms');
          end;
        // bubble_sort0 /\
        8:
          begin
            sort_bubble0(arDigits, dt);
            writeln('bubble_sort0 �� �����������. Time = ', dt:0:3, 'ms');
          end;

        // bubble_sort1 /\
        9:
          begin
            sort_bubble1(arDigits, dt);
            writeln('bubble_sort1 �� �����������. Time = ', dt:0:3, 'ms');
          end;
        // shaker sort0 /\
        10:
          begin
            sort_shaker0(arDigits, dt);
            writeln('shaker_sort0 �� �����������. Time = ', dt:0:3, 'ms');
          end;

        // shaker sort1 /\ exit
        11:
          begin
            sort_shaker1(arDigits, dt);
            writeln('shaker_sort1 �� �����������. Time = ', dt:0:3, 'ms');
          end;

        // gnom0 /\
        12:
          begin
            sort_gnom0(arDigits, dt);
            writeln('gnom_sort0 �� �����������. Time = ', dt:0:3, 'ms');
          end;

        // gnom1 /\
        13:
          begin
            sort_gnom1(arDigits, dt);
            writeln('gnom_sort0 �� �����������. Time = ', dt:0:3, 'ms');
          end;
        // shell0 /\
        14:
          begin
            sort_shell0(arDigits, dt);
            writeln('Shell_sort0k = 2 �� �����������. Time = ', dt:0:3, 'ms');
          end;

        // shell1 /\
        15:
          begin
            sort_shell1(arDigits, dt);
            writeln('Shell_sort1 k = 3 �� �����������. Time = ', dt:0:3, 'ms');
          end;

        // shell_t
        16:
          begin
            sort_shell_t(arDigits, dt);
            writeln('Shell_sort_t ���������� ����� � ���������� ���������� �� �����������. Time = ',
              dt:0:3, 'ms');
          end;

        // shell_topt
        17:
          begin
            sort_shell_topt(arDigits, dt);
            writeln('Shell_sort_topt ���������� ����� � ���������� ���������� �� ����������� + Ins0. Time = ',
              dt:0:3, 'ms');
          end;

        // shell_k
        18:
          begin
            sort_shell_k(arDigits, dt);
            writeln('Shell_sort_k ���������� ����� � ���������� ����� �� �����������. Time = ',
              dt:0:3, 'ms');
          end;

        // shell research
        19:
          begin
            if np <> 4 then
            begin
              if f_name <> '' then
              begin
                scripttokb(ff, f_name);
                ers := ' ��������� ������ ����';
              end;
              raise ERangeError.Create
                ('����������� ���������� ���������� � �������' + ers);
            end;

            sort_shell_research(arDigits, dt, strtoint(arWords[1]),
              strtoint(arWords[2]), strtoint(arWords[3]));
            writeln('dMax = ', arWords[1], ' d = (d - ', arWords[3], ') div ',
              arWords[2]);
            writeln('Shell_sort_topt ���������� ����� � ���������� ���������� �� ����������� + Ins0. Time = ',
              dt:0:3, 'ms');
          end;
        // Qsort
        { TODO : ��������� � ������� ���������� }
        20:
          begin
            QSort_dt(arDigits, dt);
            if f_pos < 0 then
              writeln('�������� ������� ���������� �����. Time = ',
                dt:0:3, 'ms');
          end;

        // HeapSort1
        21:
          begin
            heapsort1(arDigits, dt);
            writeln('�������� HeapSort1 c �������������� sift_up+sift_d1. Time = ', dt:0:3);
          end;
        // HeapSort2
        22:
        begin
          heapsort2(arDigits,dt);
          writeln('�������� HeapSort2 c �������������� sift_d2+sift_d1. Time = ', dt:0:3);
        end;

        // Build_tree_d
        24:
          begin
          build_tree_d2(arDigits, dt);
          writeln ('���������� ������������ ���� � ������� sift_d2. Time = ', dt:0:3);
          end;
        // Build_tree_u
        25:
          begin
            build_tree_u(arDigits, dt);
            writeln ('���������� ������������ ���� � ������� sift_u. Time = ', dt:0:3);
          end;
        // Out63
        26:
          begin
            if np <> 2 then
            begin
              if f_name <> '' then
              begin
                scripttokb(ff, f_name);
                ers := ' ��������� ������ ����';
              end;
              raise ERangeError.Create
                ('����������� ���������� ���������� � �������' + ers);
            end;
            n1 := strtoint(arWords[1]);
            Out63(arDigits, n1);
          end;

        { TODO -Egor -��������� : ��������� � �������� ������� � ����������� �reate_t; end_t; add_r; Repeat; until }
        // Create_t
        27:
          begin
            if f_name = '' then
              raise EinOutError.Create('�������������� ������ � ������ �����!');
            if np <> 2 then
              raise ERangeError.Create('����������� ���������� ����������');
            f_plan := arWords[1];
            plan_ex := TStringList.Create;
            plan_ex.LoadFromFile(f_plan + '.txt');
            plan_line := 0;
            plan_pos := n_line + 1;
            // ��������� ������� Create_t � ������ �����+1
            str_plan := plan_ex[plan_line]; // ������ ��� �����������
          end;
        // end_t
        28:
          begin
            if f_name = '' then
              raise EinOutError.Create('�������������� ������ � ������ �����!');
            if np <> 2 then
              raise ERangeError.Create('������������ ���������� ����������');
            f_plan := arWords[1]; // ������ ���������� ��� ��������
            // ��������� � ������ ������� � ����� � plan_ex
            plan_ex[plan_line] := rectostr(rec_t);
            if plan_line < (plan_ex.count - 1) then
            begin
              inc(plan_line);
              str_plan := plan_ex[plan_line];
              n_line := plan_pos;
              continue
            end;
            // ���������� ���������� �� plan_ex
            plan_ex.Insert(0,
              ' N ����������         ��������� ������ ������         ' +
              'Random        (avg) UP (min)  (avg) Down (min)');
            plan_ex.SaveToFile(f_plan + '.txt');
            writeln('���������� �������� � ����: ' + f_plan + '.txt');
            plan_ex.Free;
            str_plan := '';
            plan_pos := -1;
          end;
        29:
          begin
            s := str_plan;
            goto Use_str;
          end;
        // add_t
        30:
          begin
            rec_t.sort_name := str_plan;
            if f_name = '' then
              raise EinOutError.Create('�������������� ������ � ������ �����');
            if not(np = 2) then
              raise ERangeError.Create('������������ ���������� ����������� � '
                + arWords[0]);
            if not(arWords[1][1] in ['r', 'u', 'd']) then
              raise ERangeError.Create('����������� ������ �������� � ' +
                arWords[0]);
            { if k_t = 1 then
              rec_t.sort_name := S_list[0]; }
            add_t(arWords[1][1], rec_t, dt);
          end;
        { TODO : �������� ����� ���������� ������ � ������� � ����� Repeat ��� ������ }
        // Repeat
        31:
          begin
            if f_name = '' then
              raise EinOutError.Create('�������������� ������ � ������ �����');
            if np <> 1 then
              raise ERangeError.Create('������������ ���������� ����������');
            K_t := 1;
            init_rec_time(rec_t);
            f_pos := n_line;
            writeln('f_pos = ', f_pos);
          end;

        // Until
        32:
          begin
            if not(np = 2) then
              raise ERangeError.Create('������������ ���������� ����������');
            if f_name = '' then
              raise EinOutError.Create
                ('������� �������������� ������ � ������ �����');
            K_rpt := strtoint(arWords[1]);
            if K_rpt > K_t then
            begin
              n_line := f_pos + 1;
              inc(K_t);
              continue;
            end;
            if K_rpt = K_t then
              out_t(rec_t, K_t);
          end;

        // ����� ������������ �� �������
        33:
          if f_name <> '' then
            writeln(s);

        // use script file
        34:
          begin
            // try
            if np <> 2 then
              raise ERangeError.Create
                ('����������� ���������� ���������� � �������');
            f_name := arWords[1];
            S_list := TStringList.Create;
            S_list.LoadFromFile(f_name + '.txt');
            n_line := 0;
            continue;
          end;
        // Exit function
        35:
          begin
            if f_name <> '' then
            begin
              f_name := '';
              S_list.Free;
            end
            else
              break;
          end;
      else
        begin
          ers := '';
          if f_name <> '' then
          begin
            scripttokb(ff, f_name);
            ers := ' ��������� ������ ����';
          end;
          raise ERangeError.Create('Command "' + arWords[0] +
            '" is not exist' + ers);
        end;
      end; // case

    except
      on E: ERangeError do
      begin
        writeln(E.Message + '  � ������� ' + arWords[0]);
        if f_name <> '' then
          scripttokb(ff, f_name);
        continue;
        writeln;
      end;

      on E: EConvertError do
      begin
        writeln('������ � ������� ', arWords[0], ', ', no, ' �������� (',
          arWords[no], ') ������ ���� ������');
        if f_name <> '' then
          scripttokb(ff, f_name);
        continue;
        writeln;
      end;

      on E: EIntOverflow do
      begin
        writeln('������� ������� ����� � ', no, '��������');
        continue;
        writeln;
      end;

      on E: EIntError do
      begin
        writeln(E.ClassName, ': ', E.Message);
        continue;
        writeln;
      end;

      on E: EinOutError do // ������ � ������� � readln
      begin
        writeln(E.ClassName, ': "' + f_name, '" ', E.Message, '  ��� ������:',
          inttostr(E.ErrorCode));
        if E.ErrorCode in [2, 3, 103] then
          scripttokb(ff, f_name, 1)
        else
          scripttokb(ff, f_name);
      end;

      on E: Exception do
      begin
        writeln('��������� �����-�� ������');
        continue;
        writeln;
      end;
    end; // try
    s := '';
    ers := '';
    inc(n_line);
    sort_name := arWords[0];
  until false;

  arWords := nil;
  arDigits := nil;

end.
