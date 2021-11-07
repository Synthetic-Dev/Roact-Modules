local Roact = require(game.ReplicatedStorage.Roact)

local elements = script.Parent.Elements
local Frame = require(elements.Frame)

local Theme = require(script.Parent.Theme)

local ThemedFrame = Roact.Component:extend("ThemedFrame")

function ThemedFrame:render()
	return Roact.createElement(Theme.Consumer, {
		render = function(theme)
			if self.props.rounded == nil and self.props.cornerRadius == nil then
				self.props.rounded = theme.roundCorners
			end

			self.props.color = self.props.color
				or (self.props.shadow and theme.shadowColor or theme.bgColor)
			self.props.trans = self.props.trans or 0
			return Roact.createElement(Frame, self.props)
		end;
	})
end

return ThemedFrame
