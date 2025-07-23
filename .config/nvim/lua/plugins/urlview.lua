return {
	"andreaswachowski/urlview.nvim",
	config = function()
		require("urlview").setup({
			default_picker = "telescope",
			-- custom configuration options --
		})
		vim.keymap.set("n", "\\u", "<Cmd>UrlView<CR>", { desc = "View buffer URLs" })
	end,
}
