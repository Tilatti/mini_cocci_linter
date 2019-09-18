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
		cocci.print_main("ERROR: A number is directly used as index (maybe a define is relevant).", p)
