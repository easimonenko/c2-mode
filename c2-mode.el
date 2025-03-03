;;; c2-mode.el --- Major mode for C2 programming language -*- lexical-binding: t; -*-

;; Copyright (c) 2025 Evgeny Simonenko

;; Author: Evgeny Simonenko <easimonenko@gmail.com>
;; Keywords: languages c2
;; Version: 0.1.0
;; Package-Requires: ((emacs "24.3"))
;; Created: February 2025
;; URL: https://github.com/easimonenko/c2-mode
;; Repository: https://github.com/easimonenko/c2-mode

;;; License:
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Major mode for editing code written in the C2 Programming Language.
;;
;; c2-mode supports:
;;
;; * syntax highlighting;
;; * proper indentations;
;; * autoload for *.c2, *.c2i, *.c2t files.
;;
;; Customization
;; -------------
;;
;; You can set the width of the indentation by setting the customizable user
;; option variable c2-indent-offset from customization group c2.
;; By default, it is set to 2.

;;; Code:

(require 'cc-bytecomp)
(require 'cc-fonts)
(require 'cc-langs)
(require 'cc-mode)
(require 'compile)

(eval-when-compile
  (let ((load-path (if (and (boundp 'byte-compile-dest-file)
                            (stringp byte-compile-dest-file))
                       (cons (file-name-directory byte-compile-dest-file)
                             load-path)
                     load-path)))
    (load "cc-mode" nil t)
    (load "cc-fonts" nil t)
    (load "cc-langs" nil t)
    (load "cc-bytecomp" nil t)))

(eval-and-compile
  (c-add-language 'c2-mode 'c-mode))

(defvar c-syntactic-element)
(declare-function c-populate-syntax-table "cc-langs.el" (table))

;; (c-lang-defconst c-block-comment-starter c2 "/*")
;; (c-lang-defconst c-block-comment-ender c2 "*/")
;; (c-lang-defconst c-comment-start-regexp c2 "/[*+/]")
;; (c-lang-defconst c-block-comment-start-regexp c2 "/[*+]")
;; (c-lang-defconst c-line-comment-starter c2 "//")

;; (c-lang-defconst c-literal-start-regexp c2 "/[*+/]\\|\"")

(c-lang-defconst c-identifier-ops c2 '((left-assoc ".")))

(c-lang-defconst c-ref-list-kwds
  c2 '("import" "local" "module"))

(c-lang-defconst c-protection-kwds
  c2 '("public"))

(c-lang-defconst c-constant-kwds
  c2 '("false" "true" "nil"))

(c-lang-defconst c-primitive-type-kwds
  c2 '("bool" "char" "f32" "f64" "i8" "i16" "i32" "i64" "isize" "u8" "u16" "u32" "u64" "usize" "void"))

(c-lang-defconst c-decl-start-kwds
  c2 '("fn" "module" "type"))

(c-lang-defconst c-type-prefix-kwds
  c2 '("enum" "struct" "union"))

(c-lang-defconst c-class-decl-kwds
  c2 '("enum" "struct" "union"))

(c-lang-defconst c-typedef-decl-kwds
  c2 '("type"))

(c-lang-defconst c-brace-list-decl-kwds
  c2 '("enum"))

(c-lang-defconst c-modifier-kwds
  c2 '("const" "local" "volatile"))

(c-lang-defconst c-block-stmt-1-kwds
  c2 '("as" "case" "do" "else"))

(c-lang-defconst c-block-stmt-2-kwds
  c2 '("for" "if" "sswitch" "switch" "while"))

(c-lang-defconst c-simple-stmt-kwds
  c2 '("assert" "break" "continue" "default" "elemsof" "fallthrough" "return" "sizeof" "static_assert"))

(c-lang-defconst c-paren-type-kwds
  c2 '("cast"))

(c-lang-defconst c-decl-hangon-kwds
  c2 '("as" "local"))

(c-lang-defconst c-paren-nontype-kwds
  c2 '("assert" "elemsof" "sizeof" "static_assert"))

(c-lang-defconst c-paren-stmt-kwds
  c2 '("for" "if" "sswitch" "swtich" "while"))

(c-lang-defconst c-label-kwds
  c2 '("case" "default"))

(c-lang-defconst c-before-label-kwds
  c2 '("goto"))

(c-lang-defconst c-return-kwds
  c2 '("return"))

(c-lang-defconst c-assignment-operators
  c2 '("=" "*=" "/=" "%=" "+=" "-=" "<<=" ">>=" "&=" "^=" "|="))

(c-lang-defconst c-operators
  c2 `(
       (left-assoc ".")
       (postfix "(" ")" "[" "]" "++" "--")
       (prefix "!" "-" "~" "*" "&" "++" "--")
       (infix "." "*" "/" "%" "<<" ">>" "^" "|" "&" "+" "-")
       (infix "==" "!=" ">=" "<=" ">" "<" "&&" "||")
       (ternary "?:")
       (infix "=" "*=" "/=" "%=" "+=" "-=" "<<=" ">>=" "&=" "^=" "|=")
       (infix ",")))

(c-lang-defconst c-opt-type-suffix-key
  c2 (concat "\\(\\[" (c-lang-const c-simple-ws) "*\\]\\|\\*\\)"))

(defconst c2-font-lock-keywords-1 (c-lang-const c-matchers-1 c2)
  "Minimal highlighting for C2 mode.")
(defconst c2-font-lock-keywords-2 (c-lang-const c-matchers-2 c2)
  "Fast normal highlighting for C2 mode.")
(defconst c2-font-lock-keywords-3 (c-lang-const c-matchers-3 c2)
  "Accurate normal highlighting for C2 mode.")
(defvar c2-font-lock-keywords c2-font-lock-keywords-3
  "Default expressions to highlight in C2 mode.")

(defvar c2-mode-map () "Keymap for C2 mode buffers.")
(if c2-mode-map nil (setq c2-mode-map (c-make-inherited-keymap)))

(defgroup c2 nil
  "Customization variables for C2 mode."
  :group 'languages
  :tag "C2")

(defcustom c2-indent-offset 2
  "Indentation offset for `c2-mode'."
  :group 'c2
  :type 'integer
  :safe 'integerp)

;;;###autoload
(define-derived-mode c2-mode prog-mode "C2"
  "Major mode for editing code written in the C2 Programming Language.

  Key bindings:
  \\{c2-mode-map}"
  :after-hook (c-update-modeline)
  (c-initialize-cc-mode t)
  (use-local-map c2-mode-map)
  (c-init-language-vars c2-mode)
  (c-common-init 'c2-mode)
  (c-run-mode-hooks 'c-mode-common-hook)
  (setq-local comment-start "// "
              comment-end ""
              block-comment-start "/*"
              block-comment-end "*/"))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.\\(c2\\|c2i\\|c2t\\)\\'" . c2-mode))

(provide 'c2-mode)
;;; c2-mode.el ends here
