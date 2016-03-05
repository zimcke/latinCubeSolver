%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% GENERATION OF SETS: Incremental generation (+ evaluation)       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Global variables
%	missing_counter			number of missing constraints at current iteration of main
%	to_expand_global		list of sets to expand
%	minimal_redundant_sets	list of minimal redundant sets
%	expantion_idx			index where the new 1 is placed to expand a set

% Basic case, main for missing(0)
main:-
	write('New iteration started: 0'),
	clear_non_red_sets,
	clear_minimal_redundant_sets,
	global_set(missing_counter,0),
	global_set(minimal_redundant_sets,[]),
	write_nonredundant_set_header,
	write_minimal_redundant_sets_header,
	findall(0, between(1,48,_), Set),
	global_set(to_expand_global, [Set]),
	write_nonredundant_set(Set),
	nl, write('found a minimal set -> to expand (iteration 0)'),
	global_set(missing_counter,1),
	main2.

% Base case of main2 where we have reached the desired N.
% In the end this will be 12 (or 13)
main2:-
	global_get(missing_counter, 15).

% Recursive case of main where missing(N) will we handeld
% Calls itselfs again with N+1 
% and the cases to expand of missing(N) in 'to_expand_global'	
main2:-
	nl,nl,write('New iteration started: '),
	global_get(missing_counter, M), write(M),
	write_nonredundant_set_header,
	write_minimal_redundant_sets_header,
	generate_missing_N,
	global_get(missing_counter, N),
	Nnew is N + 1,
	global_set(missing_counter, Nnew),
	main2.
	
% Generator must expand cases untill there are non left
generate_missing_N:-
	call(expand_cases), fail.
generate_missing_N.

% Reads non-redundant sets of missing(n-1) and handles them
% Until there are no sets of missing(n-1) left
expand_cases:-
	global_get(to_expand_global, SetsRev),
	reverse(SetsRev,Sets),
	empty_to_expand_global,
	get_set(Sets, Set),
	call(expand_set(Set)), fail.

% Tries to expand the given set by trying to put a one on each position	
expand_set(Set):-
	search_last_one(Set,StartIdx),
	between(StartIdx,47,Idx),
	global_set(expantion_idx, Idx),
	set_one_on_idx(Set, Idx, 0, []).

% searches for the index of the last 1 in a binary list of length 48
% returns 0 if there is no 1 in the list
search_last_one(_,Idx):-
	global_get(missing_counter, 1),
	Idx = 0.
search_last_one(Set,Idx):-
	reverse(Set,RSet),
	search_first_one(RSet,IdxRev),
	Idx is 47-IdxRev.

% searches for the index of the first 1 in a binary list	
search_first_one([1|_], 0).	
search_first_one([0|Rest], Idx):-
	search_first_one(Rest, IdxNext),
	Idx is IdxNext + 1.

% Sets a one on the given index if there is none and decides to handle this missing(N) configuration
set_one_on_idx([Elem|_], Counter, Counter, _):-
	Elem = 1.
set_one_on_idx([Elem|Next], Counter, Counter, Prev):-
	Elem = 0,
	append(Prev, [1], Temp),
	append(Temp, Next, Set),
	% This is a valid set to examin
	handle_set(Set).
set_one_on_idx([Elem|Rest], Idx, Counter, Prev):-
	append(Prev, [Elem], NewPrev),
	NextCounter is Counter + 1,
	set_one_on_idx(Rest, Idx, NextCounter, NewPrev).

% Get one set out of a list of sets	
get_set(Sets, Set):-
	member(Set, Sets),
	not(Set == []).
	
% Write header like "minimal non-redundant sets of missing(N)"
write_nonredundant_set_header:-
	open('non_red_sets.pl', append, Stream),
	write(Stream, '\n'),
	write(Stream, '% Non-redundant (minimal) sets of '),
	global_get(missing_counter, N),
	write(Stream, N),
	write(Stream, ' missing constraint'),
	write(Stream, '\n'),
	close(Stream).
	
% Write non-redundant set to non_red_sets.pl
write_nonredundant_set(Set):-
	open('non_red_sets.pl', append, Stream),
	write(Stream, 'set('),
	global_get(missing_counter,N),
	write(Stream,N),
	write(Stream,','),
	write(Stream, Set),
	write(Stream, ').\n'),
	close(Stream).

% Make or empty the file non_red_sets.pl
clear_non_red_sets:-
	open('non_red_sets.pl', write, Stream),
	close(Stream).

% Add the given set to the global list of set to expand	
add_to_expand_global(Set):-
	global_get(to_expand_global, Temp),
	append([Set], Temp, Next),
	global_set(to_expand_global, Next).

% Emty the global list of sets to expand (when entering new iteration)	
empty_to_expand_global:-
	global_set(to_expand_global, []).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% HANDLING OF A SET: One set will be examined conform the schema  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handle_set(Set):-
	not(contains_minimal_redundant(Set)),
	not(is_not_minimal(Set)),
	nl, write('found a minimal set'),
	not(has_nonLC_solution(Set)),
	write(' -> to expand (iteration '),
	global_get(missing_counter, N), write(N), write(')'),
	write_nonredundant_set(Set),
	add_to_expand_global(Set).
handle_set(_).	
	
% Return true if the given set does not contain a minimal redundant set
% Look for minimal (smaller) redundant sets in a file
contains_minimal_redundant(Set):-
	once(contains_any_minimal_redundant(Set)).
contains_any_minimal_redundant(Set):-
	global_get(minimal_redundant_sets, RSets),
	member(RSet, RSets),
	contains(RSet, Set),
	nl,write('found set that contains a minimal redundant set').

% Returns true if the first set of missing constraints is a subset of the second set
contains([],[]).
contains([1|_], [0|_]):-fail.
contains([1|Rest1], [1|Rest2]):-
	contains(Rest1,Rest2).
contains([0|Rest1], [0|Rest2]):-
	contains(Rest1,Rest2).
contains([0|Rest1], [1|Rest2]):-
	contains(Rest1,Rest2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Deside if a set is minimal            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Return true if a smaller equivalent set is found
is_not_minimal(Set):-
	tranformation(Set, SetT),
	not(Set = SetT),
	is_smaller(SetT, Set).	

% Preform a transformation on the set and return the transformed set
tranformation(Set, SetRes):-
	p(Set, SetP1),
	rotation1(SetP1, SetRes).

% Rotate in direction 1, permutate and optionally rotate one or two times more
% Or do nothing and pass on to rotation 2
rotation1(Set,ResSet):-
	rotation2(Set,ResSet).
rotation1(Set, ResSet):-
	r1(Set,Set1),
	p(Set1, Set2),
	rotation2(Set2, Set3),
	maybe_r1(Set3, Set4),
	maybe_r1(Set4, ResSet).
maybe_r1(Set,Set).
maybe_r1(Set,ResSet):-
	r1(Set,ResSet).

% Rotate in direction 2, permutate and optionally rotate one or two times more
% Or do nothing and pass on to rotation 3
rotation2(Set,ResSet):-
	rotation3(Set,ResSet).
rotation2(Set, ResSet):-
	r2(Set,Set1),
	p(Set1, Set2),
	rotation3(Set2, Set3),
	maybe_r2(Set3, Set4),
	maybe_r2(Set4, ResSet).
maybe_r2(Set,Set).
maybe_r2(Set,ResSet):-
	r2(Set,ResSet).

% Rotate in 0,1,2 or 3 times in direction 3
rotation3(Set,ResSet):-
	maybe_r3(Set, Set2),
	maybe_r3(Set2, Set3),
	maybe_r3(Set3, ResSet).
maybe_r3(Set,Set).
maybe_r3(Set,ResSet):-
	r3(Set,ResSet).

% Rotations
r1([W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44], Result):-
	Result = [H14,H13,H12,H11,H24,H23,H22,H21,H34,H33,H32,H31,H44,H43,H42,H41,W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44,D41,D42,D43,D44,D31,D32,D33,D34,D21,D22,D23,D24,D11,D12,D13,D14].
r2([W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44], Result):-
	Result = [W41,W31,W21,W11,W42,W32,W22,W12,W43,W33,W23,W13,W44,W34,W24,W14,D11,D21,D31,D41,D12,D22,D32,D42,D13,D23,D33,D43,D14,D24,D34,D44,H41,H31,H21,H11,H42,H32,H22,H12,H43,H33,H23,H13,H44,H34,H24,H14].	
r3([W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44], Result):-
	Result = [D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44,H41,H31,H21,H11,H42,H32,H22,H12,H43,H33,H23,H13,H44,H34,H24,H14,W41,W42,W43,W44,W31,W32,W33,W34,W21,W22,W23,W24,W11,W12,W13,W14].

% permutation of 4 layers
p(Set0, Set3):-
	p1(Set0, Set1),
	p2(Set1, Set2),
	p3(Set2, Set3).	
% permutation 1-1, 1-2, 1-3 & 1-4
p1(Set, Set).
p1([W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44], Result):-
	Result = [W12,W11,W13,W14,W22,W21,W23,W24,W32,W31,W33,W34,W42,W41,W43,W44,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D12,D11,D13,D14,D22,D21,D23,D24,D32,D31,D33,D34,D42,D41,D43,D44].
p1([W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44], Result):-
	Result = [W13,W12,W11,W14,W23,W22,W21,W24,W33,W32,W31,W34,W43,W42,W41,W44,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D13,D12,D11,D14,D23,D22,D21,D24,D33,D32,D31,D34,D43,D42,D41,D44].
p1([W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44], Result):-
	Result = [W14,W12,W13,W11,W24,W22,W23,W21,W34,W32,W33,W31,W44,W42,W43,W41,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D14,D12,D13,D11,D24,D22,D23,D21,D34,D32,D33,D31,D44,D42,D43,D41].
% permutations 2-2, 2-3 & 2-4
p2(Set, Set).
p2([W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44], Result):-
	Result = [W11,W13,W12,W14,W21,W23,W22,W24,W31,W33,W32,W34,W41,W43,W42,W44,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D11,D13,D12,D14,D21,D23,D22,D24,D31,D33,D32,D34,D41,D43,D42,D44].
p2([W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44], Result):-
	Result = [W11,W14,W13,W12,W21,W24,W23,W22,W31,W34,W33,W32,W41,W44,W43,W42,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D11,D14,D13,D12,D21,D24,D23,D22,D31,D34,D33,D32,D41,D44,D43,D42].
% permutation 3-3 & 3-4
p3(Set, Set).
p3([W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44], Result):-
	Result = [W11,W12,W14,W13,W21,W22,W24,W23,W31,W32,W34,W33,W41,W42,W44,W43,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D11,D12,D14,D13,D21,D22,D24,D23,D31,D32,D34,D33,D41,D42,D44,D43].

% Returns true if the first set is smaller than the second set (and not equal)
% Only works for list of equivalent length
is_smaller([],[]):- fail.
is_smaller([1|_],[0|_]).
is_smaller([0|_],[1|_]):- fail.
is_smaller([0|Rest1],[0|Rest2]):-
	is_smaller(Rest1,Rest2).
is_smaller([1|Rest1],[1|Rest2]):-
	is_smaller(Rest1,Rest2).

	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Deside if a set has a non LC solution %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Return true if this set has a non LC solution
has_nonLC_solution(Set):-
	find_nonLC_solution(Set),
	write(' -> has a non LC solution'),
	add_to_minimal_redundant_sets(Set),
	write_minimal_redundant_set(Set).
has_nonLC_solution(_):- fail.

% True if the given set of constrains has a non LC solution
find_nonLC_solution(Set):-
	set_problem(Set,Problem),
	split_constraints(Set, WCons, HCons, DCons),
	domain_constraints(Problem),
	w_constraint(Problem,WCons),
	h_constraint(Problem,HCons),
	d_constraint(Problem,DCons),
	flatten(Problem, Solution),
	labeling(Solution),
	once(not(is_LC(Solution))).

% Initialise a 4x4x4 Cube by one row on a present constraint
% Done 16 times (one full direction), no need to do more
% Because one direction can not be totaly abscent	
set_problem([0|_], [[[1,2,3,4],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]]]).	
set_problem([1,0|_], [[[_,_,_,_],[1,2,3,4],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]]]).	
set_problem([1,1,0|_], [[[_,_,_,_],[_,_,_,_],[1,2,3,4],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]]]).
set_problem([1,1,1,0|_], [[[_,_,_,_],[_,_,_,_],[_,_,_,_],[1,2,3,4]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]]]).
set_problem([1,1,1,1,0|_], [[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[1,2,3,4],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]]]).
set_problem([1,1,1,1,1,0|_], [[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[1,2,3,4],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]]]).
set_problem([1,1,1,1,1,1,0|_], [[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[1,2,3,4],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]]]).
set_problem([1,1,1,1,1,1,1,0|_], [[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[1,2,3,4]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]]]).
set_problem([1,1,1,1,1,1,1,1,0|_], [[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[1,2,3,4],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]]]).
set_problem([1,1,1,1,1,1,1,1,1,0|_], [[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[1,2,3,4],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]]]).
set_problem([1,1,1,1,1,1,1,1,1,1,0|_], [[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[1,2,3,4],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]]]).
set_problem([1,1,1,1,1,1,1,1,1,1,1,0|_], [[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[1,2,3,4]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]]]).
set_problem([1,1,1,1,1,1,1,1,1,1,1,1,0|_], [[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[1,2,3,4],[_,_,_,_],[_,_,_,_],[_,_,_,_]]]).
set_problem([1,1,1,1,1,1,1,1,1,1,1,1,1,0|_], [[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[1,2,3,4],[_,_,_,_],[_,_,_,_]]]).
set_problem([1,1,1,1,1,1,1,1,1,1,1,1,1,1,0|_], [[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[1,2,3,4],[_,_,_,_]]]).
set_problem([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0|_], [[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],[[_,_,_,_],[_,_,_,_],[_,_,_,_],[1,2,3,4]]]).
	
% True if the given 4x4x4 Cube is LC	
is_LC(Solution):-
	formatSolution(Solution, SolutionToTest),
	global_get(expantion_idx, IDX),
	ones(Noconstraints),
	add_zero(Noconstraints, IDX, 0, [], OneConstraintSet),
	split_constraints(OneConstraintSet, WCons, HCOs, DCons),
	w_constraint(SolutionToTest,WCons),
	h_constraint(SolutionToTest,HCOs),
	d_constraint(SolutionToTest,DCons).

% Set a zero on the given index (with contains a zero by definition)	
% Returns the result in the fifth argument
% DO NOTHING MORE (difference with set_one_on_idx)
add_zero([_|Next], Counter, Counter, Prev, Result):-
	append(Prev, [0], Temp),
	append(Temp, Next, Result).
add_zero([Elem|Rest], Idx, Counter, Prev, Result):-
	append(Prev, [Elem], NewPrev),
	NextCounter is Counter + 1,
	add_zero(Rest, Idx, NextCounter, NewPrev, Result).

% Split set of constraints (length 48) in three directions of constraints (length 16)
split_constraints([W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44,H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44,D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44], 
	[W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44], 
	[H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44], 
	[D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44]).
	
% Domain constraints
domain_constraints(P) :-
    term_variables(P,V),
	domain_constraints2(V).
domain_constraints2([]).
domain_constraints2([Elem|V]) :-
    Elem in 1..4,
	domain_constraints2(V).

% Height constraints
h_constraint([],[]).
h_constraint(_,[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]).	
h_constraint([[[A1,A2,A3,A4],[B1,B2,B3,B4],[C1,C2,C3,C4],[D1,D2,D3,D4]],[[E1,E2,E3,E4],[F1,F2,F3,F4],[G1,G2,G3,G4],[H1,H2,H3,H4]],[[I1,I2,I3,I4],[J1,J2,J3,J4],[K1,K2,K3,K4],[L1,L2,L3,L4]],[[M1,M2,M3,M4],[N1,N2,N3,N4],[O1,O2,O3,O4],[P1,P2,P3,P4]]],[H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44]):-
	h_constraint_2([A1,B1,C1,D1],H11),
	h_constraint_2([A2,B2,C2,D2],H12),
	h_constraint_2([A3,B3,C3,D3],H13),
	h_constraint_2([A4,B4,C4,D4],H14),
	h_constraint_2([E1,F1,G1,H1],H21),
	h_constraint_2([E2,F2,G2,H2],H22),
	h_constraint_2([E3,F3,G3,H3],H23),
	h_constraint_2([E4,F4,G4,H4],H24),
	h_constraint_2([I1,J1,K1,L1],H31),
	h_constraint_2([I2,J2,K2,L2],H32),
	h_constraint_2([I3,J3,K3,L3],H33),
	h_constraint_2([I4,J4,K4,L4],H34),
	h_constraint_2([M1,N1,O1,P1],H41),
	h_constraint_2([M2,N2,O2,P2],H42),
	h_constraint_2([M3,N3,O3,P3],H43),
	h_constraint_2([M4,N4,O4,P4],H44).
h_constraint_2(P,0):-
	all_different(P).
h_constraint_2(_,1).

% Width constraints	
w_constraint([],[]).
w_constraint(_,[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]).		
w_constraint([[[A1,A2,A3,A4],[B1,B2,B3,B4],[C1,C2,C3,C4],[D1,D2,D3,D4]],[[E1,E2,E3,E4],[F1,F2,F3,F4],[G1,G2,G3,G4],[H1,H2,H3,H4]],[[I1,I2,I3,I4],[J1,J2,J3,J4],[K1,K2,K3,K4],[L1,L2,L3,L4]],[[M1,M2,M3,M4],[N1,N2,N3,N4],[O1,O2,O3,O4],[P1,P2,P3,P4]]],[W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44]):-
	w_constraint_2([A1,A2,A3,A4],W11),
	w_constraint_2([B1,B2,B3,B4],W12),
	w_constraint_2([C1,C2,C3,C4],W13),
	w_constraint_2([D1,D2,D3,D4],W14),
	w_constraint_2([E1,E2,E3,E4],W21),
	w_constraint_2([F1,F2,F3,F4],W22),
	w_constraint_2([G1,G2,G3,G4],W23),
	w_constraint_2([H1,H2,H3,H4],W24),
	w_constraint_2([I1,I2,I3,I4],W31),
	w_constraint_2([J1,J2,J3,J4],W32),
	w_constraint_2([K1,K2,K3,K4],W33),
	w_constraint_2([L1,L2,L3,L4],W34),
	w_constraint_2([M1,M2,M3,M4],W41),
	w_constraint_2([N1,N2,N3,N4],W42),
	w_constraint_2([O1,O2,O3,O4],W43),
	w_constraint_2([P1,P2,P3,P4],W44).
w_constraint_2(P,0):-
	all_different(P).
w_constraint_2(_,1).

% Depth constraints
d_constraint([],[]).
d_constraint(_,[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]).		
d_constraint([[[A1,A2,A3,A4],[B1,B2,B3,B4],[C1,C2,C3,C4],[D1,D2,D3,D4]],[[E1,E2,E3,E4],[F1,F2,F3,F4],[G1,G2,G3,G4],[H1,H2,H3,H4]],[[I1,I2,I3,I4],[J1,J2,J3,J4],[K1,K2,K3,K4],[L1,L2,L3,L4]],[[M1,M2,M3,M4],[N1,N2,N3,N4],[O1,O2,O3,O4],[P1,P2,P3,P4]]],[D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44]):-
	d_constraint_2([A1,E1,I1,M1],D11),
	d_constraint_2([A2,E2,I2,M2],D12),
	d_constraint_2([A3,E3,I3,M3],D13),
	d_constraint_2([A4,E4,I4,M4],D14),
	d_constraint_2([B1,F1,J1,N1],D21),
	d_constraint_2([B2,F2,J2,N2],D22),
	d_constraint_2([B3,F3,J3,N3],D23),
	d_constraint_2([B4,F4,J4,N4],D24),
	d_constraint_2([C1,G1,K1,O1],D31),
	d_constraint_2([C2,G2,K2,O2],D32),
	d_constraint_2([C3,G3,K3,O3],D33),
	d_constraint_2([C4,G4,K4,O4],D34),
	d_constraint_2([D1,H1,L1,P1],D41),
	d_constraint_2([D2,H2,L2,P2],D42),
	d_constraint_2([D3,H3,L3,P3],D43),
	d_constraint_2([D4,H4,L4,P4],D44).
d_constraint_2(P,0):-
	all_different(P).
d_constraint_2(_,1).

% Format solution: [] -> [ [[],[],[],[]],[[],[],[],[]]... ]	
formatSolution([A1,A2,A3,A4,B2,B3,B4,B1,C3,C4,C1,C2,D4,D1,D2,D3,E2,E3,E4,E1,F3,F4,F1,F2,G4,G1,G2,G3,H1,H2,H3,H4,I3,I4,I1,I2,J4,J1,J2,J3,K1,K2,K3,K4,L2,L3,L4,L1,M4,M1,M2,M3,N1,N2,N3,N4,O2,O3,O4,O1,P3,P4,P1,P2],Formatted):-
	Formatted = [	[[A1,A2,A3,A4],[B2,B3,B4,B1],[C3,C4,C1,C2],[D4,D1,D2,D3]],
					[[E2,E3,E4,E1],[F3,F4,F1,F2],[G4,G1,G2,G3],[H1,H2,H3,H4]],
					[[I3,I4,I1,I2],[J4,J1,J2,J3],[K1,K2,K3,K4],[L2,L3,L4,L1]],
					[[M4,M1,M2,M3],[N1,N2,N3,N4],[O2,O3,O4,O1],[P3,P4,P1,P2]]
				].

% Returns a list of 48 ones
ones(Ones):-
	findall(1, between(0,47,_), Ones).

% Write this redundant set to the file of minimal redundant sets	
write_minimal_redundant_set(Set):-
	open('minimal_redundant_sets.pl', append, Stream),
	write(Stream, 'set('),
	global_get(missing_counter,N),
	write(Stream, N),
	write(Stream, ','),
	write(Stream, Set),
	write(Stream, '.\n'),
	close(Stream).

% Empty the file of minimal redundant sets
clear_minimal_redundant_sets:-
	open('minimal_redundant_sets.pl', write, Stream),
	close(Stream).

% Write a header like '% Minimal redundant (minimal) sets of N missing contraints'
write_minimal_redundant_sets_header:-
	open('minimal_redundant_sets.pl', append, Stream),
	write(Stream, '\n'),
	write(Stream, '% Minimal redundant (minimal) sets of '),
	global_get(missing_counter, N),
	write(Stream, N),
	write(Stream, ' missing constraint'),
	write(Stream, '\n'),
	close(Stream).

% Add the given set to the list of minimal redundant sets	
add_to_minimal_redundant_sets(Set):-
	global_get(minimal_redundant_sets, Prev),
	append(Prev,[Set],New),
	global_set(minimal_redundant_sets, New).