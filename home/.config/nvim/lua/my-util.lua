local M = {}

M.buf_get_full_text = function(bufnr)
	local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, true), "\n")
	if vim.api.nvim_buf_get_option(bufnr, "eol") then
		text = text .. "\n"
	end
	return text
end

-- Credit: https://github.com/ckipp01/stylua-nvim/blob/main/lua/stylua-nvim.lua
M.format_whole_file = function(cmd)
	local bufnr = vim.fn.bufnr("%")
	local input = M.buf_get_full_text(bufnr)
	local output = vim.fn.system(cmd, input)
	if output ~= input then
		local new_lines = vim.fn.split(output, "\n")
		vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
	end
end

return M
