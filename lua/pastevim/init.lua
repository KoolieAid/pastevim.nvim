local http = require("plenary.curl")

local M = {
    public = 1,
    include_filename = true,
    code_only = false,
}

local secrets = {
    api_key = nil,
}

local function check_key()
    if secrets.api_key == nil then
        vim.notify("Pastevim: API Key was not provided.", vim.log.levels.ERROR);
        return false
    end
    return true
end

M.setup = function(config)
    if config.api_key == nil then
        vim.notify("Pastevim: API Key was not provided.", vim.log.levels.ERROR);
        return
    end

    secrets.api_key = config.api_key

    M.public = config.public or M.public

    M.include_filename = config.include_filename or M.include_filename
    M.code_only = config.code_only or M.code_only
end

local function copy_to_clipboard(content)
    if content.status ~= 200 then
        vim.notify("There was a problem processing the request. Response: " .. content.body, vim.log.levels.ERROR);
        return
    end
    local raw_body = content.body

    local pastebin_link
    if M.code_only then
        -- TODO: Convert to code
        pastebin_link = nil
    else
        pastebin_link = raw_body
    end

    vim.schedule(function()
        vim.fn.setreg("+", pastebin_link)
        print("Copied to clipboard! " .. pastebin_link)
    end)
end

M.upload = function(content)
    if not check_key() then
        return
    end
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
