local M = {}

local not_found = ""
local sonarqube_dir = vim.fn.stdpath("data") .. "/sonarqube"
local vsix_path = sonarqube_dir .. "/sonarlint.vsix"
local sonarqube_vsix_url =
    "https://github.com/SonarSource/sonarlint-vscode/releases/download/%s/sonarlint-vscode-%s.vsix"

local create_sonarqube_dir = function()
    vim.fn.mkdir(sonarqube_dir, "p")
end

local unzip_vsix = function()
    vim.notify("Unpacking SonarQube LSP")

    vim.system({ "unzip", "-o", vsix_path, "-d", sonarqube_dir }, {}, function(result)
        vim.schedule(function()
            if result.code ~= 0 then
                vim.notify("Unable to unpack SonarQube LSP", vim.log.levels.ERROR)
                return
            end

            if vim.loop.fs_stat(sonarqube_dir .. "/extension") ~= nil then
                vim.notify("Successfully installed SonarQube LSP")
            end
        end)
    end)
end

local download_vsix = function(releases)
    vim.notify("Downloading SonarQube LSP [version " .. releases.name .. "]")

    local url = string.format(sonarqube_vsix_url, releases.tag_name, releases.name)

    vim.system({ "curl", "-L", "-o", vsix_path, url }, {}, function(result)
        vim.schedule(function()
            if result.code ~= 0 then
                vim.notify(
                    "Unable to download SonarQube LSP: Failed to download vsix",
                    vim.log.levels.ERROR
                )
                return
            end

            unzip_vsix()
        end)
    end)
end

local install_lsp = function()
    if vim.fn.exepath("curl") == not_found then
        vim.notify("Unable to Install SonarQube LSP: curl command not found", vim.log.levels.ERROR)
        return
    end

    if vim.fn.exepath("unzip") == not_found then
        vim.notify("Unable to Install SonarQube LSP: unzip command not found", vim.log.levels.ERROR)
        return
    end

    create_sonarqube_dir()

    vim.system({
        "curl",
        "-sL",
        "https://api.github.com/repos/SonarSource/sonarlint-vscode/releases/latest",
    }, {}, function(result)
        vim.schedule(function()
            if result.code ~= 0 then
                vim.notify(
                    "Unable to download SonarQube LSP: Failed to get releases",
                    vim.log.levels.ERROR
                )
                return
            end

            local ok, parsed = pcall(vim.fn.json_decode, result.stdout)
            if ok then
                download_vsix(parsed)
            end
        end)
    end)
end

M.setup = function(_)
    vim.api.nvim_create_user_command("SonarQubeInstallLsp", install_lsp, {})
end

return M
