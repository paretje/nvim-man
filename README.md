# man.vim

View man pages in vim. Grep for the man pages.

### Features and Usage

##### Viewing man pages

- `:Man printf` - open `printf(1)` man page in a split
- `:Vman 3 putc` - open `putc(3)` man page in a vertical split (read more
  [here](http://unix.stackexchange.com/a/3587/80379) on what the
  manual page numbers mean, they are really useful)
- `:Man pri<Tab>` - command completion for man page names
- `:Man 3 pri<Tab>` - completion "respects" the man page section argument
- `:Man 6 <Ctrl-D>` - list all man pages from section 6

##### Using from the shell

You can use vim-man from the shell (instead of standard `man` program) using
the following script:

    #! /bin/sh
    nvim -c "Man $1 $2" -c 'silent only'

Save it in `/usr/bin/` as a file named `viman`, give it execution
permission with:

    $ chmod +x /usr/bin/viman

Then from your shell you can read a DOC with:

    $ viman doc

Or you can use the alias `alias man=viman` so you can do (as usual):

    $ man doc

### Installation

Just use your favorite plugin manager.

If you were previously using `man.vim` that comes with vim by default, please
remove this line `runtime! ftplugin/man.vim` from your `.vimrc`. It's known to
be causing [issues](https://github.com/vim-utils/vim-man/issues/23) with this
plugin. See credits for differences between vim-man and nvim-man, but keep in
mind that you can't use both at the same time.

### Contributing

Contributing and bug fixes are welcome. If you have an idea for a new feature
please get in touch by opening an issue so we can discuss it first.

### Credits

Neovim by default comes with man page viewer, as decribed in
[find-manpage](http://vimdoc.sourceforge.net/htmldoc/usr_12.html#find-manpage).
This work is based on [vim-man](https://github.com/vim-utils/vim-man), using
neovim's terminal to view the man. By using the man command in terminal, full
markup of the man command is kept intact. On top of that, syntax coloring is
applied. This plugin does use the default vim syntax file, and doesn't provide
vim-man's Mangrep command, as it's currently broken. It shouldn't be difficult
to fix, but it seems too slow to be usefull anyway. If you care about this
feature, revert the relevant commit and fix the neovim code.

These people created and maintain (or maintained) `man.vim` that comes with vim
itself:
* SungHyun Nam
* Gautam H. Mudunuri
* Johannes Tanzler

### License

Vim license, see `:help license`.
