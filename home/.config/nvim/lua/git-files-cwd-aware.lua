local M = {}

M.regexEscape = function(str)
  return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

M.get_working_path_from_git_root = function()
  local handle = io.popen("git rev-parse --show-toplevel")
  local root = handle:read("*a"):gsub("\n", "")
  handle:close()
  current_dir = os.getenv("PWD")
  return current_dir:gsub(M.regexEscape(root), ""):gsub("^/", "")
end

M.git_files_cwd_aware = function()
  local relative_path = M.get_working_path_from_git_root()
  if relative_path == "" then
    require("fzf-lua").git_files()
  else
    require("fzf-lua").git_files({ fzf_opts = { ["--query"] = relative_path .. "/ " } })
  end
end

return M
