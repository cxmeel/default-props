local function isRoact(react: any)
	return typeof(react) == "table"
		and typeof(react.Children) == "userdata"
		and tostring(react.Children) == "Symbol(Children)"
end

return isRoact
