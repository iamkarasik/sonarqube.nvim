local M = {}

M.setup = function(_)
    local server = require("sonarqube.lsp.server")
    server.register_filetypes({ "html", "templ" })
    server.register_root_files({ "index.html", "package.json" })
end

return M
