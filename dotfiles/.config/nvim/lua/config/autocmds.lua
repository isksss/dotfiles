-----------------------------------------------------------
-- Filetype and general autocommands
-----------------------------------------------------------
vim.filetype.add({
    extension = {
        bash = "sh",
        sh = "sh",
        zsh = "sh",
    },
    filename = {
        [".bash_profile"] = "sh",
        [".bashrc"] = "sh",
        [".zprofile"] = "sh",
        [".zshrc"] = "sh",
    },
})
