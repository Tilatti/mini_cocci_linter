//
//  Adjust confusing if/while/for indentation
//
// r: 
//   if (cond)
//     statement1
//     statement2 
//
// r2:
//   while (cond);
//     statement
//
// Target: Linux
// Copyright:  2012 - LIP6/INRIA
// License:  Licensed under ISC. See LICENSE or http://www.isc.org/software/license
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
// URL: http://coccinelle.lip6.fr/ 
// URL: http://coccinellery.org/ 

@r disable braces4@ // braces4 isomorphisme needs to be disabled.
position p1,p2,p3;
statement S1,S2;
@@

(
for (...;...;...);
|
while (...);
|
if (...) { ... }
|
for (...;...;...) { ... }
|
while (...) { ... }
|
if@p3 (...) S1@p1 S2@p2
|
for@p3 (...;...;...) S1@p1 S2@p2
|
while@p3 (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
p3 << r.p3;
@@

indent_level = 2
if (int(p1[0].line) != int(p3[0].line)):
	if int(p1[0].column) != (int(p2[0].column) + indent_level):
		cocci.print_main("Bad indentation ?: ", p1)
else:
	if int(p3[0].column) != int(p2[0].column):
		cocci.print_main("Bad indentation ?: ", p1)

@r2 disable braces4@ // braces4 isomorphisme needs to be disabled.
position p1,p2;
statement S;
@@

(
for@p2 (...;...;...); S@p1
|
while@p2 (...); S@p1
)

@script:python@
p1 << r2.p1;
p2 << r2.p2;
@@

indent_level = 2
if (int(p1[0].line) != int(p2[0].line)) and (int(p1[0].column) != int(p2[0].column)):
	cocci.print_main("ERROR: Bad indentation ?: " + str(p1[0].line) +  ", " + str(p2[0].line), p1)
