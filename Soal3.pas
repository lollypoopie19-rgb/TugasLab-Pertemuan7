program HasilStudiMahasiswa;
uses crt;   { crt dipakai buat clrscr (bersihin layar), readkey (nunggu tombol), gotoxy (atur posisi tulisan) }

var
  { ===== Data mahasiswa =====
    Tiap array ini isinya dibedain pakai nomor mahasiswa.
    Contoh: nama[1] = nama mahasiswa pertama, nama[2] = mahasiswa kedua, dst. }
  nama   : array[1..50] of string;
  nim    : array[1..50] of string;
  jmlMK  : array[1..50] of integer;   { jumlah mata kuliah yang diambil tiap mahasiswa }

  { ===== Data mata kuliah =====
    Pakai array 2 dimensi: [mahasiswa ke berapa, mata kuliah ke berapa]
    Contoh: mk[2, 3] = mata kuliah ketiga milik mahasiswa kedua }
  mk     : array[1..50, 1..10] of string;    { nama mata kuliah }
  sks    : array[1..50, 1..10] of integer;   { jumlah SKS }
  nilai  : array[1..50, 1..10] of string;    { nilai huruf: A, B+, B, dst }
  skor   : array[1..50, 1..10] of real;      { skor = SKS x bobot nilai }

  n, i, j : integer;      { n = jumlah mahasiswa; i dan j = penghitung buat perulangan }
  totalSKS : integer;     { jumlah semua SKS satu mahasiswa }
  totalSkor, ip : real;   { jumlah semua skor, dan IP-nya }

{ Fungsi ini tugasnya ngubah nilai huruf jadi angka.
  Misal dikasih 'B+' hasilnya 3.5. Huruf besar dan kecil dua-duanya bisa. }
function Bobot(h: string): real;
begin
  if (h = 'A') or (h = 'a') then Bobot := 4
  else if (h = 'B+') or (h = 'b+') then Bobot := 3.5
  else if (h = 'B') or (h = 'b') then Bobot := 3
  else if (h = 'C+') or (h = 'c+') then Bobot := 2.5
  else if (h = 'C') or (h = 'c') then Bobot := 2
  else if (h = 'D') or (h = 'd') then Bobot := 1
  else Bobot := 0;      { kalau bukan semua di atas, berarti E (bobotnya 0) }
end;

{ ================= PROGRAM UTAMA ================= }
begin
  clrscr;
  write('Masukkan jumlah mahasiswa: ');
  readln(n);

  { ---------- BAGIAN 1: INPUT DATA ----------
    Perulangan luar (i) jalan sebanyak jumlah mahasiswa.
    Jadi kalau n = 3, kita bakal input data 3 mahasiswa. }
  for i := 1 to n do
  begin
    writeln;
    writeln('Data mahasiswa ke-', i);
    write('Nama : ');
    readln(nama[i]);
    write('NIM  : ');
    readln(nim[i]);
    write('Jumlah mata kuliah : ');
    readln(jmlMK[i]);

    { Perulangan dalam (j) jalan sebanyak jumlah mata kuliah mahasiswa ini.
      Jadi kalau dia ambil 3 matkul, kita input 3 kali. }
    for j := 1 to jmlMK[i] do
    begin
      writeln('Mata kuliah ke-', j);
      write('  Nama mata kuliah : ');
      readln(mk[i, j]);
      write('  Jumlah SKS       : ');
      readln(sks[i, j]);
      write('  Nilai (A/B+/B/C+/C/D/E) : ');
      readln(nilai[i, j]);

      { Langsung hitung skornya di sini.
        Contoh: SKS 3 dan nilai B+ (3.5) -> skor = 3 x 3.5 = 10.5 }
      skor[i, j] := sks[i, j] * Bobot(nilai[i, j]);
    end;
  end;

  { ---------- BAGIAN 2: TAMPILKAN DATA ----------
    Datanya ditampilin satu-satu. Satu layar = satu mahasiswa. }
  for i := 1 to n do
  begin
    clrscr;     { bersihin layar dulu biar data mahasiswa sebelumnya hilang }
    writeln('Nama : ', nama[i]);
    writeln('NIM  : ', nim[i]);
    writeln('----------------------------------------------------------');

    { Judul tabel.
      gotoxy(x, wherey) artinya: pindah kursor ke kolom ke-x, barisnya tetap.
      Dipakai biar tulisan tiap kolom sejajar dan rapi. }
    write('|');
    gotoxy(3, wherey);  write('No');
    gotoxy(8, wherey);  write('Mata Kuliah');
    gotoxy(30, wherey); write('SKS');
    gotoxy(37, wherey); write('Nilai');
    gotoxy(46, wherey); write('Skor');
    gotoxy(58, wherey); writeln('|');
    writeln('----------------------------------------------------------');

    { Total di-nol-kan dulu tiap ganti mahasiswa.
      Kalau tidak, nilai mahasiswa sebelumnya ikut kehitung. }
    totalSKS := 0;
    totalSkor := 0;

    { Tampilkan semua mata kuliah mahasiswa ini, baris per baris }
    for j := 1 to jmlMK[i] do
    begin
      write('|');
      gotoxy(3, wherey);  write(j);
      gotoxy(8, wherey);  write(mk[i, j]);
      gotoxy(30, wherey); write(sks[i, j]);
      gotoxy(37, wherey); write(nilai[i, j]);
      gotoxy(46, wherey); write(skor[i, j]:0:1);   { :0:1 artinya 1 angka di belakang koma }
      gotoxy(58, wherey); writeln('|');

      { sambil nampilin, sekalian jumlahin SKS dan skornya }
      totalSKS := totalSKS + sks[i, j];
      totalSkor := totalSkor + skor[i, j];
    end;
    writeln('----------------------------------------------------------');

    { Baris TOTAL }
    write('| TOTAL');
    gotoxy(46, wherey); write(totalSkor:0:1);
    gotoxy(58, wherey); writeln('|');
    writeln('----------------------------------------------------------');

    { Rumus IP = total skor dibagi total SKS.
      Contoh: 31.5 / 9 = 3.50 }
    ip := totalSkor / totalSKS;
    writeln('Jumlah SKS : ', totalSKS);
    writeln('IP         : ', ip:0:2);
    writeln;

    { Kalau masih ada mahasiswa berikutnya, program berhenti dulu
      sampai user pencet tombol apa saja (readkey). }
    if i < n then
    begin
      write('Tekan sembarang tombol untuk melihat data selanjutnya..');
      readkey;
    end;
  end;

  { Semua data sudah tampil. Tunggu tombol lagi biar layar tidak langsung tertutup. }
  writeln('Semua data sudah ditampilkan.');
  readkey;
end.