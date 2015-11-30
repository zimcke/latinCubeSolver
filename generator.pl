h(X,Y):-
    member(X,[1,2,3,4]),
    member(Y,[1,2,3,4]).

hdirection(HConstraints):-
	findall(h(X,Y), h(X,Y), HConstraints).

onedirection(Constraints):-
	Length in 1..12,
    length(Constraints, Length),
	hdirection(HConstraints),
    subset2(Constraints,HConstraints),
	open('sets.pl', append, Stream),
	write(Stream, Constraints),nl(Stream),
	close(Stream),
	Constraints = [].

main:-
	open('sets.pl', write, Stream),
	close(Stream),
	findall(constraints(Cons), onedirection(Cons), _).
	
subset2([],[]).
subset2([X|L],[X|S]) :-
    subset2(L,S).
subset2(L, [_|S]) :-
    subset2(L,S).