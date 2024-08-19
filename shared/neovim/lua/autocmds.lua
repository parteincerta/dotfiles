vim.api.nvim_create_autocmd("FileType", {
	pattern = "gitcommit",
	callback = function ()
		vim.cmd.set("spell")
	end
})
