void t1(void)
{
  char a[32];
  int v;

  v = a[0];
  v = a[1];
  v = a[2];
  v = a[3];
  v = a[4];
  v = a[5]; /* not good */
  v = a[31]; /* not good */
  v = a[255]; /* not good */
}
