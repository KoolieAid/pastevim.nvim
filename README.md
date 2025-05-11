# Pastevim
Plugin to copy things in Neovim into Pastebin

I made this plugin to help pasting stuff in ComputerCraft, and also to try making a Neovim plugin
Could also be used to share code snippets to other people

This is my first time making a Neovim plugin, suggestions or criticisms appreciated.

# Requirements
1. [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
2. API key from Pastebin

### Things to do / Missing
- Copying lines while in visual mode
- Including the file name while uploading
- Copy only the pastebin code

# Installation
## Lazy.nvim
Defaults are currently set
```lua
{
    "",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
        api_key = "YOUR KEY HERE",
        public = 1, -- 0=public 1=unlisted 2=private
        include_filename = true, -- Whether to include the filename when uploading to Pastebin
        code_only = false,  -- Whether to copy only the Pastebin code to clipboard instead of full link
    }
}

```
### OR
```lua
{
    "",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
        require("pastevim").setup({
            api_key = "YOUR KEY HERE",
            public = 1,
            include_filename = true,
            code_only = false,
        })
    end
}
```

## Functions
TBA
