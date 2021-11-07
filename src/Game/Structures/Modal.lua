local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)
local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local PlayerGui = Knit.Player.PlayerGui

return function(component, mapStateToPropsOrThunk, mapDispatchToProps, target)
	local modalName = component.__componentName

	return RoactRodux.connect(function(state, props)
		local partial = mapStateToPropsOrThunk
				and mapStateToPropsOrThunk(state, props)
			or { }

		partial.isOpen = state.UIData.currentModal == modalName
		partial.isOverridden = state.UIData.desiredModal ~= ""

		return partial
	end, function(dispatch)
		local UIController = Knit.GetController("UIController")
		local actions = UIController:GetActions()

		local partial = mapDispatchToProps
				and mapDispatchToProps(actions, dispatch)
			or { }

		partial.close = function()
			dispatch(actions.OnModalClose(modalName))
		end

		return partial
	end)(function(props)
		return Roact.createElement(
			Roact.Portal,
			{ target = target or props.target or PlayerGui; },
			{
				[modalName] = Roact.createElement(component, props);
			}
		)
	end)
end
