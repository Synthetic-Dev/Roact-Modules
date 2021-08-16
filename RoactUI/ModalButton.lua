local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)
local Roact = require(ReplicatedStorage.Roact)

local TableUtil = require(Knit.Util.TableUtil)

local ModalButton = Roact.Component:extend("ModalButton")

function ModalButton:init(props)
    assert(props.modal and typeof(props.modal) == "function",
        "'modal' is not a function")
    assert(props.target, "'target' for modal must be specified")
    assert(props.element, "ModalButton 'element' must be specified")

    self.modal = function(_props)
        _props = TableUtil.Assign(_props, self.props.modalProps)
        return Roact.createElement(Roact.Portal, { target = props.target },
                   { Modal = props.modal(_props) })
    end
    self:setState({ modalOpen = self.props.open })
end

function ModalButton:render()
    local children = self.props[Roact.Children] or {}

    local modal = nil
    if self.state.modalOpen then
        modal = Roact.createElement(self.modal, {
            onClose = function()
                self:setState({ modalOpen = false })
            end;
        })
    end

    children.modal = modal
    self.props.click = function()
        self:setState({ modalOpen = not self.state.modalOpen })
    end

    return Roact.createElement(self.props.element, self.props)
end

return ModalButton
