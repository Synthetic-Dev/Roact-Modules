local Roact = require(game.ReplicatedStorage.Roact)

local elements = script.Parent
local Corners = require(elements.Corners)

return Roact.forwardRef(function(props, ref)
    local children = props[Roact.Children] or {}
    if props.rounded or props.cornerRadius then
        children.Corners = Roact.createElement(Corners,
                               { radius = props.cornerRadius });
    end

    return Roact.createElement("Frame", {
        AnchorPoint = props.anchor;

        BackgroundColor3 = props.color or Color3.new(1, 1, 1);
        BackgroundTransparency = props.trans or 1;
        BorderSizePixel = 0;

        Position = props.pos;
        Size = props.size or UDim2.fromScale(1, 1);

        LayoutOrder = props.order;
        ZIndex = props.index;

        [Roact.Ref] = ref;
    }, children)
end)
