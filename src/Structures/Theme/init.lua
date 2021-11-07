local Roact = require(game.ReplicatedStorage.Roact)

local Palette = require(script.ColorPalette)

local ThemeContext = Roact.createContext({
	roundCorners = true;
	bgColor = Palette.secondary;
	shadowColor = Palette.secondaryDark;
	textColor = Palette.primary;
	shadowTextColor = Palette.primaryDark;
	buttonColor = Palette.secondaryDark;
})

return ThemeContext
