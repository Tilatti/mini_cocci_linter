# mini_cocci_linter
*mini_cocci_linter* is a small C linter using spatch program from the [coccinelle project](https://github.com/coccinelle/coccinelle).

## Usage

```console
$ ./check_code.sh <directory with C source code>
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

## Bugs

* Is the cocci/req_2.cocci broken ?
* Why is cocci/warn_5.cocci disabled ?
