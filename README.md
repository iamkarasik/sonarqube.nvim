# sonarqube
`sonarqube` integrates with the [sonarlint-language-server](https://github.com/SonarSource/sonarlint-language-server) to deliver real-time static analysis and code actions directly in neovim.

**Key Features:**
- [x] Go support
- [x] HTML support
- [x] IAC support
- [x] Java support
- [x] JavaScript support
- [x] PHP support
- [x] Python support
- [x] Text support
- [x] XML support

# Configuration
```lua
require('sonarqube').setup({
    lsp = {
        cmd = { 
            "/path/to/java",
            "-jar",
            "/path/to/sonarlint-ls.jar",
            "-stdio",
            "-analyzers",
            "/path/to/analyzers/go.jar",
            "/path/to/analyzers/html.jar",
            "/path/to/analyzers/iac.jar",
            "/path/to/analyzers/java.jar",
            "/path/to/analyzers/javascript.jar",
            "/path/to/analyzers/php.jar",
            "/path/to/analyzers/python.jar",
            "/path/to/analyzers/text.jar",
            "/path/to/analyzers/xml.jar",
        },
        log_level = "OFF",
    },
    go = { 
        enabled = true 
    },
    html = {
        enabled = true,
    },
    iac = {
        -- Docker analysis only works on 'Dockerfile'
        -- All supported files: https://github.com/SonarSource/sonar-iac
        enabled = true,
    },
    java = {
        enabled = true,
        await_jdtls = true 
    },
    javascript = {
        enabled = true, -- Requires node >= 18.17.0
        clientNodePath = vim.fn.exepath("node")
    },
    php = {
        enabled = true,
    },
    python = {
        enabled = true 
    },
    text = {
        enabled = true,
    },
    xml = {
        enabled = true,
    },
})
```

# Special Thanks
- [@schrieveslaach](https://github.com/schrieveslaach/) - [sonarlint.nvim](https://gitlab.com/schrieveslaach/sonarlint.nvim) was used as inspiration
