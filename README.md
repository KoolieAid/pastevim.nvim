# Pastevim
Plugin to copy things in Neovim into Pastebin

I made this plugin to help pasting stuff in ComputerCraft, and also to try making a Neovim plugin
Could also be used to share code snippets to other people

This is my first time making a Neovim plugin, suggestions or criticisms appreciated.

# Requirements
1. plenary
2. API key from Pastebin
    The key is automatically provided when you make an account

### Things to do / Missing
- Copying lines while in visual mode
- Including the file name while uploading
-

# Installation
## Lazy.nvim
Defaults are currently set
```lua
{
    "",
    opts = {
        api_key = "YOUR KEY HERE",
        public = 1, -- 0=public 1=unlisted 2=private
        use_filename = true, -- Whether to include the filename when uploading to Pastebin
        only_code = false,  -- Whether to copy only the Pastebin code to clipboard instead of full link
    }
}

```
### OR
```lua
{
    "",
    config = function()
        require("pastevim").setup({
            api_key = "YOUR KEY HERE",
            public = 1,
            use_filename = true,
            only_code = false,
        })
    end
}
```

## Functions
TBA
