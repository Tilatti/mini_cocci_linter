//
// DESCRIPTION: Array indexed with a magic number (without using a const or a define) superior to 4.
//

@r1@
identifier func;
expression x;
constant C;
position p;
@@

x[C@p]

@script: python@
p << r1.p;
C << r1.C;
@@

try:
	index = int(C)
except:
	pass
else:
	if index > 4:
		cocci.print_main("ERROR", p)
