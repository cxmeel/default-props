local React = require(script.React)
local Sift = require(script.Parent.Sift)

local collateBindings = require(script.collateBindings)
local cx = require(script.cx)
local instanceHasProperties = require(script.instanceHasProperties)
local isHostComponent = require(script.isHostComponent)
local isRoact = require(script.isRoact)

local Dictionary = Sift.Dictionary
local ReactChildren: any = isRoact(React) and React.Children or "children"

local FFLAGS = {
	ALLOW_MERGE_FUNCTIONAL_DEFAULTS = true, -- May cause performance issues
	COLLATE_BINDINGS = true,
}

export type DefaultProps = { [any]: any } | (props: { [any]: any }, ...any) -> { [any]: any }

local function withDefaultProps(component, defaultProps: DefaultProps)
	local isDefaultPropsFunctional = typeof(defaultProps) == "function"
	local isComponentHostComponent = isHostComponent(component)

	return function(props, ...)
		local resolvedDefaultProps = if isDefaultPropsFunctional
			then (defaultProps :: any)(props, ...)
			else defaultProps
		local resolvedOtherProps = if isDefaultPropsFunctional then nil else props
		local resolvedBindings = nil

		if FFLAGS.ALLOW_MERGE_FUNCTIONAL_DEFAULTS and isDefaultPropsFunctional and isComponentHostComponent then
			local instanceProperties = instanceHasProperties(component, props)

			resolvedOtherProps = Dictionary.filter(props, function(_, key)
				return instanceProperties[key] == true
			end)
		end

		if FFLAGS.COLLATE_BINDINGS then
			resolvedBindings = collateBindings(resolvedDefaultProps, props)
		end

		local newProps = Dictionary.merge(resolvedDefaultProps, resolvedOtherProps, resolvedBindings, {
			[ReactChildren] = Dictionary.merge(resolvedDefaultProps[ReactChildren], props[ReactChildren]),
		})

		return React.createElement(component, newProps)
	end
end

local function wrapMetamethod(_, component)
	return function(defaultProps)
		return withDefaultProps(component, defaultProps)
	end
end

return setmetatable({
	FFLAGS = FFLAGS,
	None = Sift.None,

	cx = cx,
}, {
	__index = wrapMetamethod,
	__call = wrapMetamethod,
})
