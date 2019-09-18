//
// DESCRIPTION: Signed integer which can be declared as unsigned.
// 
// License:  Licensed under ISC. See LICENSE or http://www.isc.org/software/license
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
// URL: http://coccinelle.lip6.fr/ 
// URL: http://coccinellery.org/

@r exists@ // find anything that might decrement the variable
identifier i;
expression E;
position p;
@@

  int i@p;
  ...
(
  &i
|
  i--
|
  --i
|
  i-=E
|
  i+=E
)

@x disable decl_init@
identifier r.i;
expression E;
position p1 != r.p;
@@

(
  volatile int i = 0;
|
  volatile int i;
|
  int i@p1 = 0;
|
  int i@p1;
)
  <... when != i = E
(
  i = 0
|
  i = 1
)
  ...>

@ script:python @
p1 << x.p1;
@@

cocci.print_main("Should be an unsigned integer ?:", p1)
