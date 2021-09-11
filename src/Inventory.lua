local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)
local Roact = require(ReplicatedStorage.Roact)

local Janitor = require(Knit.Util.Janitor)
local TableUtil = require(Knit.Util.TableUtil)

local element = script.Parent.Elements
local Frame = require(element.Frame)

local Item = require(script.Parent.Item)

local Inventory = Roact.Component:extend("Inventory")

function Inventory:init()
	self.Layout = Roact.createRef()
	self.Janitor = Janitor.new()
end

function Inventory:render()
	local items = self.props.items
	local itemsPerRow = self.props.itemsPerRow or 4
	local sidebar = self.props.sidebar or { }

	local itemElements = { }
	for i, item in ipairs(items) do
		local itemProps = TableUtil.Copy(self.props.itemProps or { })
		itemProps = TableUtil.Assign(itemProps, { order = i; item = item; })

		itemElements[item.id] = Roact.createElement(
			self.props.itemElement or Item,
			itemProps,
			{
				--[[Aspect = Roact.createElement("UIAspectRatioConstraint", {
                    AspectType = Enum.AspectType.ScaleWithParentSize;
                    DominantAxis = Enum.DominantAxis.Width;
                });]]
			}
		)
	end

	return Roact.createElement(Frame, {
		clip = true;
		size = self.props.size;
		pos = self.props.pos;
		anchor = self.props.anchor;
	}, {
		Frame = Roact.createElement("ScrollingFrame", {
			BottomImage = sidebar.bottom or "rbxassetid://7276231065";
			MidImage = sidebar.middle or "rbxassetid://7276206983";
			TopImage = sidebar.top or "rbxassetid://7276206454";
			ScrollBarImageColor3 = sidebar.color or Color3.new(0.5, 0.5, 0.5);
			ScrollBarImageTransparency = sidebar.trans;
			ScrollBarThickness = sidebar.thickness or 20;

			VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
			ScrollingDirection = Enum.ScrollingDirection.Y;
			ClipsDescendants = false;

			CanvasSize = UDim2.fromScale(0, 0);

			Size = UDim2.fromScale(1, 1);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			ZIndex = self.props.index or 10;
		}, {
			Layout = self.props.grid and Roact.createElement("UIGridLayout", {
				CellPadding = UDim2.new(
					self.props.paddingX or UDim.new(0.1 / (itemsPerRow - 1), 0),
					self.props.paddingY or UDim.new(0, 0)
				);
				CellSize = UDim2.fromScale(0.9 / itemsPerRow, 0.9 / itemsPerRow);
				HorizontalAlignment = Enum.HorizontalAlignment.Left;
				SortOrder = Enum.SortOrder.LayoutOrder;

				[Roact.Ref] = self.Layout;
			}) or Roact.createElement("UIListLayout", {
				Padding = self.props.paddingY or UDim.new(0, 20);
				HorizontalAlignment = Enum.HorizontalAlignment.Left;
				VerticalAlignment = Enum.VerticalAlignment.Top;
				SortOrder = Enum.SortOrder.LayoutOrder;

				[Roact.Ref] = self.Layout;
			});
			VerticalItems = Roact.createFragment(itemElements);
		});
	})
end

function Inventory:didMount()
	-- TODO Remove this entirely and place AspectRatio inside of GridLayout and hook a binding to Roact.Change.AbsoluteContentSize to update canvas size
	task.defer(function()
		local itemsPerRow = self.props.itemsPerRow or 4
		local layout = self.Layout:getValue()

		local paddingX = self.props.paddingX
			or UDim.new(0.1 / (itemsPerRow - 1), 0)
		local paddingY = self.props.paddingY
			or UDim.new(paddingX.Scale, paddingX.Offset)

		local remainingScale = 1
			- paddingX.Scale * (itemsPerRow - 1)
			- (paddingX.Offset * (itemsPerRow - 1))
				/ layout.Parent.AbsoluteWindowSize.X

		layout.CellPadding = UDim2.new(paddingX, paddingY)
		layout.CellSize = UDim2.fromScale(
			remainingScale / itemsPerRow,
			remainingScale / itemsPerRow
		)

		local CellSize = layout.CellSize
		local x = CellSize.X.Scale * layout.Parent.AbsoluteWindowSize.X
			+ CellSize.X.Offset

		self.Janitor:Add(
			layout.Parent
				:GetPropertyChangedSignal("AbsoluteWindowSize")
				:Connect(function()
					x = CellSize.X.Scale * layout.Parent.AbsoluteWindowSize.X
						+ CellSize.X.Offset
					layout.CellSize = UDim2.new(0, x, 0, x)
				end)
		)

		layout.CellSize = UDim2.new(0, x, 0, x)

		-- * Required because AutomaticCanvasSize is non-functional
		local function Update()
			local size = layout.Parent.Parent.AbsoluteSize
			local scale = layout.AbsoluteContentSize / size

			if
				layout.Parent.ScrollingDirection == Enum.ScrollingDirection.X
			then
				scale *= Vector2.new(1, 0)
			elseif
				layout.Parent.ScrollingDirection == Enum.ScrollingDirection.Y
			then
				scale *= Vector2.new(0, 1)
			end

			layout.Parent.CanvasSize = UDim2.new(scale.X, 0, scale.Y, 0)

			paddingY = self.props.paddingY
				or UDim.new(paddingX.Scale / (scale.Y / 2), paddingX.Offset)
			layout.CellPadding = UDim2.new(paddingX, paddingY)
		end

		self.Janitor:Add(
			layout
				:GetPropertyChangedSignal("AbsoluteContentSize")
				:Connect(Update)
		)
		Update()
	end)
end

function Inventory:willUnmount()
	self.Janitor:Cleanup()
end

return Inventory
