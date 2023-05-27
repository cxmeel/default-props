local function isHostComponent(component: any)
	return typeof(component) == "string"
end

return isHostComponent
