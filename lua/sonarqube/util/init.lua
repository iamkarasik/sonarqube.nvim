local M = {}

M.create_win = function(buf)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    vim.api.nvim_set_option_value("readonly", true, { buf = buf })
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, noremap = true, silent = true })

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    return win
end

M.notify = function(client, method, params)
    if vim.fn.has("nvim-0.11") == 1 then
        return client:notify(method, params)
    else
        return client.notify(method, params)
    end
end

M.request = function(client, method, params, handler, bufnr)
    if vim.fn.has("nvim-0.11") == 1 then
        return client:request(method, params, handler, bufnr)
    else
        return client.request(method, params, handler, bufnr)
    end
end

return M
