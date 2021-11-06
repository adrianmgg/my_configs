local M = {}

function M.hsv_to_rgb(h, s, v)
	local c = v * s
	local hp = (h % 1) * 6
	local x = c * (1 - math.abs((hp % 2) - 1))
	local m = v - c
	local rgb
	if     hp < 1 then rgb = {c, x, 0}
	elseif hp < 2 then rgb = {x, c, 0}
	elseif hp < 3 then rgb = {0, c, x}
	elseif hp < 4 then rgb = {0, x, c}
	elseif hp < 5 then rgb = {x, 0, c}
	else               rgb = {c, 0, x}
	end
	table.foreach(rgb, function(i, v) rgb[i] = math.floor((v+m)*255) end)
	return string.format('#%02x%02x%02x', unpack(rgb))
end

return M

