using REPL
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
