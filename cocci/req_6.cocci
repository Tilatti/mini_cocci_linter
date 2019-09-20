//
// DESCRIPTION: Variable is assigned in a condition.
//

@rule_if exists@
statement S;
expression E1;
expression E;
position p;
@@

if@p (<+... E1 = E ...+>) S

@script:python@
p << rule_if.p;
@@

cocci.print_main("ERROR", p)

@rule_while exists@
statement S;
expression E1;
expression E;
position p;
@@

while@p (<+... E1 = E ...+>) S

@script:python@
p << rule_while.p;
@@

cocci.print_main("ERROR", p)
