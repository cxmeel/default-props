# DefaultProps

A utility module for creating default props for React/Roact components.

## Quick Start

Add DefaultProps to your `wally.toml` file:

```toml
# wally.toml

[dependencies]
DefaultProps = "csqrl/default-props-react@0.1.0"
DefaultProps = "csqrl/default-props-roact@0.1.0" # if using Roact
```

```bash
$ wally install
```

## Usage

```lua
-- Button.lua
local default = require(path.to.DefaultProps)

local Button = default.TextButton {
  AutoButtonColor = false,
  AutomaticSize = Enum.AutomaticSize.XY,
  BackgroundColor3 = Color3.fromHex("#fafafa"),
  FontFace = Font.fromEnum(Enum.Font.GothamBold),
  TextSize = 14,
  TextColor3 = Color3.fromHex("#1a1a1a"),

  children = {
    Corners = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 4)
    }),

    Padding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 8),
      PaddingLeft = UDim.new(0, 14),
      PaddingBottom = UDim.new(0, 8),
      PaddingRight = UDim.new(0, 14)
    }),
  }
}

return Button
```

```lua
-- App.lua
local Button = require(path.to.Button)

local function App()
  return React.createElement(..., { ... }, {
    Button = React.createElement(Button, {
      Text = "Click Me!"
    }),
  })
end
```

### Extending Components

```lua
-- PrimaryButton.lua
local default = require(path.to.DefaultProps)

local Button = require(path.to.Button)

local PrimaryButton = default(Button) {
  BackgroundColor3 = Color3.fromHex("#00a2ff"),
  TextColor3 = Color3.fromHex("#fafafa"),
}

return PrimaryButton
```

### Functional Defaults

```lua
-- Button.lua
local default = require(path.to.DefaultProps)

local Button = default.TextButton (function(props)--, hooks)
  local hovered, setHovered = React.useState(false)

  return {
    BackgroundColor3 = hovered and Color3.fromHex("#cdcdcd") or Color3.fromHex("#fafafa"),

    [React.Event.MouseEnter] = function()
      setHovered(true)
    end,
    [React.Event.MouseLeave] = function()
      setHovered(false)
    end,
  }
end)

return Button
```

## cx

`cx` is a utility function for conditionally selecting prop values. It's somewhat similar
to the `clsx` utility for React.

`cx` accepts an array of inputs in the format of `{ value, condition }`. To specify a
default value, include a raw value in your conditions array. It does not matter where
the default value is placed in the array, but only the first non-table value will be
considered.

```lua
-- Button.lua
local default = require(path.to.DefaultProps)
local cx = default.cx

local Button = default.TextButton (function(props)
  local hovered, setHovered = React.useState(false)
  local pressed, setPressed = React.useState(false)

  if props.disabled then
    props[React.Event.Activated] = nil
  end

  return {
    AutoButtonColor = false,
    AutomaticSize = Enum.AutomaticSize.XY,
    BackgroundColor3 = cx {
      { Color3.fromHex("#99daff"), props.primary and props.disabled },
      { Color3.fromHex("#0074bd"), props.primary and pressed },
      { Color3.fromHex("#32b5ff"), props.primary and hovered },
      { Color3.fromHex("#00a2ff"), props.primary },

      { Color3.new(1, 1, 1), props.disabled },
      { Color3.fromHex("#d9d9d9"), pressed },
      { Color3.fromHex("#d9f8ff"), hovered },
      Color3.fromHex("#f2f2f2"),
    },

    TextColor3 = cx {
      { Color3.new(1, 1, 1), props.primary },
      { Color3.fromHex("#787878"), props.disabled },
      Color3.new(),
    },

    FontFace = Font.fromEnum(Enum.Font.GothamBold),
    TextSize = 14,

    [React.Event.InputBegan] = function(_, input)
      if input.UserInputType == Enum.UserInputType.MouseMovement then
        setHovered(true)
      elseif input.UserInputType.Name:match("^MouseButton%d+$") then
        setPressed(true)
      end
    end,

    [React.Event.InputEnded] = function(_, input)
      if input.UserInputType == Enum.UserInputType.MouseMovement then
        setHovered(false)
      elseif input.UserInputType.Name:match("^MouseButton%d+$") then
        setPressed(false)
      end
    end,
  }
end)

return Button
```
