local M = {}

M.setup = function(opts)
    -- well, nothing to do :)
end

local expansion_buf_id = nil
M.expand_macro = function()
    local function make_buffer_lines(name, expansion)
        local lines = {}
        local header = "// Recursive expansion of the " .. name .. " macro"
        table.insert(lines, header)
        table.insert(lines, "// " .. string.rep("=", string.len(header) - 3))
        table.insert(lines, "")

        for line in string.gmatch(expansion, "[^\n]+") do
            table.insert(lines, line)
        end

        return lines
    end

    local function handler(responses)
        if responses == nil or responses[1] == nil or responses[1].result == nil then
            vim.notify('No macro under cursor!', vim.log.levels.WARN)
            return
        end

        local name = responses[1].result.name
        local expansion = responses[1].result.expansion

        -- if there already is an expansion buffer open, delete it first
        if expansion_buf_id ~= nil then
            vim.api.nvim_buf_delete(expansion_buf_id, { force = true })
        end

        -- create new buffer for macro expansion
        expansion_buf_id = vim.api.nvim_create_buf(false, true)

        -- create new window for macro expansion
        vim.cmd('vsplit')
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, expansion_buf_id)

        -- set the contents of the buffer and it's type for syntax highlighting
        vim.api.nvim_buf_set_lines(expansion_buf_id, 0, 0, false, make_buffer_lines(name, expansion))
        vim.api.nvim_buf_set_option(expansion_buf_id, 'filetype', 'rust')
    end

    vim.lsp.buf_request_all(0, 'rust-analyzer/expandMacro', vim.lsp.util.make_position_params(), handler)
end

return M
