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

return M
