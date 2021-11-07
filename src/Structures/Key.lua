local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)
local Janitor = require(Knit.Util.Janitor)
local TableUtil = require(Knit.Util.TableUtil)

local Roact = require(ReplicatedStorage.Roact)

local elements = script.Parent.Elements
local Frame = require(elements.Frame)
local TextLabel = require(elements.TextLabel)

local Key = Roact.PureComponent:extend("Key")

local images = {
	[Enum.UserInputType.Touch] = "rbxassetid://7625493742";
	[Enum.UserInputType.MouseButton1] = "rbxassetid://7625494008";
	[Enum.UserInputType.MouseButton2] = "rbxassetid://7625494406";
	[Enum.UserInputType.MouseButton3] = "rbxassetid://7625494225";
	[Enum.KeyCode.ButtonA] = "rbxassetid://7625502583";
	[Enum.KeyCode.ButtonB] = "rbxassetid://7625502327";
	[Enum.KeyCode.ButtonX] = "rbxassetid://7625500057";
	[Enum.KeyCode.ButtonY] = "rbxassetid://7625499774";
	[Enum.KeyCode.ButtonStart] = "rbxassetid://7626956529";
	[Enum.KeyCode.ButtonSelect] = "rbxassetid://7626957065";
	[Enum.KeyCode.DPadUp] = "rbxassetid://7625498976";
	[Enum.KeyCode.DPadDown] = "rbxassetid://7625499590";
	[Enum.KeyCode.DPadLeft] = "rbxassetid://7625499420";
	[Enum.KeyCode.DPadRight] = "rbxassetid://7625499185";
	[Enum.KeyCode.ButtonL1] = "rbxassetid://7625501623";
	[Enum.KeyCode.ButtonL2] = "rbxassetid://7625501219";
	[Enum.KeyCode.ButtonR1] = "rbxassetid://7625500678";
	[Enum.KeyCode.ButtonR2] = "rbxassetid://7625500426";
	[Enum.KeyCode.ButtonL3] = "rbxassetid://7625498721";
	[Enum.KeyCode.ButtonR3] = "rbxassetid://7625498497";
}

local largeKeys = {
	Enum.KeyCode.Space;
	Enum.KeyCode.CapsLock;
	Enum.KeyCode.Backspace;
	Enum.KeyCode.Tab;
}

local buttonFillProps = {
	anchor = Vector2.new(0.5, 0.5);
	pos = UDim2.fromScale(0.51, 0.5);
	size = UDim2.fromScale(0.75, 0.75);

	cornerRadius = UDim.new(1, 0);
}

local menuButtonsFillProps = {
	anchor = Vector2.new(0.5, 0.5);
	pos = UDim2.fromScale(0.51, 0.52);
	size = UDim2.fromScale(0.94, 0.55);

	cornerRadius = UDim.new(0.12, 0);
}

local bumperFillProps = {
	anchor = Vector2.new(0.5, 0.5);
	pos = UDim2.fromScale(0.5, 0.51);
	size = UDim2.fromScale(0.7, 0.4);

	cornerRadius = UDim.new(0.2, 0);
}

local specialFillProps = {
	[Enum.KeyCode.ButtonA] = buttonFillProps;
	[Enum.KeyCode.ButtonB] = buttonFillProps;
	[Enum.KeyCode.ButtonX] = buttonFillProps;
	[Enum.KeyCode.ButtonY] = buttonFillProps;
	[Enum.KeyCode.ButtonStart] = menuButtonsFillProps;
	[Enum.KeyCode.ButtonSelect] = menuButtonsFillProps;
	[Enum.KeyCode.ButtonL1] = bumperFillProps;
	[Enum.KeyCode.ButtonL2] = bumperFillProps;
	[Enum.KeyCode.ButtonR1] = bumperFillProps;
	[Enum.KeyCode.ButtonR2] = bumperFillProps;
	[Enum.KeyCode.ButtonL3] = buttonFillProps;
	[Enum.KeyCode.ButtonR3] = buttonFillProps;
}

function Key:init()
	local UI = require(ReplicatedStorage.UI)

	self:setState({
		device = UI:GetInputDevice(true);
	})

	self.janitor = Janitor.new()
end

function Key:render()
	local children = self.props[Roact.Children] or { }
	self.props[Roact.Children] = nil

	local input = self.props.inputs[self.state.device]
		or Enum.UserInputType.None
	local image = images[input]

	local isKey = not image
	if isKey then
		image = "rbxassetid://7626320648"
	end

	children.Image = Roact.createElement("ImageLabel", {
		Image = image;
		ImageTransparency = self.props.trans;
		ImageColor3 = self.props.color;
		ScaleType = Enum.ScaleType.Fit;
		Size = UDim2.fromScale(1, 1);
		BackgroundTransparency = 1;
		ZIndex = self.props.index;
	})

	if isKey then
		children.Text = Roact.createElement(TextLabel, {
			trans = self.props.trans;
			text = input.Name;
			color = self.props.color;
			size = UDim2.fromScale(0.7, 0.7);
			anchor = Vector2.new(0.5, 0);
			pos = UDim2.fromScale(0.5, 0.1);
		})
	end

	local index = (
			self.props.fill
				and (self.props.index and self.props.index + 1)
			or self.props.index
		) or 1

	if self.props.fill then
		local fillProps = TableUtil.Assign({
			anchor = Vector2.new(0.5, 0.5);
			pos = UDim2.fromScale(0.5, 0.5);
			size = UDim2.fromScale(0.9, 0.9);

			cornerRadius = isKey and UDim.new(0.15, 0) or UDim.new(1, 0);
			index = index - 1;
		}, specialFillProps[input] or { })

		children.Fill = Roact.createElement(self.props.fill, fillProps)
	end

	return Roact.createElement(Frame, {
		anchor = self.props.anchor;
		pos = self.props.pos;
		size = self.props.size;
		constraint = self.props.constraint;
		clip = self.props.clip;
		order = self.props.order;
		index = index;

		[Roact.Ref] = self.props[Roact.Ref];
	}, children)
end

function Key:didMount()
	local UI = require(ReplicatedStorage.UI)
	self.janitor:Add(UI.InputDeviceChanged:Connect(function(_id, device)
		self:setState({
			device = device;
		})
	end))
end

function Key:willUnmount()
	self.janitor:Destroy()
end

return Key
