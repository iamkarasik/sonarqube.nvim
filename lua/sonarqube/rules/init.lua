M = {}

local sort_table_keys = function(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end
    table.sort(keys)
    return keys
end

M.list_all_rules = function()
    local client = vim.lsp.get_clients({ name = "sonarqube" })
    if #client == 0 then
        vim.notify(
            "Failed to run SonarQubeListAllRules: SonarQube LSP is not running",
            vim.log.levels.ERROR
        )
        return
    end

    client[1].request("sonarlint/listAllRules", {}, function(err, res)
        if err ~= nil then
            vim.notify(
                "Failed to run SonarQubeListAllRules: SonarQube LSP returned error",
                vim.log.levels.ERROR
            )
            return
        end

        local buf = vim.api.nvim_create_buf(false, true)

        local lines = {}
        for _, lang in ipairs(sort_table_keys(res)) do
            table.insert(lines, "# " .. lang)

            table.sort(res[lang], function(a, b)
                local prefixA, numA = a.key:match("^(.-):S(%d+)$")
                local prefixB, numB = b.key:match("^(.-):S(%d+)$")
                if prefixA and prefixB then
                    return tonumber(numA) < tonumber(numB)
                else
                    return a.key < b.key
                end
            end)

            for _, rule in ipairs(res[lang]) do
                local default = " (" .. (rule.activeByDefault and "on" or "off") .. " by default)"
                table.insert(lines, "- " .. "[" .. rule.key .. "] - " .. rule.name .. default)
            end

            table.insert(lines, "")
        end

        vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        local win = require("sonarqube.util").create_win(buf)
        vim.api.nvim_win_set_buf(win, buf)
    end)
end

M.setup = function(opts)
    local server = require("sonarqube.lsp.server")
    if opts.enabled == false then
        server.settings = {
            sonarlint = {
                rules = {},
            },
        }
        return
    end

    local count = 0
    local rules = {}
    for rule_key, rule_val in pairs(opts) do
        if rule_key ~= "enabled" then
            if rule_val.enabled ~= nil then
                count = count + 1
                rules[rule_key] = {
                    level = rule_val.enabled and "on" or "off",
                    parameters = rule_val.parameters,
                }
            end
        end
    end

    if count > 0 then
        server.settings = vim.tbl_deep_extend("force", server.settings, {
            sonarlint = {
                rules = rules,
            },
        })
    end
end

return M
