//
// DESCRIPTION: Useless continue at the end of a loop.
//
// License:  Licensed under ISC. See LICENSE or http://www.isc.org/software/license
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
// URL: http://coccinelle.lip6.fr/ 
// URL: http://coccinellery.org/

@r1 forall@
position p;
@@

while (...) {
  ...
  if (...) {
    ...
    continue;@p
  }
}

@r2 forall@
position p;
@@

for (...;...;...) {
  ...
  if (...) {
    ...
    continue;@p
  }
}

@script:python@
p << r1.p;
@@

cocci.print_main("WARNING", p)

@script:python@
p << r2.p;
@@

cocci.print_main("WARNING", p)
