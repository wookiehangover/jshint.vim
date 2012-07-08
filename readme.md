# jshint.vim

A [jshint](https://github.com/jshint/jshint) flavor of [hallettj's
jslint.vim](https://github.com/hallettj/jslint.vim).

### Installation

Recommended for use with [tpope's
Pathogen](https://github.com/tpope/vim-pathogen) plugin runtime
management system.

**Node.js must be in your path.**

### Usage

* This plugin automatically checks the JavaScript source and highlights the lines with errors.

It also will display more information about the error in the commandline if the curser is in the same line.

* You also can call it manually via `:JSHintUpdate`

* You can toggle automatic checking on or off with the command
  `:JSHintToggle`. You can modify your `~/.vimrc` file to bind this command to a key or to turn off error checking by default.

* (optional) Add any valid JSHint options to `~/.jshintrc` file, they
  will be used as global options for all JavaScript files. For example:

      /*jshint browser: true, laxcomma, true, asi: true */
      /*global deepEqual, equal, notEqual, test, ok, raises */

To disable error highlighting altogether add this line to your ~/.vimrc file:

    let g:JSHintHighlightErrorLine = 0


### Working with quickfix

When automatic error checking is enabled jshint.vim will automatically display
errors in the [quickfix][] window in addition to highlighting them.

You can open and close the quickfix window with the commands `:copen` and
`:cclose`.  Use the command `:cn` to go to the next error or `:cc [nr]` to go
to a specific error, where `[nr]` is a number.  The first error in the list is
`1`, the second is `2`, and so on.

Once an error is fixed the corresponding quickfix line will disappear.

[quickfix]: http://vimdoc.sourceforge.net/htmldoc/quickfix.html  "Vim documentation: quickfix"
