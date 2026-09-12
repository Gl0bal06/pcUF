--[[-------------------------------------------------------------------------
  Copyright (c) 2005-2026, Mark T Dragon
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above
        copyright notice, this list of conditions and the following
        disclaimer in the documentation and/or other materials provided
        with the distribution.
      * Neither the name of gUF nor the names of its contributors may
        be used to endorse or promote products derived from this
        software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------]]

---@class gUF

local gUF = LibStub("AceAddon-3.0"):NewAddon("gUF", "AceEvent-3.0")		-- Create the main addon object
local L = LibStub("AceLocale-3.0"):GetLocale("gUF", true)				-- Localizations
gUF.rev = "12.0.1 Alpha"
--local isPTR = select(4, GetBuildInfo()) >= 120001						-- Code for only getting a game toc to code for PTRs

local frames = {}														-- Table for units we are currently listening for

function gUF:OnInitialize()												-- ADDON_LOADED event for gUF
	self.defaults = {													-- Defaults for the entire mod
		profile = {
			global = {
				[L["Config Mode"]] = false,
				[L["Lock Frames"]] = false,
				[L["Bar Texture"]] = "Blizzard", -- not implemented yet
				[L["Invert Bar Values"]] = false, -- not implemented yet
				[L["Color Frame By Debuff"]] = true,
				[L["Status Bar Texture"]] = "Blizzard",
				[L["Status Bar Background Texture"]] = "Blizzard",
				[L["Background Color"]] = {r = 0, g = 0, b = 0, a = 1}, -- allow each frame to have its own color maybe?
				[L["Border Color"]] = {r = 0.5, g = 0.5, b = 0.5, a = 1}, -- allow each frame to have its own color maybe?
				[L["Friendly PvE Color"]] = {r = 0.5, g = 0.5, b = 1, a = 1},
				[L["Friendly PvP Color"]] = {r = 0, g = 1, b = 0, a = 1},
				[L["Hostile PvE Color"]] = {r = 0.5, g = 0.5, b = 1, a = 1},
				[L["Hostile PvP Color"]] = {r = 1, g = 0, b = 0, a = 1},
				[L["Hostile PvP In PvE Color"]] = {r = 1, g = 1, b = 0, a = 1},
				[L["Tapped NPC Color"]] = {r = 0.5, g = 0.5, b = 0.5, a = 1},
				[L["Health Bar Color"]] = {r = 0, g = 0.8, b = 0, a = 1},
				[L["Mana Bar Color"]] = {r = 0, g = 0, b = 1, a = 1},
				[L["Rage Bar Color"]] = {r = 1, g = 0, b = 0, a = 1},
				[L["Focus Bar Color"]] = {r = 1, g = 0.5, b = 0.25, a = 1},
				[L["Energy Bar Color"]] = {r = 1, g = 1, b = 0, a = 1},
				[L["Combo Points Bar Color"]] = {r = 1, g = 0.96, b = 0.41, a = 1},
				[L["Runes Bar Color"]] = {r = 0.5, g = 0.5, b = 0.5, a = 1},
				[L["Runic Power Bar Color"]] = {r = 0, g = 0.82, b = 1, a = 1},
				[L["Soul Shards Bar Color"]] = {r = 0.5, g = 0.32, b = 0.55, a = 1},
				[L["Astral Power Bar Color"]] = {r = 0.3, g = 0.52, b = 0.9, a = 1},
				[L["Holy Power Bar Color"]] = {r = 0.95, g = 0.9, b = 0.6, a = 1},
				[L["Maelstrom Bar Color"]] = {r = 0, g = 0.5, b = 1, a = 1},
				[L["Chi Bar Color"]] = {r = 0.71, g = 1, b = 0.92, a = 1},
				[L["Insanity Bar Color"]] = {r = 0.4, g = 0, b = 0.8, a = 1},
				[L["Arcane Charges Bar Color"]] = {r = 0.1, g = 0.1, b = 0.98, a = 1},
				[L["Fury Bar Color"]] = {r = 0.788, g = 0.259, b = 0.992, a = 1},
				[L["Pain Bar Color"]] = {r = 1, g = 0.61, b = 0, a = 1},
				[L["Essence Bar Color"]] = {r = 0.392, g = 0.678, b = 0.808, a = 1}, -- No official color, taken from oUF
			},
			module = {
				castbar = {
					[L["Enabled"]] = true,
					[L["Bar Flash"]] = true,
					[L["Bar Spark"]] = true,
					[L["Display Cast Timer"]] = true,
					[L["Replace Unit Names"]] = true,
					[L["TradeSkills"]] = true,
					[L["Casting Color"]] = {r = 1, g = 0.7, b = 0, a = 1},
					[L["Channelling Color"]] = {r = 0, g = 1, b = 0, a = 1},
					[L["Failed Cast Color"]] = {r = 1, g = 0, b = 0, a = 1},
					[L["Success Cast Color"]] = {r = 0, g = 1, b = 0, a = 1},
					[L["Uninterruptible Cast Color"]] = {r = 0.7, g = 0.7, b = 0.7, a = 1},
				},
			},
			player = {
				[L["Enabled"]] = true,
				[L["Position"]] = {x = -2, y = -43}, -- adjust these some more and make a reset gui
				[L["Scale"]] = 1, -- not implemented yet
				[L["Transparency"]] = 1, -- not implemented yet
				[L["Healer Mode"]] = false, -- remove this later once better text options are made
				[L["Color Names By Class"]] = false,
				[L["Show PvP Status Icon"]] = true,
				[L["Classic Buff & Debuff Mode"]] = true,
				buffs = {
					[L["Number of Buffs"]] = 20,
					[L["Buffs Per Row"]] = 10,
					[L["Horizontal Spacing"]] = 0,
					[L["Vertical Spacing"]] = 0,
					[L["Show Cooldown Models"]] = true,
					[L["X Offset"]] = 0,
					[L["Y Offset"]] = 0,
					[L["Grow Upwards"]] = false,
					[L["Expand Left"]] = false,
					[L["Position"]] = 1,
				},
				debuffs = {
					[L["Number of Debuffs"]] = 20,--
					[L["Buffs Per Row"]] = 10,--
					[L["Horizontal Spacing"]] = 0,--
					[L["Vertical Spacing"]] = 0,--
					[L["Show Cooldown Models"]] = true,--
					[L["X Offset"]] = 0,--
					[L["Y Offset"]] = 0,--
					[L["Grow Upwards"]] = false,--
					[L["Expand Left"]] = false,--
					[L["Position"]] = 1,--
				},
			},
			target = {
				[L["Enabled"]] = true,
				[L["Position"]] = {x = 305, y = -43}, -- adjust these some more and make a reset gui
				[L["Scale"]] = 1, -- not implemented yet
				[L["Transparency"]] = 1, -- not implemented yet
				[L["Healer Mode"]] = false, -- remove this later once better text options are made
				[L["Color Names By Class"]] = false,
				[L["Show PvP Status Icon"]] = true,
				[L["Classic Buff & Debuff Mode"]] = true,
				buffs = {
					[L["Number of Buffs"]] = 20,
					[L["Buffs Per Row"]] = 10,
					[L["Horizontal Spacing"]] = 0,
					[L["Vertical Spacing"]] = 0,
					[L["Show Cooldown Models"]] = true,
					[L["X Offset"]] = 0,
					[L["Y Offset"]] = 0,
					[L["Grow Upwards"]] = false,
					[L["Expand Left"]] = false,
					[L["Position"]] = 1,
				},
				debuffs = {
					[L["Number of Debuffs"]] = 40,--
					[L["Buffs Per Row"]] = 10,--
					[L["Horizontal Spacing"]] = 0,--
					[L["Vertical Spacing"]] = 0,--
					[L["Show Cooldown Models"]] = true,--
					[L["X Offset"]] = 0,--
					[L["Y Offset"]] = 0,--
					[L["Grow Upwards"]] = false,--
					[L["Expand Left"]] = false,--
					[L["Position"]] = 1,--
				},
			},
		}
	}

	self.ClassIcon = {	--Right, Left, Top, Bottom
		["DEATHKNIGHT"]	= {0.25, 0.5, 0.5, 0.75},
		["DEMONHUNTER"]	= {0.7421875, 0.98828125, 0.5, 0.75},
		["DRUID"]		= {0.7421875, 0.98828125, 0, 0.25},
		["EVOKER"]		= {0, 0.25, 0.75, 1},
		["HUNTER"]		= {0, 0.25, 0.25, 0.5},
		["MAGE"]		= {0.25, 0.49609375, 0, 0.25},
		["MONK"]		= {0.5, 0.73828125, 0.5, .75},
		["PALADIN"]		= {0, 0.25, 0.5, 0.75},
		["PRIEST"]		= {0.49609375, 0.7421875, 0.25, 0.5},
		["ROGUE"]		= {0.49609375, 0.7421875, 0, 0.25},
		["SHAMAN"]	 	= {0.25, 0.49609375, 0.25, 0.5},
		["WARLOCK"]		= {0.7421875, 0.98828125, 0.25, 0.5},
		["WARRIOR"]		= {0, 0.25, 0, 0.25},
	}

	self.CurableDebuff = {	-- Debuffs that can be cured regardless of specialization
		["DEATHKNIGHT"]	= {[L["Curse"]] = 0, [L["Disease"]] = 0, [L["Magic"]] = 0, [L["Poison"]] = 0},
		["DEMONHUNTER"]	= {[L["Curse"]] = 0, [L["Disease"]] = 0, [L["Magic"]] = 0, [L["Poison"]] = 0},
		["DRUID"]		= {[L["Curse"]] = 1, [L["Disease"]] = 0, [L["Magic"]] = 0, [L["Poison"]] = 1},
		["EVOKER"]		= {[L["Curse"]] = 1, [L["Disease"]] = 1, [L["Magic"]] = 0, [L["Poison"]] = 1},
		["HUNTER"]		= {[L["Curse"]] = 0, [L["Disease"]] = 0, [L["Magic"]] = 0, [L["Poison"]] = 0},
		["MAGE"]		= {[L["Curse"]] = 1, [L["Disease"]] = 0, [L["Magic"]] = 0, [L["Poison"]] = 0},
		["MONK"]		= {[L["Curse"]] = 0, [L["Disease"]] = 1, [L["Magic"]] = 0, [L["Poison"]] = 1},
		["PALADIN"]		= {[L["Curse"]] = 0, [L["Disease"]] = 1, [L["Magic"]] = 0, [L["Poison"]] = 1},
		["PRIEST"]		= {[L["Curse"]] = 0, [L["Disease"]] = 1, [L["Magic"]] = 1, [L["Poison"]] = 0},
		["ROGUE"]		= {[L["Curse"]] = 0, [L["Disease"]] = 0, [L["Magic"]] = 0, [L["Poison"]] = 0},
		["SHAMAN"]		= {[L["Curse"]] = 1, [L["Disease"]] = 0, [L["Magic"]] = 0, [L["Poison"]] = 0},
		["WARLOCK"]		= {[L["Curse"]] = 0, [L["Disease"]] = 0, [L["Magic"]] = 1, [L["Poison"]] = 0},
		["WARRIOR"]		= {[L["Curse"]] = 0, [L["Disease"]] = 0, [L["Magic"]] = 0, [L["Poison"]] = 0},
	}

	self.DebuffTypeColor = {
		["none"]	= {r = 0.80, g = 0, b = 0},
		["Magic"]	= {r = 0.20, g = 0.60, b = 1.00},
		["Curse"]	= {r = 0.60, g = 0.00, b = 1.00},
		["Disease"]	= {r = 0.60, g = 0.40, b = 0},
		["Poison"]	= {r = 0.00, g = 0.60, b = 0},
		[""]		= {r = 0.80, g = 0, b = 0},
	}

	self.FactionBarColors = {
		[1] = {r = 0.8, g = 0.3, b = 0.22},
		[2] = {r = 0.8, g = 0.3, b = 0.22},
		[3] = {r = 0.75, g = 0.27, b = 0},
		[4] = {r = 0.9, g = 0.7, b = 0},
		[5] = {r = 0, g = 0.6, b = 0.1},
		[6] = {r = 0, g = 0.6, b = 0.1},
		[7] = {r = 0, g = 0.6, b = 0.1},
		[8] = {r = 0, g = 0.6, b = 0.1},
	}

	self.RaidClassColors = {
		["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23, colorStr = "ffc41e3a" },
		["DEMONHUNTER"] = { r = 0.64, g = 0.19, b = 0.79, colorStr = "ffa330c9" },
		["DRUID"] = { r = 1.0, g = 0.49, b = 0.04, colorStr = "ffff7c0a" },
		["EVOKER"] = { r = 0.20, g = 0.58, b = 0.50, colorStr = "ff33937f" },
		["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45, colorStr = "ffaad372" },
		["MAGE"] = { r = 0.25, g = 0.78, b = 0.92, colorStr = "ff3fc7eb" },
		["MONK"] = { r = 0.0, g = 1.00 , b = 0.60, colorStr = "ff00ff98" },
		["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, colorStr = "fff48cba" },
		["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0, colorStr = "ffffffff" },
		["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41, colorStr = "fffff468" },
		["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87, colorStr = "ff0070dd" },
		["WARLOCK"] = { r = 0.53, g = 0.53, b = 0.93, colorStr = "ff8788ee" },
		["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, colorStr = "ffc69b6d" },
	}

	self.abbrevTablePercent = {
		breakpointData = {
			{ breakpoint = 100, abbreviation = "", significandDivisor = 1, fractionDivisor = 1, abbreviationIsGlobal = false },
			{ breakpoint = 0, abbreviation = "", significandDivisor = 1, fractionDivisor = 1, abbreviationIsGlobal = false },
		}
	}

	self.LSM = LibStub:GetLibrary("LibSharedMedia-3.0")

	self:Print("|cffffff00v"..self.rev.." loaded")
end

function gUF:OnEnable()																	-- PLAYER_LOGIN event for gUF
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("PARTY_LEADER_CHANGED")
	self:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_FLAGS_CHANGED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("PLAYER_UPDATE_RESTING")
	self:RegisterEvent("RAID_TARGET_UPDATE")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_DISPLAYPOWER")
	--self:RegisterEvent("UNIT_DYNAMIC_FLAGS")
	self:RegisterEvent("UNIT_FACTION")
	self:RegisterEvent("UNIT_HEALTH")
	-- self:RegisterEvent("UNIT_HEALTH_PREDICTION")
	self:RegisterEvent("UNIT_LEVEL")
	self:RegisterEvent("UNIT_MAXHEALTH")
	self:RegisterEvent("UNIT_MAXPOWER")
	self:RegisterEvent("UNIT_NAME_UPDATE")
	self:RegisterEvent("UNIT_PORTRAIT_UPDATE")
	-- self:RegisterEvent("UNIT_POWER")
	self:RegisterEvent("UNIT_POWER_FREQUENT")
	-- self:RegisterEvent("VOICE_START")
	-- self:RegisterEvent("VOICE_STOP")

	self.db = LibStub:GetLibrary("AceDB-3.0"):New("gUFDB", self.defaults, true)			-- Initialize the saved variables database with the default settings

	--Slash Command stuff
	SLASH_gUF1 = "/guf"
	SlashCmdList["gUF"] = function(msg)
		msg = msg and string.lower(msg)
		if (msg == "version") then
			self:Print("|cffffff00v"..self.rev)
		else
			if (InCombatLockdown() == true) then
				self:Print(L["Options cannot be changed in combat."])
			else
				local loaded, reason = C_AddOns.LoadAddOn("gUF_Options")
				if (loaded) then
					LibStub("AceConfig-3.0"):RegisterOptionsTable("gUF", gUF.options)	-- Initialize AceConfig-3.0
					LibStub("AceConfigDialog-3.0"):Open("gUF")
				else
					self:Print(L["Failed to load gUF_Options.  The options menu failed to load because: "]..reason)
					return
				end
			end
		end
	end

	self:InitializeBarColorArray()														-- Populate the bar color array with saved values

	self.class = select(2, UnitClass("player"))

	self:CreateRemoveFrames()															-- Create any frames that are enabled

	self:EnableDisableModules()															-- Enable or disable any modules that should be enabled or disabled

	-- One time function calls that will be properly managed once events are active
	self:UpdateLootMethod()
end

function gUF:Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99gUF|r: "..tostring(msg))
end


--------------------
-- Event Handlers --
--------------------
function gUF:PLAYER_ENTERING_WORLD(event)
	-- Color the player's name correctly when zoning
	self:UNIT_FACTION(nil, "player")
	self:UNIT_FACTION(nil, "target")

	-- Display/hide the rest icon if needed, combat should appear on it's own from events on zoning
	self:UpdateCombatRestIcon(nil)
end

function gUF:UNIT_HEALTH(event, unit)
	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		local unithealth = UnitHealth(unit)
		local unithealthmax = UnitHealthMax(unit)
		local rawunithealthpercent = UnitHealthPercent(unit, false, CurveConstants.ScaleTo100)
		local unithealthpercent = AbbreviateNumbers(rawunithealthpercent, self.abbrevTablePercent)

		frame.healthbar:SetValue(unithealth)

		--if (unithealthmax > 99999) then
			-- do some abbreviating here, probably turn this into an option later?
		--end

		-- Handle Death Status
		if (UnitIsDead(unit) or UnitIsGhost(unit)) then
			frame.deathicon:Show()
			unithealth = 0
			unithealthpercent = "0"
		else
			frame.deathicon:Hide()
		end

		frame.currentmaxhealthtext:SetText(unithealth.."/"..unithealthmax)
		--frame.currentmaxhealthtext:SetText(self:FormatHealthPowerText(unithealth).."/"..self:FormatHealthPowerText(unithealthmax))
		frame.percenthealthtext:SetText(unithealthpercent.."%")
		--frame.deficithealthtext:SetText("-"..unithealthmax - unithealth)

		if (unit == "target") then
			frame.currentmaxhealthtext:SetText(unithealth.."/"..unithealthmax.." | "..unithealthpercent.."%")
			frame.percenthealthtext:Hide()
		end

		-- Handle Disconnected Status
		if (UnitIsConnected(unit)) then
			frame.disconnectedicon:Hide()
		else
			frame.disconnectedicon:Show()
			frame.currentmaxhealthtext:SetText(L["Offline"])
			return
		end

		-- Handle Feign Death Status
		if (UnitIsDead(unit)) then
			if (UnitIsPlayer(unit)) then
				local _, englishClass = UnitClass(unit)
				if (englishClass == "HUNTER") then
					local i = 1

					local aura = C_UnitAuras.GetBuffDataByIndex(unit, i)	-- Get the buff information if any
					while (aura) do
						if (aura.name == L["Feign Death"]) then
							frame.currentmaxhealthtext:SetText(L["Feign Death"])
							break
						end
						i = i + 1
						aura = C_UnitAuras.GetBuffDataByIndex(unit, i)
					end
				end
			end
		end
	end
end

function gUF:UNIT_MAXHEALTH(event, unit)
	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		frame.healthbar:SetMinMaxValues(0, UnitHealthMax(unit))
		self:UNIT_HEALTH(nil, unit)
	end
end

function gUF:UNIT_POWER_FREQUENT(event, unit)
	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		local unitpower = UnitPower(unit)
		local unitpowermax = UnitPowerMax(unit)
		local rawunitpowerpercent = UnitPowerPercent(unit, UnitPowerType(unit), false, CurveConstants.ScaleTo100)
		local unitpowerpercent = AbbreviateNumbers(rawunitpowerpercent, self.abbrevTablePercent)

		frame.powerbar:SetValue(unitpower)

		frame.currentmaxpowertext:SetText(unitpower.."/"..unitpowermax)
		frame.percentpowertext:SetText(unitpowerpercent.."%")
		--frame.deficitpowertext:SetText("-"..unitpowermax - unitpower)

		if (unit == "target") then
			--frame.currentmaxpowertext:SetText(unitpower.."/"..unitpowermax.." | "..unitpowerpercent.."%")
			frame.percentpowertext:Hide()
		end

		if (unit == "player") then
			local unitpowertype = UnitPowerType("player")
			local classFilename = UnitClassBase("player")

			if (classFilename == "DRUID" or classFilename == "MONK" or classFilename == "PRIEST" or classFilename == "SHAMAN") then			-- Alternate power bar stuff
				if (unitpowertype > 0) then								-- Are we in a manaless form?
					local unitalternatepower = UnitPower(unit, 0)
					local unitalternatepowermax = UnitPowerMax(unit, 0)
					local rawunitalternatepowerpercent = UnitPowerPercent(unit, 0, false, CurveConstants.ScaleTo100)
					local unitalternatepowerpercent = AbbreviateNumbers(rawunitalternatepowerpercent, self.abbrevTablePercent)

					--frame.alternatepowerbar:SetMinMaxValues(0, unitalternatepowermax)
					frame.alternatepowerbar:SetValue(unitalternatepower)

					frame.currentmaxalternatepowertext:SetText(unitalternatepower.."/"..unitalternatepowermax)
					frame.percentalternatepowertext:SetText(unitalternatepowerpercent.."%")
					--frame.deficitalternatepowertext:SetText("-"..unitalternatepowermax - unitalternatepower)
				else
					-- Hide it all (bars and text)
					frame.currentmaxalternatepowertext:SetText()
					frame.percentalternatepowertext:SetText()
					--frame.deficitalternatepowertext:SetText()
					frame.alternatepowerbar:SetMinMaxValues(0, 1)
					frame.alternatepowerbar:SetValue(0)
				end
			end

			if (classFilename == "DRUID" or classFilename == "ROGUE") then
				local unitsecondarypower = UnitPower(unit, 4)
				local unitsecondarypowermax = UnitPowerMax(unit, 4)

				frame.secondarypowerbar:SetValue(unitsecondarypower)

				frame.currentmaxsecondarypowertext:SetText(unitsecondarypower.."/"..unitsecondarypowermax)
				frame.percentsecondarypowertext:SetText(unitsecondarypower)
				--frame.deficitsecondarypowertext:SetText("-"..unitpowermax - unitpower)
			elseif (classFilename == "EVOKER") then
				local unitsecondarypower = UnitPower(unit, 19)
				local unitsecondarypowermax = UnitPowerMax(unit, 19)

				frame.secondarypowerbar:SetValue(unitsecondarypower)

				frame.currentmaxsecondarypowertext:SetText(unitsecondarypower.."/"..unitsecondarypowermax)
				frame.percentsecondarypowertext:SetText(unitsecondarypower)
				--frame.deficitsecondarypowertext:SetText("-"..unitpowermax - unitpower)
			elseif (classFilename == "MAGE") then
				local unitsecondarypower = UnitPower(unit, 16)
				local unitsecondarypowermax = UnitPowerMax(unit, 16)

				frame.secondarypowerbar:SetValue(unitsecondarypower)

				frame.currentmaxsecondarypowertext:SetText(unitsecondarypower.."/"..unitsecondarypowermax)
				frame.percentsecondarypowertext:SetText(unitsecondarypower)
				--frame.deficitsecondarypowertext:SetText("-"..unitpowermax - unitpower)
			elseif (classFilename == "MONK") then
				if (C_SpecializationInfo.GetSpecializationInfo(C_SpecializationInfo.GetSpecialization()) == 269) then
					local unitsecondarypower = UnitPower(unit, 12)
					local unitsecondarypowermax = UnitPowerMax(unit, 12)

					frame.secondarypowerbar:SetValue(unitsecondarypower)

					frame.currentmaxsecondarypowertext:SetText(unitsecondarypower.."/"..unitsecondarypowermax)
					frame.percentsecondarypowertext:SetText(unitsecondarypower)
					--frame.deficitsecondarypowertext:SetText("-"..unitpowermax - unitpower)
				end
			elseif (classFilename == "PALADIN") then
				local unitsecondarypower = UnitPower(unit, 9)
				local unitsecondarypowermax = UnitPowerMax(unit, 9)

				frame.secondarypowerbar:SetValue(unitsecondarypower)

				frame.currentmaxsecondarypowertext:SetText(unitsecondarypower.."/"..unitsecondarypowermax)
				frame.percentsecondarypowertext:SetText(unitsecondarypower)
				--frame.deficitsecondarypowertext:SetText("-"..unitpowermax - unitpower)
			elseif (classFilename == "WARLOCK") then
				local unitsecondarypower = UnitPower(unit, 7)
				local unitsecondarypowermax = UnitPowerMax(unit, 7)

				frame.secondarypowerbar:SetValue(unitsecondarypower)

				frame.currentmaxsecondarypowertext:SetText(unitsecondarypower.."/"..unitsecondarypowermax)
				frame.percentsecondarypowertext:SetText(unitsecondarypower)
				--frame.deficitsecondarypowertext:SetText("-"..unitpowermax - unitpower)
			end
		end
	end
end

function gUF:UNIT_MAXPOWER(event, unit)
	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		frame.powerbar:SetMinMaxValues(0, UnitPowerMax(unit))
		self:UNIT_POWER_FREQUENT(nil, unit)

		if (unit == "player") then								-- Alternate power bar stuff
			local classFilename = UnitClassBase("player")
			if (classFilename == "DRUID" or classFilename == "MONK" or classFilename == "PRIEST" or classFilename == "SHAMAN") then
				if (UnitPowerType("player") > 0) then
					frame.alternatepowerbar:SetMinMaxValues(0, UnitPowerMax("player", 0))
				end
			end

			if (classFilename == "DRUID" or classFilename == "ROGUE") then
				frame.secondarypowerbar:SetMinMaxValues(0, UnitPowerMax("player", 4))
			elseif (classFilename == "EVOKER") then
				frame.secondarypowerbar:SetMinMaxValues(0, UnitPowerMax("player", 19))
			elseif (classFilename == "MAGE") then
				frame.secondarypowerbar:SetMinMaxValues(0, UnitPowerMax("player", 16))
			elseif (classFilename == "MONK") then
				frame.secondarypowerbar:SetMinMaxValues(0, UnitPowerMax("player", 12))
			elseif (classFilename == "PALADIN") then
				frame.secondarypowerbar:SetMinMaxValues(0, UnitPowerMax("player", 9))
			elseif (classFilename == "WARLOCK") then
				frame.secondarypowerbar:SetMinMaxValues(0, UnitPowerMax("player", 7))
			end
		end
	end
end

function gUF:UNIT_DISPLAYPOWER(event, unit)
	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		local unitpower, unitpowertoken = UnitPowerType(unit)
		--self:Print(unitpower)
		local unitpowerinfo = PowerBarColor[unitpowertoken]

		--if (UnitPowerMax(unit) == 0) then					-- No Power Bar
		if (unitpowerinfo == 0) then						-- No Power Bar
			frame.powerbar:SetStatusBarColor(0, 0, 0, 0)
			frame.powerbarbg:SetStatusBarColor(0, 0, 0, 0)
			frame.currentmaxpowertext:SetText()				-- these text field blanks will probably change later once text options are added
			frame.percentpowertext:SetText()
			frame.deficitpowertext:SetText()
		elseif (unitpower) then
			frame.powerbar:SetStatusBarColor(self.BarColor[unitpower].r, self.BarColor[unitpower].g, self.BarColor[unitpower].b, self.BarColor[unitpower].a)
			frame.powerbarbg:SetStatusBarColor(self.BarColor[unitpower].r, self.BarColor[unitpower].g, self.BarColor[unitpower].b, self.BarColor[unitpower].a * 0.25)
			if (unit == "player") then
				local classFilename = UnitClassBase("player")
				if (classFilename == "DRUID" or classFilename == "MONK" or classFilename == "PRIEST" or classFilename == "SHAMAN") then
					if (UnitPowerType("player") > 0) then
						frame.alternatepowerbar:SetStatusBarColor(self.BarColor[0].r, self.BarColor[0].g, self.BarColor[0].b, self.BarColor[0].a)
						frame.alternatepowerbarbg:SetStatusBarColor(self.BarColor[0].r, self.BarColor[0].g, self.BarColor[0].b, self.BarColor[0].a * 0.25)
					end
				end
			end
			self:UNIT_MAXPOWER(nil, unit)
		end
	end
end

function gUF:UNIT_LEVEL(event, unit)
	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		local unitlevel = UnitLevel(unit)
		local unitdifficultycolor = GetQuestDifficultyColor(unitlevel)
		local unitclassification = UnitClassification(unit)

		frame.leveltext:SetVertexColor(unitdifficultycolor.r, unitdifficultycolor.g, unitdifficultycolor.b)

		if (unitlevel < 0) then
			frame.leveltext:SetTextColor(1, 0, 0)
--			if (UnitIsPlayer(unit)) then
--				targetclassificationframetext = nil
--			end
			unitlevel = "??"
		end

		if (unitclassification == "worldboss") then
--			Perl_Target_RareEliteBarText:SetTextColor(1, 0, 0)
--			Perl_Target_EliteRareGraphic:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite")
--			targetclassificationframetext = PERL_LOCALIZED_TARGET_BOSS
		elseif (unitclassification == "rareelite") then
--			Perl_Target_EliteRareGraphic:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite")
--			targetclassificationframetext = PERL_LOCALIZED_TARGET_RAREELITE
			unitlevel = unitlevel.."r+"
		elseif (unitclassification == "elite") then
--			Perl_Target_EliteRareGraphic:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite")
--			targetclassificationframetext = PERL_LOCALIZED_TARGET_ELITE
			unitlevel = unitlevel.."+"
		elseif (unitclassification == "rare") then
--			Perl_Target_EliteRareGraphic:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare")
--			targetclassificationframetext = PERL_LOCALIZED_TARGET_RARE
			unitlevel = unitlevel.."r"
--		else
--			Perl_Target_EliteRareGraphic:SetTexture()
		end

		frame.leveltext:SetText(unitlevel)
	end
end

function gUF:UNIT_NAME_UPDATE(event, unit)
	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		if (not canaccessvalue(UnitIsAFK(unit))) then
			frame.nametext:SetText(UnitName(unit))
		elseif (UnitIsAFK(unit)) then
			frame.nametext:SetText(UnitName(unit).." (AFK)")
		elseif (UnitIsDND(unit)) then
			frame.nametext:SetText(UnitName(unit).." (DND)")
		else
			frame.nametext:SetText(UnitName(unit))
		end
		self:UNIT_LEVEL(nil, unit)
	end
end

function gUF:UNIT_PORTRAIT_UPDATE(event, unit)
	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		if (frame.portraitframe) then								-- Add a toggle option here eventually
			if (UnitIsVisible(unit)) then
				frame.portrait3d:SetUnit(unit)						-- Load the correct 3d graphic
				frame.portrait3d:SetPortraitZoom(1)
				frame.portrait2d:Hide()								-- Hide the 2d graphic
				frame.portrait3d:Show()								-- Show the 3d graphic
			else
				SetPortraitTexture(frame.portrait2d, unit)			-- Load the correct 2d graphic
				frame.portrait3d:Hide()								-- Hide the 3d graphic
				frame.portrait2d:Show()								-- Show the 2d graphic
			end
		end
	end
end

function gUF:PLAYER_FLAGS_CHANGED(event, unit)
	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		self:UNIT_NAME_UPDATE(nil, unit)
	end
end

function gUF:RAID_TARGET_UPDATE()
	for i,v in pairs(frames) do
		for frame in pairs(v) do
			self:UpdateRaidIcon(frame)
		end
	end
end

function gUF:UNIT_FACTION(event, unit)
	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		--self:UNIT_DYNAMIC_FLAGS(nil, unit)

		if (self.db.profile[unit][L["Show PvP Status Icon"]] == true) then
			local englishFaction, _ = UnitFactionGroup(unit)
			--if (englishFaction == nil) then								-- Did this bug ever get fixed?
			--	englishFaction  = UnitFactionGroup("player")
			--end

			if (UnitIsPVPFreeForAll(unit)) then
				frame.pvpicon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")				-- Set the FFA PvP icon
				frame.pvpicon:Show()															-- Show the icon
			elseif (englishFaction and UnitIsPVP(unit) and not UnitIsPVPSanctuary(unit)) then
				frame.pvpicon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..englishFaction)	-- Set the correct team icon
				frame.pvpicon:Show()															-- Show the icon
			else
				frame.pvpicon:Hide()															-- Hide the icon
			end
		else																					-- move this hide check to the style function?
				frame.pvpicon:Hide()															-- Hide the icon
		end

		if (self.db.profile[unit][L["Color Names By Class"]] == true) then
			if (UnitIsPlayer(unit)) then
				local _, englishClass = UnitClass(unit)
				if (englishClass) then
					frame.nametext:SetTextColor(self.RaidClassColors[englishClass].r,self.RaidClassColors[englishClass].g,self.RaidClassColors[englishClass].b)
					return
				end
			end
		end

		if (UnitPlayerControlled(unit)) then							-- is it a player
			if (UnitCanAttack(unit, "player")) then						-- are we in an enemy controlled zone
				-- Hostile players are red
				if (not UnitCanAttack("player", unit)) then				-- enemy is not pvp enabled
					frame.nametext:SetTextColor(self.db.profile.global[L["Hostile PvE Color"]].r, self.db.profile.global[L["Hostile PvE Color"]].g, self.db.profile.global[L["Hostile PvE Color"]].b, self.db.profile.global[L["Hostile PvE Color"]].a)
				else									-- enemy is pvp enabled
					frame.nametext:SetTextColor(self.db.profile.global[L["Hostile PvP Color"]].r, self.db.profile.global[L["Hostile PvP Color"]].g, self.db.profile.global[L["Hostile PvP Color"]].b, self.db.profile.global[L["Hostile PvP Color"]].a)
				end
			elseif (UnitCanAttack("player", unit)) then					-- enemy in a zone controlled by friendlies or when we're a ghost
				-- Players we can attack but which are not hostile are yellow
				frame.nametext:SetTextColor(self.db.profile.global[L["Hostile PvP In PvE Color"]].r, self.db.profile.global[L["Hostile PvP In PvE Color"]].g, self.db.profile.global[L["Hostile PvP In PvE Color"]].b, self.db.profile.global[L["Hostile PvP In PvE Color"]].a)
			elseif (UnitIsPVP(unit) and not UnitIsPVPSanctuary(unit) and not UnitIsPVPSanctuary(unit)) then	-- friendly pvp enabled character
				-- Players we can assist but are PvP flagged are green
				frame.nametext:SetTextColor(self.db.profile.global[L["Friendly PvP Color"]].r, self.db.profile.global[L["Friendly PvP Color"]].g, self.db.profile.global[L["Friendly PvP Color"]].b, self.db.profile.global[L["Friendly PvP Color"]].a)
			else										-- friendly non pvp enabled character
				-- All other players are blue (the usual state on the "blue" server)
				frame.nametext:SetTextColor(self.db.profile.global[L["Friendly PvE Color"]].r, self.db.profile.global[L["Friendly PvE Color"]].g, self.db.profile.global[L["Friendly PvE Color"]].b, self.db.profile.global[L["Friendly PvE Color"]].a)
			end
		elseif (not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)) then			-- not our tap (Post 7.0)
			frame.nametext:SetTextColor(self.db.profile.global[L["Tapped NPC Color"]].r, self.db.profile.global[L["Tapped NPC Color"]].g, self.db.profile.global[L["Tapped NPC Color"]].b, self.db.profile.global[L["Tapped NPC Color"]].a)
		else
			if (UnitIsVisible(unit)) then
				local reaction = UnitReaction(unit, "player")
				if (reaction) then
					frame.nametext:SetTextColor(self.FactionBarColors[reaction].r, self.FactionBarColors[reaction].g, self.FactionBarColors[reaction].b, self.db.profile.global[L["Hostile PvP Color"]].a)
				else
					frame.nametext:SetTextColor(self.db.profile.global[L["Friendly PvE Color"]].r, self.db.profile.global[L["Friendly PvE Color"]].g, self.db.profile.global[L["Friendly PvE Color"]].b, self.db.profile.global[L["Friendly PvE Color"]].a)
				end
			else
				if (UnitCanAttack(unit, "player")) then				-- are we in an enemy controlled zone
					-- Hostile players are red
					if (not UnitCanAttack("player", unit)) then			-- enemy is not pvp enabled
						frame.nametext:SetTextColor(self.db.profile.global[L["Hostile PvE Color"]].r, self.db.profile.global[L["Hostile PvE Color"]].g, self.db.profile.global[L["Hostile PvE Color"]].b, self.db.profile.global[L["Hostile PvE Color"]].a)
					else								-- enemy is pvp enabled
						frame.nametext:SetTextColor(self.db.profile.global[L["Hostile PvP Color"]].r, self.db.profile.global[L["Hostile PvP Color"]].g, self.db.profile.global[L["Hostile PvP Color"]].b, self.db.profile.global[L["Hostile PvP Color"]].a)
					end
				elseif (UnitCanAttack("player", unit)) then				-- enemy in a zone controlled by friendlies or when we're a ghost
					-- Players we can attack but which are not hostile are yellow
					frame.nametext:SetTextColor(self.db.profile.global[L["Hostile PvP In PvE Color"]].r, self.db.profile.global[L["Hostile PvP In PvE Color"]].g, self.db.profile.global[L["Hostile PvP In PvE Color"]].b, self.db.profile.global[L["Hostile PvP In PvE Color"]].a)
				elseif (UnitIsPVP(unit) and not UnitIsPVPSanctuary(unit) and not UnitIsPVPSanctuary("player")) then	-- friendly pvp enabled character
					-- Players we can assist but are PvP flagged are green
					frame.nametext:SetTextColor(self.db.profile.global[L["Friendly PvP Color"]].r, self.db.profile.global[L["Friendly PvP Color"]].g, self.db.profile.global[L["Friendly PvP Color"]].b, self.db.profile.global[L["Friendly PvP Color"]].a)
				else									-- friendly non pvp enabled character
					-- All other players are blue (the usual state on the "blue" server)
					frame.nametext:SetTextColor(self.db.profile.global[L["Friendly PvE Color"]].r, self.db.profile.global[L["Friendly PvE Color"]].g, self.db.profile.global[L["Friendly PvE Color"]].b, self.db.profile.global[L["Friendly PvE Color"]].a)
				end
			end
		end

	end
end

-- function gUF:UNIT_DYNAMIC_FLAGS(event, unit)
-- 	if not frames[unit] then return end

-- 	for frame in pairs(frames[unit]) do
-- 		if (self.db.profile[unit][L["Color Names By Class"]] == true) then
-- 			if (UnitIsPlayer(unit)) then
-- 				local _, englishClass = UnitClass(unit)
-- 				if (englishClass) then
-- 					frame.nametext:SetTextColor(self.RaidClassColors[englishClass].r,self.RaidClassColors[englishClass].g,self.RaidClassColors[englishClass].b)
-- 					return
-- 				end
-- 			end
-- 		end

-- 		if (UnitPlayerControlled(unit)) then							-- is it a player
-- 			if (UnitCanAttack(unit, "player")) then						-- are we in an enemy controlled zone
-- 				-- Hostile players are red
-- 				if (not UnitCanAttack("player", unit)) then				-- enemy is not pvp enabled
-- 					frame.nametext:SetTextColor(self.db.profile.global[L["Hostile PvE Color"]].r, self.db.profile.global[L["Hostile PvE Color"]].g, self.db.profile.global[L["Hostile PvE Color"]].b, self.db.profile.global[L["Hostile PvE Color"]].a)
-- 				else									-- enemy is pvp enabled
-- 					frame.nametext:SetTextColor(self.db.profile.global[L["Hostile PvP Color"]].r, self.db.profile.global[L["Hostile PvP Color"]].g, self.db.profile.global[L["Hostile PvP Color"]].b, self.db.profile.global[L["Hostile PvP Color"]].a)
-- 				end
-- 			elseif (UnitCanAttack("player", unit)) then					-- enemy in a zone controlled by friendlies or when we're a ghost
-- 				-- Players we can attack but which are not hostile are yellow
-- 				frame.nametext:SetTextColor(self.db.profile.global[L["Hostile PvP In PvE Color"]].r, self.db.profile.global[L["Hostile PvP In PvE Color"]].g, self.db.profile.global[L["Hostile PvP In PvE Color"]].b, self.db.profile.global[L["Hostile PvP In PvE Color"]].a)
-- 			elseif (UnitIsPVP(unit) and not UnitIsPVPSanctuary(unit) and not UnitIsPVPSanctuary(unit)) then	-- friendly pvp enabled character
-- 				-- Players we can assist but are PvP flagged are green
-- 				frame.nametext:SetTextColor(self.db.profile.global[L["Friendly PvP Color"]].r, self.db.profile.global[L["Friendly PvP Color"]].g, self.db.profile.global[L["Friendly PvP Color"]].b, self.db.profile.global[L["Friendly PvP Color"]].a)
-- 			else										-- friendly non pvp enabled character
-- 				-- All other players are blue (the usual state on the "blue" server)
-- 				frame.nametext:SetTextColor(self.db.profile.global[L["Friendly PvE Color"]].r, self.db.profile.global[L["Friendly PvE Color"]].g, self.db.profile.global[L["Friendly PvE Color"]].b, self.db.profile.global[L["Friendly PvE Color"]].a)
-- 			end
-- 		elseif (not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)) then			-- not our tap (Post 7.0)
-- 			frame.nametext:SetTextColor(self.db.profile.global[L["Tapped NPC Color"]].r, self.db.profile.global[L["Tapped NPC Color"]].g, self.db.profile.global[L["Tapped NPC Color"]].b, self.db.profile.global[L["Tapped NPC Color"]].a)
-- 		else
-- 			if (UnitIsVisible(unit)) then
-- 				local reaction = UnitReaction(unit, "player")
-- 				if (reaction) then
-- 					frame.nametext:SetTextColor(self.FactionBarColors[reaction].r, self.FactionBarColors[reaction].g, self.FactionBarColors[reaction].b, self.db.profile.global[L["Hostile PvP Color"]].a)
-- 				else
-- 					frame.nametext:SetTextColor(self.db.profile.global[L["Friendly PvE Color"]].r, self.db.profile.global[L["Friendly PvE Color"]].g, self.db.profile.global[L["Friendly PvE Color"]].b, self.db.profile.global[L["Friendly PvE Color"]].a)
-- 				end
-- 			else
-- 				if (UnitCanAttack(unit, "player")) then				-- are we in an enemy controlled zone
-- 					-- Hostile players are red
-- 					if (not UnitCanAttack("player", unit)) then			-- enemy is not pvp enabled
-- 						frame.nametext:SetTextColor(self.db.profile.global[L["Hostile PvE Color"]].r, self.db.profile.global[L["Hostile PvE Color"]].g, self.db.profile.global[L["Hostile PvE Color"]].b, self.db.profile.global[L["Hostile PvE Color"]].a)
-- 					else								-- enemy is pvp enabled
-- 						frame.nametext:SetTextColor(self.db.profile.global[L["Hostile PvP Color"]].r, self.db.profile.global[L["Hostile PvP Color"]].g, self.db.profile.global[L["Hostile PvP Color"]].b, self.db.profile.global[L["Hostile PvP Color"]].a)
-- 					end
-- 				elseif (UnitCanAttack("player", unit)) then				-- enemy in a zone controlled by friendlies or when we're a ghost
-- 					-- Players we can attack but which are not hostile are yellow
-- 					frame.nametext:SetTextColor(self.db.profile.global[L["Hostile PvP In PvE Color"]].r, self.db.profile.global[L["Hostile PvP In PvE Color"]].g, self.db.profile.global[L["Hostile PvP In PvE Color"]].b, self.db.profile.global[L["Hostile PvP In PvE Color"]].a)
-- 				elseif (UnitIsPVP(unit) and not UnitIsPVPSanctuary(unit) and not UnitIsPVPSanctuary("player")) then	-- friendly pvp enabled character
-- 					-- Players we can assist but are PvP flagged are green
-- 					frame.nametext:SetTextColor(self.db.profile.global[L["Friendly PvP Color"]].r, self.db.profile.global[L["Friendly PvP Color"]].g, self.db.profile.global[L["Friendly PvP Color"]].b, self.db.profile.global[L["Friendly PvP Color"]].a)
-- 				else									-- friendly non pvp enabled character
-- 					-- All other players are blue (the usual state on the "blue" server)
-- 					frame.nametext:SetTextColor(self.db.profile.global[L["Friendly PvE Color"]].r, self.db.profile.global[L["Friendly PvE Color"]].g, self.db.profile.global[L["Friendly PvE Color"]].b, self.db.profile.global[L["Friendly PvE Color"]].a)
-- 				end
-- 			end
-- 		end

-- 	end
-- end

function gUF:UNIT_AURA(event, unit)
	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		if (UnitName(unit)) then														-- "target" needed this check in the past, haven't checked recently
			local _, color																-- Variables for both buffs and debuffs
			local button = _G["gUF_"..unit].buffs										-- Reference the main icon for the buff

			local numBuffs = 0															-- Buff counter for correct layout
			for buffnum=1,self.db.profile[unit].buffs[L["Number of Buffs"]] do			-- Start main buff loop
				local aura = C_UnitAuras.GetBuffDataByIndex(unit, buffnum, displaycastablebuffs)	-- Get the texture and buff stacking information if any
				if (aura) then															-- If there is a aura return, proceed with buff icon creation
					button[buffnum].icon:SetTexture(aura.icon)							-- Set the texture of the icon
					--local count = C_UnitAuras.GetAuraApplicationDisplayCount(unit, aura.auraInstanceID, 1)
					--if (count > 1) then
						--button[buffnum].count:SetText(aura.applications)				-- Set the text to the number of applications if greater than 0
						button[buffnum].count:SetText(C_UnitAuras.GetAuraApplicationDisplayCount(unit, aura.auraInstanceID, 1))				-- Set the text to the number of applications if greater than 0
						button[buffnum].count:Show()									-- Show the text
					--else
						--button[buffnum].count:Hide()									-- Hide the text if equal to 0
					--end
					if (self.db.profile[unit].buffs[L["Show Cooldown Models"]] == true) then		-- Handle cooldowns
						if (aura.duration) then
							--if (aura.duration > 0) then
								--self:CooldownFrame_SetTimer(button[buffnum].cooldown, aura.expirationTime - aura.duration, aura.duration, 1)

								--local duration = C_UnitAuras.GetAuraDuration(unit, aura.auraInstanceID)
								--self:CooldownFrame_SetTimer(button[buffnum].cooldown, duration, aura.duration, 1)

								self:CooldownFrame_SetTimer(button[buffnum].cooldown, aura.duration, aura.expirationTime, 1)
								button[buffnum].cooldown:Show()
							--else
							--	self:CooldownFrame_SetTimer(button[buffnum].cooldown, 0, 0, 0)
							--	button[buffnum].cooldown:Hide()
							--end
						else
							self:CooldownFrame_SetTimer(button[buffnum].cooldown, 0, 0, 0)
							button[buffnum].cooldown:Hide()
						end
					end
					numBuffs = numBuffs + 1													-- Increment the buff counter
					button[buffnum]:Show()													-- Show the final buff icon
				else
					button[buffnum]:Hide()													-- Hide the icon since there isn't a buff in this position
				end
			end																				-- End main buff loop

			button = _G["gUF_"..unit].debuffs												-- Reference the main icon for the buff
			local numDebuffs = 0															-- Debuff counter for correct layout
			local curableDebuffFound = 0													-- Flag to stop running curable debuff checks once one is found
			for debuffnum=1,self.db.profile[unit].debuffs[L["Number of Debuffs"]] do		-- Start main debuff loop
				local aura = C_UnitAuras.GetDebuffDataByIndex(unit, debuffnum, displaycastabledebuffs)	-- Get the texture and buff stacking information if any
				if (aura) then																-- If there is a aura return, proceed with debuff icon creation
					button[debuffnum].icon:SetTexture(aura.icon)							-- Set the texture of the icon
					-- if (aura.dispelName) then
					-- 	color = self.DebuffTypeColor[aura.dispelName]
					-- 	if (self.db.profile.global[L["Color Frame By Debuff"]] == true) then			-- Moved this code into the loop since 3.0 broke the 3rd argument for UnitDebuff
					-- 		if (curableDebuffFound == 0) then
					-- 			if (UnitIsFriend("player", unit)) then
					-- 				if (self.CurableDebuff[self.class][aura.dispelName] == 1) then
					-- 					for i=1,table.getn(frame.frames),1 do
					-- 						frame.frames[i]:SetBackdropBorderColor(color.r, color.g, color.b)
					-- 					end
					-- 					curableDebuffFound = 1
					-- 				end
					-- 			end
					-- 		end
					-- 	end
					-- else
					-- 	color = self.DebuffTypeColor[L["none"]]
					-- end
					-- button[debuffnum].border:SetVertexColor(color.r, color.g, color.b)				-- Set the debuff border color
					--if (aura.applications > 1) then
						--button[debuffnum].count:SetText(aura.applications)							-- Set the text to the number of applications if greater than 0
						button[debuffnum].count:SetText(C_UnitAuras.GetAuraApplicationDisplayCount(unit, aura.auraInstanceID, 1))				-- Set the text to the number of applications if greater than 0
						button[debuffnum].count:Show()												-- Show the text
					--else
					--	button[debuffnum].count:Hide()												-- Hide the text if equal to 0
					--end
					if (self.db.profile[unit].debuffs[L["Show Cooldown Models"]] == true) then		-- Handle cooldowns
						if (aura.duration) then
							--if (aura.duration > 0) then
								--self:CooldownFrame_SetTimer(button[debuffnum].cooldown, aura.expirationTime - aura.duration, aura.duration, 1)
								self:CooldownFrame_SetTimer(button[debuffnum].cooldown, aura.duration, aura.expirationTime, 1)
								button[debuffnum].cooldown:Show()
							--else
							--	self:CooldownFrame_SetTimer(button[debuffnum].cooldown, 0, 0, 0)
							--	button[debuffnum].cooldown:Hide()
							--end
						else
							self:CooldownFrame_SetTimer(button[debuffnum].cooldown, 0, 0, 0)
							button[debuffnum].cooldown:Hide()
						end
					end
					numDebuffs = numDebuffs + 1								-- Increment the debuff counter
					button[debuffnum]:Show()								-- Show the final debuff icon
				else
					button[debuffnum]:Hide()								-- Hide the icon since there isn't a debuff in this position
				end
			end																-- End main debuff loop

			if (curableDebuffFound == 0) then
				for i=1,table.getn(frame.frames),1 do
					frame.frames[i]:SetBackdropBorderColor(self.db.profile.global[L["Border Color"]].r, self.db.profile.global[L["Border Color"]].g, self.db.profile.global[L["Border Color"]].b)
				end
			end

			if (self.db.profile[unit][L["Classic Buff & Debuff Mode"]] == true) then
				local frame = _G["gUF_"..unit]
				frame.buffs[1]:ClearAllPoints()
				frame.debuffs[1]:ClearAllPoints()
				if (UnitIsFriend("player", unit)) then
					self:GetInitialBuffAndDebuffAnchorPoint(frame, "buffs", 1)
					local index = ceil(numBuffs / self.db.profile[frame.unit].buffs[L["Buffs Per Row"]]) * self.db.profile[frame.unit].buffs[L["Buffs Per Row"]] - self.db.profile[frame.unit].buffs[L["Buffs Per Row"]] + 1
					if (index < 1) then
						index = 1
					end
					if (self.db.profile[frame.unit].debuffs[L["Expand Left"]] == false) then
						if (self.db.profile[frame.unit].debuffs[L["Grow Upwards"]] == false) then
							if (self.db.profile[frame.unit].buffs[L["Grow Upwards"]] == false) then
								frame.debuffs[1]:SetPoint("TOPLEFT", frame.buffs[index], "BOTTOMLEFT", 0, self.db.profile[frame.unit].buffs[L["Vertical Spacing"]])
							else
								frame.debuffs[1]:SetPoint("TOPLEFT", frame.buffs[1], "BOTTOMLEFT", 0, self.db.profile[frame.unit].buffs[L["Vertical Spacing"]])
							end
						else
							if (self.db.profile[frame.unit].buffs[L["Grow Upwards"]] == false) then
								frame.debuffs[1]:SetPoint("BOTTOMLEFT", frame.buffs[1], "TOPLEFT", 0, -1 * self.db.profile[frame.unit].buffs[L["Vertical Spacing"]])
							else
								frame.debuffs[1]:SetPoint("BOTTOMLEFT", frame.buffs[index], "TOPLEFT", 0, -1 * self.db.profile[frame.unit].buffs[L["Vertical Spacing"]])
							end
						end
					else
						if (self.db.profile[frame.unit].debuffs[L["Grow Upwards"]] == false) then
							if (self.db.profile[frame.unit].buffs[L["Grow Upwards"]] == false) then
								frame.debuffs[1]:SetPoint("TOPRIGHT", frame.buffs[index], "BOTTOMRIGHT", 0, self.db.profile[frame.unit].buffs[L["Vertical Spacing"]])
							else
								frame.debuffs[1]:SetPoint("TOPRIGHT", frame.buffs[1], "BOTTOMRIGHT", 0, self.db.profile[frame.unit].buffs[L["Vertical Spacing"]])
							end
						else
							if (self.db.profile[frame.unit].buffs[L["Grow Upwards"]] == false) then
								frame.debuffs[1]:SetPoint("BOTTOMRIGHT", frame.buffs[1], "TOPRIGHT", 0, -1 * self.db.profile[frame.unit].buffs[L["Vertical Spacing"]])

							else
								frame.debuffs[1]:SetPoint("BOTTOMRIGHT", frame.buffs[index], "TOPRIGHT", 0, -1 * self.db.profile[frame.unit].buffs[L["Vertical Spacing"]])
							end
						end
					end
				else
					self:GetInitialBuffAndDebuffAnchorPoint(frame, "debuffs", 1)
					local index = ceil(numDebuffs / self.db.profile[frame.unit].debuffs[L["Buffs Per Row"]]) * self.db.profile[frame.unit].debuffs[L["Buffs Per Row"]] - self.db.profile[frame.unit].debuffs[L["Buffs Per Row"]] + 1
					if (index < 1) then
						index = 1
					end
					if (self.db.profile[frame.unit].buffs[L["Expand Left"]] == false) then
						if (self.db.profile[frame.unit].buffs[L["Grow Upwards"]] == false) then
							if (self.db.profile[frame.unit].debuffs[L["Grow Upwards"]] == false) then
								frame.buffs[1]:SetPoint("TOPLEFT", frame.debuffs[index], "BOTTOMLEFT", 0, self.db.profile[frame.unit].debuffs[L["Vertical Spacing"]])
							else
								frame.buffs[1]:SetPoint("TOPLEFT", frame.debuffs[1], "BOTTOMLEFT", 0, self.db.profile[frame.unit].debuffs[L["Vertical Spacing"]])
							end
						else
							if (self.db.profile[frame.unit].debuffs[L["Grow Upwards"]] == false) then
								frame.buffs[1]:SetPoint("BOTTOMLEFT", frame.debuffs[1], "TOPLEFT", 0, -1 * self.db.profile[frame.unit].debuffs[L["Vertical Spacing"]])
							else
								frame.buffs[1]:SetPoint("BOTTOMLEFT", frame.debuffs[index], "TOPLEFT", 0, -1 * self.db.profile[frame.unit].debuffs[L["Vertical Spacing"]])
							end
						end
					else
						if (self.db.profile[frame.unit].buffs[L["Grow Upwards"]] == false) then
							if (self.db.profile[frame.unit].debuffs[L["Grow Upwards"]] == false) then
								frame.buffs[1]:SetPoint("TOPRIGHT", frame.debuffs[index], "BOTTOMRIGHT", 0, self.db.profile[frame.unit].debuffs[L["Vertical Spacing"]])
							else
								frame.buffs[1]:SetPoint("TOPRIGHT", frame.debuffs[1], "BOTTOMRIGHT", 0, self.db.profile[frame.unit].debuffs[L["Vertical Spacing"]])
							end
						else
							if (self.db.profile[frame.unit].debuffs[L["Grow Upwards"]] == false) then
								frame.buffs[1]:SetPoint("BOTTOMRIGHT", frame.debuffs[1], "TOPRIGHT", 0, -1 * self.db.profile[frame.unit].debuffs[L["Vertical Spacing"]])
							else
								frame.buffs[1]:SetPoint("BOTTOMRIGHT", frame.debuffs[index], "TOPRIGHT", 0, -1 * self.db.profile[frame.unit].debuffs[L["Vertical Spacing"]])
							end
						end
					end
				end
			end
		end

		if (unit == "player") then
			if (UnitClassBase("player") == "MONK") then
				if (C_SpecializationInfo.GetSpecializationInfo(C_SpecializationInfo.GetSpecialization()) == 268) then
					local unitsecondarypower = UnitStagger(unit)
					local unitsecondarypowermax = UnitHealthMax(unit)

					local roundedStagger = tonumber(string.format("%.0f", math.ceil(unitsecondarypower/unitsecondarypowermax)))

					frame.secondarypowerbar:SetMinMaxValues(0, 100)
					frame.secondarypowerbar:SetValue(roundedStagger)

					frame.currentmaxsecondarypowertext:SetText(roundedStagger.."/"..100)
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
end

-- function gUF:VOICE_START(event, unit)
-- 	if not frames[unit] then return end

-- 	for frame in pairs(frames[unit]) do
-- 		frame.speakericon:Show()
-- 		frame.speakersoundicon:Show()
-- 	end
-- end

-- function gUF:VOICE_STOP(event, unit)
-- 	if not frames[unit] then return end

-- 	for frame in pairs(frames[unit]) do
-- 		frame.speakericon:Hide()
-- 		frame.speakersoundicon:Hide()
-- 	end
-- end

function gUF:PLAYER_TARGET_CHANGED()
	if (UnitExists("target")) then
		self:UpdateFrameInfo("target")
	end
end

function gUF:PLAYER_REGEN_DISABLED(event)
	if (LibStub("AceConfigDialog-3.0"):Close("gUF")) then
		self:Print(L["Options cannot be changed in combat."])
	end
	if (self.db.profile.global[L["Config Mode"]] == true) then
		self.db.profile.global[L["Config Mode"]] = false
		-- Call stuff to get the frames back to normal
	end
	self:UpdateCombatRestIcon(event)
	if (gUF_player) then
		self:DragStop(gUF_player)
	end
	if (gUF_target) then
		self:DragStop(gUF_target)
	end
end

function gUF:PLAYER_REGEN_ENABLED(event)
	self:UpdateCombatRestIcon(event)
end

function gUF:PLAYER_UPDATE_RESTING(event)
	self:UpdateCombatRestIcon(event)
end

function gUF:ACTIVE_TALENT_GROUP_CHANGED(event)
	self:SetStyle(gUF_player, "player")
	self:UNIT_AURA(nil, "player")
end

function gUF:GROUP_ROSTER_UPDATE(event)
	self:UpdateLeader(nil)
	self:UpdateLootMethod()
end

function gUF:PARTY_LEADER_CHANGED(event)
	self:UpdateLeader(nil)
	self:UpdateLootMethod()
end

function gUF:PARTY_LOOT_METHOD_CHANGED(event)
	self:UpdateLootMethod()
end

function gUF:UpdateLeader(unit)
	if (unit == nil) then
		for i,v in pairs(frames) do
			for frame in pairs(v) do
				if (UnitIsGroupLeader(frame.unit)) then
					frame.leadericon:Show()
				else
					frame.leadericon:Hide()
				end
			end
		end
	else
		if not frames[unit] then return end

		for frame in pairs(frames[unit]) do
			if (UnitIsGroupLeader(frame.unit)) then
				frame.leadericon:Show()
			else
				frame.leadericon:Hide()
			end
		end
	end
end

function gUF:UpdateLootMethod()
	local _, masterLootPartyID = C_PartyInfo.GetLootMethod()

	if (masterLootPartyID == 0) then
		gUF_player.masterlootericon:Show()
		-- gUF_party1.masterlootericon:Hide()
		-- gUF_party2.masterlootericon:Hide()
		-- gUF_party3.masterlootericon:Hide()
		-- gUF_party4.masterlootericon:Hide()
	elseif (masterLootPartyID == 1) then
		gUF_player.masterlootericon:Hide()
		-- gUF_party1.masterlootericon:Show()
		-- gUF_party2.masterlootericon:Hide()
		-- gUF_party3.masterlootericon:Hide()
		-- gUF_party4.masterlootericon:Hide()
	elseif (masterLootPartyID == 2) then
		gUF_player.masterlootericon:Hide()
		-- gUF_party1.masterlootericon:Hide()
		-- gUF_party2.masterlootericon:Show()
		-- gUF_party3.masterlootericon:Hide()
		-- gUF_party4.masterlootericon:Hide()
	elseif (masterLootPartyID == 3) then
		gUF_player.masterlootericon:Hide()
		-- gUF_party1.masterlootericon:Hide()
		-- gUF_party2.masterlootericon:Hide()
		-- gUF_party3.masterlootericon:Show()
		-- gUF_party4.masterlootericon:Hide()
	elseif (masterLootPartyID == 4) then
		gUF_player.masterlootericon:Hide()
		-- gUF_party1.masterlootericon:Hide()
		-- gUF_party2.masterlootericon:Hide()
		-- gUF_party3.masterlootericon:Show()
		-- gUF_party4.masterlootericon:Hide()
	else
		gUF_player.masterlootericon:Hide()
		-- gUF_party1.masterlootericon:Hide()
		-- gUF_party2.masterlootericon:Hide()
		-- gUF_party3.masterlootericon:Hide()
		-- gUF_party4.masterlootericon:Hide()
	end
end

function gUF:FormatHealthPowerText(number)
	if (number < 9999) then
		return number
	elseif (number < 999999) then
		return string.format("%.1fk", number / 1000)
	elseif (number < 99999999) then
		return string.format("%.2fm", number / 1000000)
	end
	
	return string.format("%dm", number / 1000000)
end

function gUF:UpdateCombatRestIcon(event)
	local unit = "player"
	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		if (event == "PLAYER_REGEN_DISABLED") then
			frame.combatresticon:SetTexCoord(0.5, 1.0, 0.0, 0.5)
			frame.combatresticon:Show()
		elseif (IsResting()) then
			frame.combatresticon:SetTexCoord(0, 0.5, 0.0, 0.5)
			frame.combatresticon:Show()
		else
			frame.combatresticon:Hide()
		end
	end
end

function gUF:UpdateRaidIcon(frame)
	local raidTargetIconIndex = GetRaidTargetIndex(frame.unit)
	if (raidTargetIconIndex) then
		SetRaidTargetIconTexture(frame.raidicon, raidTargetIconIndex)
		frame.raidicon:Show()
	else
		frame.raidicon:Hide()
	end
end

function gUF:CooldownFrame_SetTimer(self, start, duration, enable, charges, maxCharges)
	if (enable and enable ~= 0) then
		self:SetCooldown(start, duration, charges, maxCharges)

		--self:SetCooldown(Duration, ExpirationTime)
		self:SetCooldownFromExpirationTime(duration, start)
	else
		self:SetCooldown(0, 0, charges, maxCharges)
	end
end

function gUF:EnableDisableModules()
	-- Wrap in an if statement to see if it really is enabled once options are built
	--self:EnableModule("CastBar")
end

function gUF:UpdateFrameInfo(unit)
	if not frames[unit] then return end

	for frame in pairs(frames[unit]) do
		if (UnitExists(unit)) then
			self:UNIT_NAME_UPDATE(nil, unit)
			self:UNIT_LEVEL(nil, unit)
			self:UNIT_MAXHEALTH(nil, unit)
			self:UNIT_DISPLAYPOWER(nil, unit)
			self:UNIT_FACTION(nil, unit)
			self:UNIT_PORTRAIT_UPDATE(nil, unit)
			self:UNIT_AURA(nil, unit)
			self:UpdateLeader(unit)
			self:UpdateRaidIcon(frame)

			local _, englishClass = UnitClass(unit)

			if (frame.classicon) then
				if (UnitIsPlayer(unit) and self.ClassIcon[englishClass] ~= nil) then			-- A player's class won't ever change so not using an event is fine
					frame.classicon:SetTexCoord(self.ClassIcon[englishClass][1], self.ClassIcon[englishClass][2], self.ClassIcon[englishClass][3], self.ClassIcon[englishClass][4])
					frame.classicon:Show()
				else
					frame.classicon:Hide()
				end
			end

			if (unit == "target") then
				if (UnitIsQuestBoss(unit)) then
					frame.questicon:Show()
				else
					frame.questicon:Hide()
				end
			end

			-- if (UnitIsTalking(UnitName(unit))) then
			-- 	self:VOICE_START(nil, unit)
			-- else
			-- 	self:VOICE_STOP(nil, unit)
			-- end

			if (unit == "player") then
				self:UpdateCombatRestIcon(nil)
			end
		end
	end
end

function gUF:SetStyleAllFrames()
	if (gUF_player) then
		self:SetStyle(gUF_player, "player")
	end
	if (gUF_target) then
		self:SetStyle(gUF_target, "target")
	end
end

function gUF:SetStyle(frame, unit)
	if (frame) then
		if (unit == "player") then
			frame.fkeytext:Hide()
			if (self.db.profile.player[L["Healer Mode"]] == true) then
				frame.deficithealthtext:Show()
				frame.deficitpowertext:Show()
				frame.deficitalternatepowertext:Show()
				frame.deficitsecondarypowertext:Show()
			else
				frame.deficithealthtext:Hide()
				frame.deficitpowertext:Hide()
			end

			frame.statsframe:SetHeight(42)

			local classFilename = UnitClassBase("player")
			local specializationInfo = C_SpecializationInfo.GetSpecializationInfo(C_SpecializationInfo.GetSpecialization())
			if (classFilename == "DRUID" or (classFilename == "PRIEST" and specializationInfo == 258) or (classFilename == "SHAMAN" and specializationInfo == 262)) then		-- Do we need to display the extra mana bar and make the stats frame bigger?
				frame.statsframe:SetHeight(frame.statsframe:GetHeight() + 12)

				frame.alternatepowerbar:Show()
				frame.alternatepowerbarbg:Show()
				frame.alternatepowerbaroverlay:Show()
				frame.currentmaxalternatepowertext:Show()
				frame.percentalternatepowertext:Show()
				--frame.deficitalternatepowertext:Show()

				--self:UNIT_POWER_FREQUENT(nil, unit)
			else
				frame.alternatepowerbar:Hide()
				frame.alternatepowerbarbg:Hide()
				frame.alternatepowerbaroverlay:Hide()
				frame.currentmaxalternatepowertext:Hide()
				frame.percentalternatepowertext:Hide()
				frame.deficitalternatepowertext:Hide()
			end

			if (classFilename == "DRUID" or classFilename == "EVOKER" or (classFilename == "MAGE" and specializationInfo == 62) or (classFilename == "MONK" and (specializationInfo == 268 or specializationInfo == 269)) or classFilename == "PALADIN" or (classFilename == "PRIEST" and specializationInfo == 258) or classFilename == "ROGUE" or (classFilename == "SHAMAN" and specializationInfo == 262) or classFilename == "WARLOCK") then		-- Do we need to display the class resource bar and make the stats frame bigger?
				frame.statsframe:SetHeight(frame.statsframe:GetHeight() + 12)
				if (frame.alternatepowerbar:IsVisible() == false) then
					frame.secondarypowerbar:SetPoint("TOPLEFT", frame.statsframe, "TOPLEFT", 10, -34)

					frame.secondarypowerbar:Show()
					frame.secondarypowerbarbg:Show()
					frame.secondarypowerbaroverlay:Show()
					frame.currentmaxsecondarypowertext:Show()
					frame.percentsecondarypowertext:Show()
					--frame.deficitsecondarypowertext:Show()
				end
			else
				frame.secondarypowerbar:Hide()
				frame.secondarypowerbarbg:Hide()
				frame.secondarypowerbaroverlay:Hide()
				frame.currentmaxsecondarypowertext:Hide()
				frame.percentsecondarypowertext:Hide()
				frame.deficitsecondarypowertext:Hide()
			end
		end

		if (unit == "target") then
			frame.fkeytext:Hide()
			if (self.db.profile.target[L["Healer Mode"]] == true) then
				frame.deficithealthtext:Show()
				frame.deficitpowertext:Show()
			else
				frame.deficithealthtext:Hide()
				frame.deficitpowertext:Hide()
			end
		end

		self:SetupBorderBackground(frame)
		self:SetupStatusBarTextures(frame)
		self:SetupStatusBarBackgroundTextures(frame)
		self:SetupBarColors(frame)
	end
end

function gUF:CreateRemoveFrames()
	if (self.db.profile.player[L["Enabled"]] == true) then			-- Create the Player frame
		if (not gUF_player) then
			self:CreateFrame("normal", "gUF_player", "player")
		else
			self:RegisterFrame(gUF_player, "player")
		end
		self:SetStyle(gUF_player, "player")							-- Apply any option changes
		self:UpdateFrameInfo("player")								-- Update the frame's information
	else
		if (gUF_player) then
			self:RemoveFrame(gUF_player)
		end
	end

	if (self.db.profile.target[L["Enabled"]] == true) then			-- Create the Target frame
		if (not gUF_target) then
			self:CreateFrame("target", "gUF_target", "target")
		else
			self:RegisterFrame(gUF_target, "target")
		end
		self:SetStyle(gUF_target, "target")							-- Apply any option changes
		self:UpdateFrameInfo("target")								-- Update the frame's information
	else
		if (gUF_target) then
			self:RemoveFrame(gUF_target)
		end
	end
end

function gUF:GetDebuffNumberForFrame(unit)
	if (unit == "target") then
		return 40
	else
		return 20
	end
end

function gUF:CreateFrame(frametemplate, framename, unit)
	local frame

	if (frametemplate == "normal") then
		frame = self:CreateBaseFrameObject(framename, unit)

		-- remove this once we have a full option set for customizing this
		frame.currentmaxhealthtext:SetTextColor(1, 1, 1, 1)
		frame.currentmaxpowertext:SetTextColor(1, 1, 1, 1)
		frame.percenthealthtext:SetTextColor(1, 1, 1, 1)
		frame.percentpowertext:SetTextColor(1, 1, 1, 1)
		frame.deficithealthtext:SetTextColor(1, 1, 1, 1)
		frame.deficitpowertext:SetTextColor(1, 1, 1, 1)
		if (unit == "player") then
			frame.currentmaxalternatepowertext:SetTextColor(1, 1, 1, 1)
			frame.percentalternatepowertext:SetTextColor(1, 1, 1, 1)
			frame.deficitalternatepowertext:SetTextColor(1, 1, 1, 1)
			frame.currentmaxsecondarypowertext:SetTextColor(1, 1, 1, 1)
			frame.percentsecondarypowertext:SetTextColor(1, 1, 1, 1)
			frame.deficitsecondarypowertext:SetTextColor(1, 1, 1, 1)
		end
		-- remove this once we have a full option set for customizing this

		self:LayoutBuffs(frame, nil, "buffs")			-- move this to someplace else later
		self:LayoutBuffs(frame, nil, "debuffs")			-- move this to someplace else later

		self:SetupOverlays(frame)						-- Set up the overlay buttons so clicking works (can move this most liekly too)

		frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.db.profile[frame.unit][L["Position"]].x, self.db.profile[frame.unit][L["Position"]].y)
		frame:Show()									-- Remove this once we have a few frames ready to go, it's handled by the frame's secureheader unit stuff anyway
	elseif (frametemplate == "target") then
		frame = self:CreateBaseOfTargetFrameObject(framename, unit)

		-- remove this once we have a full option set for customizing this
		frame.currentmaxhealthtext:SetTextColor(1, 1, 1, 1)
		frame.currentmaxpowertext:SetTextColor(1, 1, 1, 1)
		frame.percenthealthtext:SetTextColor(1, 1, 1, 1)
		frame.percentpowertext:SetTextColor(1, 1, 1, 1)
		frame.deficithealthtext:SetTextColor(1, 1, 1, 1)
		frame.deficitpowertext:SetTextColor(1, 1, 1, 1)
		-- remove this once we have a full option set for customizing this

		self:LayoutBuffs(frame, nil, "buffs")			-- move this to someplace else later
		self:LayoutBuffs(frame, nil, "debuffs")			-- move this to someplace else later

		self:SetupOverlays(frame)						-- Set up the overlay buttons so clicking works (can move this most liekly too)

		frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.db.profile[frame.unit][L["Position"]].x, self.db.profile[frame.unit][L["Position"]].y)
		frame:Show()									-- Remove this once we have a few frames ready to go, it's handled by the frame's secureheader unit stuff anyway
	elseif (frametemplate == "oftarget") then

	elseif (frametemplate == "pet") then

	end

	self:RegisterFrame(frame, unit)
end

function gUF:LayoutBuffs(frame, unit, buffType)
	if (frame == nil) then
		frame = _G["gUF_"..unit]
	end
	local j = 1
	local k
	if (buffType == "debuffs") then
		k = self:GetDebuffNumberForFrame(frame.unit)
	else
		k = 20
	end
	for i=1,k do
		frame[buffType][i]:ClearAllPoints()
		if (i == 1) then
			self:GetInitialBuffAndDebuffAnchorPoint(frame, buffType, i)
		else
			if ((j - 1) == self.db.profile[frame.unit][buffType][L["Buffs Per Row"]]) then
				if (self.db.profile[frame.unit][buffType][L["Grow Upwards"]] == true) then
					frame[buffType][i]:SetPoint("BOTTOMLEFT", frame[buffType][i - self.db.profile[frame.unit][buffType][L["Buffs Per Row"]]], "TOPLEFT", 0, -1 * self.db.profile[frame.unit][buffType][L["Vertical Spacing"]])
				else
					frame[buffType][i]:SetPoint("TOPLEFT", frame[buffType][i - self.db.profile[frame.unit][buffType][L["Buffs Per Row"]]], "BOTTOMLEFT", 0, self.db.profile[frame.unit][buffType][L["Vertical Spacing"]])
				end
				j = 1
			else
				if (self.db.profile[frame.unit][buffType][L["Expand Left"]] == true) then
					frame[buffType][i]:SetPoint("TOPRIGHT", frame[buffType][i - 1], "TOPLEFT", self.db.profile[frame.unit][buffType][L["Horizontal Spacing"]], 0)
				else
					frame[buffType][i]:SetPoint("TOPLEFT", frame[buffType][i - 1], "TOPRIGHT", self.db.profile[frame.unit][buffType][L["Horizontal Spacing"]], 0)
				end
			end
		end
		j = j + 1
	end
end

function gUF:GetInitialBuffAndDebuffAnchorPoint(frame, buffType, buffIndex)
	if (self.db.profile[frame.unit][buffType][L["Position"]] == 1) then
		if (frame.unit == "player") then
			--frame[buffType][buffIndex]:SetPoint("TOPLEFT", frame.levelframe, "BOTTOMLEFT", 0 + self.db.profile[frame.unit][buffType][L["X Offset"]], 0 + self.db.profile[frame.unit][buffType][L["Y Offset"]])
			frame[buffType][buffIndex]:SetPoint("TOPLEFT", frame.statsframe, "BOTTOMLEFT", 0 + self.db.profile[frame.unit][buffType][L["X Offset"]], 0 + self.db.profile[frame.unit][buffType][L["Y Offset"]])
		elseif (frame.unit == "target") then
			frame[buffType][buffIndex]:SetPoint("TOPLEFT", frame.statsframe, "BOTTOMLEFT", 0 + self.db.profile[frame.unit][buffType][L["X Offset"]], 0 + self.db.profile[frame.unit][buffType][L["Y Offset"]])
		end
	elseif (self.db.profile[frame.unit][buffType][L["Position"]] == 2) then
		frame[buffType][buffIndex]:SetPoint("TOPRIGHT", frame.statsframe, "BOTTOMRIGHT", 0 + self.db.profile[frame.unit][buffType][L["X Offset"]], 0 + self.db.profile[frame.unit][buffType][L["Y Offset"]])
	elseif (self.db.profile[frame.unit][buffType][L["Position"]] == 3) then
		if (frame.unit == "player") then
			--frame[buffType][buffIndex]:SetPoint("TOPRIGHT", frame.levelframe, "BOTTOMLEFT", 0 + self.db.profile[frame.unit][buffType][L["X Offset"]], 33 + self.db.profile[frame.unit][buffType][L["Y Offset"]])
			frame[buffType][buffIndex]:SetPoint("TOPRIGHT", frame.statsframe, "BOTTOMLEFT", 0 + self.db.profile[frame.unit][buffType][L["X Offset"]], 33 + self.db.profile[frame.unit][buffType][L["Y Offset"]])
		elseif (frame.unit == "target") then
			frame[buffType][buffIndex]:SetPoint("TOPRIGHT", frame.statsframe, "BOTTOMLEFT", 0 + self.db.profile[frame.unit][buffType][L["X Offset"]], 33 + self.db.profile[frame.unit][buffType][L["Y Offset"]])
		end
	elseif (self.db.profile[frame.unit][buffType][L["Position"]] == 4) then
		frame[buffType][buffIndex]:SetPoint("TOPLEFT", frame.statsframe, "BOTTOMRIGHT", 0 + self.db.profile[frame.unit][buffType][L["X Offset"]], 33 + self.db.profile[frame.unit][buffType][L["Y Offset"]])
	elseif (self.db.profile[frame.unit][buffType][L["Position"]] == 5) then
		frame[buffType][buffIndex]:SetPoint("BOTTOMLEFT", frame.nameframe, "TOPLEFT", 0 + self.db.profile[frame.unit][buffType][L["X Offset"]], 0 + self.db.profile[frame.unit][buffType][L["Y Offset"]])
	elseif (self.db.profile[frame.unit][buffType][L["Position"]] == 6) then
		frame[buffType][buffIndex]:SetPoint("BOTTOMLEFT", frame.nameframe, "TOPRIGHT", 0 + self.db.profile[frame.unit][buffType][L["X Offset"]], 0 + self.db.profile[frame.unit][buffType][L["Y Offset"]])
	end
end

function gUF:ResetBuffsAndDebuffs(unit)
	local frame = _G["gUF_"..unit]
	for i=1,20 do
		self:CooldownFrame_SetTimer(frame.buffs[i].cooldown, 0, 0, 0)
		frame.buffs[i].cooldown:Hide()
		frame.buffs[i]:Hide()
	end

	local j = self:GetDebuffNumberForFrame(frame.unit)
	for i=1,j do
		self:CooldownFrame_SetTimer(frame.debuffs[i].cooldown, 0, 0, 0)
		frame.debuffs[i].cooldown:Hide()
		frame.debuffs[i]:Hide()
	end
end

-- /script perltestthree()
-- function perltestthree()
-- 	for i,v in ipairs(gUF_player.buffs) do gUF:Print(i,v) end
-- end

-- --/script guftest2()
-- function guftest2()
-- 	--CastBar:CreateRemoveFrames()
-- 	gUF:Print( gUF_player.arcanebar:GetValue() )
-- end

-- function gUF:GetActiveUnitFrameNames()
-- 	local framenames = {}
-- 	for i,v in pairs(frames) do
-- 		for frame in pairs(v) do
-- 			table.insert(framenames, tostring(frame:GetName()))
-- 			--table.insert(framenames, tostring(frame.nameframeoverlay:GetName()))
-- 			--table.insert(framenames, frame)
-- 		end
-- 	end
-- 	return framenames
-- end

function gUF:GetActiveUnitFrames()					-- Used in modules
	return frames
end

function gUF:RegisterFrame(frame, unit)
	frame:SetAttribute("unit", unit)				-- Next 4 lines probably needs moving later
	RegisterUnitWatch(frame)
	frames[unit] = frames[unit] or {}
	frames[unit][frame] = true
end

function gUF:RemoveFrame(frame)
	frames[frame.unit][frame] = nil
	UnregisterUnitWatch(frame)
	frame:Hide()
end

function gUF:SetupOverlays(frame)
	for i=1,#frame.frameoverlays,1 do
		frame.frameoverlays[i]:SetFrameLevel(frame.frameoverlays[i]:GetParent():GetFrameLevel() + 2)
	end
	for i=1,#frame.baroverlays,1 do
		frame.baroverlays[i]:SetFrameLevel(frame.baroverlays[i]:GetParent():GetFrameLevel() + 3)
	end
end

function gUF:SetupAllBorderBackground()
	for i,v in pairs(frames) do
		for frame in pairs(v) do
			self:SetupBorderBackground(frame)
		end
	end
end

function gUF:SetupBorderBackground(frame)
	for i=1,#frame.frames,1 do
		frame.frames[i]:SetBackdrop({bgFile = "Interface\\AddOns\\gUF\\Images\\gUF_FrameBack", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = {left = 3, right = 3, top = 3, bottom = 3}})	-- Thanks Zek for the background file help
		frame.frames[i]:SetBackdropColor(self.db.profile.global[L["Background Color"]].r, self.db.profile.global[L["Background Color"]].g, self.db.profile.global[L["Background Color"]].b, self.db.profile.global[L["Background Color"]].a)
		frame.frames[i]:SetBackdropBorderColor(self.db.profile.global[L["Border Color"]].r, self.db.profile.global[L["Border Color"]].g, self.db.profile.global[L["Border Color"]].b, self.db.profile.global[L["Border Color"]].a)
	end
end

function gUF:SetupAllStatusBarTextures()
	for i,v in pairs(frames) do
		for frame in pairs(v) do
			self:SetupStatusBarTextures(frame)
		end
	end
end

function gUF:SetupStatusBarTextures(frame)
	local texture = self.LSM:Fetch(self.LSM.MediaType.STATUSBAR, self.db.profile.global[L["Status Bar Texture"]])
	--local texture = self.LSM:Fetch("statusbar", self.db.profile.global[L["Status Bar Texture"]])
	--texture:SetPoint("TOPLEFT", frame.healthbar, "TOPLEFT", -1,1)
	--texture:SetPoint("BOTTOMRIGHT", frame.healthbar, "BOTTOMRIGHT", 1, -1)
	--texture:SetHeight(10)
	--texture:SetWidth(150)
	--frame.bartextures[1] = self.LSM:Fetch("statusbar", self.db.profile.global[L["Status Bar Texture"]])
	for i=1,#frame.bars,1 do
		--frame.bars[i]:SetMinMaxValues(0, 1)
		frame.bars[i]:SetStatusBarTexture(texture)
		--frame.bars[i]:SetStatusBarTexture(frame.bartextures[1])
		--frame.bartextures[i]:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
		frame.bars[i]:GetStatusBarTexture():SetHorizTile(false)
		frame.bars[i]:GetStatusBarTexture():SetVertTile(false)
	end
	--frame.healthbar:SetStatusBarColor(self.db.profile.global[L["Health Bar Color"]].r, self.db.profile.global[L["Health Bar Color"]].g, self.db.profile.global[L["Health Bar Color"]].b, self.db.profile.global[L["Health Bar Color"]].a)
	--frame.healthbarbg:SetStatusBarColor(self.db.profile.global[L["Health Bar Color"]].r, self.db.profile.global[L["Health Bar Color"]].g, self.db.profile.global[L["Health Bar Color"]].b, self.db.profile.global[L["Health Bar Color"]].a * 0.25)
end

function gUF:SetupAllStatusBarBackgroundTextures()
	for i,v in pairs(frames) do
		for frame in pairs(v) do
			self:SetupStatusBarBackgroundTextures(frame)
		end
	end
end

function gUF:SetupStatusBarBackgroundTextures(frame)
	--local texture = self.LSM:Fetch(self.LSM.MediaType.STATUSBAR, self.db.profile.global[L["Status Bar Background Texture"]])
	local texture = self.LSM:Fetch("statusbar", self.db.profile.global[L["Status Bar Background Texture"]])
	--texture:SetHeight(10)
	--texture:SetWidth(150)
	for i=1,#frame.barbackgrounds,1 do
		--frame.barbackgrounds[i]:SetMinMaxValues(0, 1)
		--frame.barbackgrounds[i]:SetStatusBarTexture(texture)
		frame.barbackgrounds[i]:SetStatusBarTexture(texture)
		--frame.bartextures[i]:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
		frame.barbackgrounds[i]:GetStatusBarTexture():SetHorizTile(false)
		frame.barbackgrounds[i]:GetStatusBarTexture():SetVertTile(false)
	end
end

function gUF:InitializeBarColorArray()
	self.BarColor = {
		[0] = self.db.profile.global[L["Mana Bar Color"]],
		[1] = self.db.profile.global[L["Rage Bar Color"]],
		[2] = self.db.profile.global[L["Focus Bar Color"]],
		[3] = self.db.profile.global[L["Energy Bar Color"]],
		[4] = self.db.profile.global[L["Combo Points Bar Color"]],
		[5] = self.db.profile.global[L["Runes Bar Color"]],
		[6] = self.db.profile.global[L["Runic Power Bar Color"]],
		[7] = self.db.profile.global[L["Soul Shards Bar Color"]],
		[8] = self.db.profile.global[L["Astral Power Bar Color"]],
		[9] = self.db.profile.global[L["Holy Power Bar Color"]],
		[11] = self.db.profile.global[L["Maelstrom Bar Color"]],
		[12] = self.db.profile.global[L["Chi Bar Color"]],
		[13] = self.db.profile.global[L["Insanity Bar Color"]],
		[16] = self.db.profile.global[L["Arcane Charges Bar Color"]],
		[17] = self.db.profile.global[L["Fury Bar Color"]],
		[18] = self.db.profile.global[L["Pain Bar Color"]],
		[19] = self.db.profile.global[L["Essence Bar Color"]],
	}
end

function gUF:SetupAllBarColors()
	self:InitializeBarColorArray()

	for i,v in pairs(frames) do
		for frame in pairs(v) do
			self:SetupBarColors(frame)
		end
	end
end

function gUF:SetupBarColors(frame)
	frame.healthbar:SetStatusBarColor(self.db.profile.global[L["Health Bar Color"]].r, self.db.profile.global[L["Health Bar Color"]].g, self.db.profile.global[L["Health Bar Color"]].b, self.db.profile.global[L["Health Bar Color"]].a)
	frame.healthbarbg:SetStatusBarColor(self.db.profile.global[L["Health Bar Color"]].r, self.db.profile.global[L["Health Bar Color"]].g, self.db.profile.global[L["Health Bar Color"]].b, self.db.profile.global[L["Health Bar Color"]].a * 0.25)
	if (frame.unit == "player") then
		frame.alternatepowerbar:SetStatusBarColor(self.db.profile.global[L["Mana Bar Color"]].r, self.db.profile.global[L["Mana Bar Color"]].g, self.db.profile.global[L["Mana Bar Color"]].b, self.db.profile.global[L["Mana Bar Color"]].a)
		frame.alternatepowerbarbg:SetStatusBarColor(self.db.profile.global[L["Mana Bar Color"]].r, self.db.profile.global[L["Mana Bar Color"]].g, self.db.profile.global[L["Mana Bar Color"]].b, self.db.profile.global[L["Mana Bar Color"]].a * 0.25)

		if (UnitClassBase("player") == "DRUID" or UnitClassBase("player") == "ROGUE") then
			frame.secondarypowerbar:SetStatusBarColor(self.db.profile.global[L["Combo Points Bar Color"]].r, self.db.profile.global[L["Combo Points Bar Color"]].g, self.db.profile.global[L["Combo Points Bar Color"]].b, self.db.profile.global[L["Combo Points Bar Color"]].a)
			frame.secondarypowerbarbg:SetStatusBarColor(self.db.profile.global[L["Combo Points Bar Color"]].r, self.db.profile.global[L["Combo Points Bar Color"]].g, self.db.profile.global[L["Combo Points Bar Color"]].b, self.db.profile.global[L["Combo Points Bar Color"]].a * 0.25)
		end
		if (UnitClassBase("player") == "EVOKER") then
			frame.secondarypowerbar:SetStatusBarColor(self.db.profile.global[L["Essence Bar Color"]].r, self.db.profile.global[L["Essence Bar Color"]].g, self.db.profile.global[L["Essence Bar Color"]].b, self.db.profile.global[L["Essence Bar Color"]].a)
			frame.secondarypowerbarbg:SetStatusBarColor(self.db.profile.global[L["Essence Bar Color"]].r, self.db.profile.global[L["Essence Bar Color"]].g, self.db.profile.global[L["Essence Bar Color"]].b, self.db.profile.global[L["Essence Bar Color"]].a * 0.25)
		end
		if (UnitClassBase("player") == "MAGE") then
			frame.secondarypowerbar:SetStatusBarColor(self.db.profile.global[L["Arcane Charges Bar Color"]].r, self.db.profile.global[L["Arcane Charges Bar Color"]].g, self.db.profile.global[L["Arcane Charges Bar Color"]].b, self.db.profile.global[L["Arcane Charges Bar Color"]].a)
			frame.secondarypowerbarbg:SetStatusBarColor(self.db.profile.global[L["Arcane Charges Bar Color"]].r, self.db.profile.global[L["Arcane Charges Bar Color"]].g, self.db.profile.global[L["Arcane Charges Bar Color"]].b, self.db.profile.global[L["Arcane Charges Bar Color"]].a * 0.25)
		end
		if (UnitClassBase("player") == "MONK") then
			frame.secondarypowerbar:SetStatusBarColor(self.db.profile.global[L["Chi Bar Color"]].r, self.db.profile.global[L["Chi Bar Color"]].g, self.db.profile.global[L["Chi Bar Color"]].b, self.db.profile.global[L["Chi Bar Color"]].a)
			frame.secondarypowerbarbg:SetStatusBarColor(self.db.profile.global[L["Chi Bar Color"]].r, self.db.profile.global[L["Chi Bar Color"]].g, self.db.profile.global[L["Chi Bar Color"]].b, self.db.profile.global[L["Chi Bar Color"]].a * 0.25)
		end
		if (UnitClassBase("player") == "PALADIN") then
			frame.secondarypowerbar:SetStatusBarColor(self.db.profile.global[L["Holy Power Bar Color"]].r, self.db.profile.global[L["Holy Power Bar Color"]].g, self.db.profile.global[L["Holy Power Bar Color"]].b, self.db.profile.global[L["Holy Power Bar Color"]].a)
			frame.secondarypowerbarbg:SetStatusBarColor(self.db.profile.global[L["Holy Power Bar Color"]].r, self.db.profile.global[L["Holy Power Bar Color"]].g, self.db.profile.global[L["Holy Power Bar Color"]].b, self.db.profile.global[L["Holy Power Bar Color"]].a * 0.25)
		end
		if (UnitClassBase("player") == "WARLOCK") then
			frame.secondarypowerbar:SetStatusBarColor(self.db.profile.global[L["Soul Shards Bar Color"]].r, self.db.profile.global[L["Soul Shards Bar Color"]].g, self.db.profile.global[L["Soul Shards Bar Color"]].b, self.db.profile.global[L["Soul Shards Bar Color"]].a)
			frame.secondarypowerbarbg:SetStatusBarColor(self.db.profile.global[L["Soul Shards Bar Color"]].r, self.db.profile.global[L["Soul Shards Bar Color"]].g, self.db.profile.global[L["Soul Shards Bar Color"]].b, self.db.profile.global[L["Soul Shards Bar Color"]].a * 0.25)
		end
	end
	self:UNIT_DISPLAYPOWER(nil, frame.unit)
end


--------------------
-- Click Handlers --
--------------------
function gUF:DragStart(frame)
	if (gUF.db.profile.global[L["Lock Frames"]] == false) then
		if (InCombatLockdown() == false) then
			frame:StartMoving()
		end
	end
end

function gUF:DragStop(frame)
	if (InCombatLockdown() == false) then
		frame:StopMovingOrSizing()
		gUF.db.profile[frame.unit][L["Position"]].x = floor(frame:GetLeft() + 0.5)
		gUF.db.profile[frame.unit][L["Position"]].y = floor(frame:GetTop() - (UIParent:GetTop() / frame:GetScale()) + 0.5)
	end
end

function gUF:Overlay_OnLoad(frame, overlay, unit)
	overlay:SetAttribute("unit", unit)				-- Assign the Overlay frame a unit (eg. player, party1, target)

	overlay:SetAttribute("*type1", "target")		-- Any left click will target the unit in the given frame
	overlay:SetAttribute("*type2", "togglemenu")	-- Any right click will open the unit menu for the unit in the given frame
	overlay:SetAttribute("type2", "togglemenu")		-- Right click will open the unit menu for the unit in the given frame

	if (not ClickCastFrames) then					-- Clique standard click casting support
		ClickCastFrames = {}
	end
	ClickCastFrames[overlay] = true
end


-------------
-- Tooltip --
-------------
function gUF:BuffTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:SetUnitBuff(self.unit, self.id, displaycastablebuffs)		-- change the displaycastablebuffs argument name
end

function gUF:DebuffTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:SetUnitDebuff(self.unit, self.id, displaycastabledebuffs)	-- change the displaycastablebuffs argument name
end
