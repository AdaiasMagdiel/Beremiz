local function pprint_rec(tbl, level)
	local space = (" "):rep(level * 2)

	for k, v in pairs(tbl) do
		if type(v) == "table" then
			local count = 0 for _ in pairs(tbl) do count = count + 1 end
			if count == 0 then
				io.write(("%s%s => {}"):format(space, tostring(k)))
				io.write('\n')
			else
				io.write(("%s%s => "):format(space, tostring(k)))
				io.write('\n')
				pprint_rec(v, level+1)
			end
		elseif type(v) == "function" then
			io.write(("%s%s => %s"):format(space, tostring(k), "<function>"))
			io.write('\n')
		elseif type(v) == "string" then
			if #v == 0 then
				io.write(("%s%s => \"\""):format(space, tostring(k)))
				io.write('\n')
			else
				io.write(("%s%s => %s"):format(space, tostring(k), v))
				io.write('\n')
			end
		else
			io.write(("%s%s => %s"):format(space, tostring(k), tostring(v)))
			io.write('\n')
		end
	end
end

local function pprint(tbl)
	pprint_rec(tbl, 0)
end

return pprint
