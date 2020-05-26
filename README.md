# sectional-couch.vim

Vi/vim are well known for how easy it is to move around with a minimum of keystrokes. But some of the built-in motions -- specifically `[[`/`]]` (start of prior/next section), `[]`/`][` (end of prior/next section), and `{`/`}` (prior/next paragraph) -- are hard-coded to be most useful in C-like programming, or for editing nroff text.

Seriously. Look at the [help for object motions](https://vimhelp.org/motion.txt.html#object-motions). There are `'paragraphs'` and `'sections'` options, but they have to hold lists of nroff macros. Without that, paragraphs are identified by blank lines, and sections by a form-feed (`<C-L>`) character in the first column.

The official recommendation in that documentation, and general common practice, is to map over top of these potentially useful motions. I made sectional-couch in the hope that it would make that a bit easier. With sectional couch, you can just specify regular expressions to tell vim better ways of identifying paragraph and section breaks.

## Installation

Install like any other vim plugin. If you have a package manager, consult its documentation. If you don't but are using Vim 8.0 or greater, use its [built-in package management](https://vimhelp.org/repeat.txt.txt.html#packages).

This plugin hasn't been tested in neovim, but I imagine it should work.

It shouldn't interfere with any per-filetype mappings provided by other plugins, since those mappings will override the sectional-couch ones. But this is still very early days of development, and there are probably cases where it breaks things.

## Usage

The recommended use is via a [filetype plugin](https://vimhelp.org/filetype.txt.html), since the whole point is that sections and paragraphs have different meanings in different editing contexts.

In your filetype plugin, set the standard `sections` and/or `paragraphs` options to a regular expression, surrounded by `/` characters, that indicates the start of a section or paragraph respectively. (You will probably need to add extra backslash-escapes.)

For example, if you want a markdown `#`-delimited header to be the start of a section:

    setlocal sections=/^#\\{1,6\\}/
    " or, to remove one level of backslashes:
    let &sections='/^#\{1,6\}/'

Then you can use `[[` and `]]` to hop back and forth between headers.

To get back to the normal vim behaviour, reset the respective options to their defaults (or really, anything that doesn't start and end with `/`):

    setlocal sections&

As a less-tested experimental feature, for `sections` only, you can set it to two space-separated regular expressions, with the second one indicating how to find the end of a section.

For example, for an overly simplistic way to use the start and end of vimscript functions as the start and end of sections, one might use:

    setlocal sections=/^function/\ /^endfunction/
    " or
    let &sections='/^function/ /^endfunction/'

(This won't actually work in vim programming, since vim comes with a filetype macro with its own mappings for `]]` et al. This is just a demonstration.)

If your section boundaries themselves include `/ /` in them, put backslashes in front of each forward slash of your expression.

## Warnings, Caveats, and Future Improvements

The `/` on either end isn't (currently) actually used for the search operation, it's just a way for sectional-couch to detect that you've overridden the option. In the future I may improve this so you can use search modifiers such as `//i` and `//e`.

## License and Acknowledgements

Copyright David Perry, aka Boolean263. Distributed under the same terms as Vim itself. See [`:help license`](https://vimhelp.org/uganda.txt.html).

This work was inspired by chapters [50](https://learnvimscriptthehardway.stevelosh.com/chapters/50.html) and [51](https://learnvimscriptthehardway.stevelosh.com/chapters/51.html) of _Learn Vimscript the Hard Way_.
