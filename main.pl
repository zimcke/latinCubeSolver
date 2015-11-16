:- include(problems).
:- include(writeOutput).
:- include(constraintsCheck).

main:-
	getProblems(Problems),
	filename(Filename),
	main(Problems,Filename).

main([],_).
main([Problem|OtherProblems],Filename):-
	findall(Oplossing, solve(Problem, Oplossing), Oplossingen),
	writeOutput(Oplossingen,Filename),
	main(OtherProblems,Filename).
		
solve(Problem, Oplossing):-
	constraints_check(Problem),
    flatten(Problem,Oplossing), labeling(Oplossing).

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