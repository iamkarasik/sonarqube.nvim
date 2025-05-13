local M = {}

M.setup = function(opts)
    local cfg = require("sonarqube.config")
    cfg.setup(opts)

    require("sonarqube.lsp").setup(cfg)
end

return M
