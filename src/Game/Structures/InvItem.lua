local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)
local Roact = require(ReplicatedStorage.Roact)
local Flipper = require(ReplicatedStorage.Flipper)

local Structures = ReplicatedStorage.UI.Structures
local Elements = Structures.Elements

local Frame = require(Elements.Frame)
local TextLabel = require(Elements.TextLabel)
local ImageButton = require(Elements.ImageButton)

local CurrencyUtil = Knit.GetController("CurrencyUtil")

local InvItem = Roact.PureComponent:extend("InvItem")

function InvItem:init(props)
	self.motor = Flipper.SingleMotor.new(1)

	local binding, setBinding = Roact.createBinding(self.motor:getValue())
	self.binding = binding
	self.motor:onStep(setBinding)

	self:setState({
		itemId = (props.item and props.item.id);
	})
end

function InvItem:didUpdate()
	local id = self.props.item and self.props.item.id
	if id ~= self.state.itemId then
		self:setState({
			itemId = id;
		})

		-- TODO Add animation
	end
end

function InvItem:render()
	local children = self.props[Roact.Children] or { }
	self.props[Roact.Children] = children

	self.props.size = self.props.size or UDim2.fromScale(1, 1)
	self.props.cornerRadius = self.props.cornerRadius or UDim.new(0.2, 0)
	self.props.color = self.props.color or Color3.new(0.93, 0.93, 0.93)
	self.props.index = self.props.index or 5

	self.props.trans = 0

	local item = self.props.item
	local hasItem = (item and item.icon)

	if hasItem then
		local text
		if item.type == "Pickaxe" then
			text = CurrencyUtil:ToSuffixedDecimal(item.value)
		end

		local strokeThickness = 3

		children.Icon = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.5);
			Size = UDim2.fromScale(0.9, 0.9);
			Image = item.icon;
			ImageColor3 = item.iconColor;
			BackgroundTransparency = 1;
			ZIndex = self.props.index + 1;
		})

		if text then
			children.Text = Roact.createElement(TextLabel, {
				anchor = Vector2.new(1, 1);
				pos = UDim2.fromScale(0.9, 1);
				size = UDim2.fromScale(0.9, 0.38);
				index = self.props.index + 2;
				text = text;
				alignmentX = Enum.TextXAlignment.Right;
			}, {
				Stroke = Roact.createElement("UIStroke", {
					Thickness = strokeThickness;
					Color = Color3.new();
				});
			})
		end

		if item.equipped then
			children.EquippedIcon = Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.8, 0.1);
				Position = UDim2.fromScale(1, 0);
				Size = UDim2.fromScale(0.5, 0.5);
				SizeConstraint = Enum.SizeConstraint.RelativeYY;
				ScaleType = Enum.ScaleType.Fit;
				--Image = item.icon;
				BackgroundTransparency = 1;
				ZIndex = self.props.index + 3;
			})
		end

		children.Background = Roact.createElement(ImageButton, {
			anchor = Vector2.new(0.5, 0.5);
			pos = UDim2.fromScale(0.5, 0.5);
			size = UDim2.fromScale(0.8, 0.8);
			cornerRadius = self.props.cornerRadius;
			color = item.equipped and Color3.fromRGB(65, 213, 108)
				or Color3.fromRGB(255, 144, 0);
			trans = self.props.trans;
			index = self.props.index;

			click = item.click;
		})
	else
		children.Background = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.5);
			Size = UDim2.fromScale(0.6, 0.6);
			BackgroundTransparency = 1;
			ZIndex = self.props.index;

			ImageColor3 = Color3.new(0.9, 0.9, 0.9);
			Image = "rbxassetid://7514441546";
		})
	end

	return Roact.createElement(
		Frame,
		{ size = self.props.size; order = self.props.order; },
		children
	)
end

return InvItem
