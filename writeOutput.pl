writeOutput(List,Filename):-
	sort(List,Sorted),
	length(Sorted,Length),
	
	/*
	date(Year,Month,Day),
	time(H,M,S),
	open(output,append,Stream),
	nl(Stream),
	write(Stream,Day),write(Stream," "),
	write(Stream,Month),write(Stream," "),
	write(Stream,Year),write(Stream," "),
	write(Stream,H),write(Stream,"uur"),
	write(Stream,M),write(Stream,"minuten"),
	write(Stream,S),write(Stream,"seconden"), nl(Stream), nl(Stream),
	close(Stream),
	*/

	/*
	date(Year,Month,Day),
	time(H,M,S),
	term2string(Year,Years),
	term2string(Month,Months),
	term2string(Day,Days),
	*/
	
	X = output,
	writeSolutions(Sorted),
	open(X,append,Stream),
	write(Stream,'TOTAL NUMBER OF SOLUTIONS: '),
	write(Stream,Length),
	nl(Stream), nl(Stream),
	close(Stream).

writeSolutions([]).
writeSolutions([Solution|Rest]):-
	open(output,append,Stream),
	write(Stream,Solution),nl(Stream),
	close(Stream),
	writeSolutions(Rest).
	
	
clear:-
	open(output,write,Stream),
	close(Stream).