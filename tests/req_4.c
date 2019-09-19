void t1(void)
{
  int cond;
  if (cond)
    return;
  if (cond); /* not good */
}
