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

	return Roact.createElement("ImageButton", {
		Active = props.active;
		AnchorPoint = props.anchor;

		AutoButtonColor = props.autoColor;

		BackgroundColor3 = props.color or Color3.new(1, 1, 1);
		BackgroundTransparency = props.trans;
		BorderSizePixel = 0;

		Position = props.pos;
		Size = props.size or UDim2.fromScale(1, 1);
		SizeConstraint = props.constraint;

		HoverImage = props.hoverImage;
		Image = props.image;
		ImageTransparency = props.imageTrans or 1;
		ImageColor3 = props.imageColor;

		LayoutOrder = props.order;
		ZIndex = props.index;

		[Roact.Ref] = ref;
		[Roact.Event.Activated] = props.activated or props.click;

		[Roact.Event.InputBegan] = props.inputBegan or props.down;
		[Roact.Event.InputEnded] = props.inputEnded or props.up;
	}, children)
end)
