%% Latin Cube Solver
%% Written in B-Prolog by Zimcke Van de Staey and Tobias Verlinde
%%
%% writeOutput.pl will write all correct solutions (and first incorrect) to output.pl.
%% Filename does not work yet. 
%% "clear." will clear the output.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write the List of Solutions					%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CASE 1: All solutions to a Latin Cube problem

writeOutput(List,Filename):-
	sort(List,Sorted),
	length(Sorted,Length),
	
	writeSolutions(Sorted),
	open('output.pl',append,Stream),
	write(Stream,'TOTAL NUMBER OF SOLUTIONS (Latin or not Latin): '),
	write(Stream,Length),
	nl(Stream), nl(Stream),
	close(Stream).
	
% CASE 2: The first failed solution to a Latin Cube problem

writeOutput2(List,ConstraintId,Filename):-
	writeSolutions2(List,ConstraintId).
	
writeOutput3(ConstraintId,Filename):-
			open('output.pl',append,Stream),
			write(Stream, '% '), write(Stream, ConstraintId),nl(Stream),
			write(Stream, '% '), write(Stream, 'No incorrect solution '),nl(Stream),nl(Stream),
			close(Stream).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Handles each solutions recursively			%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
writeSolutions([]).
writeSolutions([Solution|Rest]):-
	(	checkAfter(Solution)
		->	open('output.pl',append,Stream),
			write(Stream,'solution( '),write(Stream,Solution),write(Stream,' )'),nl(Stream),
			close(Stream),
			writeSolutions(Rest)
		;
			open('output.pl',append,Stream),
			write(Stream,'% '), write(Stream,'This is not a Latin Cube: '),nl(Stream),
			write(Stream,'solution( '),write(Stream,Solution),write(Stream,' )'),nl(Stream),
			close(Stream)
			%writeSolutions(Rest)
	).
	
writeSolutions2([],_).
writeSolutions2(Solution,ConstraintId):-
			open('output.pl',append,Stream),
			write(Stream, '% '), write(Stream, ConstraintId),nl(Stream),
			write(Stream, '% '), write(Stream, 'First solution that is not Latin: '),nl(Stream),
			write(Stream,'solution( '),write(Stream,Solution),write(Stream,' )'),nl(Stream),nl(Stream),
			close(Stream).
			%writeSolutions2(Rest,ConstraintId).
	
			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear output									%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
clear:-
	open('output.pl',write,Stream),
	close(Stream).