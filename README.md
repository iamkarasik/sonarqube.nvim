# sonarqube
`sonarqube` integrates with the [sonarlint-language-server](https://github.com/SonarSource/sonarlint-language-server) to deliver real-time static analysis and code actions directly in neovim.

https://github-production-user-asset-6210df.s3.amazonaws.com/10507366/454176376-cda18dde-6bb9-49c8-8dfa-59d29d3d8750.mp4

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
- [x] Commands to download sonarlint server/analyzers (requires [NeoVim](https://neovim.io/) >= 0.10)
- [x] Configurable handler for sonarlint/showRuleDescription
- [x] Rules: Disable All, Toggle Rule (Code Action), configure in setup

## Installation

### Install with your favourite package manager

[lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    "iamkarasik/sonarqube.nvim",
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
        handlers = {
            -- Custom handler to show rule description
            -- The `res` argument contains various keys containing html that can be rendered in your favourite neovim html plugin 
            -- Alternatively, open the rule in the browser using your favourite sonarqube rule website (example below)
            ["sonarlint/showRuleDescription"] = function(err, res, ctx, cfg)
                local uri = "https://rules.sonarsource.com/%s/RSPEC-%s"
                local lang = res.languageKey
                local spec = string.match(res.key, "S(%d+)")
                vim.ui.open(string.format(uri, lang, spec))
            end,
        },
    },
    rules = {
        enabled = true,
        ["typescript:S103"] = { -- Lines should not be too long (Default Value: 180)
            enabled = true,
            parameters = { maximumLineLength = 100 }
        },
        ["java:S1188"] = { -- Anonymous classes should not have too many lines (Default Value: 20)
            enabled = true,
            parameters = { Max: 40 }
        },
	["java:S106"] = { enabled = false },
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
- [ ] Implement handler - sonarlint/needCompilationDatabase
- [ ] Support C/C++

## Special Thanks
- [@schrieveslaach](https://github.com/schrieveslaach/) - [sonarlint.nvim](https://gitlab.com/schrieveslaach/sonarlint.nvim) was used as inspiration
