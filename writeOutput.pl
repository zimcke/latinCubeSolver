
writeOutput(List,Filename):-
	sort(List,Sorted),
	length(Sorted,Length),
	
	/*
	date(Year,Month,Day),
	time(H,M,S),
	*/
	
	writeSolutions(Sorted),
	open(output,append,Stream),
	write(Stream,'TOTAL NUMBER OF SOLUTIONS (Latin or not Latin): '),
	write(Stream,Length),
	nl(Stream), nl(Stream),
	close(Stream).

writeSolutions([]).
writeSolutions([Solution|Rest]):-
	(	checkAfter(Solution)
		->	open(output,append,Stream),
			write(Stream,Solution),nl(Stream),
			close(Stream),
			writeSolutions(Rest)
		;
			open(output,append,Stream),
			nl(Stream),
			write(Stream,'This is not a Latin Cube: '),nl(Stream),
			write(Stream,Solution),nl(Stream),
			close(Stream)
	).
			
	
clear:-
	open(output,write,Stream),
	close(Stream).