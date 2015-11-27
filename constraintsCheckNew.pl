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
	w_constraint(Solution,Ones),
	h_constraint(Solution,Ones),
	d_constraint(Solution,Ones).
	
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

domain_problem([]).	
domain_problem([E|L]) :-
	E in 1..4,
	domain_problem(L).

%%%%%%%%%%%%%%%%%%%%%%%
% Height constraints  %
%%%%%%%%%%%%%%%%%%%%%%%

h_constraint([],[]).	
h_constraint([A1,A2,A3,A4,B1,B2,B3,B4,C1,C2,C3,C4,D1,D2,D3,D4,E1,E2,E3,E4,F1,F2,F3,F4,G1,G2,G3,G4,H1,H2,H3,H4,I1,I2,I3,I4,J1,J2,J3,J4,K1,K2,K3,K4,L1,L2,L3,L4,M1,M2,M3,M1,N1,N2,N3,N4,O1,O2,O3,O4,P1,P2,P3,P4],[H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44]):-
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

h_constraint_2(P,H)
	(	H >= 1 ->
		all_different(P)
		;
		H == 0
	).

%%%%%%%%%%%%%%%%%%%%%%%%
% Width constraints    %
%%%%%%%%%%%%%%%%%%%%%%%%
	
w_constraint([],[]).	
w_constraint([A1,A2,A3,A4,B1,B2,B3,B4,C1,C2,C3,C4,D1,D2,D3,D4,E1,E2,E3,E4,F1,F2,F3,F4,G1,G2,G3,G4,H1,H2,H3,H4,I1,I2,I3,I4,J1,J2,J3,J4,K1,K2,K3,K4,L1,L2,L3,L4,M1,M2,M3,M1,N1,N2,N3,N4,O1,O2,O3,O4,P1,P2,P3,P4],[W11,W12,W13,W14,W21,W22,W23,W24,W31,W32,W33,W34,W41,W42,W43,W44]):-
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
	

w_constraint_2(P,W)
	(	W >= 1 ->
		all_different(P)
		;
		W == 0
	).

%%%%%%%%%%%%%%%%%%%%%%
% Depth constraints  %
%%%%%%%%%%%%%%%%%%%%%%

d_constraint([],[]).	
d_constraint([A1,A2,A3,A4,B1,B2,B3,B4,C1,C2,C3,C4,D1,D2,D3,D4,E1,E2,E3,E4,F1,F2,F3,F4,G1,G2,G3,G4,H1,H2,H3,H4,I1,I2,I3,I4,J1,J2,J3,J4,K1,K2,K3,K4,L1,L2,L3,L4,M1,M2,M3,M1,N1,N2,N3,N4,O1,O2,O3,O4,P1,P2,P3,P4],[D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44]):-
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

d_constraint_2(P,D)
	(	D >= 1 ->
		all_different(P)
		;
		D == 0
	).
	
