local M = {}

M.regexEscape = function(str)
	return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

M.get_working_path_from_git_root = function()
	local handle = io.popen("git rev-parse --show-toplevel")
	if handle == nil then
		return
	end
	local root = handle:read("*a"):gsub("\n", "")
	handle:close()
	local current_dir = os.getenv("PWD")
	if current_dir == nil then
		return
	end
	return current_dir:gsub(M.regexEscape(root), ""):gsub("^/", "")
end

M.upper_first_letter = function(value)
	local first = string.sub(value, 0, 1)
	local rest = string.sub(value, 2)
	return string.upper(first) .. rest
end

M.filter = function(arr, fn)
	if type(arr) ~= "table" then
		return arr
	end

	local filtered = {}
	for k, v in pairs(arr) do
		if fn(v, k, arr) then
			table.insert(filtered, v)
		end
	end

	return filtered
end

M.filter_react_dts = function(value)
	return string.match(value.uri, "react/index.d.ts") == nil
end

return M
