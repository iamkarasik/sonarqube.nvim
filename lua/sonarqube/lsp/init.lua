local M = {}

local log_levels = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4,
    OFF = 10,
}

M.setup = function(opts)
    -- stylua: ignore start
    if opts.go.enabled then require("sonarqube.go").setup(opts.go) end
    -- stylua: ignore end

    require("sonarqube.rules").setup(opts.rules)
    local cfg = require("sonarqube.lsp.server")

    vim.api.nvim_create_autocmd("FileType", {
        pattern = cfg.filetypes,
        callback = function(opt)
            local client = vim.lsp.get_clients({ name = "sonarqube" })
            if #client > 0 then
                vim.lsp.buf_attach_client(opt.buf, client[1].id)
                return
            end

            local root = vim.fs.dirname(vim.fs.find(cfg.root_files, { upward = true })[1])
                or vim.fn.getcwd()

            local server = {
                name = "sonarqube",
                cmd = opts.lsp.cmd,
                root_dir = root,
                capabilities = opts.lsp.capabilities,
                filetypes = cfg.filetypes,
                init_options = cfg.init_options,
                handlers = cfg.handlers,
                autostart = true,
                on_attach = function()
                    client = vim.lsp.get_clients({ name = "sonarqube" })[1]
                    client.notify("workspace/didChangeConfiguration", {
                        settings = {
                            sonarlint = {
                                rules = vim.empty_dict(),
                            },
                        },
                    })
                end,
            }

            cfg.register_handler("window/logMessage", function(_, params, _, _)
                local message = params.message

                local first_space = message:find(" ")
                local lvl = message:sub(2, first_space - 1):upper()

                if log_levels[lvl] >= log_levels[opts.lsp.log_level:upper()] then
                    local closing_bracket = message:find("]")
                    vim.notify(message:sub(closing_bracket + 2), lvl:lower())
                end
            end)

            vim.lsp.start(server, {
                bufnr = opt.buf,
                silent = true,
            })
        end,
    })
end

return M
