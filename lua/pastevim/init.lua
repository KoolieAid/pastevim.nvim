local http = require("plenary.curl")

local M = {
    public = 1,
    include_filename = true,
    code_only = false,
    expiry = "N",
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

    if config.include_filename == false then
        M.include_filename = false
    end
    M.code_only = config.code_only or M.code_only
    M.expiry = config.expiry or M.code_only
end

local function copy_to_clipboard(content)
    if content.status ~= 200 then
        vim.notify("There was a problem processing the request. Response: " .. content.body, vim.log.levels.ERROR);
        return
    end
    local raw_body = content.body

    local pastebin_link = nil
    if M.code_only then
        pastebin_link = raw_body:match("https://pastebin.com/(.+)")
    else
        pastebin_link = raw_body
    end

    vim.schedule(function()
        vim.fn.setreg("+", pastebin_link)
        print("Copied to clipboard! " .. pastebin_link)
    end)
end

M.upload = function(content, filename)
    if not check_key() then
        return
    end

    local file_type = vim.fn.fnamemodify(filename, ":e")

    if not M.include_filename then
        filename = nil
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
            api_paste_name = filename,
            api_paste_format = file_type,
        },
        callback = copy_to_clipboard,
    })
end

M.upload_current_buffer = function()
    local buf = vim.api.nvim_get_current_buf()
    local data = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    data = table.concat(data, "\n")

    local filename_path = vim.api.nvim_buf_get_name(buf)
    local filename = vim.fn.fnamemodify(filename_path, ":t")
    M.upload(data, filename)
end

vim.api.nvim_create_user_command("Pastevim", function(cmd)
    require("pastevim").upload_current_buffer()
end, {})

return M
