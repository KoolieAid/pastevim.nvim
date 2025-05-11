local http = require("plenary.curl")

local M = {
    public = 0,
    use_filename = true,
    only_code = false,
}

local secrets = {
    api_key = nil,
}

M.setup = function(config)
    if config.api_key == nil then
        error("No API key provided")
        return
    end

    secrets.api_key = config.api_key

    M.public = config.public or M.public

    M.use_filename = config.use_filename or M.use_filename
    M.only_code = config.only_code or M.only_code
end

local function copy_to_clipboard(content)
    local response = content.body

    vim.schedule(function()
        vim.fn.setreg("+", response)
        print("Copied to clipboard!")
    end)
end

M.upload = function(content)
    http.post({
        url = "https://pastebin.com/api/api_post.php",
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded"
        },
        body = {
            api_dev_key = secrets.api_key,
            api_option = "paste",
            api_paste_public = M.public,
            api_paste_code = content,
        },
        callback = copy_to_clipboard,
    })
end

M.upload_current_buffer = function()
    local buf = vim.api.nvim_get_current_buf()
    local data = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    data = table.concat(data, "\n")
    M.upload(data)
end

vim.api.nvim_create_user_command("Pastevim", function(cmd)
    require("pastevim").upload_current_buffer()
end, {})

return M
