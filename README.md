ad
==

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
usage:
  ad
  ad -w|--wrapper <SHELL>
  ad --help
chdir with file-manager.

options:
  -w, --wrapper=SHELL  output evaluatable script for SHELL and exit
      --help           print usage and exit

keys:
  +       toggle show hidden files (default: OFF)
  -       chdir to the parent directory in file-manager
  <CR>    chdir to the directory in file-manager
  <C-g>   quit file-manager and chdir to the last directory
  q       quit file-manager

supported-shells:
  bash
```

Requirements
------------

- Bash
- Vim

Installation
------------

1. Copy `ad` into your `$PATH`.
2. Make `ad` executable.
3. Add following config to your shell's rc file.

| Shell |                       |
|-------|-----------------------|
| bash  | eval "$(cdf -w bash)" |

### Example

```
$ curl -L https://raw.githubusercontent.com/kusabashira/ad/master/ad > ~/bin/ad
$ chmod +x ~/bin/ad
$ echo 'eval "$(ad -w bash)"' >> ~/.bashrc
```

Note: In this example, `$HOME/bin` must be included in `$PATH`.

Options
-------

### -w, --wrapper=SHELL

Output evaluatable script for SHELL and exit.

```
$ eval "$(ad -w bash)"
(Enable shell integration for bash)
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
