w(X,Y):-
    member(X,[1,2,3,4]),
    member(Y,[1,2,3,4]).
h(X,Y):-
    member(X,[1,2,3,4]),
    member(Y,[1,2,3,4]).
d(X,Y):-
    member(X,[1,2,3,4]),
    member(Y,[1,2,3,4]).

wdirection(WConstraints):-
	findall(w(X,Y), w(X,Y), WConstraints).
hdirection(HConstraints):-
	findall(h(X,Y), h(X,Y), HConstraints).
ddirection(DConstraints):-
	findall(d(X,Y), d(X,Y), DConstraints).

%Generate a configuration of missing(N) and print it	
generator(Constraints, AllConstraints, N):-
    length(Constraints, N),
	subset2(Constraints,AllConstraints),
	writeset(Constraints,N).
	%Constraints = [].

%Generates a list with all constraints in the right order
allconstraints(AllConstraints):-
	wdirection(WConstraints),
	hdirection(HConstraints),
	ddirection(DConstraints),
	append(WConstraints,HConstraints,DConstraints,AllConstraints).

%Print out a set
writeset(Constraints,N):-
	
	% generate a case id with form "Case N.Counter" (N = how many constraints, Counter = global variable)
	getCaseName(N,CaseName),
	open('sets.pl', append, Stream),
	write(Stream, 'constraints('),
	write(Stream, Constraints),
	write(Stream, ' , '),
	writeq(Stream, CaseName),
	write(Stream, ').'),
	nl(Stream),
	close(Stream).

%Call this with N the number of missing constraints
%Get all configurations of missing(N) in sets.pl regardless of isomorf configurations	
%Be carefull because this will generate [48!/(N!.(48-N)!)] Prolog facts
main(N):-
	global_set(counter,0),
	%is_global(Counter,0),
	open('sets.pl', write, Stream),
	close(Stream),
	allconstraints(AllConstraints),
	findall(constraints(Cons), generator(Cons, AllConstraints, N), _).
	% call(generator), fail ; true)
subset2([],[]).
subset2([X|L],[X|S]) :-
    subset2(L,S).
subset2(L, [_|S]) :-
    subset2(L,S).
	
getCaseName(N,CaseName):-
	global_get(counter,Value),
	NewCounter is Value + 1,
	atom_concat('Case',' ',S1),
	term2atom(N,NA),
	term2atom(Value,ValueA),
	atom_concat(NA,'.',S2),
	atom_concat(S1,S2,S3),
	atom_concat(S3,ValueA,CaseName),
	global_set(counter,NewCounter).


	