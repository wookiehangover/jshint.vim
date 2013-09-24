# jshint.vim

A [jshint](https://github.com/jshint/jshint) flavor of [hallettj's
jslint.vim](https://github.com/hallettj/jslint.vim).

v0.9.0

## Installation

**[Node.js](http://nodejs.org) must be in your path.**

Recommended for use with [tpope's Pathogen](https://github.com/tpope/vim-pathogen) plugin runtime management system or [vundle](https://github.com/gmarik/vundle).

If you're old school or not into pathogen, there is a Makefile to copy everything into your `~/.vim` directory.

## Usage

### Automatically

This plugin automatically checks the JavaScript source and highlights the lines with errors on file writes, entering a buffer and leaving insert mode. It also will display more information about the error in the commandline if the curser is in the same line.

To disable automatic checking and only check when the file is written, use the following in your ~/.vimrc or set it at runtime:
`let JSHintUpdateWriteOnly=1`

### Manually check the file

`:JSHintUpdate`

### Toggle automatic checking of a file

This can also be set in the `~/.vimrc` file to bind this command to a key or to turn off error checking by default:

`:JSHintToggle`

### Working with quickfix

When automatic error checking is enabled, jshint.vim will automatically display errors in the [quickfix][] window in addition to highlighting them.

You can open and close the quickfix window with the commands `:copen` and `:cclose`.  Use the command `:cn` to go to the next error or `:cc [nr]` to go to a specific error, where `[nr]` is a number.  The first error in the list is `1`, the second is `2`, and so on.

Once an error is fixed the corresponding quickfix line will disappear.

[quickfix]: http://vimdoc.sourceforge.net/htmldoc/quickfix.html  "Vim documentation: quickfix"

## Configuration

### ~/.vimrc Options

#### Disable error highlighting

`let g:JSHintHighlightErrorLine = 0`

### JSHint options

Add any valid JSHint options to a `~/.jshintrc` file. These options will be used as global options for all JavaScript files. There is an example file at [Official Example](https://github.com/jshint/jshint/blob/master/examples/.jshintrc)

```js
/*jshint browser: true, laxcomma, true, asi: true */
/*global deepEqual, equal, notEqual, test, ok, raises */
```
