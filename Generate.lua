
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

t[7] = {}

local scores = {
	10,
	10,
	1,
	2,
	-1,
	3,
	-2,
}

BADBOY_DEBUG_MIN = 10
BADBOY_DEBUG_MAX = 10

local strfind = string.find
t.is = function(msg)
	local a = 0
	local matches = {}
	for i, filter in ipairs(t) do
		for j=1, #filter do
			if strfind(msg, t[i][j]) then
				matches[t[i][j]] = scores[i]
				a = a + scores[i]
			end
		end
	end
	if a > BADBOY_DEBUG_MIN and a <= BADBOY_DEBUG_MAX then
		matches["TOTAL"] = a
		DevTools_Dump({
			[msg] = matches
		})
	end
	return a > 3
end
