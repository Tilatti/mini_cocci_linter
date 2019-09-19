void t1(void)
{
  int cond;
  while (1) {
    if (cond)
      continue; /* not good */
  }
}

void t2(void)
{
  int cond;
  int v;
  while (1) {
    if (cond)
      continue;
    v = 1;
  }
}
