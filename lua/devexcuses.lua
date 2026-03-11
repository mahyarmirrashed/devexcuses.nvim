local M = {}

local cache = nil

-- Seed the RNG
math.randomseed(os.time())

-- Fisher-Yates shuffle algorithm: https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
local function shuffle(array)
  local n = #array
  for i = n, 2, -1 do
    local j = math.random(1, i)
    array[i], array[j] = array[j], array[i]
  end
  return array
end

local function load_quotes()
  if cache then return cache end

  local csv_path = vim.api.nvim_get_runtime_file("lua/excuses.csv", false)[1]
  if not csv_path then error("Could not find excuses.csv") end

  local file = io.open(csv_path, "r")
  if not file then error("Failed to open: " .. csv_path) end

  _ = file:read("*line") -- Skip header row

  local excuses = {}

  for line in file:lines() do
    local excuse = line:match('"(.-)"')
    if excuse then table.insert(excuses, {
      excuse = excuse,
    }) end
  end

  file:close()

  -- Store in cache and return
  cache = excuses

  return excuses
end

--- Sets up the devexcuses plugin.
--- This function is provided for compatibility but performs no actions.
--- @return nil
function M.setup() end

--- Retrieves a specified number of random excuses from the excuses CSV file.
--- Excuses are shuffled using the Fisher-Yates algorithm on each call.
--- @param count? number The number of excuses to retrieve (default: 1). Use -1 to retrieve all excuses.
--- @return table A table of excuse objects, each containing an 'excuse' field.
function M.get_excuse(count)
  count = count or 1
  local excuses = load_quotes()

  if count == -1 then count = #excuses end

  if count < 1 then return {} end

  local shuffled = shuffle(vim.deepcopy(excuses))

  local result = {}
  for i = 1, math.min(count, #shuffled) do
    table.insert(result, shuffled[i])
  end

  return result
end

--- Inserts a specified number of random excuses at the current cursor position.
--- @param count? number The number of excuses to insert (default: 1). Must be a strictly positive number.
function M.insert_excuse(count)
  count = count or 1
  if count < 1 then
    vim.notify("count must be a strictly positive number", vim.log.levels.WARN)
    return
  end

  local excuses = M.get_excuse(count)
  local lines = vim.tbl_map(function(e) return e.excuse end, excuses)
  vim.api.nvim_put(lines, "l", true, true)
end

vim.api.nvim_create_user_command(
  "Excuse",
  function(opts) require("devexcuses").insert_excuse(tonumber(opts.args) or 1) end,
  { nargs = "?" }
)

return M
