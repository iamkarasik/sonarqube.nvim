local M = {}

M.setup = function(_)
    local server = require("sonarqube.lsp.server")
    server.register_filetypes({
        "dockerfile",
        "hcl",
        "terraform",
        "tf",
        "terraform-vars",
        "yaml",
        "yml",
        "json",
    })
    server.register_root_files({ "Dockerfile", ".terraform" })
end

return M
