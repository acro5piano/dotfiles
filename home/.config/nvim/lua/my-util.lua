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

return M
