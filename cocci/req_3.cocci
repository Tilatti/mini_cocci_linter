//
// DESCRIPTION: Expression computing the size of a pointer.
//
// License:  Licensed under ISC. See LICENSE or http://www.isc.org/software/license
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
// URL: http://coccinelle.lip6.fr/ 
// URL: http://coccinellery.org/

@r@
expression *E;
position p;
@@

sizeof(E)@p

@ script:python @
pbad << r.p;
@@

cocci.print_main("ERROR", pbad)
