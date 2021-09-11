local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)
local Roact = require(ReplicatedStorage.Roact)

local TableUtil = require(Knit.Util.TableUtil)

local ModalButton = Roact.Component:extend("ModalButton")
local Modals = setmetatable({ }, { __mode = "v"; })

function ModalButton:close()
	self:setState({ modalOpen = false; })

	--[[for _, modalButton in pairs(self.shared) do
        modalButton:setState(self.state)
    end]]
end

function ModalButton:init(props)
	assert(props.modal, "'modal' must be specified")
	assert(props.target, "'target' for modal must be specified")
	assert(props.element, "ModalButton 'element' must be specified")

	self.shared = { }

	local sharedModal = false
	--[[for _, modalButton in pairs(Modals) do
        if modalButton ~= self and props.modal == modalButton.props.modal then
            sharedModal = true
            table.insert(modalButton.shared, self)
            table.insert(self.shared, modalButton)

            self.modal = modalButton.modal
            self:setState(modalButton.state)
        end
    end]]

	if not sharedModal then
		self.modal = function(_props)
			_props = TableUtil.Assign(_props, self.props.modalProps)
			return Roact.createElement(
				Roact.Portal,
				{ target = props.target; },
				{ Modal = Roact.createElement(props.modal, _props); }
			)
		end
		self:setState({ modalOpen = self.props.open; })
	end

	table.insert(Modals, self)
end

function ModalButton:render()
	local children = self.props[Roact.Children] or { }
	self.props[Roact.Children] = children

	local modal = nil
	if self.state.modalOpen then
		modal = Roact.createElement(self.modal, {
			onClose = function()
				self:close()
			end;
		})

		if self.props.closeOtherModals then
			for _, modalButton in pairs(Modals) do
				if
					modalButton ~= self
					and not table.find(self.shared, modalButton)
				then
					modalButton:close()
				end
			end
		end
	end

	children.modal = modal
	self.props.click = function()
		self:setState({ modalOpen = not self.state.modalOpen; })
		--[[for _, modalButton in pairs(self.shared) do
            modalButton:setState(self.state)
        end]]
	end

	return Roact.createElement(self.props.element, self.props)
end

return ModalButton
