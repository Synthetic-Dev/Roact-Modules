local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)
local TableUtil = require(Knit.Util.TableUtil)

local Roact = require(ReplicatedStorage.Roact)

local element = script.Parent.Elements
local Frame = require(element.Frame)

local Item = require(script.Parent.Item)

local Container = Roact.Component:extend("Container")

function Container:init()
	self:setState({
		canvasSize = UDim2.fromScale(0, 1);
	})
end

function Container:render()
	local items = TableUtil.CopyShallow(self.props.items)
	local sidebar = self.props.sidebar or { }

	if self.props.sortFunction then
		self.props.sortOrder = Enum.SortOrder.LayoutOrder
		table.sort(items, self.props.sortFunction)
	end

	local itemElements = { }
	for i, item in ipairs(items) do
		local itemProps
		if typeof(self.props.itemProps) == "function" then
			itemProps = TableUtil.Copy(self.props.itemProps(i, item))
		else
			itemProps = TableUtil.Copy(self.props.itemProps or { })
		end
		itemProps = TableUtil.Assign(itemProps, { order = i; item = item; })

		itemElements[item.id] = Roact.createElement(
			self.props.itemElement or Item,
			itemProps
		)
	end

	local padding = self.props.padding
	local cellSize

	if self.props.grid then
		self.props.grid.itemsPerRow = self.props.grid.itemsPerRow or 4

		local paddingDefault = UDim2.new(UDim.new(0, 5), UDim.new(0, 5))

		if padding and typeof(padding) == "UDim2" then
			local xEmpty = padding.X.Scale == -1 or padding.X.Offset == -1
			local yEmpty = padding.Y.Scale == -1 or padding.Y.Offset == -1

			local xPadding = xEmpty and paddingDefault.X or padding.X
			local yPadding = yEmpty and paddingDefault.Y or padding.Y

			padding = UDim2.new(xPadding, yPadding)
		else
			padding = paddingDefault
		end

		local size = (1 - padding.X.Scale) / self.props.grid.itemsPerRow

		cellSize = UDim2.new(size, -padding.X.Offset, size, 0)
	else
		if not padding or typeof(padding) ~= "UDim" then
			padding = UDim.new(0, 20)
		end
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

			-- REVIEW AutomaticCanvasSize still doesn't work when the size is set using Scale change back once fixed
			--AutomaticCanvasSize = Enum.AutomaticSize.Y;
			CanvasSize = self.state.canvasSize;

			Size = UDim2.fromScale(1, 1);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			ZIndex = self.props.index or 10;
		}, {
			Layout = self.props.grid and Roact.createElement("UIGridLayout", {
				CellPadding = padding;
				CellSize = cellSize;
				HorizontalAlignment = Enum.HorizontalAlignment.Left;
				SortOrder = self.props.sortOrder or Enum.SortOrder.LayoutOrder;

				[Roact.Change.AbsoluteContentSize] = function(rbx)
					self:setState({
						canvasSize = UDim2.fromScale(
							0,
							rbx.AbsoluteContentSize.Y
								/ rbx.Parent.AbsoluteWindowSize.Y
						);
					})
				end;
			}, {
				Aspect = Roact.createElement("UIAspectRatioConstraint", {
					AspectType = Enum.AspectType.ScaleWithParentSize;
					DominantAxis = Enum.DominantAxis.Width;
				});
			}) or Roact.createElement("UIListLayout", {
				Padding = padding;
				HorizontalAlignment = Enum.HorizontalAlignment.Left;
				VerticalAlignment = Enum.VerticalAlignment.Top;
				SortOrder = self.props.sortOrder or Enum.SortOrder.LayoutOrder;
			});
			Padding = self.props.grid and Roact.createElement("UIPadding", {
				PaddingRight = -padding.X;
			});
			VerticalItems = Roact.createFragment(itemElements);
			AdditionalChildren = Roact.createFragment(
				self.props[Roact.Children]
			);
		});
	})
end

return Container
