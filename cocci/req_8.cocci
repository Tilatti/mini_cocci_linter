//
// DESCRIPTION: Functions with more than 200 lines (blank line and comments included).
//

@initialize:python@
@@

func_lines = []

@r@
identifier func;
position pfunc;
position pbegin;
position pend;
@@

func(...)@pfunc@pbegin {
	... when exists
	return ...;@pend
}

@script:python@
pfunc << r.pfunc;
pbegin << r.pbegin;
pend << r.pend;
@@

func_line = int(pfunc[0].line)
begin_line = int(pbegin[0].line)
end_line = int(pend[0].line)

if ((end_line - begin_line) > 200) and (func_line not in func_lines):
	func_lines.append(func_line)
	cocci.print_main("ERROR: More than 200 lines in this function.", pfunc)
