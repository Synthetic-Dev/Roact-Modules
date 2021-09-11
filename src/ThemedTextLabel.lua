local Roact = require(game.ReplicatedStorage.Roact)

local elements = script.Parent.Elements
local TextLabel = require(elements.TextLabel)

local Theme = require(script.Parent.Theme)

local ThemedTextLabel = Roact.Component:extend("ThemedTextLabel")

function ThemedTextLabel:render()
	return Roact.createElement(Theme.Consumer, {
		render = function(theme)
			if self.props.rounded == nil and self.props.cornerRadius == nil then
				self.props.rounded = theme.roundCorners
			end

			self.props.color = self.props.color
				or (
					self.props.shadow and theme.shadowTextColor
					or theme.textColor
				)
			return Roact.createElement(TextLabel, self.props)
		end;
	})
end

return ThemedTextLabel
