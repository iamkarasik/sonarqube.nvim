# sonarqube
`sonarqube` integrates with the [sonarlint-language-server](https://github.com/SonarSource/sonarlint-language-server) to deliver real-time static analysis and code actions directly in neovim.

https://github-production-user-asset-6210df.s3.amazonaws.com/10507366/454176376-cda18dde-6bb9-49c8-8dfa-59d29d3d8750.mp4

<!-- TOC -->
- [Installation](#installation)
- [Configuration](#configuration)
- [Rules](#rules)
- [Key Features](#key-features)
- [Commands](#commands)
- [TODO](#todo)
- [Special Thanks](#special-thanks)
<!-- /TOC -->

## Installation

### 1. Install with your favourite package manager

[lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    "iamkarasik/sonarqube.nvim",
    config = function()
      require("sonarqube").setup({})
    end
}
```

[packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use {
    "iamkarasik/sonarqube.nvim",
    config = function()
      require("sonarqube").setup({})
    end
}
```

### 2. Install the sonarlint-language-server

#### Option 1: Using the plugin (Recommended)
If you do not already have the sonarlint-language-server, you can run `:SonarQubeInstallLsp`

#### Option 2: Using [mason.nvim](https://github.com/mason-org/mason.nvim)
Run `:MasonInstall sonarlint-language-server` then navigate to the [Mason Configuration](#mason-configuration)

#### Option 3: Manually install from GitHub
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
    rules = { enabled = true },
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

## Mason Configuration
```lua
local extension_path = vim.fn.stdpath("data")
    .. "/mason/packages/sonarlint-language-server/extension"

require("sonarqube").setup({
    lsp = {
        cmd = {
            vim.fn.exepath("java"),
            "-jar",
            extension_path .. "/server/sonarlint-ls.jar",
            "-stdio",
            "-analyzers",
            extension_path .. "/analyzers/sonargo.jar",
            extension_path .. "/analyzers/sonarhtml.jar",
            extension_path .. "/analyzers/sonariac.jar",
            extension_path .. "/analyzers/sonarjava.jar",
            extension_path .. "/analyzers/sonarjavasymbolicexecution.jar",
            extension_path .. "/analyzers/sonarjs.jar",
            extension_path .. "/analyzers/sonarphp.jar",
            extension_path .. "/analyzers/sonarpython.jar",
            extension_path .. "/analyzers/sonartext.jar",
            extension_path .. "/analyzers/sonarxml.jar",
        },
    },
    csharp = {
        enabled = true,
        omnisharpDirectory = extension_path .. "/omnisharp",
        csharpOssPath = extension_path .. "/analyzers/sonarcsharp.jar",
        csharpEnterprisePath = extension_path .. "/analyzers/csharpenterprise.jar",
    },
})
```

## Rules
Rules can be individually enabled or disabled, as well as optionally receive override parameters where applicable.
Note that setting `rules.enabled = false` will disable all analysis.

```lua
require('sonarqube').setup({
    rules = {
        enabled = true,

        -- Lines should not be too long (Default Value: 180)
        ["typescript:S103"] = { enabled = true, parameters = { maximumLineLength = 100 } },

        -- Anonymous classes should not have too many lines (Default Value: 20)
        ["java:S1188"] = { enabled = true, parameters = { Max: 40 } },

        -- Standard outputs should not be used directly to log anything
        ["java:S106"] = { enabled = false },
    }
})
```

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

## Commands
- `SonarQubeInstallLsp` - Install the LSP
- `SonarQubeShowConfig` - Print the configuration
- `SonarQubeListAllRules` - List all the registered rules

## TODO
- [ ] Support C/C++
- [ ] Show all locations for issue

## Special Thanks
- [@schrieveslaach](https://github.com/schrieveslaach/) - [sonarlint.nvim](https://gitlab.com/schrieveslaach/sonarlint.nvim) was used as inspiration
