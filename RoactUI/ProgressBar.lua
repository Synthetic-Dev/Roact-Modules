local TweenService = game:GetService("TweenService")

local Roact = require(game.ReplicatedStorage.Roact)

local elements = script.Parent.Elements
local Frame = require(elements.Frame)

local ProgressBar = Roact.Component:extend("ProgressBar")

function ProgressBar:init(props)
    self.tweenInfo = props.tweenInfo or
                         TweenInfo.new(0.4, Enum.EasingStyle.Quart,
                             Enum.EasingDirection.InOut)
    self.bar = Roact.createRef()
end

function ProgressBar:shouldUpdate(nextProps)
    return nextProps.percent ~= self.props.percent
end

function ProgressBar:willUpdate(nextProps)
    if nextProps.percent == self.props.percent then
        return
    end

    local bar = self.bar:getValue()
    local levelUp = nextProps.percent < self.props.percent

    local tween = TweenService:Create(bar, self.tweenInfo, {
        Size = UDim2.fromScale(
            math.clamp(levelUp and 1 or nextProps.percent, 0, 1), 1);
    })

    tween:Play()
    if levelUp then
        tween.Completed:Connect(function()
            TweenService:Create(bar, self.tweenInfo, {
                Size = UDim2.fromScale(math.clamp(nextProps.percent, 0, 1), 1);
            }):Play()
        end)
    end
end

function ProgressBar:render()
    local children = self.props[Roact.Children] or {}

    local index = self.props.index or 3

    children.BarFrame = Roact.createElement(Frame, {
        anchor = Vector2.new(0, 0.5);
        pos = UDim2.fromScale(0, 0.5);
        size = UDim2.fromScale(1, 0.5);
    }, {
        Bar = Roact.createElement(Frame, {
            color = self.props.color or Color3.fromRGB(255, 63, 107);
            anchor = Vector2.new(0, 0.5);
            pos = UDim2.fromScale(0, 0.5);
            size = UDim2.fromScale(0, 1);
            trans = 0;
            index = index + 1;
            cornerRadius = UDim.new(1, 0);
            [Roact.Ref] = self.bar;
        });
        Background = Roact.createElement(Frame, {
            color = Color3.new(0.3, 0.3, 0.3);
            anchor = Vector2.new(0, 0.5);
            pos = UDim2.fromScale(0, 0.5);
            trans = 0;
            index = index;
            cornerRadius = UDim.new(1, 0);
        });
    })

    return Roact.createElement(Frame, { size = UDim2.fromScale(1, 0.31) },
               children)
end

function ProgressBar:didMount()
    local bar = self.bar:getValue()
    bar.Size = UDim2.fromScale(self.props.percent, 1)
end

return ProgressBar
