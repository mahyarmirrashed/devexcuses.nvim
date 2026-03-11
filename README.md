# devexcuses.nvim

A Neovim plugin that provides random developer excuses from a bundled CSV file. Excuses are shuffled using the Fisher-Yates algorithm and cached for performance.

## Features

- No dependencies: everything is self-contained so no unnecessary internet API calls
- Supports fetching one excuse, multiple excuses, or all the excuses
- Caches excuses to avoid repeated file I/O

## Requirements

- Neovim 0.5.0 or later

## Installation

Install using your preferred Neovim package manager.

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use 'mahyarmirrashed/devexcuses.nvim'
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'mahyarmirrashed/devexcuses.nvim'
```

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "mahyarmirrashed/devexcuses.nvim",
  config = function()
    require("devexcuses").setup()
  end,
}
```

## Usage

The plugin provides a single function, `get_excuse(count)`, to retrieve random excuses.

### Example Commands

```lua
-- Get one random excuse (default)
local excuse = require('devexcuses').get_excuse()
print(excuse[1].excuse)

-- Get three random excuses
local excuses = require('devexcuses').get_excuse(3)
for _, e in ipairs(excuses) do
  print(e.excuse)
end

-- Get all excuses
local all_excuses = require('devexcuses').get_excuse(-1)
```

### Function Documentation

#### `get_excuse(count?)`

- **count** (optional, number): Number of excuses to retrieve. Defaults to 1. Use `-1` to get all excuses
- **Returns**: A table of excuse objects, each with an `excuse` field

#### `setup()`

- No-op function provided for compatibility. No configuration needed

## Credits

Thanks to @codehaks for the [CSV of excuses](https://gist.github.com/codehaks/f2ef79d9d1d4fc2d438abd5b7d24150c) used in this plugin.

## License

[MIT License](./LICENSE)
