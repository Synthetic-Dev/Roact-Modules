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

	return Roact.createElement("TextButton", {
		Active = props.active;
		AnchorPoint = props.anchor;

		AutoButtonColor = props.autoColor;

		BackgroundColor3 = props.bgColor or Color3.new(1, 1, 1);
		BackgroundTransparency = props.trans or 1;
		BorderSizePixel = 0;

		Font = props.font or Enum.Font.FredokaOne;

		Position = props.pos;
		Size = props.size;

		Text = props.text;
		TextColor3 = props.color or Color3.new(1, 1, 1);
		TextSize = props.textSize;
		TextScaled = props.textSize == nil;
		TextXAlignment = props.alignmentX;
		TextYAlignment = props.alignmentY;

		LayoutOrder = props.order;
		ZIndex = props.index or 2;

		[Roact.Ref] = ref;
		[Roact.Event.Activated] = props.activated or props.click;

		[Roact.Event.InputBegan] = props.inputBegan or props.down;
		[Roact.Event.InputEnded] = props.inputEnded or props.up;
	}, children)
end)
