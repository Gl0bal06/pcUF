local pcUF = LibStub("AceAddon-3.0"):GetAddon("pcUF")
local L = LibStub("AceLocale-3.0"):GetLocale("pcUF", true)
local Stagger = pcUF:NewModule("Stagger", "AceEvent-3.0")

local bars = {}
local frames = {}

function Stagger:OnInitialize()
	pcUF:Print("Stagger Module - OnInitialize")

	self:SetEnabledState(false)
end

function Stagger:OnEnable()
	pcUF:Print("Stagger Module - OnEnable")

	self.db = pcUF.db:RegisterNamespace("pcUFDB", self.defaults)

	self:CreateRemoveFrames()											-- Create any frames that are enabled

	-- if not frames["player"] then return end

	-- for frame in pairs(frames["player"]) do
	-- 	pcUF:Print("register")
	-- 	frame.secondarypowerbar:RegisterUnitEvent("UNIT_AURA", "player")
	-- end

	self:RegisterEvent("UNIT_AURA")													-- change this later to only trigger for unit = player
	--self:RegisterUnitEvent("UNIT_AURA", "player")
	--pcUF_player.secondarypowerbar:RegisterUnitEvent("UNIT_AURA", "player")		-- clean this up later

	self:UNIT_AURA(nil, "player")

	--self:SetEnabledState(true)
end

function Stagger:OnDisable()
	pcUF:Print("Stagger Module - OnDisable")

	self:UnregisterAllEvents()
end

function Stagger:UNIT_AURA(event, unit)
	--pcUF:Print(unit)
	if (unit == "player") then

		if (C_SpecializationInfo.GetSpecializationInfo(C_SpecializationInfo.GetSpecialization()) == 268) then
			if not frames[unit] then return end

			for frame in pairs(frames[unit]) do
				local unitsecondarypower = UnitStagger(unit)
				local unitsecondarypowermax = UnitHealthMax(unit)

				local roundedStagger = tonumber(string.format("%.0f", math.ceil(unitsecondarypower/unitsecondarypowermax)))

				frame.secondarypowerbar:SetMinMaxValues(0, 100)
				frame.secondarypowerbar:SetValue(roundedStagger)

				frame.currentmaxsecondarypowertext:SetText(roundedStagger.."/"..100)			-- this needs work and is not accurate
				frame.percentsecondarypowertext:SetText(roundedStagger.."%")
				--frame.deficitsecondarypowertext:SetText("-"..unitpowermax - unitpower)

				if (roundedStagger < 30) then
					frame.secondarypowerbar:SetStatusBarColor(0, 1, 0, 1)
					frame.secondarypowerbarbg:SetStatusBarColor(0, 1, 0, 0.25)
				elseif (roundedStagger > 29 and roundedStagger < 60) then
					frame.secondarypowerbar:SetStatusBarColor(1, 1, 0, 1)
					frame.secondarypowerbarbg:SetStatusBarColor(1, 1, 0, 0.25)
				else
					frame.secondarypowerbar:SetStatusBarColor(1, 0, 0, 1)
					frame.secondarypowerbarbg:SetStatusBarColor(1, 0, 0, 0.25)
				end
			end
		end

	end
end

function Stagger:Reload()
	pcUF:Print("Stagger Module - Reload")
end

-- function Stagger:OnUpdate(elapsed)
-- 	local getTime = GetTime()

-- end

function Stagger:CreateRemoveFrames()
	--pcUF:Print("Stagger Module - CreateRemoveFrames")

	frames = pcUF:GetActiveUnitFrames()
end
