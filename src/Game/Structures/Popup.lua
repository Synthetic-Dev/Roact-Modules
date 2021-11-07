local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)
local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local PlayerGui = Knit.Player.PlayerGui

return function(component, mapStateToPropsOrThunk, mapDispatchToProps, target)
	return RoactRodux.connect(function(state, props)
		local partial = mapStateToPropsOrThunk
				and mapStateToPropsOrThunk(state, props)
			or { }

		partial.isOpen = function(id)
			return state.UIData.currentPopup == id
		end

		return partial
	end, function(dispatch)
		local UIController = Knit.GetController("UIController")
		local actions = UIController:GetActions()

		local partial = mapDispatchToProps
				and mapDispatchToProps(actions, dispatch)
			or { }

		partial.request = function(id)
			dispatch(actions.RequestPopup(id))
		end

		partial.close = function(id)
			dispatch(actions.OnPopupClose(id))
		end

		return partial
	end)(function(props)
		return Roact.createElement(
			Roact.Portal,
			{ target = target or props.target or PlayerGui; },
			{
				[component.__componentName] = Roact.createElement(
					component,
					props
				);
			}
		)
	end)
end
