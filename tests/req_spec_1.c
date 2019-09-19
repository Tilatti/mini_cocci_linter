/* ECOS mutexes */

int cyg_mutex_lock(int h) { return h; }
int cyg_mutex_unlock(int h) { return h; }

void t1(void)
{
  int h;

  cyg_mutex_lock(h);
  cyg_mutex_unlock(h);
}

void t2(int cond)
{
  int h;
  int ret;

  ret = cyg_mutex_lock(h); /* not good */
  if (ret != 0)
    return;

  if (cond) {
    return;
  }

  cyg_mutex_unlock(h);
}

void t2_bis(int cond)
{
  int h;
  int ret;

  ret = cyg_mutex_lock(h); /* not good */
  if (ret != 0)
    return;

  if (cond)
    return;

  cyg_mutex_unlock(h);
}

void t3(int cond)
{
  int h;
  int ret;

  ret = cyg_mutex_lock(h); /* not good */
  if (ret != 0)
    return;

  if (cond) {
    cyg_mutex_unlock(h);
    return;
  }
}

void t4(int cond)
{
  int h;
  int ret;

  ret = cyg_mutex_lock(h);
  if (ret != 0)
    return;

  if (cond) {
    cyg_mutex_unlock(h);
    return;
  }

  cyg_mutex_unlock(h);
}

/* MBedTLS MD5 context */

void mbedtls_md5_init(void* p) { }
void mbedtls_md5_free(void* p) { }

void t5(void)
{
  int* p;

  mbedtls_md5_init(p);
  mbedtls_md5_free(p);
}

void t6(int cond)
{
  int* p;

  mbedtls_md5_init(p); /* not good */

  if (cond) {
    return;
  }

  mbedtls_md5_free(p);
}

void t6_bis(int cond)
{
  int* p;

  mbedtls_md5_init(p); /* not good */

  if (cond)
    return;

  mbedtls_md5_free(p);
}

void t7(int cond)
{
  int* p;

  mbedtls_md5_init(p); /* not good */

  if (cond) {
    mbedtls_md5_free(p);
    return;
  }
}

void t8(int cond)
{
  int* p;

  mbedtls_md5_init(p);

  if (cond) {
    mbedtls_md5_free(p);
    return;
  }

  mbedtls_md5_free(p);
}
