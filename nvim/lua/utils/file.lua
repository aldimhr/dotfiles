local M = {}

-- Remove leading icons or whitespace from fzf selection by matching from first valid path character
function M.strip_icons(raw)
  local cleaned = raw:match("[%w%._%-/].*")
  return cleaned or raw
end

-- Helper to delete and wipe buffer if loaded (fuzzy match endswith path)
local function delete_buffer(path)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      local name = vim.api.nvim_buf_get_name(bufnr)
      -- Match if buffer name ends with the given path
      if name:sub(- #path) == path then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end
  end
end

-- Open file
function M.open_path(raw)
  local path = M.strip_icons(raw)
  vim.cmd("edit " .. vim.fn.expand(path))
end

-- Edit or create file (with parent folders)
function M.edit_or_create_file(filepath)
  local fullpath = vim.fn.expand(filepath)
  local dir = vim.fn.fnamemodify(fullpath, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
  vim.cmd("edit " .. fullpath)
end

-- Delete file or directory (with confirmation)
function M.delete_path(raw)
  local path = vim.fn.expand(raw)
  if vim.loop.fs_stat(path) == nil then
    print("❌ Path not found: " .. path)
    return
  end
  local ans = vim.fn.confirm(string.format("Delete '%s'?", path), "&Yes\n&No", 2)
  if ans ~= 1 then
    print("❌ Canceled")
    return
  end
  local st = vim.loop.fs_stat(path)
  if st.type == "directory" then
    vim.fn.delete(path, "rf")
    print(string.format("📁 Directory deleted: %s", path))
  else
    local ok, err = os.remove(path)
    if ok then
      print(string.format("📄 File deleted: %s", path))
    else
      print(string.format("❌ Failed delete: %s", err))
    end
  end
  -- close related buffer if open
  delete_buffer(path)
end

-- Prompt input for delete, prefilled with default, then delete
function M.delete_path_input(default)
  local input = vim.fn.input("Delete file/directory (enter to cancel): ", default)
  if input == "" then
    print("❌ Canceled")
    return
  end
  M.delete_path(input)
end

-- Rename file or directory
function M.rename_path(raw)
  local old = M.strip_icons(raw)
  local full_old = vim.fn.expand(old)
  if vim.loop.fs_stat(full_old) == nil then
    print("❌ Path not found: " .. full_old)
    return
  end
  local new = vim.fn.input(string.format("Rename '%s' to: ", old), old)
  if new == "" or new == old then
    print("❌ Canceled or same name")
    return
  end
  local full_new = vim.fn.expand(new)
  local new_dir = vim.fn.fnamemodify(full_new, ":h")
  if vim.fn.isdirectory(new_dir) == 0 then
    vim.fn.mkdir(new_dir, "p")
  end
  local ok, err = vim.loop.fs_rename(full_old, full_new)
  if not ok then
    print(string.format("❌ Rename failed: %s", err))
    return
  end
  -- close old buffer and open new
  delete_buffer(old)
  vim.cmd("edit " .. full_new)
  print(string.format("✏️ Renamed: %s → %s", old, new))
end

-- Move file or directory
function M.move_path(raw)
  local old = M.strip_icons(raw)
  local full_old = vim.fn.expand(old)
  if vim.loop.fs_stat(full_old) == nil then
    print("❌ Path not found: " .. full_old)
    return
  end
  local dest = vim.fn.input(string.format("Move '%s' to: ", old), old)
  if dest == "" or dest == old then
    print("❌ Canceled or same location")
    return
  end
  local full_new = vim.fn.expand(dest)
  local dest_dir = vim.fn.fnamemodify(full_new, ":h")
  if vim.fn.isdirectory(dest_dir) == 0 then
    vim.fn.mkdir(dest_dir, "p")
  end
  local ok, err = vim.loop.fs_rename(full_old, full_new)
  if not ok then
    print(string.format("❌ Move failed: %s", err))
    return
  end
  -- close old buffer and open new
  delete_buffer(old)
  vim.cmd("edit " .. full_new)
  print(string.format("📦 Moved: %s → %s", old, dest))
end

return M
