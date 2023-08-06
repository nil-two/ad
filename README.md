ad
==

[![CI](https://github.com/nil-two/ad/actions/workflows/test.yml/badge.svg)](https://github.com/nil-two/ad/actions/workflows/test.yml)

Chdir with file-manager.

```
$ pwd
/path/to/directory

$ ad
/path/to/directory

dir1/
dir2/
file1.txt
file2.txt
(Up, up, up, move to another/, move to directory/, chdir and exit)

$ pwd
/another/directory
```

Usage
-----

```
$ ad [<option(s)>]
chdir with file-manager.

options:
  -w, --wrapper=<shell>  output the wrapper script for the shell and exit
      --help             print usage and exit

supported-shells:
  sh, bash

keys:
  +       toggle show hidden files (default: OFF)
  -       chdir to the parent directory in file-manager
  <CR>    chdir to the directory in file-manager
  <C-g>   quit file-manager and chdir to the last directory
  q       quit file-manager
```

Requirements
------------

- Bash (Even if you are not using Bash)
- Vim

Installation
------------

1. Copy `ad` into your `$PATH`.
2. Make `ad` executable.
3. Add the following config to your shell's profile.

| Shell |                      |
|-------|----------------------|
| sh    | eval "$(ad -w sh)"   |
| bash  | eval "$(ad -w bash)" |

### Example

```
$ curl -L https://raw.githubusercontent.com/nil-two/ad/master/ad > ~/bin/ad
$ chmod +x ~/bin/ad
$ echo 'eval "$(ad -w bash)"' >> ~/.bashrc
```

Note: In this example, `$HOME/bin` must be included in `$PATH`.

Also, if you are using Bash, you can execute `ad` from a shortcut key by adding the following config to your `.bashrc`.

```
bind -x '"\C-g": ad'
```

Options
-------

### -w, --wrapper=\<shell\>

Output the wrapper script for the `shell` and exit.
If you load the script, you will be able to chdir when you press `<C-g>` in file-manager.

Supported shells are as follows:

- sh
- bash

```
$ eval "$(ad -w sh)"
(Enable the shell integration for the shell compatible with Bourne Shell)

$ eval "$(ad -w bash)"
(Enable the shell integration for Bash)
```

### --help

Print usage and exit.

```
$ ad --help
(Print usage)
```

License
-------

MIT License

Author
------

nil2 <nil2@nil2.org>
