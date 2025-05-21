local M = {}

M.setup = function(opts)
    -- stylua: ignore start
    if opts.csharp.enabled then require("sonarqube.csharp").setup(opts.csharp) end
    if opts.go.enabled then require("sonarqube.go").setup(opts.go) end
    if opts.html.enabled then require("sonarqube.html").setup(opts.html) end
    if opts.iac.enabled then require("sonarqube.iac").setup(opts.iac) end
    if opts.java.enabled then require("sonarqube.java").setup(opts.java) end
    if opts.javascript.enabled then require("sonarqube.javascript").setup(opts.javascript) end
    if opts.php.enabled then require("sonarqube.php").setup(opts.php) end
    if opts.python.enabled then require("sonarqube.python").setup(opts.python) end
    if opts.text.enabled then require("sonarqube.text").setup(opts.text) end
    if opts.xml.enabled then require("sonarqube.xml").setup(opts.xml) end
    -- stylua: ignore end

    local rules = require("sonarqube.rules")
    rules.setup(opts.rules)

    local server = require("sonarqube.lsp.server")
    server.setup(opts.lsp)

    vim.api.nvim_create_autocmd("FileType", {
        pattern = server.filetypes,
        callback = function(opt)
            local client = vim.lsp.get_clients({ name = "sonarqube" })
            if #client > 0 then
                vim.lsp.buf_attach_client(opt.buf, client[1].id)
                return
            end

            local root = vim.fs.dirname(vim.fs.find(server.root_files, { upward = true })[1])
                or vim.fn.getcwd()

            local cfg = {
                name = "sonarqube",
                cmd = opts.lsp.cmd,
                root_dir = root,
                capabilities = opts.lsp.capabilities,
                filetypes = server.filetypes,
                init_options = server.init_options,
                handlers = server.handlers,
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

            vim.lsp.start(cfg, {
                bufnr = opt.buf,
                silent = true,
            })

            vim.api.nvim_create_user_command("SonarQubeListAllRules", rules.list_all_rules, {})
        end,
    })
end

return M
