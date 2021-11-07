local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)
local Janitor = require(Knit.Util.Janitor)

local Roact = require(ReplicatedStorage.Roact)
local Flipper = require(ReplicatedStorage.Flipper)

local elements = script.Parent.Elements
local Frame = require(elements.Frame)

local LevelBar = Roact.Component:extend("LevelBar")

function LevelBar:init(props)
	self.motor = Flipper.SingleMotor.new(props.percent)

	local binding, setBinding = Roact.createBinding(self.motor:getValue())
	self.binding = binding
	self.motor:onStep(setBinding)

	self.janitor = Janitor.new()
end

function LevelBar:didUpdate(prevProps)
	local levelUp = self.props.percent < prevProps.percent
	if levelUp then
		local connection
		connection = self.motor:onComplete(function()
			connection:disconnect()
			self.motor:setGoal(Flipper.Spring.new(self.props.percent, {
				frequency = self.props.springFrequency or 5;
				dampingRatio = self.props.springDamping or 1;
			}))
		end)

		self.janitor:Add(connection, "disconnect")
	end

	self.motor:setGoal(Flipper.Spring.new(levelUp and 1 or self.props.percent, {
		frequency = self.props.springFrequency or 3;
		dampingRatio = self.props.springDamping or 1;
	}))
end

function LevelBar:render()
	local children = self.props[Roact.Children] or { }

	local index = self.props.index or 3

	children.BarFrame = Roact.createElement(Frame, {
		anchor = Vector2.new(0, 0.5);
		pos = UDim2.fromScale(0, 0.5);
		size = UDim2.fromScale(1, self.props.widthScale or 0.5);
	}, {
		Bar = Roact.createElement(Frame, {
			color = self.props.color or Color3.new(1, 1, 1);
			anchor = Vector2.new(0, 0.5);
			pos = UDim2.fromScale(0, 0.5);
			size = self.binding:map(function(value)
				return UDim2.fromScale(math.clamp(value, 0, 1) or 0, 1)
			end);
			trans = 0;
			index = index + 1;
			cornerRadius = UDim.new(1, 0);
			[Roact.Ref] = self.bar;
		});
		Background = Roact.createElement(Frame, {
			color = self.props.bgColor or Color3.new(0.3, 0.3, 0.3);
			anchor = Vector2.new(0, 0.5);
			pos = UDim2.fromScale(0, 0.5);
			trans = 0;
			index = index;
			cornerRadius = UDim.new(1, 0);
		});
	})

	return Roact.createElement(Frame, {
		size = self.props.size;
		pos = self.props.pos;
		anchor = self.props.anchor;
	}, children)
end

function LevelBar:willUnmount()
	self.janitor:Destroy()
end

return LevelBar
