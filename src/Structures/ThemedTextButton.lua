local Roact = require(game.ReplicatedStorage.Roact)

local elements = script.Parent.Elements
local TextButton = require(elements.TextButton)

local Theme = require(script.Parent.Theme)

local ThemedTextButton = Roact.Component:extend("ThemedTextButton")

function ThemedTextButton:render()
	return Roact.createElement(Theme.Consumer, {
		render = function(theme)
			if self.props.rounded == nil and self.props.cornerRadius == nil then
				self.props.rounded = theme.roundCorners
			end

			self.props.bgColor = self.props.bgColor or theme.buttonColor
			self.props.color = self.props.color or theme.textColor
			return Roact.createElement(TextButton, self.props)
		end;
	})
end

return ThemedTextButton
