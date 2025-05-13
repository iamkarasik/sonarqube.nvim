local M = {}

M.setup = function(_)
    local server = require("sonarqube.lsp.server")
    server.register_filetypes({ "python" })
    server.register_root_files({
        ".ruff.toml",
        "Pipfile",
        "pyproject.toml",
        "requirements.txt",
        "ruff.toml",
        "setup.cfg",
        "setup.py",
    })
end

return M
