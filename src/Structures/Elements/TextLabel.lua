local Roact = require(game.ReplicatedStorage.Roact)

return Roact.forwardRef(function(props, ref)
	if props.shadow then
		if props.index == nil then
			props.index = -1
		end

		if props.pos == nil and props.anchor == nil then
			props.anchor = Vector2.new(0.5, 0)
			props.pos = UDim2.fromScale(0.5, 0.1)
		end
	end

	return Roact.createElement("TextLabel", {
		AnchorPoint = props.anchor;

		BackgroundTransparency = 1;

		Font = props.font or Enum.Font.FredokaOne;

		Position = props.pos;
		Size = props.size or UDim2.fromScale(1, 1);

		Text = props.text;
		TextTransparency = props.trans or 0;
		TextColor3 = props.color or Color3.new(1, 1, 1);
		TextSize = props.textSize;
		TextScaled = props.textSize == nil;
		TextWrapped = props.textWrapped;
		TextXAlignment = props.alignmentX;
		TextYAlignment = props.alignmentY;

		LayoutOrder = props.order;
		ZIndex = props.index or 2;

		[Roact.Ref] = ref;
	}, props[Roact.Children])
end)
