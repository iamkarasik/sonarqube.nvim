local M = {}

M.setup = function(opts)
    local server = require("sonarqube.lsp.server")
    server.register_filetypes({ "cs" })
    server.register_root_files({ "*.sln", "*.csproj" })

    server.register_init_opt("omnisharpDirectory", opts.omnisharpDirectory)
    server.register_init_opt("csharpOssPath", opts.csharpOssPath)
    server.register_init_opt("csharpEnterprisePath", opts.csharpEnterprisePath)
end

return M

