# sonarqube
`sonarqube` integrates with the [sonarlint-language-server](https://github.com/SonarSource/sonarlint-language-server) to deliver real-time static analysis and code actions directly in neovim.

**Key Features:**
- [x] Go support
- [x] Html support
- [x] Java support
- [x] JavaScript support
- [x] Python support

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
            "/path/to/analyzers/java.jar",
            "/path/to/analyzers/javascript.jar",
            "/path/to/analyzers/python.jar",
        },
        log_level = "OFF",
    },
    go = { 
      enabled = true 
    },
    html = {
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
    python = {
        enabled = true 
    },
})
```

# Special Thanks
- [@schrieveslaach](https://github.com/schrieveslaach/) - [sonarlint.nvim](https://gitlab.com/schrieveslaach/sonarlint.nvim) was used as inspiration
