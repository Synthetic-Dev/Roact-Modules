local Roact = require(game.ReplicatedStorage.Roact)

return function(props)
	return Roact.createElement("UICorner", {
		CornerRadius = props.radius or UDim.new(0.2, 0);
	})
end
