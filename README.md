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
- ~~Including the file name while uploading~~
- ~~Copy only the pastebin code~~
- ~~Expiry date~~

# Installation
## Lazy.nvim
Defaults are currently set
```lua
{
    "KoolieAid/pastevim.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
        api_key = "YOUR KEY HERE",
        public = 1, -- 0=public 1=unlisted 2=private
        include_filename = true, -- Whether to include the filename when uploading to Pastebin
        code_only = false,  -- Whether to copy only the Pastebin code to clipboard instead of full link
        expiry = "N" -- Default expiry of the pastes.
    }
}

Expiry options:
These are the only options, it is not possible to fine-tune the options due to API limitations
- N - Never
- 10M - 10 Minutes
- 1H = 1 Hour
- 1D = 1 Day
- 1W = 1 Week
- 2W = 2 Weeks
- 1M = 1 Month
- 6M = 6 Months
- 1Y = 1 Year

```
### OR
I would recommend using this so you can put the API key in a different place and add it programmatically
```lua
{
    "KoolieAid/pastevim.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
        require("pastevim").setup({
            api_key = "YOUR KEY HERE",
            public = 1,
            include_filename = true,
            code_only = false,
            expiry = "N"
        })
    end
}
```
# Usage
Type `:Pastevim`. It will copy the current buffer and then put the pastebin link into your system clipboard

## Functions
Use `require("pastevim")` in your code
1. `upload(string)` - Uploads the string provided and returns the link
2. `upload_current_buffer()` - Uploads the current buffer
