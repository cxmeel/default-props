local function cx<T>(conditions: { { T | any } | T }): T?
	local defaultValue

	for _, input in conditions do
		local inputType = typeof(input)

		if inputType ~= "table" or #input < 1 then
			if input ~= nil and inputType ~= "table" and defaultValue == nil then
				defaultValue = input
			end

			continue
		end

		if input[2] then
			return input[1]
		end
	end

	return defaultValue
end

return cx
