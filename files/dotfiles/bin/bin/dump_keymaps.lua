-- dump_keymaps.lua
local modes = {
	"n",
	"i",
	"v",
	"x",
	"s",
	"o",
	"c",
	"t",
	"l",
}

local mode_names = {
	n = "Normal",
	i = "Insert",
	v = "Visual",
	x = "Visual (Selection)",
	s = "Select",
	o = "Operator-pending",
	c = "Command",
	t = "Terminal",
	l = "Lang-Arg",
}

local output = {}
table.insert(output, "# Complete Neovim Keymaps Documentation")
table.insert(output, "*Generated on: " .. os.date("%Y-%m-%d %H:%M:%S") .. "*")
table.insert(output, "")

for _, mode in ipairs(modes) do
	local maps = vim.api.nvim_get_keymap(mode)
	if #maps > 0 then
		table.insert(output, "## " .. mode_names[mode] .. " Mode (`" .. mode .. "`)")
		table.insert(output, "")
		table.insert(output, "| Keys | Action / Command | Description | Source |")
		table.insert(output, "|------|------------------|-------------|--------|")

		for _, map in ipairs(maps) do
			local lhs = map.lhs
			local rhs = map.rhs or (map.callback and "<Lua function>" or "")
			local desc = map.desc or ""
			local source = ""

			-- Attempt to resolve source if verbose info is available (requires :verbose map logic usually)
			-- For headless, we rely on the 'script' field or sid if available, but often it's limited without verbose redir
			if map.script and map.sid and map.sid > 0 then
				source = "Script ID: " .. map.sid
			elseif map.buffer and map.buffer > 0 then
				source = "Buffer: " .. map.buffer
			else
				source = "Global"
			end

			-- Escape pipes for Markdown safety
			lhs = lhs:gsub("|", "\\|")
			rhs = rhs:gsub("|", "\\|")
			desc = desc:gsub("|", "\\|")

			table.insert(output, string.format("| `%s` | `%s` | %s | %s |", lhs, rhs, desc, source))
		end
		table.insert(output, "")
	end
end

-- Print to stdout so we can redirect it
print(table.concat(output, "\n"))
