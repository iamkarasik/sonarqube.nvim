local M = {}

local need_compilation_database = function(_, _, ctx, _)
    local locations = vim.fs.find("compile_commands.json", {
        upward = true,
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    })

    if #locations == 0 then
        vim.notify("Failed to find compile_commands.json", vim.log.levels.WARN)
        return
    end

    local server = require("sonarqube.lsp.server")
    server.settings = vim.tbl_deep_extend("force", server.settings, {
        sonarlint = {
            pathToCompileCommands = locations[1],
        },
    })
    local sonarqube = vim.lsp.get_client_by_id(ctx.client_id)
    sonarqube.settings = server.settings
    server.did_change_configuration(sonarqube)
end

M.setup = function(opts)
    local server = require("sonarqube.lsp.server")
    server.register_filetypes({ "c", "cpp" })
    server.register_root_files(opts.root_files)
    server.register_handler("sonarlint/needCompilationDatabase", need_compilation_database)
end

return M
