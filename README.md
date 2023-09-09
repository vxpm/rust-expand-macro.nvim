# rust-expand-macro.nvim
this is a small neovim plugin for utilizing rust-analyzer's _recursively expand macro_ feature.
just install it using your favorite plugin manager and use it like so:

```lua
require('rust-expand-macro').expand_macro()
```

this will expand whatever macro is currently under the cursor into a new buffer and will show it
in a new vertical split.

yes, really. that's it. a single function - no need to call setup or anything like that.

## special thanks
[rust-tools](https://github.com/simrat39/rust-tools.nvim) for being the reason why this plugins exists.
i didn't want any of the features it offers _except_ for recursive expansion of macros, so i made this plugin!
also, the code here is heavily based on it's implementation.
