local M = {}

function M.split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

function M.reveal()
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(bufnr, "Explorer")
	local buf_dirname = vim.fn.expand("%:p:h")
	local handle = io.popen(string.format("tree --noreport --dirsfirst --sort name -f %s", buf_dirname))
	local result = handle:read("*a")
	handle:close()
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, M.split(result:gsub(buf_dirname .. "/", ""), "\n"))
	vim.api.nvim_win_set_buf(0, bufnr)
end

return M
