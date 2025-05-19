# sonarqube
`sonarqube` integrates with the [sonarlint-language-server](https://github.com/SonarSource/sonarlint-language-server) to deliver real-time static analysis and code actions directly in neovim.

## Requirements
- [NeoVim](https://neovim.io/) >= 0.10
- [Java](https://adoptopenjdk.net/releases.html) >= 11 (Required in order to run the sonarlint-language-server)

## Key Features
- [x] C# support
- [x] Go support
- [x] HTML support
- [x] IAC support
- [x] Java support
- [x] JavaScript support
- [x] PHP support
- [x] Python support
- [x] Text support
- [x] XML support
- [x] Commands to download sonarlint server/analyzers

## Installation

### Install with your favourite package manager

[lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    "iamkarasik/sonarqube.nvim",
    opts = {}
}
```

### Install the sonarlint-language-server

#### Options 1: Using the plugin (Recommended)
If you do not already have the sonarlint-language-server, you can run `:SonarQubeInstallLsp`

#### Option 2: Manually install from GitHub
Download/Install the extension from the [github releases](https://github.com/SonarSource/sonarlint-vscode/releases)

## Configuration

### Option 1: Default Configuration (Recommended)
This is recommended when installing the LSP via `:SonarQubeInstallLsp`
```lua
require('sonarqube').setup({})
```

### Option 2: Override Default Configuration
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
        -- capabilities = require("cmp_nvim_lsp").default_capabilities(),
        log_level = "OFF",
    },
    csharp = {
        enabled = true,
        omnisharpDirectory = "/path/to/omnisharp",
        csharpOssPath = "/path/to/analyzers/sonarcsharp.jar",
        csharpEnterprisePath = "/path/to/analyzers/csharpenterprise.jar",
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

## TODO
- [ ] Configure rules
- [ ] Implement Actions - Toggle rule
- [ ] Implement handler - sonarlint/showRuleDescription
- [ ] Implement handler - sonarlint/needCompilationDatabase
- [ ] Support C/C++

## Special Thanks
- [@schrieveslaach](https://github.com/schrieveslaach/) - [sonarlint.nvim](https://gitlab.com/schrieveslaach/sonarlint.nvim) was used as inspiration
