-- Maps specified number keys from 1 to n to a keymap.
-- @param n number: The key numbers from 1 to n to map.
-- @param keymap: The callback function containing the keymap template.
_G.mk_keymaps = function(n, keymap) 
    for i = 1, n do
        keymap(i)
    end
end

_G.key_opts = function(desc)
    return { desc = desc, silent = true }
end