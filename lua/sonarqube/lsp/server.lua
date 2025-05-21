local M = {
    filetypes = {},
    handlers = {},
    root_files = { ".git" },
    init_options = {
        productKey = "sonarqube",
        productName = "sonarqube",
        architecture = vim.loop.os_uname().machine,
        firstSecretDetected = false,
        platform = vim.loop.os_uname().sysname,
        productVersion = "0.0.1",
        showVerboseLogs = true,
        workspaceName = vim.fn.getcwd(),
    },
}

local log_levels = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4,
    OFF = 10,
}

M.handlers["sonarlint/canShowMissingRequirementsNotification"] = function()
    return false
end

M.handlers["sonarlint/isOpenInEditor"] = function()
    return true
end

M.handlers["sonarlint/shouldAnalyzeFile"] = function()
    return {
        shouldBeAnalyzed = true,
    }
end

M.handlers["sonarlint/listFilesInFolder"] = function(_, params, _, _)
    local folder = vim.uri_to_fname(params.folderUri)
    local files = vim.fs.dir(folder)

    local result = {
        foundFiles = {},
    }

    for path, t in files do
        if t == "file" then
            table.insert(result.foundFiles, { fileName = path, filePath = folder })
        end
    end

    return result
end

M.handlers["sonarlint/filterOutExcludedFiles"] = function(_, params, _, _)
    return params
end

M.handlers["sonarlint/showRuleDescription"] = function(_, params, _, _) end

M.handlers["sonarlint/needCompilationDatabase"] = function(_, _, ctx)
    return nil
end

M.register_handler = function(name, fn)
    M.handlers[name] = fn
end

M.register_filetypes = function(filetypes)
    for _, filetype in pairs(filetypes) do
        table.insert(M.filetypes, filetype)
    end
end

M.register_root_files = function(files)
    for _, file in pairs(files) do
        table.insert(M.root_files, file)
    end
end

M.register_init_opt = function(key, value)
    M.init_options[key] = value
end

local log_message = function(message, log_level)
    local first_space = message:find(" ")
    local lvl = message:sub(2, first_space - 1):upper()

    if log_levels[lvl] >= log_levels[log_level:upper()] then
        local closing_bracket = message:find("]")
        vim.notify(message:sub(closing_bracket + 2), lvl:lower())
    end
end

M.setup = function(opts)
    M.register_handler("window/logMessage", function(_, req)
        log_message(req.message, opts.log_level)
    end)
end

return M
