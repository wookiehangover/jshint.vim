jshint.vim
=============

Vim plugin and command line tool for running [JHLint][].

[JShint]: http://jshint.com/

JSHint is a handy tool that spots errors and common mistakes in
JavaScript code.

Installation
-----------------------

- Make sure you have a JavaScript interpreter installed.  On Linux jshint.vim
  supports Spidermonkey, Rhino, and node.js.  Spidermonkey or node.js are
  recommended because Rhino tends to have a long startup time.

  In Ubuntu you can install the Spidermonkey shell with this command:

        $ sudo apt-get install spidermonkey-bin

  Latest Ubuntu versions don't have spidermonkey in the default repositories.
  You can use rhino instead:

        $ sudo apt-get install rhino

  Or you can find instructions for installing node.js on the [node.js website][nodejs].

  [nodejs]: http://nodejs.org/

  On Windows you can use `cscript.exe` - which is probably already installed.

  On MacOS X you don't need to install any JavaScript interpreter because one
  is included with OS X by default.

- If you have rake installed, run:

        $ rake install

  Otherwise copy the directory ftplugin/ into your Vim ftplugin directory.
  Usually this is `~/.vim/ftplugin/`. On Windows it is `~/vimfiles/ftplugin/`.

- Finally, activate filetype plugins in your .vimrc, by adding the following line:

        filetype plugin on


Usage
-----------------------

- This plugin automatically checks the JavaScript source and highlights the
  lines with errors.

  It also will display more information about the error in the commandline if the curser is
  in the same line.

- You also can call it manually via `:JSLintUpdate`

- You can toggle automatic checking on or off with the command `:JSLintToggle`.
  You can modify your `~/.vimrc` file to bind this command to a key or to turn
  off error checking by default.

- (optional) Add any valid JSLint options to `~/.jshintrc` file, they will be
  used as global options for all JavaScript files.
  For example:

        /*jshint browser: true, regexp: true */
        /*global jQuery, $ */

        /* vim: set ft=javascript: */

To get a detailed report of any issues in your JavaScript file outside of Vim,
run the `bin/jshint` executable in a terminal. For example:

    $ bin/jshint ftplugin/jshint/fulljshint.js

You can copy `bin/jshint` into for `PATH` for easier access. The executable
requires that the Vim plugin is installed and also requires Ruby.

To disable error highlighting altogether add this line to your `~/.vimrc` file:

    let g:JSLintHighlightErrorLine = 0


Working with quickfix
------------------------

When automatic error checking is enabled jshint.vim will automatically display
errors in the [quickfix][] window in addition to highlighting them.

You can open and close the quickfix window with the commands `:copen` and
`:cclose`.  Use the command `:cn` to go to the next error or `:cc [nr]` to go
to a specific error, where `[nr]` is a number.  The first error in the list is
`1`, the second is `2`, and so on.

Once an error is fixed the corresponding quickfix line will disappear.

[quickfix]: http://vimdoc.sourceforge.net/htmldoc/quickfix.html  "Vim documentation: quickfix"