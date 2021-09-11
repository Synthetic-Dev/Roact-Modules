local Roact = require(game.ReplicatedStorage.Roact)

local Theme = require(script.Parent)
local Palette = require(script.Parent.ColorPalette)

local SubTheme = Roact.Component:extend("SubTheme")

function SubTheme:render()
	return Roact.createElement(Theme.Provider, {
		value = {
			roundCorners = true;
			bgColor = Palette.primary;
			shadowColor = Palette.primaryDark;
			textColor = Palette.secondary;
			shadowTextColor = Palette.secondaryDark;
			buttonColor = Palette.primaryDark;
		};
	}, self.props[Roact.Children])
end

return SubTheme
