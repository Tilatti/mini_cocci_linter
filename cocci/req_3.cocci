//
// DESCRIPTION: Expression computing the size of a pointer (sizeof(char*)).
//
// License:  Licensed under ISC. See LICENSE or http://www.isc.org/software/license
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
// URL: http://coccinelle.lip6.fr/ 
// URL: http://coccinellery.org/

@r2@
expression *x;
expression f;
position p;
type T;
@@

(
memset(...)
|
f(...,(T)x@p,...,sizeof(x),...)
|
f(...,sizeof(x),...,(T)x@p,...)
)

@r@
expression *E;
position p;
@@

sizeof(E)@p

@ script:python @
pbad << r.p;
@@

cocci.print_main("ERROR: sizeof(pointer) is suspicious.", pbad)
