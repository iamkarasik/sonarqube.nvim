local M = {}

M.setup = function(_)
    vim.api.nvim_create_user_command(
        "SonarQubeInstallLsp",
        require("sonarqube.cmds.install").install_lsp,
        {}
    )

    vim.api.nvim_create_user_command(
        "SonarQubeListAllRules",
        require("sonarqube.cmds.rules").list_all_rules,
        {}
    )
end

return M
