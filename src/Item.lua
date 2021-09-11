local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)

local element = script.Parent.Elements
local Frame = require(element.Frame)

local Item = Roact.PureComponent:extend("Item")

function Item:render()
	local children = self.props[Roact.Children] or { }
	self.props[Roact.Children] = children

	self.props.size = self.props.size or UDim2.fromScale(1, 1)
	self.props.cornerRadius = self.props.cornerRadius or UDim.new(0.2, 0)
	self.props.color = self.props.color or Color3.new(0.93, 0.93, 0.93)
	self.props.index = self.props.index or 5

	self.props.trans = 0

	local item = self.props.item

	children.Icon = (item and item.icon)
		and Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.5);
			Size = UDim2.fromScale(0.7, 0.7);
			Image = item.icon;
			ImageColor3 = item.iconColor;
			BackgroundTransparency = 1;
			ZIndex = self.props.index + 1;
		})

	return Roact.createElement(Frame, self.props)
end

return Item
