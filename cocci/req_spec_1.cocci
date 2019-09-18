@ rule_ecos exists @
expression E;
expression RET1;
expression RET2;
position p;
@@

(
cyg_mutex_lock(E);@p
|
RET1 = cyg_mutex_lock(E);@p
if (<+...RET1...+>)
  return ...;
)
... when != cyg_mutex_unlock(E);
(
return RET2;
|
return;
)

@ script:python @
p << rule_ecos.p;
@@

cocci.print_main("SPECIFIC ERROR: Mutex has not been unlocked.", p)
