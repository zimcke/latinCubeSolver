%% Latin Cube Solver
%% Written in B-Prolog by Zimcke Van de Staey and Tobias Verlinde
%%
%% Use [main] to load the file in B-Prolog, next use the query "main." to run the program on all problems in problems.pl. 
%% The output will appear in output.pl.
%% Use "clear." to clear output.pl.
 
:- include(problems).
:- include(writeOutput).
:- include(constraintsCheck).

% CASE 1: Find all solutions to one or several Latin Cube problem
main:-
	getProblems(Problems),
	filename(Filename),
	main(Problems,Filename).
	
main([],_).
main([Problem|OtherProblems],Filename):-
	findall(Oplossing, solve(Problem, Oplossing), Oplossingen),
	writeOutput(Oplossingen,Filename),
	main(OtherProblems,Filename).

% CASE 2: Find the first failed solution to a Latin Cube problem
	
main2:-
	getProblems([Problem|_]),
	getConstraints(Constraints),
	filename(Filename),
	main2(Problem,Constraints,Filename).
	
main2(_,[],_).
main2(Problem,[(ConstraintSet,Id)|OtherConstraints],Filename):-
	getProblems([SameProblem|_]),
	(	once((solve2(Problem,ConstraintSet,Oplossing),length(Oplossing,L),L\==0)) 
		->
			writeOutput2(Oplossing,Id,Filename),
			main2(SameProblem,OtherConstraints,Filename)
		;
			writeOutput3(Id,Filename),
			main2(SameProblem,OtherConstraints,Filename)
	).
	
solve(Problem, Oplossing):-
	constraints_check(Problem),
    flatten(Problem,Oplossing), labeling(Oplossing).

solve2(Problem,ConstraintSet,Solution):-
	constraints_check(Problem,ConstraintSet),
	flatten(Problem,Solution),
	labeling(Solution),
			open('debug.pl',append,Stream),
			write(Stream,'solution( '),write(Stream,Solution),write(Stream,' )'),nl(Stream),
			close(Stream),
	(checkAfter(Solution)
		-> 	Solution = []
		;	Solution = Solution
	).

filename(Filename):-
	date(Year,Month,Day),
	term2string(Year,String1),
	term2string(Month,String2),
	term2string(Day,String3),
	char_code('_',Code),
	append(String3,[Code],New),
	append(New,String2,NNew),
	append(NNew,[Code],NNNew),
	append(NNNew,String1,Filename).
		
getProblems(Problems):-
	findall(Problem, problem(Problem), Problems).
	
getConstraints(Constraints):-
	findall((ConstraintSet,Id), (constraints(ConstraintSet,Id)), Constraints).

/*	
debugSolutions:-
	findall(Solution,(solution(Solution)),Solutions),
	debugSolutions(Solutions).
	
debugSolutions([]).
debugSolutions([Solution|OtherSolutions]):-
	(checkAfter(Solution)
		-> Solution = []
		;  open('notLatin.pl',append,Stream),
			write(Stream,'solution( '),write(Stream,Solution),write(Stream,' )'),nl(Stream),
			close(Stream)
	),
	debugSolutions(OtherSolutions).*/