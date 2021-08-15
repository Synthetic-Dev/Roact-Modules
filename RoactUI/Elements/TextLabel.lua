local Roact = require(game.ReplicatedStorage.Roact)

return Roact.forwardRef(function(props, ref)
    return Roact.createElement("TextLabel", {
        BackgroundTransparency = 1;

        Font = props.font or Enum.Font.FredokaOne;

        Position = props.pos;
        Size = props.size or UDim2.fromScale(1, 0.31);

        Text = props.text;
        TextColor3 = props.color;
        TextScaled = true;
        TextXAlignment = props.alignment;

        LayoutOrder = props.order;
        ZIndex = props.index or 2;

        [Roact.Ref] = ref;
    }, props[Roact.Children])
end)
