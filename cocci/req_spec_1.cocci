//
// DESCRIPTION: Functions initializing a specific context without freed it on all code paths.
//

// ECOS mutex context

@ rule_ecos_mutex exists @
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
p << rule_ecos_mutex.p;
@@

cocci.print_main("SPECIFIC ERROR", p)

// Mbedtls MD5 context

@ rule_mbedtls_md5_context exists @
expression E;
expression RET;
position p;
@@

mbedtls_md5_init(E);@p
... when != mbedtls_md5_free(E);
(
return RET;
|
return;
)

@ script:python @
p << rule_mbedtls_md5_context.p;
@@

cocci.print_main("SPECIFIC ERROR", p)

// Mbedtls X509 Certificate context

@ rule_mbedtls_x509write_context exists @
expression E;
expression RET;
position p;
@@

mbedtls_x509write_crt_init(E);@p
... when != mbedtls_x509write_crt_free(E);
(
return RET;
|
return;
)

@ script:python @
p << rule_mbedtls_x509write_context.p;
@@

cocci.print_main("SPECIFIC ERROR", p)
