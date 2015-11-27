%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Indicate all constraints that are absent in order w(),h(),d(): %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% One Direction
% h could be any direction t
/*
constraints([h(1,1)], 'ODC1').
constraints([h(1,1),h(1,2)], 'ODC2').
constraints([h(1,1),h(1,2),h(1,3)], 'ODC3').
constraints([h(1,1),h(1,2),h(1,3),h(1,4)], 'ODC4').
constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1)], 'ODC5').


constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2)], 'ODC6').


constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2),h(2,3)], 'ODC7').
constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2),h(2,3),h(2,4)], 'ODC8').
constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2),h(2,3),h(2,4),h(3,1)], 'ODC9').
constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2),h(2,3),h(2,4),h(3,1),h(3,2)], 'ODC10').
constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2),h(2,3),h(2,4),h(3,1),h(3,2),h(3,3)], 'ODC11').
constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2),h(2,3),h(2,4),h(3,1),h(3,2),h(3,3),h(3,4)], 'ODC12').
constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2),h(2,3),h(2,4),h(3,1),h(3,2),h(3,3),h(3,4),h(4,1)], 'ODC13').
constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2),h(2,3),h(2,4),h(3,1),h(3,2),h(3,3),h(3,4),h(4,1),h(4,2)], 'ODC14').
constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2),h(2,3),h(2,4),h(3,1),h(3,2),h(3,3),h(3,4),h(4,1),h(4,2),h(4,3)], 'ODC15').
constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2),h(2,3),h(2,4),h(3,1),h(3,2),h(3,3),h(3,4),h(4,1),h(4,2),h(4,3),h(4,4)], 'ODC16').
constraints([h(1,1),h(2,1)], 'ODC17').
constraints([h(1,1),h(2,1),h(3,1)], 'ODC18').
constraints([h(1,1),h(2,1),h(3,1),h(4,1)], 'ODC19').
constraints([h(1,1),h(1,2),h(2,1),h(3,1),h(4,1)], 'ODC20').
constraints([h(1,1),h(1,2),h(2,1),h(2,2),h(3,1),h(4,1)], 'ODC21').
constraints([h(1,1),h(1,2),h(2,1),h(2,2),h(3,1),h(3,2),h(4,1)], 'ODC22').
constraints([h(1,1),h(1,2),h(2,1),h(2,2),h(3,1),h(3,2),h(4,1),h(4,2)], 'ODC23').
constraints([h(1,1),h(1,2),h(1,3),h(2,1),h(2,2),h(3,1),h(3,2),h(4,1),h(4,2)], 'ODC24').
constraints([h(1,1),h(1,2),h(1,3),h(2,1),h(2,2),h(2,3),h(3,1),h(3,2),h(4,1),h(4,2)], 'ODC24').
constraints([h(1,1),h(1,2),h(1,3),h(2,1),h(2,2),h(2,3),h(3,1),h(3,2),h(3,3),h(4,1),h(4,2)], 'ODC25').
constraints([h(1,1),h(1,2),h(1,3),h(2,1),h(2,2),h(2,3),h(3,1),h(3,2),h(3,3),h(4,1),h(4,2),h(4,3)], 'ODC26').
constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2),h(2,3),h(3,1),h(3,2),h(3,3),h(4,1),h(4,2),h(4,3)], 'ODC27').
constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2),h(2,3),h(2,4),h(3,1),h(3,2),h(3,3),h(4,1),h(4,2),h(4,3)], 'ODC28').
constraints([h(1,1),h(1,2),h(1,3),h(1,4),h(2,1),h(2,2),h(2,3),h(2,4),h(3,1),h(3,2),h(3,3),h(3,4),h(4,1),h(4,2),h(4,3)], 'ODC29').

% One constraint
constraints([w(1,2)], '1 w-constraint').
constraints([h(2,3)], '1 h-constraint').
constraints([d(4,1)], '1 d-constraint').

% Two constraints
constraints([h(1,1),h(1,2)], '2 constraints case 1').
constraints([h(1,1),d(1,2)], '2 constraints case 2').
constraints([w(1,2),d(1,4)], '2 constraints case 3').
constraints([w(1,4),d(1,4)], '2 constraints case 4').
constraints([w(1,1),w(1,2)], '2 constraints case 5').
constraints([w(1,4),w(2,4)], '2 constraints case 6').

% Tree constraints
constraints([h(1,1),h(1,2),h(1,3)], '3 constraints case 1').
constraints([h(1,1),h(1,2),h(2,1)], '3 constraints case 2').
constraints([h(1,1),h(3,1),h(2,1)], '3 constraints case 3').
constraints([h(1,1),h(2,2),h(2,3)], '3 constraints case 4').
constraints([h(1,1),h(2,2),h(3,3)], '3 constraints case 5').
constraints([w(1,1),h(2,1),h(3,3)], '3 constraints case 6').
constraints([w(1,1),h(3,1),h(3,3)], '3 constraints case 7').
constraints([w(1,1),h(2,2),h(3,2)], '3 constraints case 8').
constraints([w(1,1),h(1,1),h(3,3)], '3 constraints case 9').
constraints([w(1,1),h(1,1),h(4,1)], '3 constraints case 10').
constraints([w(1,1),h(1,1),h(1,2)], '3 constraints case 11').
constraints([w(1,2),w(1,1),h(2,3)], '3 constraints case 12').
constraints([w(1,2),w(1,1),h(1,3)], '3 constraints case 13').
*/
constraints([w(1,1),h(1,2),d(2,1)], '3 constraints case 14').

/*
constraints([w(4,4),h(4,4),d(4,4)], 'tester').
*/