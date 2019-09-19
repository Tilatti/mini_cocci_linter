void t1(void)
{
  int i;
  int v;
  int* p;

  i = sizeof(char);
  i = sizeof(p); /* not good */
  i = sizeof(v);
  i = sizeof(&v); /* not good */
}
