local M = {}

M.setup = function(_)
    local server = require("sonarqube.lsp.server")
    server.register_filetypes({ "go", "gomod", "gowork", "gotmpl" }) -- TODO: Consider letting user specify custom filetypes
    server.register_root_files({ "go.mod", "go.work" })
end

return M
