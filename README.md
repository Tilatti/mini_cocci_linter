# mini_cocci_linter
*mini_cocci_linter* is a small C linter using spatch program from the [coccinelle project](https://github.com/coccinelle/coccinelle).

## Usage

```console
Usage:
        Execute requirements on source code of a directory: ./check_code.sh [-r <requirement>] <directory>
        Execute the test cases: ./check_code.sh -t [-r <requirement>]
        Print this help: ./check_code.sh -h
```

Check all the requirements on the C source code files inside a directory (and its sub-directories).

```console
$ ./check_code.sh <directory>
```

Same as previously, but its check only the requirement *req_3*:

```console
$ ./check_code.sh -r req_3 <directory>
```

Execute the self-tests for all the requirements:

```console
$ ./check_code.sh -t
```

## Dependencies

* bash
* spatch
* clang

## Notes

Each requirement checks one rule using a coccinelle script inside the cocci
directory.

Some scripts come from the examples of the cocinelle project.
* req_1.cocci: [ifco.cocci](https://github.com/coccinelle/coccinellery/tree/master/ifcol/ifcol.cocci)
* req_2.cocci: [dc.cocci](https://github.com/coccinelle/coccinellery/blob/master/double_call/dc.cocci)
* req_3.cocci: [sz.cocci](https://github.com/coccinelle/coccinellery/blob/master/sz/sz.cocci)
* req_4.cocci: [if-semicolon.cocci](https://github.com/coccinelle/coccinellery/blob/master/if-semicolon/if-semicolon.cocci)
* warn_1.cocci: [signed.cocci](https://github.com/coccinelle/coccinellery/blob/master/signed/signed.cocci)
* warn_2.cocci: [cont.cocci](https://github.com/coccinelle/coccinellery/blob/master/drop_continue/cont.cocci)

You can implement our own requirement. For example, if we want to detect when
the goto jumps to a label preceding this goto, we will add the following file
*cocci/goto_req.cocci* :

```
//
// DESCRIPTION: Detect use of backward goto.
//

@r@
position p;
identifier label;
@@

label:
...
goto label;@p

@script:python@
p << r.p;
@@
cocci.print_main("ERROR", p)
```

To check the requirement on a directory containing C files:

```console
$ ./check_code.sh -r goto_req.cocci /home/foo/src
```

We will also add a test in order to verify if the requirement do what we
expect. Add the file *cocci/goto_req.c*:

```
void t1(void)
{
  goto F;
F:
  return;
}

void t2(void)
{
  goto F;
  while(0);
F:
  return;
}

void t3(void)
{
F:
  while(0);
  goto F; /* not good */
  return;
}
```

Note that the place where the requirement shall detect an error is marked with
the comment ```/* not good */```. Now we can execute the test case:

```console
$ ./check_code.sh -t -r goto_req.cocci
```

## Bugs

* Is the cocci/req_2.cocci broken ?
* Why is cocci/warn_5.cocci disabled ?
