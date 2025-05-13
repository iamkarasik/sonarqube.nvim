local M = {}

M.setup = function(_)
    require("sonarqube.lsp.server").register_filetypes({ "text", "plaintex", "tex", "org" })
end

return M
