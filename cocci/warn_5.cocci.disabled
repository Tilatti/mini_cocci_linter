//
// DESCRIPTION: Functions with more than 100 lines (blank line and comments NOT included).
//

@rnotfirst@
statement S1;
statement S2;
position p;

identifier func;
@@

func (...)
{
	...
	S1
	S2@p
	...
}

@r@
position pfirst != rnotfirst.p;
position plast;
statement S1;
statement S2;

position pf;
identifier rnotfirst.func;
@@

func (...)@pf
{
	...
	S1@pfirst
	...
	S2@plast
}

@script:python@
pfirst << r.pfirst;
plast << r.plast;
pf << r.pf;
@@

first_line = int(pfirst[0].line)
last_line = int(plast[0].line)
nb_lines = last_line - first_line
#if nb_lines > 100:
cocci.print_main("Number of lines in the function is too big (" + str(nb_lines) + " > 100): ", pf)
