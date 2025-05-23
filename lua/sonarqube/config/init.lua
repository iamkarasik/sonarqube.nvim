local M = {}

local extension_dir = vim.fn.stdpath("data") .. "/sonarqube/extension"

local default = {
    lsp = {
        cmd = {
            vim.fn.exepath("java"),
            "-jar",
            extension_dir .. "/server/sonarlint-ls.jar",
            "-stdio",
            "-analyzers",
            extension_dir .. "/analyzers/sonargo.jar",
            extension_dir .. "/analyzers/sonarhtml.jar",
            extension_dir .. "/analyzers/sonariac.jar",
            extension_dir .. "/analyzers/sonarjava.jar",
            extension_dir .. "/analyzers/sonarjavasymbolicexecution.jar",
            extension_dir .. "/analyzers/sonarjs.jar",
            extension_dir .. "/analyzers/sonarphp.jar",
            extension_dir .. "/analyzers/sonarpython.jar",
            extension_dir .. "/analyzers/sonartext.jar",
            extension_dir .. "/analyzers/sonarxml.jar",
        },
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        log_level = "OFF",
    },
    rules = {
        enabled = true,
    },
    csharp = {
        enabled = true,
        omnisharpDirectory = extension_dir .. "/omnisharp",
        csharpOssPath = extension_dir .. "/analyzers/sonarcsharp.jar",
        csharpEnterprisePath = extension_dir .. "/analyzers/csharpenterprise.jar",
    },
    go = {
        enabled = true,
    },
    html = {
        enabled = true,
    },
    iac = {
        enabled = true,
    },
    java = {
        enabled = true,
        await_jdtls = true,
    },
    javascript = {
        enabled = true,
        clientNodePath = vim.fn.exepath("node"),
    },
    php = {
        enabled = true,
    },
    python = {
        enabled = true,
    },
    text = {
        enabled = true,
    },
    xml = {
        enabled = true,
    },
}

local config = default

function M.setup(opts)
    config = vim.tbl_deep_extend("force", default, opts or {})
    vim.api.nvim_create_user_command("SonarQubeShowConfig", function()
        print(vim.inspect(config))
    end, {})
end

return setmetatable(M, {
    __index = function(_, key)
        return config[key]
    end,
})
