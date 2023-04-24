using REPL
atreplinit() do repl
    repl.interface = REPL.setup_interface(repl)
    Base.active_repl.interface.modes[1].prompt_prefix = "\e[38;2;152;195;121m"
end

using OhMyREPL
colorscheme!("OneDark")
OhMyREPL.enable_pass!("RainbowBrackets", false)
