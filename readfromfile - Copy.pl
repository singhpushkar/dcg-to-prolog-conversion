converttoprolog(X,Y):-readFile(X,Z),makeprologList(Z,L),open(Y,write,Str),writeprologruleTofile(Str,L).

makeprologList([],[]):-!.
makeprologList([X|Y],[Z1|Z]):-isfact(X),!,writerulefact(Z1,X),makeprologList(Y,Z).
makeprologList([X|Y],[Z1|Z]):-writeprologrule(Z1,0,X),makeprologList(Y,Z).

writeprologrule(S,C,[X|Y]) :- C is 0,!,C1 is C+1,writeprologrule(S1,C1,Y),appendstring(X," (X,Y):- ",X1),appendstring(X1,S1,S),!.
writeprologrule(S,C,[X|Y]) :- isempty(Y),C is 1,!, appendstring(X,"(X,Y).",S),!.
writeprologrule(S,C,[X|Y]) :- isempty(Y),!,atom_string(C,CS), appendstring(X,"(X",X1),appendstring(X1,CS,X2),appendstring(X2,",Y).",S),!.
writeprologrule(S,C,[X|Y]) :- C is 1,C1 is C+1,!,number_string(C1,C1S),appendstring(X,"(X,X",X1),appendstring(X1,C1S,X2),appendstring(X2,"), ",Z),writeprologrule(S1,C1,Y),appendstring(Z,S1,S).
writeprologrule(S,C,[X|Y]) :- C1 is C+1,number_string(C,CS),number_string(C1,C1S),appendstring(X,"(X",X1),appendstring(X1,CS,X2),appendstring(X2,",X",X3),appendstring(X3,C1S,X4),appendstring(X4,"), ",Z),writeprologrule(S1,C1,Y),appendstring(Z,S1,S).

writerulefact(S,[X,Y|Z]):-split_string(Y,"]"," ",Z1),Z1 = [F|_],appendstring(X,"(",X1),appendstring(X1,F,X2),appendstring(X2," | X], X).",S).

readFile(X,Y):- open(X,read,Str),read_fileinLineByLine(Str,Y),close(Str).
read_fileinLineByLine(Str,[]):- at_end_of_stream(Str).
read_fileinLineByLine(Str,[X|Y]):- not(at_end_of_stream(Str)), read_line_to_codes(Str,X1),split_string(X1,","," .",X2),converttoList(X2,X),read_fileinLineByLine(Str,Y).
converttoList([X|Y],Z):- split_string(X,"-->"," ",Z1),delete(Z1,"",Z2),append(Z2,Y,Z).

writeprologruleTofile(Str,[]):-close(Str).
writeprologruleTofile(Str,[X|Y]):- write(Str,X),nl(Str),writeprologruleTofile(Str,Y).

isempty([]).
appendstring(A,B,C):- string_concat(A,B,C).

isfact([X,Y|Z]):- isempty(Z),atom_chars(Y,C),C=[L|_],L=='['.