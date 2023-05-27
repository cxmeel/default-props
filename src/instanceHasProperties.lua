local InstancePropertyRegistry = {}

local function instanceHasProperties(className: string, propertyList: { string })
	local propertyRegistry = InstancePropertyRegistry[className]

	if propertyRegistry == nil then
		InstancePropertyRegistry[className] = {}
		return instanceHasProperties(className, propertyList)
	end

	local testInstance = Instance.new(className)

	for propertyName in propertyList do
		local success = pcall(function()
			return testInstance[propertyName]
		end)

		propertyRegistry[propertyName] = success
	end

	testInstance:Destroy()

	return propertyRegistry
end

return instanceHasProperties
