local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)
local Signal = require(Knit.Util.Signal)

local Roact = require(ReplicatedStorage.Roact)

local Structures = script.Structures
local Game = script.Game

local UI = { }

UI.InputDeviceEnum = {
	"Unknown";
	"KeyboardMouse";
	"Controller";
	"Touch";
}
UI.InputDeviceChanged = Signal.new()

UI._inputDevice = 1
function UI:GetInputDevice(asString)
	return asString and self.InputDeviceEnum[self._inputDevice]
		or self._inputDevice
end

local keyboardMouseTypes = {
	Enum.UserInputType.Keyboard;
	Enum.UserInputType.MouseButton1;
	Enum.UserInputType.MouseButton2;
	Enum.UserInputType.MouseButton3;
	Enum.UserInputType.MouseMovement;
	Enum.UserInputType.MouseWheel;
}

local controllerTypes = {
	Enum.UserInputType.Gamepad1;
	Enum.UserInputType.Gamepad2;
	Enum.UserInputType.Gamepad3;
	Enum.UserInputType.Gamepad4;
	Enum.UserInputType.Gamepad5;
	Enum.UserInputType.Gamepad6;
	Enum.UserInputType.Gamepad7;
	Enum.UserInputType.Gamepad8;
}

local controllerCodes = {
	Enum.KeyCode.Thumbstick1;
	Enum.KeyCode.Thumbstick2;
	Enum.KeyCode.ButtonA;
	Enum.KeyCode.ButtonB;
	Enum.KeyCode.ButtonL1;
	Enum.KeyCode.ButtonL2;
	Enum.KeyCode.ButtonL3;
	Enum.KeyCode.ButtonR1;
	Enum.KeyCode.ButtonR2;
	Enum.KeyCode.ButtonR3;
	Enum.KeyCode.ButtonSelect;
	Enum.KeyCode.ButtonStart;
	Enum.KeyCode.ButtonX;
	Enum.KeyCode.ButtonY;
}

local touchTypes = {
	Enum.UserInputType.Touch;
	Enum.UserInputType.Accelerometer;
	Enum.UserInputType.Gyro;
}

local ignoreTypes = {
	Enum.UserInputType.Focus;
	Enum.UserInputType.TextInput;
	Enum.UserInputType.None;
	Enum.UserInputType.InputMethod;
}

local function update(input, processed)
	if not processed then
		local inputType = input.UserInputType
		local inputCode = input.KeyCode

		if table.find(ignoreTypes, inputType) then
			return
		end

		local id = 1

		if table.find(keyboardMouseTypes, inputType) then
			id = 2
		elseif
			table.find(controllerTypes, inputType)
			or table.find(controllerCodes, inputCode)
		then
			id = 3
		elseif table.find(touchTypes, inputType) then
			id = 4
		end

		if id ~= UI._inputDevice then
			print("Input device changed to:", UI.InputDeviceEnum[id])
			UI.InputDeviceChanged:Fire(id, UI.InputDeviceEnum[id])
		end

		UI._inputDevice = id
	end
end

UserInputService.InputBegan:Connect(update)
--UserInputService.InputChanged:Connect(update)

function UI:Combine(folder, props)
	local elements = { }
	for _, component in pairs(folder:GetChildren()) do
		elements[component.Name] = Roact.createElement(
			require(component),
			props
		)
	end

	return Roact.createFragment(elements)
end

local function createTree(folder, tree)
	for _, obj in pairs(folder:GetChildren()) do
		if obj:IsA("ModuleScript") then
			local holder = { }

			setmetatable(holder, {
				__index = obj;
				__call = function()
					return require(obj)
				end;
			})

			local subTree = createTree(obj, { })
			function holder:getChildren()
				return subTree
			end

			tree[obj.Name] = holder
		elseif obj:IsA("Folder") then
			local subTree = createTree(obj, { })

			if next(subTree) ~= nil then
				tree[obj.Name] = subTree
			end
		end
	end

	return tree
end

function UI:GetStructures()
	local tree = self._structures
	if not tree then
		tree = createTree(Structures, { })
		self._structures = tree
	end

	return tree
end

function UI:GetGame()
	local tree = self._game
	if not tree then
		tree = createTree(Game, { })
		self._game = tree
	end

	return tree
end

UI.Structures = Structures
UI.Game = Game

UI.Theme = require(Structures.Theme)
UI.SubTheme = require(Structures.Theme.SubTheme)

return UI
