local Roact = require(game.ReplicatedStorage.Roact)

return Roact.forwardRef(function(props, ref)
    return Roact.createElement("TextLabel", {
        AnchorPoint = props.anchor;

        BackgroundTransparency = 1;

        Font = props.font or Enum.Font.FredokaOne;

        Position = props.pos;
        Size = props.size or UDim2.fromScale(1, 0.31);

        Text = props.text;
        TextColor3 = props.color or Color3.new(1, 1, 1);
        TextSize = props.textSize;
        TextScaled = props.textSize == nil;
        TextXAlignment = props.alignment;

        LayoutOrder = props.order;
        ZIndex = props.index or 2;

        [Roact.Ref] = ref;
    }, props[Roact.Children])
end)
