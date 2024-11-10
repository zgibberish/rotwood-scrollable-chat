local UpvalueHacker = require("tools.upvaluehacker")
local ChatHistory = require "components.chathistory"
local lume = require "util.lume"
local Image = require "widgets.image"

-- increase MAX_CHAT_HISTORY
local NEW_MAX_CHAT_HISTORY = GetModConfigData("max_chat_history")
local MAX_LINES_SHOWN = GetModConfigData("max_lines_shown")
local LINE_HEIGHT = 60
UpvalueHacker.SetUpvalue(ChatHistory.Append, NEW_MAX_CHAT_HISTORY, "MAX_CHAT_HISTORY")

-- this is TheDungeon.HUD
AddClassPostConstruct("screens.playerhud", function(self)
    self.chat_history_label.max_lines_shown = MAX_LINES_SHOWN
    self.chat_history_label.chat_scroll_offset = 0 -- assume chat_scroll_offset cannot go below chat_messages_shown
    self.chat_history_label.chat_origin_x, self.chat_history_label.chat_origin_y = self.chat_history_label:GetPos()
    self.last_history_count = 0

    self.chat_history_label
        :SetMasked()
        :SendToBack()
    self.chat_mask = self.root:AddChild(Image("images/white.tex"))
        :SetName("Scrollable Chat Mask")
        :SetRegistration("left","bottom")
		:SetAnchors("left", "bottom")
        :SetHiddenBoundingBox(true)
        :SetSize(GLOBAL.RES_X,  LINE_HEIGHT * MAX_LINES_SHOWN)
        :SetPos(0, self.chat_history_label.chat_origin_y-6)
        :SetClickable(false)
        :SetMask()
        :SendToBack()

    function self.chat_history_label:OnUpdate(dt)
        local _, old_y = self:GetPos()
        local target_y = self.chat_origin_y + LINE_HEIGHT*self.chat_scroll_offset
        self.new_y = lume.smooth(old_y, target_y or old_y, dt*16)
        self:SetPos(self.chat_origin_x, self.new_y)
    end
    self.chat_history_label:StartUpdating()

    local original_RefreshChat = self.RefreshChat
    function self:RefreshChat(...)
        local history_count = #GLOBAL.TheDungeon.components.chathistory:GetHistory()
        -- scroll to bottom when new message received
        if history_count ~= self.last_history_count then
            self.last_history_count = history_count
            self.chat_history_label.chat_scroll_offset = 0
        end
        original_RefreshChat(self, ...)
    end

    function self:ChatScrollOffsetDelta(d)
        local line_count = self.chat_history_label:GetLines()
        local max_lines_shown = self.chat_history_label.max_lines_shown
        local res = self.chat_history_label.chat_scroll_offset + d
        if res <= 0 and res >= -(line_count - max_lines_shown) then
            self.chat_history_label.chat_scroll_offset = res
            self:RefreshChat()
        end

        return self
    end

    local original_OnControl = self.OnControl
    function self:OnControl(controls, down, trace, ...)
        local ret = original_OnControl(self, controls, down, trace, ...)

        -- handle mouse wheel scrolling
        if controls:Has(GLOBAL.Controls.Digital.MENU_SCROLL_FWD) then
            self:ChatScrollOffsetDelta(1)
            return true
        elseif controls:Has(GLOBAL.Controls.Digital.MENU_SCROLL_BACK) then
            self:ChatScrollOffsetDelta(-1)
            return true
        end

        return ret
    end
end)
