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
        vim.schedule(function()
            vim.notify("There was a problem processing the request. Response: " .. content.body, vim.log.levels.ERROR);
        end)
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
            api_paste_expire_date = M.expiry,
        },
        callback = function(content)
            vim.schedule(function()
                copy_to_clipboard(content)
            end)
        end,
    })
end

M.upload_range = function(buf, range)
    local data = vim.api.nvim_buf_get_lines(buf, range.line1 - 1, range.line2, false)
    data = table.concat(data, "\n")

    local filename_path = vim.api.nvim_buf_get_name(buf)
    local filename = vim.fn.fnamemodify(filename_path, ":t")
    M.upload(data, filename)
end

M.upload_whole_buffer = function(buf)
    M.upload_range(buf, { line1 = 1, line2 = -1, range = 0 })
end

vim.api.nvim_create_user_command("Pastevim", function(cmd)
    local range = {
        line1 = cmd.line1,
        line2 = cmd.line2,
        range = cmd.range,
    }

    local buf = vim.api.nvim_get_current_buf()
    if range.range == 0 then
        M.upload_whole_buffer(buf)
        return
    end

    M.upload_range(buf, range)
end, { range = true })

return M
