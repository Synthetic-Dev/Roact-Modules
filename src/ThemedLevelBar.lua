local Roact = require(game.ReplicatedStorage.Roact)

local LevelBar = require(script.Parent.LevelBar)

local Theme = require(script.Parent.Theme)

local ThemedLevelBar = Roact.Component:extend("ThemedLevelBar")

function ThemedLevelBar:render()
	return Roact.createElement(Theme.Consumer, {
		render = function(theme)
			self.props.color = self.props.color or theme.bgColor
			return Roact.createElement(LevelBar, self.props)
		end;
	})
end

return ThemedLevelBar
