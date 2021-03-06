unit ubooksearch;
{Berisi fungsi (F03, F04) untuk mencari buku di perpustakaan}
{REFERENSI : - }

interface
uses
	ucsvwrapper,
	ubook, ubookutils;

{PUBLIC, FUNCTION, PROCEDURE}
function categoryValid(q : string): boolean;
procedure findBookByCategoryUtil(category: string; ptrbook:pbook); {F03}
procedure findBookByYearUtil(year:integer; category:string; ptrbook:pbook); {F04}
	
implementation
{FUNGSI dan PROSEDUR}
function fitCategory(year:integer; category:string; currentyear:integer) : boolean;
	{DESKRIPSI	: mencocokkan kategori dengan tahun terbit buku.}
	{PARAMETER	: year menyatakan tahun terbit buku,
		  	  category menyatakan kategori dari buku,
		  	  dan current year adalah input tahun yang dimasukkan.}
	{RETURN		: apakah dia fitcategory atau tidak.}

	{ALGORITMA}
	begin
		if (category = '<') then begin
			fitcategory := currentyear < year;
		end else if (category = '=') then begin
			fitcategory := currentyear = year;
		end else if (category = '>') then begin
			fitcategory := currentyear > year;
		end else if (category = '<=') then begin
			fitcategory := currentyear <= year;
		end else if (category = '>=') then begin
			fitcategory := currentyear >= year;
		end;
	end;

function categoryValid(q : string): boolean;
	{DESKRIPSI	: mengecek apakah query yang dimasukkan user valid/tidak.}
	{PARAMETER	: kategori input user.}
	{RETURN 	: boolean apakah kategori valid.}

	{KAMUS LOKAL}
	var
		str : string;
		i   : integer;

	{ALGORITMA}
	begin
		categoryValid := false;
		for i := 1 to NUMCATEGORIES do begin
			str := CATEGORIES[i];
			if (q = str) then begin
				categoryValid := true;
			end;
		end;
	end;

procedure findBookByCategoryUtil(category: string; ptrbook:pbook);
	{DESKRIPSI	: (F03) mencari buku dengan kategori tertentu sesuai input dari user}
	{I.S. 		: array of Book terdefinisi}
	{F.S.		: ID buku, judul buku, penulis buku dengan kategori yang diinput ditampilkan di layar dengan judul tersusun sesuai abjad}
	{Proses 	: Menanyakan pada user kategori apa yang dicari, lalu mencari ID, judul dan penulis buku tersebut
			  lalu menampilkannya di layar}

	{KAMUS LOKAL}
	var
		i, counter 		: integer;
		found 			: boolean;
		filteredBooks 		: tbook;
		ptr 			: pbook;

	{ALGORITMA}
	begin
		if (categoryValid(category)) then begin
			i := 1;
			counter := 0;

			{skema pencarian dengan boolean}
			found := false;
			while (i <= bookNeff) do begin
				if (category = ptrbook^[i].category) then begin
					found := true;
					counter += 1;
					filteredBooks[counter] := ptrbook^[i];
				end;
				i += 1
			end; { i > userNeff or found }
			
			if (found) then begin
				new(ptr);
				ptr^ := filteredBooks;
				sortBookByTitle(ptr, counter);
				
				for i := 1 to counter do begin
					writeln(ptr^[i].id, ' | ' , unwraptext(ptr^[i].title) , ' | ' , unwraptext(ptr^[i].author));
				end;

			end else begin
				writeln ('Tidak ada buku dalam kategori ini.');
			end;

		end else begin
			writeln ('Kategori ', category ,' tidak valid.');
			writeln();
		end;
	end;

procedure findBookByYearUtil(year:integer; category:string; ptrbook:pbook);
	{DESKRIPSI	: (F04) mencari buku berdasarkan tahun yang diinput oleh user.}
	{I.S.		: array of book terdefinisi.}
	{F.S.		: ID buku, judul buku, penulis buku berdasarkan tahun yang diinput ditampilkan di layar dengan judul
			  tersusun sesuai abjad.}
	{Proses		: Menanyakan pada user tahun terbit berapa yang dicari, lalu mencari ID, judul dan penulis buku tersebut
			  dan menampilkannya di layar.}

	{KAMUS LOKAL}
	var
		i, counter 		: integer;
		found 			: boolean;
		filteredBooks 		: tbook;
		ptr 			: pbook;
		
	{ALGORITMA}
	begin
		writeln();
		writeln('Buku yang terbit pada tahun ', category, ' ', year, ':');

		{skema pencarian dengan boolean}
		i := 1;
		counter := 0;
		found := false;
		while (i <= bookNeff) do begin
			if (fitcategory(year, category, ptrbook^[i].year))  then begin
				found := true;
				counter += 1;
				filteredBooks[counter] := ptrbook^[i];
			end;
			i += 1
		end;

		if (found) then begin
			new(ptr);
			ptr^ := filteredBooks;
			sortBookByTitle(ptr, counter);

			for i := 1 to counter do begin
				writeln(ptr^[i].id, '|', unwraptext(ptr^[i].title), '|', unwraptext(ptr^[i].author));
				found := true;
			end;

		end else begin
			writeln('Tidak ada buku yang sesuai');
		end;
	end;
end.
