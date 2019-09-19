void t1(void)
{
  int v;
  if (v = 1) /* not good */
    return;
  if (v == 1)
    return;
  if ((v = 1) == 1) /* not good */
    return;
}

void t2(void)
{
  int v;
  while (v = 1) /* not good */
    return;
  while (v == 1)
    return;
  while ((v = 1) == 1) /* not good */
    return;
}
