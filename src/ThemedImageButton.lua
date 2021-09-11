local Roact = require(game.ReplicatedStorage.Roact)

local elements = script.Parent.Elements
local ImageButton = require(elements.ImageButton)

local Theme = require(script.Parent.Theme)

local ThemedImageButton = Roact.Component:extend("ThemedImageButton")

function ThemedImageButton:render()
	return Roact.createElement(Theme.Consumer, {
		render = function(theme)
			if self.props.rounded == nil and self.props.cornerRadius == nil then
				self.props.rounded = theme.roundCorners
			end

			self.props.color = self.props.color or theme.buttonColor
			return Roact.createElement(ImageButton, self.props)
		end;
	})
end

return ThemedImageButton
