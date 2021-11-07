local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local Flipper = require(ReplicatedStorage.Flipper)

local Structures = ReplicatedStorage.UI.Structures

local Frame = require(Structures.Elements.Frame)

local ThemedFrame = require(Structures.ThemedFrame)
local ThemedTextLabel = require(Structures.ThemedTextLabel)
local ThemedImageButton = require(Structures.ThemedImageButton)

local Theme = require(Structures.Theme)

local GameImageButton = Roact.Component:extend("GameImageButton")

function GameImageButton:init()
	self.motor = Flipper.SingleMotor.new(0)

	local binding, setBinding = Roact.createBinding(self.motor:getValue())
	self.binding = binding
	self.motor:onStep(setBinding)
end

function GameImageButton:render()
	return Roact.createElement(Theme.Consumer, {
		render = function(theme)
			local color = self.props.color or theme.buttonColor

			local h, s, v = Color3.toHSV(color)
			local shadow = Color3.fromHSV(h, s, v * 0.8)

			return Roact.createElement(Frame, {
				pos = self.props.pos;
				size = self.props.size;
				constraint = self.props.constraint;
				order = self.props.order;
			}, {
				Shadow = Roact.createElement(ThemedFrame, {
					anchor = Vector2.new(0.5, 0);
					pos = UDim2.fromScale(0.5, 0.1)
						+ (self.props.shadowOffset or UDim2.new());
					color = shadow;
					index = self.props.index;
					shadow = true;
				});
				Button = Roact.createElement(ThemedImageButton, {
					color = self.binding:map(function(value)
						return color:lerp(shadow, value)
					end);
					anchor = Vector2.new(0.5, 0);
					pos = self.binding:map(function(value)
						return UDim2.fromScale(0.5, 0):Lerp(
							UDim2.fromScale(0.5, 0.1)
								+ (self.props.shadowOffset or UDim2.new()),
							value
						)
					end);

					index = self.props.index and (self.props.index + 1);
					rounded = true;

					autoColor = false;

					click = self.props.click;

					down = function(_rbx, input)
						if
							input.KeyCode == Enum.KeyCode.ButtonA
							or table.find({
								Enum.UserInputType.MouseButton1;
								Enum.UserInputType.Touch;
							}, input.UserInputType)
						then
							self.motor:setGoal(Flipper.Spring.new(1, {
								frequency = 10;
								dampingRatio = 0.95;
							}))
						end
					end;
					up = function(_rbx, input)
						if
							input.KeyCode == Enum.KeyCode.ButtonA
							or table.find({
								Enum.UserInputType.MouseButton1;
								Enum.UserInputType.Touch;
							}, input.UserInputType)
						then
							task.wait(0.1)
							self.motor:setGoal(Flipper.Spring.new(0, {
								frequency = 10;
								dampingRatio = 0.7;
							}))
						end
					end;
				}, {
					Text = Roact.createElement(ThemedTextLabel, {
						anchor = Vector2.new(0.5, 0.5);
						pos = UDim2.fromScale(0.5, 0.5);
						size = UDim2.fromScale(0.9, 0.6);
						BackgroundTransparency = 1;
						textSize = self.props.textSize;
						color = self.props.textColor or Color3.new(1, 1, 1);
						text = self.props.text;
						index = self.props.index and (self.props.index + 2);
					});
				});
			})
		end;
	})
end

return GameImageButton
