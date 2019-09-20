//
// DESCRIPTION: Non constant static variable. (global variable to module).
//

@rule_const@
identifier I;
type T;
position p;
@@

(
static const T* I;@p
|
static const T I;@p
|
static const T I[...];@p
)

@rule@
identifier I;
type T;
position p != rule_const.p;
@@

static T I;@p

@script:python@
p << rule.p;
@@

cocci.print_main("WARNING", p)
