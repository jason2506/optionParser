# optionParser

The missing command-line argument parser for GNU Octave.

## TODOs

* Support positional options
* Support `--` (which terminates all options)
* Support more ways for specifying the option value
  * `--opt=val` (which is equal to `--opt val`)
  * `-ofoo` (which is equal to `-o foo`)
  * `-ijk` (which is equal to `-i -j -k`)
  * `-q 1 -q 2 -q 3` (resulting `q = {1, 2, 3}`)
* Support sub-commands
* Write some test cases
* Documentation
