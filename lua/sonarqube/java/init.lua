local M = {
    coroutines = {},
}

M.get_jdtls = function()
    return vim.lsp.get_clients({ name = "jdtls" })
end

local register_jdtls_callback = function(_)
    local jdtls = M.get_jdtls()
    if #jdtls == 0 then
        vim.api.nvim_create_autocmd("LspAttach", {
            desc = "Wait for jdtls",
            callback = function()
                jdtls = M.get_jdtls()
                if #jdtls > 0 then
                    local bufnr = vim.api.nvim_get_current_buf()
                    local co = M.coroutines[bufnr]
                    if co ~= nil then
                        coroutine.resume(co)
                    end
                end
            end,
        })
    end
end

local jdtls_java_project_getSettings = function(dependencies, settings)
    dependencies.jdtls.request("workspace/executeCommand", {
        command = "java.project.getSettings",
        arguments = {
            dependencies.uri,
            {
                "org.eclipse.jdt.core.compiler.source",
                "org.eclipse.jdt.ls.core.classpathEntries",
                "org.eclipse.jdt.ls.core.vm.location",
            },
        },
    }, function(err, res)
        if err ~= nil then
            vim.notify("Failed to get java project settings", "WARN")
            coroutine.resume(dependencies.co)
            return
        end

        local classpaths = {}
        local classpath_entries = res["org.eclipse.jdt.ls.core.classpathEntries"]
        for _, entry in pairs(classpath_entries) do
            table.insert(classpaths, entry.path)
        end

        settings.projectRoot = dependencies.uri
        settings.sourceLevel = res["org.eclipse.jdt.core.compiler.source"]
        settings.classpath = classpaths
        settings.vmLocation = res["org.eclipse.jdt.ls.core.vm.location"]

        coroutine.resume(dependencies.co)
    end, dependencies.bufnr)
end

local jdtls_java_project_isTest = function(dependencies, settings)
    dependencies.jdtls.request("workspace/executeCommand", {
        command = "java.project.isTestFile",
        arguments = { dependencies.uri },
    }, function(err, res)
        if err ~= nil then
            vim.notify("Failed to determine if buffer is a test file", "WARN")
            coroutine.resume(dependencies.co)
            return
        end

        settings.isTest = res

        jdtls_java_project_getSettings(dependencies, settings)
    end, dependencies.bufnr)
end

local query_settings = function(request)
    local settings = {}

    local jdtls = M.get_jdtls()
    if #jdtls == 0 then
        return settings
    end

    local dependencies = {
        uri = request[1],
        bufnr = vim.api.nvim_get_current_buf(),
        co = coroutine.running(),
        jdtls = jdtls[1],
    }

    jdtls_java_project_isTest(dependencies, settings)
    coroutine.yield()

    return settings
end

local get_java_config = function(opts, request)
    if not opts.await_jdtls then
        return {}
    end

    local jdtls = M.get_jdtls()
    if #jdtls == 0 then
        local bufnr = vim.api.nvim_get_current_buf()
        M.coroutines[bufnr] = coroutine.running()
        coroutine.yield()
    end

    return query_settings(request)
end

M.setup = function(opts)
    local server = require("sonarqube.lsp.server")
    server.register_filetypes({ "java" })
    server.register_root_files({
        "build.gradle",
        "build.gradle.kts",
        "build.xml",
        "pom.xml",
        "settings.gradle",
        "settings.gradle.kts",
    })
    server.register_handler("sonarlint/getJavaConfig", function(_, request, _, _)
        return get_java_config(opts, request)
    end)

    if opts.await_jdtls then
        register_jdtls_callback(opts)
    end
end

return M
