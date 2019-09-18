//
// DESCRIPTION: A condition is directly followed by a ";" (without a statement).
//
// License:  Licensed under ISC. See LICENSE or http://www.isc.org/software/license
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
// URL: http://coccinelle.lip6.fr/ 
// URL: http://coccinellery.org/

@r1@
position p;
@@
if (...);@p

@script:python@
p0 << r1.p;
@@
cocci.print_main("ERROR: The if condition seems to be useless.", p0)
