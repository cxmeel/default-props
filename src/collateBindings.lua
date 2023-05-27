local EVENT_PROPMARKER_PATTERN = "^RoactHost.*Event%b()$"

local function collectBindings(props)
	local bindings = {}

	for key, value in props do
		if tostring(key):match(EVENT_PROPMARKER_PATTERN) then
			bindings[key] = value
		end
	end

	return bindings
end

local function collateBindings(...)
	local resolvedBindings = {}
	local callbacks = {}

	for _, props in { ... } do
		if typeof(props) ~= "table" then
			continue
		end

		for symbol, callback in collectBindings(props) do
			if not callbacks[symbol] then
				callbacks[symbol] = {}
			end

			table.insert(callbacks[symbol], callback)
		end
	end

	for symbol, callbackList in callbacks do
		resolvedBindings[symbol] = function(...)
			for _, callback in callbackList do
				callback(...)
			end
		end
	end

	return resolvedBindings
end

return collateBindings
