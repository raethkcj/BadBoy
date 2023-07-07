
local _, t = ...

BADBOY_FILTERS = t

t.gnt = function(u, ...)
	local select, strsplit, tonumber, n, char = select, string.split, tonumber, C_Map.GetMapInfo(u).parentMapID, string.char
	for i = 1, select("#", ...) do
		local tbl = {}
		local pos = 0
		local str = ""
		local entry = select(i, ...)
		for l = 1, select("#", strsplit("^", entry)) do
			local db = select(l, strsplit("^", entry))
			for j = 1, select("#", strsplit(",", db)) do
				local tm = select(j, strsplit(",", db))
				local rn = tonumber(tm)
				rn = rn - i - n
				if j == 1 then
					if pos > 0 then
						tbl[pos] = str
						str = ""
					end
					pos = pos + 1
				end
				str = str .. char(rn)
			end
		end
		tbl[pos] = str
		t[i] = tbl
	end
	t.gnt = nil
end

local scores = {
	10,
	10,
	1,
	2,
	-2,
	3
}

local strfind = string.find
t.is = function(msg)
	local a = 0
	local matches = {}
	for i = 1, 6 do
		for j=1, #t[i] do
			if strfind(msg, t[i][j]) then
				matches[t[i][j]] = scores[i]
				a = i>5 and a+3 or i>4 and a-1 or i>3 and a+2 or i>2 and a+1 or a+10
			end
		end
	end
	if BADBOY_DEBUG and a > 0 and a < 3 then
		matches["TOTAL"] = a
		DevTools_Dump({
			[msg] = matches
		})
	end
	return a > 3
end
