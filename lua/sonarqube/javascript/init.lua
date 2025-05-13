local M = {}

M.setup = function(opts)
    local server = require("sonarqube.lsp.server")
    server.register_filetypes({
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    })
    server.register_root_files({ "tsconfig.json", "jsconfig.json", "package.json" })
    server.register_init_opt("clientNodePath", opts.clientNodePath)
end

return M
