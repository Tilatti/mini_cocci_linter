int t1(void) /* not good */
{
  int cond;
  if (cond)
    return 1;
}

int t2(void)
{
  int cond;
  if (cond)
    return 1;
  if (!cond)
    return 1;
  return 0;
}
