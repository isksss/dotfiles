return {
    "williamboman/mason.nvim",
    version = "*",
    lazy = false,
    config = function()
        require("mason").setup()
    end
}
