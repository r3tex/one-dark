# One-Dark
![screenshot](https://github.com/r3tex/one-dark/raw/master/screenshot.png)


This colorscheme uses the following values:

|Color Name|RGB|Hex|
| :--- | ---: | ---: |
| Black        | 40; 44; 52    | #282c34 |
| White        | 171; 178; 191 | #abb2bf |
| Light Red    | 224; 108; 117 | #e06c75 |
| Dark Red     | 190; 80; 70   | #be5046 |
| Green        | 152; 195; 121 | #98c379 |
| Light Yellow | 229; 192; 123 | #e5c07b |
| Dark Yellow  | 209; 154; 102 | #d19a66 |
| Blue         | 97; 175; 239  | #61afef |
| Magenta      | 198; 120; 221 | #c678dd |
| Cyan         | 86; 182; 194  | #56b6c2 |
| Gutter Grey  | 76; 82; 99    | #4b5263 |
| Comment Grey | 92; 99; 112   | #5c6370 |

In order to use most of these files you need a terminal with 256-color support. In `Windows Subsystem for Linux` I recommend the [WSLtty](https://github.com/mintty/wsltty) terminal. Remember to set Options... -> Terminal -> Type -> `xterm-256color`.

I've included everything you need in this repo, but you're welcome to download things like vim plugins yourself instead of copying mine if you want to be sure you have the latest versions.

## Bash
Color escape codes in bash work like this:
```### Attribute codes:
00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
### Text color codes:
30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white 38=custom
### Background color codes:
40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white 48=custom
### Color mode
02=RGB 05=16-bit
```
So to the escape code for one-dark magenta is first `00` for no attribute, `38` for text, `2` for RGB, `198;120;221` for the color itself. In other words, `00;38;2;198;120;221`.

### Setting the prompt

Rename `bashrc` to `.bashrc` and place in your home directory. The relevant line which changes colors is:

```PS1="\[\e[38;2;224;108;117m\]\h \[\e[38;2;97;175;239m\]\w \[\e[m\]\$ "```

Note how one must surround the color codes with `\[\e[` and `m\]` after. The same thing goes for other places where color can affect you such as when updating your terminal title with `\e]0;$(dirs)\a`.

### Setting dircolors

Rename `dircolors` to `.dircolors`, place in your home directory, and include the line `test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"` in your `.bashrc`.

I've chosen an arbitrary set of colorations for filetypes that I think are important, but feel free to edit the file to hilight filetypes that are relevant to you.

## Fonts
For the vim and tmux themes to work, you need good UTF8 support. I recommend [Fira Code](https://github.com/tonsky/FiraCode) or 

## VIM
Vim has a nice one-dark theme also available [here](https://github.com/joshdick/onedark.vim), or you can just grab the `vim/colors/onedark.vim` and add it to your own `~/.vim/colors/` folder.

The second part is installing the [Airline](https://github.com/vim-airline/vim-airline) and [Airline Themes](https://github.com/vim-airline/vim-airline-themes) plugins, or you can just copy my `vim/plugin` folder into your own `~/.vim`.

Last but not least you need to edit your `.vimrc` to include the following lines:
```set background=dark
set termguicolors
set noshowmode
colorscheme onedark
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:bufferline_echo = 0
```
or just rename my `vimrc` to `.vimrc` and place it in your home directory.

## Tmux
Include the following in your `~/.tmux.conf` file, or just copy the one in this repo.
```set -g status-bg black
set -g status-fg white
set -g default-terminal "xterm-256color"
set-option -ga terminal-overrides "xterm-256color"
```
Install the [tmuxline](https://github.com/edkolev/tmuxline.vim) plugin for vim. Start tmux and then open vim to apply the one-dark theme. Note that you need to restart all tmux sessions before this takes effect.

## Julia
Start your julia REPL and type:
```julia> using Pkg
julia> Pkg.add("OhMyREPL")
julia> using OhMyREPL
```
OhMyREPL has added my onedark theme now, but it's the same as including the following in your `~/.julia/config/startup.jl`
```using REPL
atreplinit() do repl
    repl.interface = REPL.setup_interface(repl)
    Base.active_repl.interface.modes[1].prompt_prefix = "\e[38;2;152;195;121m"
end

using OhMyREPL
using Crayons
import OhMyREPL: Passes.SyntaxHighlighter

scheme = SyntaxHighlighter.ColorScheme()
SyntaxHighlighter.string!(scheme, Crayon(foreground = (152,195,121)))
SyntaxHighlighter.symbol!(scheme, Crayon(foreground = (224,108,117)))
SyntaxHighlighter.comment!(scheme, Crayon(foreground = (92,99,112)))
SyntaxHighlighter.call!(scheme, Crayon(foreground = (97,175,239)))
SyntaxHighlighter.op!(scheme, Crayon(foreground = (198,120,221)))
SyntaxHighlighter.keyword!(scheme, Crayon(foreground = (224,108,117)))
SyntaxHighlighter.error!(scheme, Crayon(foreground = (190,80,70)))
SyntaxHighlighter.argdef!(scheme, Crayon(foreground = (229,192,123)))
SyntaxHighlighter.macro!(scheme, Crayon(foreground = (198,120,221)))
SyntaxHighlighter.number!(scheme, Crayon(foreground = (209,154,102)))
SyntaxHighlighter.function_def!(scheme, Crayon(foreground = (171, 178, 191)))
SyntaxHighlighter.add!("OneDark", scheme)
colorscheme!("OneDark")
OhMyREPL.enable_pass!("RainbowBrackets", false)
```
