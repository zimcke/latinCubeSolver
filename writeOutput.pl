%% Latin Cube Solver
%% Written in B-Prolog by Zimcke Van de Staey and Tobias Verlinde
%%
%% writeOutput.pl will write all correct solutions (and first incorrect) to output.txt.
%% Filename does not work yet. 
%% "clear." will clear the output.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write the List of Solutions					%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CASE: All solutions to a Latin Cube problem
writeOutput(List,Filename):-
	sort(List,Sorted),
	length(Sorted,Length),
	
	/* date(Year,Month,Day), time(H,M,S), */
	
	writeSolutions(Sorted,0,NbNotLatin),
	open('output.txt',append,Stream),
	write(Stream,'TOTAL NUMBER OF SOLUTIONS is '),
	write(Stream,Length),
	write(Stream,' of which '),write(Stream,NbNotLatin),write(Stream,' are NOT LATIN'),nl(Stream),
	nl(Stream),
	close(Stream).

% CASE: The first failed solution to a Latin Cube problem
writeOutput2(List,Filename):-
	writeSolutions2(List).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Handles each solution recursively 			%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
writeSolutions([],NbNotLatin,NbNotLatin).
writeSolutions([Solution|Rest],Counter,NbNotLatin):-
	(	checkAfter(Solution)
		->	open('output.txt',append,Stream),
			write(Stream, 'Latin:     '),
			write(Stream,Solution),nl(Stream),
			close(Stream),
			writeSolutions(Rest,Counter,NbNotLatin)
		;
			open('output.txt',append,Stream),
			write(Stream,'Not Latin: '),
			write(Stream,Solution),nl(Stream),
			close(Stream),
			NewCounter is Counter + 1,
			writeSolutions(Rest,NewCounter,NbNotLatin)
	).
	
writeSolutions2([]).
writeSolutions2(Solution):-
			open('output.txt',append,Stream),
			write(Stream, 'The first solution that is not Latin: '),nl(Stream),
			write(Stream,Solution),nl(Stream),
			close(Stream).
	
			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear output									%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
clear:-
	open('output.txt',write,Stream),
	close(Stream).