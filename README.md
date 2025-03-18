# C2 Mode

[![MELPA](https://melpa.org/packages/c2-mode-badge.svg)](https://melpa.org/#/c2-mode)

_c2-mode_ -- major mode for editing code written
in the [C2 Programming Language](http://c2lang.org/).

_c2-mode_ supports:

- syntax highlighting;
- proper indentations;
- autoload for `*.c2`, `*.c2i`, `*.c2t` files.

_c2-mode_ doesn't support:

- correctness checking;
- tooltips and auto completion.

## Customization

You can set the width of the indentation by setting the customizable user option
variable `c2-indent-offset` from customization group `c2`. By default, it is set
to `2`.

## Details

_c2-mode_ based on `cc-mode` for proper syntax highlighting and indentations.

When creating the mode, the C2 documentation and sources was used.

The correctness of the highlighting and indentations was manually checked
on various C2 files including of C2 compiler and examples sources.

## Known issues

- Incorrect highlighting for comments, attributes and directives.

## License

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

(c) 2025 Evgeny Simonenko
