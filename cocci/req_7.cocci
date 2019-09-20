//
// DESCRIPTION: In a function returning a value, there is path without value returned.
//

@voidfunc@
function FN;
position voidpos;
@@

void FN@voidpos(...) {
	...
}

@func disable ret exists@
type T;
expression E;
function FN;
position pos != voidfunc.voidpos;
@@
T FN@pos(...) {
	... when != return E;
}

@script:python@
p << func.pos;
@@

cocci.print_main("ERROR", p)
