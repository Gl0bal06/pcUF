local pcUF = LibStub("AceAddon-3.0"):GetAddon("pcUF")
local L = LibStub("AceLocale-3.0"):GetLocale("pcUF", true)
local CastBar = pcUF:NewModule("CastBar", "AceEvent-3.0")

local bars = {}
local frames = {}

function CastBar:OnInitialize()
	pcUF:Print("CastBar Module - OnInitialize")

	self:SetEnabledState(false)

	self.CASTING_BAR_ALPHA_STEP = 0.01
	self.CASTING_BAR_FLASH_STEP = 0.2
	self.CASTING_BAR_HOLD_TIME = 1
end

function CastBar:OnEnable()
	pcUF:Print("CastBar Module - OnEnable")

	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "EventStopCast")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	self:RegisterEvent("UNIT_SPELLCAST_DELAYED")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED", "EventFailedCast")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "EventFailedCast")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE", "EventInterruptibleState")
	self:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", "EventInterruptibleState")
	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_SPELLCAST_STOP", "EventStopCast")

	self:RegisterEvent("PLAYER_TARGET_CHANGED", "EventUnitChanged")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED", "EventUnitChanged")

	self.db = pcUF.db:RegisterNamespace("pcUFDB", self.defaults)

	self:CreateRemoveFrames()											-- Create any frames that are enabled

	--self:SetEnabledState(true)
end

function CastBar:OnDisable()
	pcUF:Print("CastBar Module - OnDisable")

	self:UnregisterAllEvents()
end

function CastBar:UNIT_SPELLCAST_CHANNEL_START(event, unit)
	--pcUF:Print("CastBar Module - "..event.." - "..unit)

	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do

			local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible = UnitChannelInfo(unit)
			if (not name or (not pcUF.db.profile.module.castbar[L["TradeSkills"]] and isTradeSkill)) then
				-- if there is no name, there is no bar
				frame.arcanebar:Hide()
				return
			end

			if (pcUF.db.profile.module.castbar[L["Replace Unit Names"]]) then
				--if (name == nil) then
					--frame.arcanebar.nametext:SetText(L["Channeling"])
				--else
					frame.arcanebar.nametext:SetText(name)
				--end
				frame.arcanebar.nametext:SetTextColor(frame.nametext:GetTextColor())
				frame.arcanebar.nametext:Show()
				frame.nametext:Hide()
			end

			frame.arcanebar.startTime = GetTime() - (startTime / 1000)
			frame.arcanebar.endTime = (endTime / 1000) - GetTime()

			--if (notInterruptible) then
			--	frame.arcanebar:SetStatusBarColor(pcUF.db.profile.module.castbar[L["Uninterruptible Cast Color"]].r, pcUF.db.profile.module.castbar[L["Uninterruptible Cast Color"]].g, pcUF.db.profile.module.castbar[L["Uninterruptible Cast Color"]].b)
			--else
				frame.arcanebar:SetStatusBarColor(pcUF.db.profile.module.castbar[L["Channelling Color"]].r, pcUF.db.profile.module.castbar[L["Channelling Color"]].g, pcUF.db.profile.module.castbar[L["Channelling Color"]].b)
			--end
			frame.arcanebar.value = (endTime / 1000) - GetTime()
			frame.arcanebar.maxValue = (endTime - startTime) / 1000
			frame.arcanebar:SetMinMaxValues(0, frame.arcanebar.maxValue)
			frame.arcanebar:SetValue(frame.arcanebar.value)
			--if (frame.arcanebar.spark) then
				--frame.arcanebar.spark:Hide()
			--end
			frame.arcanebar:SetAlpha(1.0)
			frame.arcanebar.holdTime = 0
			frame.arcanebar.casting = nil
			frame.arcanebar.channeling = true
			frame.arcanebar.fadeOut = nil
			frame.arcanebar.delaySum = 0

			-- if (self.showCastbar) then
				frame.arcanebar.spark:Show()
				frame.arcanebar:Show()
			-- end

			-- if (frame.arcanebar.showtimer == 1) then
			-- 	frame.arcanebar.castTimeText:Show()
			-- else
			-- 	frame.arcanebar.castTimeText:Hide()
			-- end

	end
end

function CastBar:UNIT_SPELLCAST_CHANNEL_UPDATE(event, unit)
	--pcUF:Print("CastBar Module - "..event.." - "..unit)

	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do

		if (frame.arcanebar:IsShown()) then

			local name, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(unit)
			if (not name or (not pcUF.db.profile.module.castbar[L["TradeSkills"]] and isTradeSkill)) then
				-- if there is no name, there is no bar
				frame.arcanebar:Hide()
				return
			end
			--frame.arcanebar.delaySum = frame.arcanebar.delaySum + ( (GetTime() - (startTime / 1000)) - frame.arcanebar.value )
			frame.arcanebar.delaySum = frame.arcanebar.delaySum + ( (GetTime() - (startTime / 1000)) - frame.arcanebar.startTime )

			frame.arcanebar.value = ((endTime / 1000) - GetTime())
			frame.arcanebar.maxValue = (endTime - startTime) / 1000
			frame.arcanebar.endTime = endTime / 1000
			--frame.arcanebar.delaySum = frame.arcanebar.delaySum + (endTime - frame.arcanebar.maxValue * 1000)
			frame.arcanebar:SetMinMaxValues(0, frame.arcanebar.maxValue)
			frame.arcanebar:SetValue(frame.arcanebar.value)

		end

	end
end

function CastBar:UNIT_SPELLCAST_DELAYED(event, unit)
	--pcUF:Print("CastBar Module - "..event.." - "..unit)

	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do

		if(frame.arcanebar:IsShown()) then

			local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit)
			if (not name or (not pcUF.db.profile.module.castbar[L["TradeSkills"]] and isTradeSkill)) then
				-- if there is no name, there is no bar
				frame.arcanebar:Hide()
				return
			end

			frame.arcanebar.delaySum = frame.arcanebar.delaySum + ( (GetTime() - (startTime / 1000)) - frame.arcanebar.value )

			frame.arcanebar.value = (GetTime() - (startTime / 1000))
			frame.arcanebar.maxValue = (endTime - startTime) / 1000
			frame.arcanebar:SetMinMaxValues(0, frame.arcanebar.maxValue)

			if (not frame.arcanebar.casting) then
				--if (frame.arcanebar.spark) then
					--frame.arcanebar.spark:Show()
				--end
				--if (frame.arcanebar.Flash) then
					frame.arcanebar.Flash:SetAlpha(0)
					frame.arcanebar.Flash:Hide()
				--end
				frame.arcanebar.casting = true
				frame.arcanebar.channeling = nil
				frame.arcanebar.flash = nil
				frame.arcanebar.fadeOut = nil
			end
		end

	end
end

function CastBar:UNIT_SPELLCAST_START(event, unit)
	--pcUF:Print("CastBar Module - "..event.." - "..unit)

	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		-- --frame.healthbar:SetMinMaxValues(0, UnitHealthMax(unit))
		-- --frame.arcanebar:UNIT_HEALTH(nil, unit)

		local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit)
		if (not name or (not pcUF.db.profile.module.castbar[L["TradeSkills"]] and isTradeSkill)) then
			frame.arcanebar:Hide()
			return
		end

		if (pcUF.db.profile.module.castbar[L["Replace Unit Names"]]) then
			frame.arcanebar.nametext:SetText(name)
			frame.arcanebar.nametext:SetTextColor(frame.nametext:GetTextColor())
			frame.arcanebar.nametext:Show()
			frame.nametext:Hide()
		end

		--if (notInterruptible) then
		--	frame.arcanebar:SetStatusBarColor(pcUF.db.profile.module.castbar[L["Uninterruptible Cast Color"]].r, pcUF.db.profile.module.castbar[L["Uninterruptible Cast Color"]].g, pcUF.db.profile.module.castbar[L["Uninterruptible Cast Color"]].b)
		--else
			frame.arcanebar:SetStatusBarColor(pcUF.db.profile.module.castbar[L["Casting Color"]].r, pcUF.db.profile.module.castbar[L["Casting Color"]].g, pcUF.db.profile.module.castbar[L["Casting Color"]].b)
		--end

		frame.arcanebar.value = (GetTime() - (startTime / 1000))
		frame.arcanebar.maxValue = (endTime - startTime) / 1000
		frame.arcanebar:SetMinMaxValues(0, frame.arcanebar.maxValue)
		frame.arcanebar:SetValue(frame.arcanebar.value)

		frame.arcanebar:SetAlpha(1.0)
		frame.arcanebar.holdTime = 0
		frame.arcanebar.casting = true
		frame.arcanebar.castID = castID
		frame.arcanebar.channeling = nil
		frame.arcanebar.fadeOut = nil
		frame.arcanebar.delaySum = 0

		-- if (frame.arcanebar.showtimer == 1) then
		-- 	frame.arcanebar.castTimeText:Show()
		-- else
		-- 	frame.arcanebar.castTimeText:Hide()
		-- end

		--if (frame.arcanebar.spark) then
			frame.arcanebar.spark:Show()
		--end

		--if (frame.arcanebar.showCastbar) then
			frame.arcanebar:Show()
		--end
	end
end

function CastBar:EventInterruptibleState(event, unit)
	pcUF:Print("CastBar Module - "..event.." - "..unit)

	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		self:UpdateInterruptibleState(frame)
	end
end

function CastBar:UpdateInterruptibleState(frame, notInterruptible)
	if (event == "UNIT_SPELLCAST_INTERRUPTIBLE") then
		frame.arcanebar:SetStatusBarColor(pcUF.db.profile.module.castbar[L["Uninterruptible Cast Color"]].r, pcUF.db.profile.module.castbar[L["Uninterruptible Cast Color"]].g, pcUF.db.profile.module.castbar[L["Uninterruptible Cast Color"]].b)
	else
		frame.arcanebar:SetStatusBarColor(pcUF.db.profile.module.castbar[L["Casting Color"]].r, pcUF.db.profile.module.castbar[L["Casting Color"]].g, pcUF.db.profile.module.castbar[L["Casting Color"]].b)
	end
end

function CastBar:EventStopCast(event, unit, ...)
	--pcUF:Print("CastBar Module - "..event.." - "..unit)

	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do

		if ( (frame.arcanebar.casting and event == "UNIT_SPELLCAST_STOP" and select(1, ...) == frame.arcanebar.castID) or (frame.arcanebar.channeling and event == "UNIT_SPELLCAST_CHANNEL_STOP") ) then

			--if (frame.arcanebar.spark) then
				frame.arcanebar.spark:Hide()
			--end
			--if (frame.arcanebar.Flash) then
				frame.arcanebar.Flash:SetAlpha(0)
				frame.arcanebar.Flash:Show()
			--end
			frame.arcanebar:SetValue(frame.arcanebar.maxValue)
			if (event == "UNIT_SPELLCAST_STOP") then
				frame.arcanebar.casting = nil
			else
				frame.arcanebar.channeling = nil
			end
			frame.arcanebar.flash = true
			frame.arcanebar.fadeOut = true
			frame.arcanebar.holdTime = 0
			frame.arcanebar.delaySum = 0

			-- if (pcUF.db.profile.module.castbar[L["Replace Unit Names"]]) then
			-- 	--frame.arcanebar.nametext:SetText(name)
			-- 	frame.arcanebar.nametext:Hide()
			-- 	frame.nametext:Show()
			-- end
		end

	end
end

function CastBar:EventFailedCast(event, unit, ...)
	--pcUF:Print("CastBar Module - "..event.." - "..unit)

	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		if ( (frame.arcanebar:IsShown() and frame.arcanebar.casting and select(1, ...) == frame.arcanebar.castID) and not frame.arcanebar.fadeOut ) then
			frame.arcanebar:SetValue(frame.arcanebar.maxValue)
			frame.arcanebar:SetStatusBarColor(pcUF.db.profile.module.castbar[L["Failed Cast Color"]].r, pcUF.db.profile.module.castbar[L["Failed Cast Color"]].g, pcUF.db.profile.module.castbar[L["Failed Cast Color"]].b)
			--if (frame.arcanebar.spark) then
				frame.arcanebar.spark:Hide()
			--end
			frame.arcanebar.casting = nil
			frame.arcanebar.channeling = nil
			frame.arcanebar.fadeOut = true
			frame.arcanebar.holdTime = GetTime() + CastBar.CASTING_BAR_HOLD_TIME
		end

	end
end

function CastBar:EventUnitChanged(event)
	local unit

	if (event == "PLAYER_TARGET_CHANGED") then
		unit = "target"
	elseif (event == "PLAYER_FOCUS_CHANGED") then
		unit = "focus"
	end

	for frame in pairs(frames[unit]) do
		frame.arcanebar.casting = nil
		frame.arcanebar.channeling = nil
		--frame.arcanebar:SetAlpha(0)
		--frame.arcanebar:SetMinMaxValues(0, 100)
		--frame.arcanebar:SetValue(0)
		frame.arcanebar:Hide()

		if (pcUF.db.profile.module.castbar[L["Replace Unit Names"]]) then
			frame.arcanebar.nametext:Hide()
			frame.nametext:Show()
		end
	end

	if (UnitCastingInfo(unit)) then
		self:UNIT_SPELLCAST_START("UNIT_SPELLCAST_START", unit)
	elseif (UnitChannelInfo(unit)) then
		self:UNIT_SPELLCAST_CHANNEL_START("UNIT_SPELLCAST_CHANNEL_START", unit)
	else
		-- for frame in pairs(frames[unit]) do
		-- 	frame.arcanebar.casting = nil
		-- 	frame.arcanebar.channeling = nil
		-- 	--frame.arcanebar.Flash:SetAlpha(0)
		-- 	--frame.arcanebar.Flash:Hide()
		-- 	frame.arcanebar:Hide()
		--
		-- 	if (pcUF.db.profile.module.castbar[L["Replace Unit Names"]]) then
		-- 		frame.arcanebar.nametext:Hide()
		-- 		frame.nametext:Show()
		-- 	end
		--
		return
		-- end
	end
end

function CastBar:Reload()
	pcUF:Print("CastBar Module - Reload")
end

function CastBar:OnUpdate(elapsed)
	local getTime = GetTime()

	if (pcUF.db.profile.module.castbar[L["Display Cast Timer"]]) then

		local current_time

 		if (self.channeling) then
			current_time = self.value
		elseif (self.casting) then
			current_time = self.maxValue - self.value
		else
			current_time = 0
		end
		if (current_time < 0) then
			current_time = 0
		end

		local text = math.max(current_time, 0) + 0.001
		if (text >= 100) then
			text = string.sub(text, 1, 3)
		else
			text = string.sub(text, 1, 4)
		end

		--pcUF:Print("delaySum = "..self.delaySum)
		if (self.delaySum ~= 0) then
			--local delay = string.sub(math.max(self.delaySum / 1000, 0) + 0.001, 1, 4)
			--local delay = self.delaySum - self.delaySum - self.delaySum
			--local delay = string.sub(math.max(self.delaySum - self.delaySum - self.delaySum) + 0.001, 1, 4)
			local delay = string.sub(math.abs(self.delaySum) + 0.001, 1, 4)
			--pcUF:Print("delaySum = "..self.delaySum)
			if (self.channeling) then
				self.sign = "-"
			else
				self.sign = "+"
			end
			text = "|cffcc0000"..self.sign..delay.."|r "..text
		end
		self.casttimertext:SetText(text)
	end


	if (self.casting) then

		self.value = self.value + elapsed
		if (self.value >= self.maxValue) then
			self:SetValue(self.maxValue)
			--if (self.spark) then
				self.spark:Hide()
			--end
			--if (self.Flash) then
				self.Flash:SetAlpha(0)
				self.Flash:Show()
			--end
			self.flash = true
			self.fadeOut = true
			self.casting = nil
			self.channeling = nil
			self.delaySum = 0
			return
		end
		self:SetValue(self.value)
		--if (self.Flash) then
			self.Flash:Hide()
		--end
		--if (self.spark) then
			self.spark:SetPoint("CENTER", self, "LEFT", (self.value / self.maxValue) * self:GetWidth(), 0)
		--end

	elseif (self.channeling) then

		self.value = self.value - elapsed
		if (self.value <= 0) then
			--if (self.spark) then
				self.spark:Hide()
			--end
			--if (self.Flash) then
				self.Flash:SetAlpha(0)
				self.Flash:Show()
			--end
			self.flash = true
			self.fadeOut = true
			self.casting = nil
			self.channeling = nil
			self.delaySum = 0
			return
		end
		self:SetValue(self.value)
		self.spark:SetPoint("CENTER", self, "LEFT", (self.value / self.maxValue) * self:GetWidth(), 0)
		--if (self.Flash) then
			self.Flash:Hide()
		--end

	elseif (getTime < self.holdTime) then
		return

	elseif (self.flash) then
		local alpha = 0
		--if (self.Flash) then
			alpha = self.Flash:GetAlpha() + CastBar.CASTING_BAR_FLASH_STEP
		--end
		if (alpha < 1) then
			--if (self.Flash) then
				self.Flash:SetAlpha(alpha)
			--end
		else
			--if (self.Flash) then
				self.Flash:SetAlpha(1.0)
			--end
			self.flash = nil
		end

	elseif (self.fadeOut) then
		local alpha = self:GetAlpha() - CastBar.CASTING_BAR_ALPHA_STEP
		if (alpha > 0) then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
			if (pcUF.db.profile.module.castbar[L["Replace Unit Names"]]) then
				self.nametext:Hide()
				self:GetParent().nametext:Show()
			end
		end
	end
end

function CastBar:CreateRemoveFrames()
	pcUF:Print("CastBar Module - CreateRemoveFrames")
	-- local frames = pcUF:GetActiveUnitFrameNames()
	-- for i in pairs(frames) do
	-- 	--pcUF:Print(frames[i].."_NameFrameOverlay")
	-- 	pcUF:Print(frames[i])
	-- end

	--local frames = pcUF:GetActiveUnitFrames()
	frames = pcUF:GetActiveUnitFrames()
	for i,v in pairs(frames) do
		for frame in pairs(v) do
			if (frame.arcanebar == nil) then
				--pcUF:Print(tostring(frame.unit))
				--pcUF:Print(tostring(frame.nameframeoverlay:GetName()))
				--pcUF:Print(tostring(frame:GetName()))

				--local frame = CreateFrame("Frame", framename, UIParent, nil)
				--frame:SetFrameStrata("LOW")
				--frame:SetMovable(1)
				--frame:SetHeight(1)
				--frame:SetWidth(1)

				--local unit = frame.unit


				frame.arcanebar = CreateFrame("StatusBar", nil, frame, nil)
				frame.arcanebar:Hide()
				frame.arcanebar:SetPoint("TOPLEFT", frame.nameframe, "TOPLEFT", 4, -4)
				frame.arcanebar:SetHeight(frame.nameframe:GetHeight()-8)
				frame.arcanebar:SetWidth(frame.nameframe:GetWidth()-8)
				--frame.arcanebar:SetHeight(24)
				--frame.arcanebar:SetWidth(200)
				frame.arcanebar:SetScript("OnUpdate", CastBar.OnUpdate)

				frame.arcanebar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
				frame.arcanebar:GetStatusBarTexture():SetHorizTile(false)
				frame.arcanebar:GetStatusBarTexture():SetVertTile(false)
				--frame.arcanebar:SetStatusBarColor(0, 0.65, 0)

				--pcUF:Print(frame.nameframe:GetHeight())

				frame.arcanebar:SetMinMaxValues(0, 100)
				frame.arcanebar:SetValue(0)
				--frame.arcanebar:Show()

				--pcUF:Print(frame.arcanebar:GetValue())

				--frame.healthbar:SetStatusBarColor(self.db.profile.global[L["Health Bar Color"]].r, self.db.profile.global[L["Health Bar Color"]].g, self.db.profile.global[L["Health Bar Color"]].b, self.db.profile.global[L["Health Bar Color"]].a)
				--frame.bars += frame.arcanebar
				--pcUF:SetupStatusBarTextures(frame)

				frame.arcanebar.Flash = frame.arcanebar:CreateTexture(nil, "OVERLAY", nil)
				frame.arcanebar.Flash:SetTexture("Interface\\AddOns\\pcUF\\Images\\pcUF_CastBarFlash", 0, 0)
				frame.arcanebar.Flash:SetBlendMode("ADD")
				frame.arcanebar.Flash:SetWidth(frame.nameframe:GetWidth()+8)
				frame.arcanebar.Flash:SetHeight(frame.nameframe:GetHeight()*2)
				frame.arcanebar.Flash:SetPoint("CENTER", frame.nameframe, "CENTER", 1, 0)

				frame.arcanebar.spark = frame.arcanebar:CreateTexture(nil, "OVERLAY", nil)
				frame.arcanebar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark", 0, 0)
				frame.arcanebar.spark:SetBlendMode("ADD")
				frame.arcanebar.spark:SetPoint("CENTER")
				frame.arcanebar.spark:Show()

				frame.arcanebar.nametext = frame.arcanebar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				frame.arcanebar.nametext:SetWidth(frame.arcanebar.nametext:GetParent():GetWidth() - 10)
				frame.arcanebar.nametext:SetHeight(frame.arcanebar.nametext:GetParent():GetHeight())
				frame.arcanebar.nametext:SetNonSpaceWrap(false)
				frame.arcanebar.nametext:SetPoint("CENTER", frame.nameframe, "CENTER", 0, 0)			-- remove this once we have a full option set for customizing this

				frame.arcanebar.casttimertext = frame.arcanebar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				frame.arcanebar.casttimertext:SetPoint("LEFT", frame.nameframe, "RIGHT", 0, 0)			-- remove this once we have a full option set for customizing this
				frame.arcanebar.casttimertext:Show()													-- remove this once we have a full option set for customizing this

			end
		end
	end
end
