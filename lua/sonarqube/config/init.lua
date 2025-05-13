local M = {}

local default = {
    lsp = {
        cmd = { vim.fn.exepath("sonarlint-ls") },
        capabilities = vim.lsp.protocol.make_client_capabilities(),
    },
    go = { enabled = true },
    python = { enabled = true },
}

local config = default

function M.setup(opts)
    config = vim.tbl_deep_extend("force", default, opts or {})
end

return setmetatable(M, {
    __index = function(_, key)
        return config[key]
    end,
})
