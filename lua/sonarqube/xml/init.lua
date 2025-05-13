local M = {}

M.setup = function(_)
    require("sonarqube.lsp.server").register_filetypes({ "xml", "xsd", "xsl", "xslt", "svg" })
end

return M
