local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)

local elements = script.Parent.Elements
local Frame = require(elements.Frame)
local ImageButton = require(elements.ImageButton)

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
			Size = UDim2.fromScale(0.8, 0.8);
			Image = item.icon;
			ImageColor3 = item.iconColor;
			BackgroundTransparency = 1;
			ZIndex = self.props.index + 1;
		})

	children.Background = Roact.createElement(ImageButton, {
		anchor = Vector2.new(0.5, 0.5);
		pos = UDim2.fromScale(0.5, 0.5);
		size = UDim2.fromScale(0.6, 0.6);
		cornerRadius = self.props.cornerRadius;
		color = self.props.color;
		trans = self.props.trans;
		index = self.props.index;

		click = item and item.click;
	})

	return Roact.createElement(
		Frame,
		{ size = self.props.size; order = self.props.order; },
		children
	)
end

return Item
