static void t2(void);

static const int s1;
static int s2; /* not good */

void t1(void)
{
  static int v1; /* not good */
  int v2;
}

static void t2(void) { }
