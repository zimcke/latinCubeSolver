%% Latin Cube Solver
%% Written in B-Prolog by Zimcke Van de Staey and Tobias Verlinde
%%
%% constraintCheck.pl is responsible for checking the constraints of every problem, as well as checking the constraints of every solution.

:-include(constraints).

ones(Ones):-
	Ones = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1].
	
constraints_check(Problem,ConstraintSet):-
	domain_problem(Problem),
	convertConstraints(ConstraintSet,WConstraints,HConstraints,DConstraints),
	w_constraint(Problem,WConstraints),
	h_constraint(Problem,HConstraints),
	d_constraint(Problem,DConstraints).

% returns true if and only if the Solution is latin	
checkAfter(Solution):-
	ones(Ones),
	formatSolution(Solution,SolutionFormatted),
	w_constraint(SolutionFormatted,Ones),
	h_constraint(SolutionFormatted,Ones),
	d_constraint(SolutionFormatted,Ones).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read constraints from constraints.pl as three lists of ones and zero's   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

convertConstraints(ConstraintSet,W,H,D):-
	ones(Ones),
	getWConstraints(ConstraintSet,RemainingSet,Ones,[],W),
	getHConstraints(RemainingSet,RemainingSet2,Ones,[],H),
	getDConstraints(RemainingSet2,Ones,[],D).

getWConstraints([h(I,J)|Other],[h(I,J)|Other],Ones,Indices,Result):-
			sort(Indices,IndicesSorted),
			convert(IndicesSorted,1,Ones,[],Result).

getWConstraints([w(I,J)|Other],RemainingSet,Ones,Indices,Result):-
			Index is ((I-1)*4)+J,
			getWConstraints(Other,RemainingSet,Ones,[Index|Indices],Result).

getHConstraints([d(I,J)|Other],[d(I,J)|Other],Ones,Indices,Result):-
			sort(Indices, IndicesSorted),
			convert(IndicesSorted,1,Ones,[],Result).
			
getHConstraints([h(I,J)|Other],RemainingSet,Ones,Indices,Result):-
			Index is ((I-1)*4)+J,
			getHConstraints(Other,RemainingSet,Ones,[Index|Indices],Result).
			
getDConstraints([],Ones,Indices,Result):-
			sort(Indices,IndicesSorted),
			convert(IndicesSorted,1,Ones,[],Result).
			
getDConstraints([d(I,J)|Other],Ones,Indices,Result):-
			Index is ((I-1)*4)+J,
			getDConstraints(Other,Ones,[Index|Indices],Result).
			
%%%%%%%%%%%%%%%%%%%%%%%
% Domain constraints  %
%%%%%%%%%%%%%%%%%%%%%%%
	
domain_problem(P) :-
    term_variables(P,V),
	domain_problem2(V).

domain_problem2([]).
domain_problem2([Elem|V]) :-
    Elem in 1..4,
	domain_problem2(V).

%%%%%%%%%%%%%%%%%%%%%%%
% Height constraints  %
%%%%%%%%%%%%%%%%%%%%%%%

h_constraint([L1,L2,L3,L4], HConstraints):-
	h_constraint(L1,L2,L3,L4, HConstraints).
	
	
h_constraint([],[],[],[],[]).	
h_constraint([L1|L1R],[L2|L2R],[L3|L3R],[L4|L4R],[HK1,HK2,HK3,HK4|Rest]):-
	h_constraint_2(L1,L2,L3,L4,[HK1,HK2,HK3,HK4]),
	h_constraint(L1R,L2R,L3R,L4R,Rest).

h_constraint_2([],[],[],[],[]).
h_constraint_2([E1|L1],[E2|L2],[E3|L3],[E4|L4],[H|Rest]):-
	(	H >= 1 ->
		all_different([E1,E2,E3,E4])
		;
		H == 0
	),
	
	h_constraint_2(L1,L2,L3,L4,Rest).
		
h_constraint([L1,L2,L3,L4]):-
	h_constraint(L1,L2,L3,L4).
	
h_constraint([],[],[],[]).	
h_constraint([L1|L1R],[L2|L2R],[L3|L3R],[L4|L4R]):-
	h_constraint_2(L1,L2,L3,L4),
	h_constraint(L1R,L2R,L3R,L4R).

h_constraint_2([],[],[],[]).
h_constraint_2([E1|L1],[E2|L2],[E3|L3],[E4|L4]):-
	all_different([E1,E2,E3,E4]),
	h_constraint_2(L1,L2,L3,L4).

%%%%%%%%%%%%%%%%%%%%%%%%
% Width constraints    %
%%%%%%%%%%%%%%%%%%%%%%%%
	
w_constraint([],[]).	
w_constraint([[P|R2]|R1],[WK1,WK2,WK3,WK4|Rest]):-
	(	WK1 >= 1 ->
		all_different(P)
		;
		WK1 == 0
	),
	w_constraint_2(R2,[WK2,WK3,WK4]),
	w_constraint(R1,Rest).
	
w_constraint_2([],[]).
w_constraint_2([P|R2],[W|Rest]):-
	(	W >= 1 ->
		all_different(P)
		;
		W == 0
	),
	w_constraint_2(R2,Rest).	

w_constraint([]).	
w_constraint([[P|R2]|R1]):-
	all_different(P),
	w_constraint_2(R2),
	w_constraint(R1).
w_constraint_2([]).
w_constraint_2([P|R2]):-
	all_different(P),
	w_constraint_2(R2).

%%%%%%%%%%%%%%%%%%%%%%
% Depth constraints  %
%%%%%%%%%%%%%%%%%%%%%%

d_constraint([L1,L2,L3,L4],[D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44]):-
	d_constraint_2(L1,[D11,D12,D13,D14]),
	d_constraint_2(L2,[D21,D22,D23,D24]),
	d_constraint_2(L3,[D31,D32,D33,D34]),
	d_constraint_2(L4,[D41,D42,D43,D44]).

d_constraint_2([[],[],[],[]],[]).	
d_constraint_2([[E1|R1],[E2|R2],[E3|R3],[E4|R4]],[D|Rest]):-
	(	D == 1 ->
		all_different([E1,E2,E3,E4])
		;
		D == 0
	),
	d_constraint_2([R1,R2,R3,R4],Rest).	
	
d_constraint([L1,L2,L3,L4]):-
	d_constraint_2(L1),
	d_constraint_2(L2),
	d_constraint_2(L3),
	d_constraint_2(L4).

d_constraint_2([[],[],[],[]]).	
d_constraint_2([[E1|R1],[E2|R2],[E3|R3],[E4|R4]]):-
	all_different([E1,E2,E3,E4]),
	d_constraint_2([R1,R2,R3,R4]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert constraints from list of indices to list with 1 and 0       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
convert([],_,[],List,ReverseList):-
	reverse(List,ReverseList).
	
convert([],_,[_|L],List,ReverseList):-
	convert([],_,L,[1|List],ReverseList).
	
convert([Index|Rest],Counter,[_|L],List,ReverseList):-
	(Index == Counter 
		->
			NewCounter is Counter + 1,
			convert(Rest,NewCounter,L,[0|List],ReverseList)
		;
			NewCounter is Counter + 1,
			convert([Index|Rest],NewCounter,L,[1|List],ReverseList)
	).	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Format solution: [] -> [ [[],[],[],[]],[[],[],[],[]]... ]				%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

formatSolution([A1,A2,A3,A4,B2,B3,B4,B1,C3,C4,C1,C2,D4,D1,D2,D3,E2,E3,E4,E1,F3,F4,F1,F2,G4,G1,G2,G3,H1,H2,H3,H4,I3,I4,I1,I2,J4,J1,J2,J3,K1,K2,K3,K4,L2,L3,L4,L1,M4,M1,M2,M3,N1,N2,N3,N4,O2,O3,O4,O1,P3,P4,P1,P2],Formatted):-

	Formatted = [	[[A1,A2,A3,A4],[B2,B3,B4,B1],[C3,C4,C1,C2],[D4,D1,D2,D3]],
					[[E2,E3,E4,E1],[F3,F4,F1,F2],[G4,G1,G2,G3],[H1,H2,H3,H4]],
					[[I3,I4,I1,I2],[J4,J1,J2,J3],[K1,K2,K3,K4],[L2,L3,L4,L1]],
					[[M4,M1,M2,M3],[N1,N2,N3,N4],[O2,O3,O4,O1],[P3,P4,P1,P2]]
				].