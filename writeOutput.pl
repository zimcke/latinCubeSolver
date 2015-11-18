%% Latin Cube Solver
%% Written in B-Prolog by Zimcke Van de Staey and Tobias Verlinde
%%
%% writeOutput.pl will write all correct solutions (and first incorrect) to output.txt.
%% Filename does not work yet. 
%% "clear." will clear the output.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write the List of Solutions					%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
writeOutput(List,Filename):-
	sort(List,Sorted),
	length(Sorted,Length),
	
	/*
	date(Year,Month,Day),
	time(H,M,S),
	*/
	
	writeSolutions(Sorted),
	open('output.txt',append,Stream),
	write(Stream,'TOTAL NUMBER OF SOLUTIONS (Latin or not Latin): '),
	write(Stream,Length),
	nl(Stream), nl(Stream),
	close(Stream).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Handles each solutions recursively			%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
writeSolutions([]).
writeSolutions([Solution|Rest]):-
	(	checkAfter(Solution)
		->	open('output.txt',append,Stream),
			write(Stream,Solution),nl(Stream),
			close(Stream),
			writeSolutions(Rest)
		;
			open('output.txt',append,Stream),
			write(Stream,'This is not a Latin Cube: '),nl(Stream),
			write(Stream,Solution),nl(Stream),
			close(Stream)
	).
			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear output									%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
clear:-
	open('output.txt',write,Stream),
	close(Stream).