local M = {}

M.setup = function(_)
    vim.api.nvim_create_user_command(
        "SonarQubeInstallLsp",
        require("sonarqube.cmds.install").install_lsp,
        {}
    )
end

return M
