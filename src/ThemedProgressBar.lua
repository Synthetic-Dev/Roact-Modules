local Roact = require(game.ReplicatedStorage.Roact)

local ProgressBar = require(script.Parent.ProgressBar)

local Theme = require(script.Parent.Theme)

local ThemedProgressBar = Roact.Component:extend("ThemedProgressBar")

function ThemedProgressBar:render()
	return Roact.createElement(Theme.Consumer, {
		render = function(theme)
			self.props.color = self.props.color or theme.bgColor
			return Roact.createElement(ProgressBar, self.props)
		end;
	})
end

return ThemedProgressBar
