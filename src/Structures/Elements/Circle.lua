local Roact = require(game.ReplicatedStorage.Roact)

local elements = script.Parent
local Frame = require(elements.Frame)

return Roact.forwardRef(function(props, ref)
	local children = props[Roact.Children] or { }

	props.radius = props.radius or 50
	props.hollowRadius = props.hollowRadius or 0

	local thickness = props.radius - props.hollowRadius

	children.Stroke = Roact.createElement("UIStroke", {
		Color = props.color or Color3.new(1, 1, 1);
		LineJoinMode = Enum.LineJoinMode.Round;
		Thickness = math.max(0, thickness);
		Transparency = props.trans or 0;
	})

	return Roact.createElement(Frame, {
		cornerRadius = UDim.new(1, 0);

		anchor = props.anchor;

		trans = 1;

		pos = props.pos + UDim2.fromOffset(
			thickness * -(props.anchor.X - 0.5) * 2,
			thickness * -(props.anchor.Y - 0.5) * 2
		);
		size = UDim2.fromOffset(props.hollowRadius, props.hollowRadius);

		order = props.order;
		index = props.index;

		[Roact.Ref] = ref;
	}, children)
end)
