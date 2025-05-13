local M = {}

M.setup = function(_)
    local server = require("sonarqube.lsp.server")
    server.register_filetypes({ "php" })
    server.register_root_files({ "artisan", "composer.json" })
end

return M
