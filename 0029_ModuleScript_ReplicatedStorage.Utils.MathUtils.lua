--[[
  Extracted from: ReplicatedStorage.Utils.MathUtils
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

function isPointInVolume(p1, p2, p3)
	local v4 = p2:Inverse() * p1
	local v5 = vector.abs(v4)
	local v6
	if v5.x <= p3.x * 0.5 and v5.y <= p3.y * 0.5 then
		v6 = v5.z <= p3.z * 0.5
	else
		v6 = false
	end
	return v6
end
function isPointInVolume_direct(p7, p8, p9)
	local v10 = p8 * p7
	local v11 = vector.abs(v10)
	local v12
	if v11.x <= p9.x * 0.5 and v11.y <= p9.y * 0.5 then
		v12 = v11.z <= p9.z * 0.5
	else
		v12 = false
	end
	return v12
end
return {
	["isPointInVolume"] = isPointInVolume,
	["isPointInVolume_direct"] = isPointInVolume_direct,
	["quadBezier"] = function(p13, p14, p15, p16) --[[Function name: quadBezier, line 16]]
		return (1 - p13) ^ 2 * p14 + (1 - p13) * 2 * p13 * p15 + p13 ^ 2 * p16
	end,
	["cubicBezier"] = function(p17, p18, p19, p20, p21) --[[Function name: cubicBezier, line 20]]
		return (1 - p17) ^ 3 * p18 + (1 - p17) ^ 2 * 3 * p17 * p19 + (1 - p17) * 3 * p17 ^ 2 * p20 + p17 ^ 3 * p21
	end,
	["sortByXdesc"] = function(...) --[[Function name: sortByXdesc, line 65]]
		local v22 = select("#", ...)
		if v22 == 1 then
			error("sortByXdesc requires at least 2 vectors")
		else
			if v22 == 2 then
				local v23, v24 = ...
				if v23.x >= v24.x then
					return v23, v24
				else
					return v24, v23
				end
			end
			if v22 == 3 then
				local v25, v26, v27 = ...
				if v25.x >= v26.x and v25.x >= v27.x then
					if v26.x >= v27.x then
						return v25, v26, v27
					else
						return v25, v27, v26
					end
				elseif v26.x >= v25.x and v26.x >= v27.x then
					if v25.x >= v27.x then
						return v26, v25, v27
					else
						return v26, v27, v25
					end
				elseif v25.x >= v26.x then
					return v27, v25, v26
				else
					return v27, v26, v25
				end
			end
		end
		local v28 = { ... }
		table.sort(v28, function(p29, p30) --[[Anonymous function at line 100]]
			return p29.x > p30.x
		end)
		return table.unpack(v28, 1, v22)
	end,
	["sortByYdesc"] = function(...) --[[Function name: sortByYdesc, line 106]]
		local v31 = select("#", ...)
		if v31 == 1 then
			error("sortByYdesc requires at least 2 vectors")
		else
			if v31 == 2 then
				local v32, v33 = ...
				if v32.y >= v33.y then
					return v32, v33
				else
					return v33, v32
				end
			end
			if v31 == 3 then
				local v34, v35, v36 = ...
				if v34.y >= v35.y and v34.y >= v36.y then
					if v35.y >= v36.y then
						return v34, v35, v36
					else
						return v34, v36, v35
					end
				elseif v35.y >= v34.y and v35.y >= v36.y then
					if v34.y >= v36.y then
						return v35, v34, v36
					else
						return v35, v36, v34
					end
				elseif v34.y >= v35.y then
					return v36, v34, v35
				else
					return v36, v35, v34
				end
			end
		end
		local v37 = { ... }
		table.sort(v37, function(p38, p39) --[[Anonymous function at line 141]]
			return p38.y > p39.y
		end)
		return table.unpack(v37, 1, v31)
	end,
	["sortByZdesc"] = function(...) --[[Function name: sortByZdesc, line 24]]
		local v40 = select("#", ...)
		if v40 == 1 then
			error("sortByZdesc requires at least 2 vectors")
		else
			if v40 == 2 then
				local v41, v42 = ...
				if v41.z >= v42.z then
					return v41, v42
				else
					return v42, v41
				end
			end
			if v40 == 3 then
				local v43, v44, v45 = ...
				if v43.z >= v44.z and v43.z >= v45.z then
					if v44.z >= v45.z then
						return v43, v44, v45
					else
						return v43, v45, v44
					end
				elseif v44.z >= v43.z and v44.z >= v45.z then
					if v43.z >= v45.z then
						return v44, v43, v45
					else
						return v44, v45, v43
					end
				elseif v43.z >= v44.z then
					return v45, v43, v44
				else
					return v45, v44, v43
				end
			end
		end
		local v46 = { ... }
		table.sort(v46, function(p47, p48) --[[Anonymous function at line 59]]
			return p47.z > p48.z
		end)
		return table.unpack(v46, 1, v40)
	end,
	["areVectorsAligned"] = function(p49, p50, p51) --[[Function name: areVectorsAligned, line 147]]
		local v52 = vector.normalize(p49)
		local v53 = vector.normalize(p50)
		local v54 = vector.dot(v52, v53)
		local v55 = math.clamp(v54, -1, 1)
		local v56 = math.acos(v55)
		return math.deg(v56) <= p51
	end,
	["simulateGravity"] = function(p57) --[[Function name: simulateGravity, line 154]]
		return p57 * p57 * 98.1
	end,
	["calculateTimeToGround"] = function(p58, p59) --[[Function name: calculateTimeToGround, line 158]]
		local v60 = (p58 - p59) * 2 / 196.2
		return math.sqrt(v60)
	end
}