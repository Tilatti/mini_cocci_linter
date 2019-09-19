void t1(void)
{
  int v;
  int v2;

  v = sizeof(int);
  v = sizeof(char); /* not good */
}

void t2(void)
{
  int v;
  int v2;

  v = sizeof(int);
  v = v + sizeof(char);
}

void t3(void)
{
  int v;
  int v2;

  v = sizeof(int);
  v += sizeof(char);
}
