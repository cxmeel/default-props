local InstancePropertyRegistry = {}

local UNASSIGNABLE_ERROR_PATTERN = "^unable to assign"

local function instanceHasProperties(className: string, propertyList: { string })
	local propertyRegistry = InstancePropertyRegistry[className]

	if propertyRegistry == nil then
		InstancePropertyRegistry[className] = {}
		return instanceHasProperties(className, propertyList)
	end

	local testInstance = Instance.new(className)

	for propertyName in propertyList do
		local ok, message = pcall(function()
			testInstance[propertyName] = true
		end)

		propertyRegistry[propertyName] = ok
			or typeof(message) == "string" and message:lower():find(UNASSIGNABLE_ERROR_PATTERN)
	end

	testInstance:Destroy()

	return propertyRegistry
end

return instanceHasProperties
