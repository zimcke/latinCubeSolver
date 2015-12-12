%% Generate sets of constraints
%% Written in B-Prolog by Zimcke Van de Staey and Tobias Verlinde

:- include(generator).

matrix(
	[
		[[1,1,1,1],
		 [0,1,1,1],
		 [0,1,1,1],
		 [0,1,1,1]],
		 
		[[0,1,1,1],
		 [0,1,1,1],
		 [0,1,1,1],
		 [0,1,1,1]],
		 
		[[0,1,1,1],
		 [0,1,1,1],
		 [0,1,1,1],
		 [0,1,1,1]]
	]).
	
getBitstream(MatricesConstraints,Bitstream):-
	flatten(MatricesConstraints,Bitstream).

isMinimal(Bitstream):-
	((findSmaller(Bitstream)) ->
		true
	;
		false
	).	

findSmaller(BitStream):-
	once((permutation(BitStream,Permutation), Permutation =< BitStream)).