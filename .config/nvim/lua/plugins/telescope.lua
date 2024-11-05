return {
    'nvim-telescope/telescope.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {
            desc = 'ファイル名を検索'
        })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {
            desc = 'プロジェクト内の文字列を検索'
        })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {
            desc = 'nvimのヘルプタグを検索'
        })
    end
}
