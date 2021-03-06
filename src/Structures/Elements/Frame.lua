local Roact = require(game.ReplicatedStorage.Roact)

local elements = script.Parent
local Corners = require(elements.Corners)

return Roact.forwardRef(function(props, ref)
	local children = props[Roact.Children] or { }
	if props.rounded or props.cornerRadius then
		children.Corners = Roact.createElement(
			Corners,
			{ radius = props.cornerRadius; }
		)
	end

	if props.shadow then
		if props.index == nil then
			props.index = -1
		end

		if props.pos == nil and props.anchor == nil then
			props.anchor = Vector2.new(0.5, 0)
			props.pos = UDim2.fromScale(0.5, 0.1)
		end

		if props.trans == nil then
			props.trans = 0
		end
	end

	return Roact.createElement("Frame", {
		AnchorPoint = props.anchor;

		BackgroundColor3 = props.color or Color3.new(1, 1, 1);
		BackgroundTransparency = props.trans or 1;
		BorderSizePixel = 0;

		Position = props.pos;
		Size = props.size or UDim2.fromScale(1, 1);
		SizeConstraint = props.constraint or Enum.SizeConstraint.RelativeXY;

		ClipsDescendants = props.clip;

		LayoutOrder = props.order;
		ZIndex = props.index;

		[Roact.Ref] = ref;
	}, children)
end)
