local pcUF = LibStub("AceAddon-3.0"):GetAddon("pcUF")
local L = LibStub("AceLocale-3.0"):GetLocale("pcUF", true)

function pcUF:CreateBaseFrameObject(framename, unit)										-- Player and Party frames
	-- Create the unit frame object
	local frame = CreateFrame("Frame", framename, UIParent, nil)
	frame:SetFrameStrata("LOW")
	frame:SetMovable(true)
	frame:SetHeight(1)
	frame:SetWidth(1)

	-- Assign the unit to the frame
	frame.unit = unit

	-- Frames
	frame.nameframe = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")	--remove this final and if classic ever gets this API
	frame.nameframe:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)							-- remove this once we have a full option set for customizing this
	frame.nameframe:SetHeight(24)														-- remove this once we have a full option set for customizing this
	frame.nameframe:SetWidth(200)														-- remove this once we have a full option set for customizing this

	frame.levelframe = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")	--remove this final and if classic ever gets this API
	frame.levelframe:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -22)						-- remove this once we have a full option set for customizing this
	frame.levelframe:SetHeight(42)														-- remove this once we have a full option set for customizing this
	frame.levelframe:SetWidth(34)														-- remove this once we have a full option set for customizing this

	frame.statsframe = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")	--remove this final and if classic ever gets this API
	frame.statsframe:SetPoint("TOPLEFT", frame, "TOPLEFT", 32, -22)						-- remove this once we have a full option set for customizing this
	frame.statsframe:SetHeight(42)														-- remove this once we have a full option set for customizing this
	frame.statsframe:SetWidth(280)														-- remove this once we have a full option set for customizing this

	frame.portraitframe = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")	--remove this final and if classic ever gets this API
	frame.portraitframe:SetPoint("TOPRIGHT", frame.nameframe, "TOPLEFT", 2, 0)			-- remove this once we have a full option set for customizing this
	frame.portraitframe:SetHeight(64)													-- remove this once we have a full option set for customizing this
	frame.portraitframe:SetWidth(64)													-- remove this once we have a full option set for customizing this

	-- Bars
	frame.healthbar = CreateFrame("StatusBar", nil, frame, nil)
	frame.healthbar:SetPoint("TOPLEFT", frame.statsframe, "TOPLEFT", 10, -10)			-- remove this once we have a full option set for customizing this
	frame.healthbar:SetHeight(10)														-- remove this once we have a full option set for customizing this
	frame.healthbar:SetWidth(150)														-- remove this once we have a full option set for customizing this

	frame.healthbarbg = CreateFrame("StatusBar", nil, frame, nil)
	frame.healthbarbg:SetPoint("TOP", frame.healthbar, "TOP", 0, 0)
	frame.healthbarbg:SetHeight(10)														-- remove this once we have a full option set for customizing this
	frame.healthbarbg:SetWidth(150)														-- remove this once we have a full option set for customizing this

	frame.powerbar = CreateFrame("StatusBar", nil, frame, nil)
	frame.powerbar:SetPoint("TOPLEFT", frame.statsframe, "TOPLEFT", 10, -22)			-- remove this once we have a full option set for customizing this
	frame.powerbar:SetHeight(10)														-- remove this once we have a full option set for customizing this
	frame.powerbar:SetWidth(150)														-- remove this once we have a full option set for customizing this

	frame.powerbarbg = CreateFrame("StatusBar", nil, frame, nil)
	frame.powerbarbg:SetPoint("TOP", frame.powerbar, "TOP", 0, 0)
	frame.powerbarbg:SetHeight(10)														-- remove this once we have a full option set for customizing this
	frame.powerbarbg:SetWidth(150)														-- remove this once we have a full option set for customizing this

	if (unit == "player") then
		frame.alternatepowerbar = CreateFrame("StatusBar", nil, frame, nil)
		frame.alternatepowerbar:SetPoint("TOPLEFT", frame.statsframe, "TOPLEFT", 10, -34)			-- remove this once we have a full option set for customizing this
		frame.alternatepowerbar:SetHeight(10)														-- remove this once we have a full option set for customizing this
		frame.alternatepowerbar:SetWidth(150)														-- remove this once we have a full option set for customizing this

		frame.alternatepowerbarbg = CreateFrame("StatusBar", nil, frame, nil)
		frame.alternatepowerbarbg:SetPoint("TOP", frame.alternatepowerbar, "TOP", 0, 0)
		frame.alternatepowerbarbg:SetHeight(10)														-- remove this once we have a full option set for customizing this
		frame.alternatepowerbarbg:SetWidth(150)														-- remove this once we have a full option set for customizing this

		frame.secondarypowerbar = CreateFrame("StatusBar", nil, frame, nil)
		frame.secondarypowerbar:SetPoint("TOPLEFT", frame.statsframe, "TOPLEFT", 10, -46)			-- remove this once we have a full option set for customizing this
		frame.secondarypowerbar:SetHeight(10)														-- remove this once we have a full option set for customizing this
		frame.secondarypowerbar:SetWidth(150)														-- remove this once we have a full option set for customizing this

		frame.secondarypowerbarbg = CreateFrame("StatusBar", nil, frame, nil)
		frame.secondarypowerbarbg:SetPoint("TOP", frame.secondarypowerbar, "TOP", 0, 0)
		frame.secondarypowerbarbg:SetHeight(10)														-- remove this once we have a full option set for customizing this
		frame.secondarypowerbarbg:SetWidth(150)														-- remove this once we have a full option set for customizing this
	end

	-- Overlays
	frame.nameframeoverlay = self:CreateOverlay(frame, frame.nameframe, "_NameFrameOverlay")
	frame.levelframeoverlay = self:CreateOverlay(frame, frame.levelframe, "_LevelFrameOverlay")
	frame.statsframeoverlay = self:CreateOverlay(frame, frame.statsframe, "_StatsFrameOverlay")
	frame.portraitframeoverlay = self:CreateOverlay(frame, frame.portraitframe, "_PortraitFrameOverlay")
	frame.healthbaroverlay = self:CreateOverlay(frame, frame.healthbar, "_HealthBarOverlay")
	frame.powerbaroverlay = self:CreateOverlay(frame, frame.powerbar, "_PowerbarOverlay")
	if (unit == "player") then
		frame.alternatepowerbaroverlay = self:CreateOverlay(frame, frame.alternatepowerbar, "_AlternatePowerbarOverlay")
		frame.secondarypowerbaroverlay = self:CreateOverlay(frame, frame.secondarypowerbar, "_SecondaryPowerbarOverlay")
	end

	-- Text Fields
	frame.fkeytext = frame.nameframe:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.fkeytext:SetPoint("TOPRIGHT", frame.nameframe, "TOPRIGHT", -8, -6)			-- remove this once we have a full option set for customizing this

	frame.leveltext = frame.levelframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.leveltext:SetPoint("BOTTOM", frame.levelframe, "BOTTOM", 0, 4)				-- remove this once we have a full option set for customizing this

	frame.nametext = frame.nameframe:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.nametext:SetWidth(frame.nametext:GetParent():GetWidth() - 10)
	frame.nametext:SetHeight(frame.nametext:GetParent():GetHeight())
	frame.nametext:SetNonSpaceWrap(false)
	frame.nametext:SetWordWrap(false)
	frame.nametext:SetPoint("CENTER", frame.nameframe, "CENTER", 0, 0)					-- remove this once we have a full option set for customizing this

	frame.currentmaxhealthtext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.currentmaxhealthtext:SetPoint("RIGHT", frame.healthbar, "RIGHT", 110, 0)		-- remove this once we have a full option set for customizing this

	frame.currentmaxpowertext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.currentmaxpowertext:SetPoint("RIGHT", frame.powerbar, "RIGHT", 110, 0)		-- remove this once we have a full option set for customizing this

	frame.percenthealthtext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.percenthealthtext:SetPoint("TOP", frame.healthbar, "TOP", 0, 1)				-- remove this once we have a full option set for customizing this

	frame.percentpowertext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.percentpowertext:SetPoint("TOP", frame.powerbar, "TOP", 0, 1)					-- remove this once we have a full option set for customizing this

	frame.deficithealthtext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.deficithealthtext:SetPoint("RIGHT", frame.healthbar, "RIGHT", 100, 0)			-- remove this once we have a full option set for customizing this

	frame.deficitpowertext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.deficitpowertext:SetPoint("RIGHT", frame.powerbar, "RIGHT", 100, 0)			-- remove this once we have a full option set for customizing this

	if (unit == "player") then
		frame.currentmaxalternatepowertext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		frame.currentmaxalternatepowertext:SetPoint("RIGHT", frame.alternatepowerbar, "RIGHT", 110, 0)		-- remove this once we have a full option set for customizing this

		frame.percentalternatepowertext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		frame.percentalternatepowertext:SetPoint("TOP", frame.alternatepowerbar, "TOP", 0, 1)					-- remove this once we have a full option set for customizing this

		frame.deficitalternatepowertext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		frame.deficitalternatepowertext:SetPoint("RIGHT", frame.alternatepowerbar, "RIGHT", 100, 0)			-- remove this once we have a full option set for customizing this

		frame.currentmaxsecondarypowertext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		frame.currentmaxsecondarypowertext:SetPoint("RIGHT", frame.secondarypowerbar, "RIGHT", 110, 0)		-- remove this once we have a full option set for customizing this

		frame.percentsecondarypowertext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		frame.percentsecondarypowertext:SetPoint("TOP", frame.secondarypowerbar, "TOP", 0, 1)					-- remove this once we have a full option set for customizing this

		frame.deficitsecondarypowertext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		frame.deficitsecondarypowertext:SetPoint("RIGHT", frame.secondarypowerbar, "RIGHT", 100, 0)			-- remove this once we have a full option set for customizing this
	end

	-- Art Pieces
	frame.classicon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.classicon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
	frame.classicon:SetPoint("TOPLEFT", frame.levelframe, "TOPLEFT", 5, -5)				-- remove this once we have a full option set for customizing this
	frame.classicon:SetHeight(24)														-- remove this once we have a full option set for customizing this
	frame.classicon:SetWidth(24)														-- remove this once we have a full option set for customizing this

	frame.combatresticon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.combatresticon:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
	frame.combatresticon:SetPoint("RIGHT", frame.nameframe, "RIGHT", 0, 0)				-- remove this once we have a full option set for customizing this
	frame.combatresticon:SetHeight(32)													-- remove this once we have a full option set for customizing this
	frame.combatresticon:SetWidth(31)													-- remove this once we have a full option set for customizing this

	frame.deathicon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.deathicon:SetTexture("Interface\\TargetingFrame\\TargetDead")
	frame.deathicon:SetPoint("TOPRIGHT", frame.nameframe, "TOPRIGHT", -9, -3)			-- remove this once we have a full option set for customizing this
	frame.deathicon:SetHeight(16)														-- remove this once we have a full option set for customizing this
	frame.deathicon:SetWidth(16)														-- remove this once we have a full option set for customizing this

	frame.disconnectedicon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.disconnectedicon:SetTexture("Interface\\CharacterFrame\\Disconnect-Icon")
	frame.disconnectedicon:SetPoint("TOPRIGHT", frame.nameframe, "TOPRIGHT", -35, 3)	-- remove this once we have a full option set for customizing this
	frame.disconnectedicon:SetHeight(32)												-- remove this once we have a full option set for customizing this
	frame.disconnectedicon:SetWidth(32)													-- remove this once we have a full option set for customizing this

	frame.leadericon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.leadericon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
	frame.leadericon:SetPoint("TOP", frame.nameframe, "TOP", 0, 7)						-- remove this once we have a full option set for customizing this
	frame.leadericon:SetHeight(16)														-- remove this once we have a full option set for customizing this
	frame.leadericon:SetWidth(16)														-- remove this once we have a full option set for customizing this

	frame.masterlootericon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.masterlootericon:SetTexture("Interface\\GroupFrame\\UI-Group-MasterLooter")
	frame.masterlootericon:SetPoint("TOPLEFT", frame.nameframe, "TOPLEFT", 65, 7)		-- remove this once we have a full option set for customizing this
	frame.masterlootericon:SetHeight(16)												-- remove this once we have a full option set for customizing this
	frame.masterlootericon:SetWidth(16)													-- remove this once we have a full option set for customizing this

	frame.portrait2d = frame.portraitframe:CreateTexture(nil, "ARTWORK", nil)
	frame.portrait2d:SetPoint("TOP", frame.portraitframe, "TOP", 0, -6)					-- remove this once we have a full option set for customizing this
	frame.portrait2d:SetHeight(52)														-- remove this once we have a full option set for customizing this
	frame.portrait2d:SetWidth(52)														-- remove this once we have a full option set for customizing this

	frame.portrait3d = CreateFrame("PlayerModel", nil, frame)							-- remove this final and if classic ever gets this API
	frame.portrait3d:SetPoint("TOP", frame.portraitframe, "TOP", 0, -6)					-- remove this once we have a full option set for customizing this
	frame.portrait3d:SetHeight(52)														-- remove this once we have a full option set for customizing this
	frame.portrait3d:SetWidth(52)														-- remove this once we have a full option set for customizing this

	frame.pvpicon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.pvpicon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")
	frame.pvpicon:SetPoint("TOPLEFT", frame.nameframe, "TOPLEFT", 2, -3)				-- remove this once we have a full option set for customizing this
	frame.pvpicon:SetHeight(32)															-- remove this once we have a full option set for customizing this
	frame.pvpicon:SetWidth(32)															-- remove this once we have a full option set for customizing this

	frame.raidicon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.raidicon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	frame.raidicon:SetPoint("CENTER", frame.nameframe, "TOPLEFT", 0, -10)				-- remove this once we have a full option set for customizing this
	frame.raidicon:SetHeight(26)														-- remove this once we have a full option set for customizing this
	frame.raidicon:SetWidth(26)															-- remove this once we have a full option set for customizing this

	-- frame.speakericon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	-- frame.speakericon:SetTexture("Interface\\Common\\VoiceChat-Speaker")
	-- frame.speakericon:SetPoint("CENTER", frame.nameframe, "TOPRIGHT", -35, -12)		-- remove this once we have a full option set for customizing this
	-- frame.speakericon:SetHeight(16)													-- remove this once we have a full option set for customizing this
	-- frame.speakericon:SetWidth(16)													-- remove this once we have a full option set for customizing this

	-- frame.speakersoundicon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	-- frame.speakersoundicon:SetTexture("Interface\\Common\\VoiceChat-On")
	-- frame.speakersoundicon:SetPoint("CENTER", frame.nameframe, "TOPRIGHT", -35, -12)	-- remove this once we have a full option set for customizing this
	-- frame.speakersoundicon:SetHeight(16)												-- remove this once we have a full option set for customizing this
	-- frame.speakersoundicon:SetWidth(16)												-- remove this once we have a full option set for customizing this

	-- Buffs
	frame.buffs = {}	-- The group for buffs is made and populated here
	for i=1,20 do
		table.insert(frame.buffs, i, self:CreateBuff(frame, i))
	end

	--Debuffs
	frame.debuffs = {}	-- The group for debuffs is made and populated here
	local j = self:GetDebuffNumberForFrame(unit)
	for i=1,j do
		table.insert(frame.debuffs, i, self:CreateDebuff(frame, i))
	end

	-- Groups
	frame.frames = {frame.nameframe, frame.levelframe, frame.statsframe, frame.portraitframe}
	frame.frameoverlays = {frame.nameframeoverlay, frame.levelframeoverlay, frame.statsframeoverlay, frame.portraitframeoverlay}
	frame.healthtexts = {frame.currentmaxhealthtext, frame.percenthealthtext, frame.deficithealthtext}
	frame.powertexts = {frame.currentmaxpowertext, frame.percentpowertext, frame.deficitpowertext}
	if (unit == "player") then
		frame.bars = {frame.healthbar, frame.powerbar, frame.alternatepowerbar, frame.secondarypowerbar}
		frame.barbackgrounds = {frame.healthbarbg, frame.powerbarbg, frame.alternatepowerbarbg, frame.secondarypowerbarbg}
		frame.alternatepowertexts = {frame.currentmaxalternatepowertext, frame.percentalternatepowertext, frame.deficitalternatepowertext}
		frame.secondarypowertexts = {frame.currentmaxsecondarypowertext, frame.percentsecondarypowertext, frame.deficitsecondarypowertext}
		frame.baroverlays = {frame.healthbaroverlay, frame.powerbaroverlay, frame.alternatepowerbaroverlay, frame.secondarypowerbaroverlay}
	else
		frame.bars = {frame.healthbar, frame.powerbar}
		frame.barbackgrounds = {frame.healthbarbg, frame.powerbarbg}
		frame.baroverlays = {frame.healthbaroverlay, frame.powerbaroverlay}
	end

	return frame
end

function pcUF:CreateBaseOfTargetFrameObject(framename, unit)								-- Target and Focus frames
	-- Create the unit frame object
	local frame = CreateFrame("Frame", framename, UIParent, nil)
	frame:SetFrameStrata("LOW")
	frame:SetMovable(true)
	frame:SetHeight(1)
	frame:SetWidth(1)

	-- Assign the unit to the frame
	frame.unit = unit

	-- Frames
	frame.nameframe = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")		--remove this final and if classic ever gets this API
	frame.nameframe:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)							-- remove this once we have a full option set for customizing this
	frame.nameframe:SetHeight(24)														-- remove this once we have a full option set for customizing this
	frame.nameframe:SetWidth(177)														-- remove this once we have a full option set for customizing this

	frame.levelframe = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")		--remove this final and if classic ever gets this API
	frame.levelframe:SetPoint("TOPLEFT", frame, "TOPLEFT", 174, 0)						-- remove this once we have a full option set for customizing this
	frame.levelframe:SetHeight(24)														-- remove this once we have a full option set for customizing this
	frame.levelframe:SetWidth(46)														-- remove this once we have a full option set for customizing this

	frame.statsframe = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")		--remove this final and if classic ever gets this API
	frame.statsframe:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -22)						-- remove this once we have a full option set for customizing this
	frame.statsframe:SetHeight(42)														-- remove this once we have a full option set for customizing this
	frame.statsframe:SetWidth(220)														-- remove this once we have a full option set for customizing this

	frame.portraitframe = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")	--remove this final and if classic ever gets this API
	frame.portraitframe:SetPoint("TOPLEFT", frame, "TOPLEFT", 218, 0)					-- remove this once we have a full option set for customizing this
	frame.portraitframe:SetHeight(64)													-- remove this once we have a full option set for customizing this
	frame.portraitframe:SetWidth(64)													-- remove this once we have a full option set for customizing this

	-- Bars
	frame.healthbar = CreateFrame("StatusBar", nil, frame, nil)							-- getwidth then subtract 20?
	frame.healthbar:SetPoint("TOPLEFT", frame.statsframe, "TOPLEFT", 10, -10)			-- remove this once we have a full option set for customizing this
	frame.healthbar:SetHeight(10)														-- remove this once we have a full option set for customizing this
	frame.healthbar:SetWidth(frame.statsframe:GetWidth() - 20)							-- remove this once we have a full option set for customizing this

	frame.healthbarbg = CreateFrame("StatusBar", nil, frame, nil)
	frame.healthbarbg:SetPoint("TOP", frame.healthbar, "TOP", 0, 0)
	frame.healthbarbg:SetHeight(10)														-- remove this once we have a full option set for customizing this
	frame.healthbarbg:SetWidth(frame.statsframe:GetWidth() - 20)						-- remove this once we have a full option set for customizing this

	frame.powerbar = CreateFrame("StatusBar", nil, frame, nil)
	frame.powerbar:SetPoint("TOPLEFT", frame.statsframe, "TOPLEFT", 10, -22)			-- remove this once we have a full option set for customizing this
	frame.powerbar:SetHeight(10)														-- remove this once we have a full option set for customizing this
	frame.powerbar:SetWidth(frame.statsframe:GetWidth() - 20)							-- remove this once we have a full option set for customizing this

	frame.powerbarbg = CreateFrame("StatusBar", nil, frame, nil)
	frame.powerbarbg:SetPoint("TOP", frame.powerbar, "TOP", 0, 0)
	frame.powerbarbg:SetHeight(10)														-- remove this once we have a full option set for customizing this
	frame.powerbarbg:SetWidth(frame.statsframe:GetWidth() - 20)							-- remove this once we have a full option set for customizing this

	-- Overlays
	frame.nameframeoverlay = self:CreateOverlay(frame, frame.nameframe, "_NameFrameOverlay")
	frame.levelframeoverlay = self:CreateOverlay(frame, frame.levelframe, "_LevelFrameOverlay")
	frame.statsframeoverlay = self:CreateOverlay(frame, frame.statsframe, "_StatsFrameOverlay")
	frame.portraitframeoverlay = self:CreateOverlay(frame, frame.portraitframe, "_PortraitFrameOverlay")
	frame.healthbaroverlay = self:CreateOverlay(frame, frame.healthbar, "_HealthBarOverlay")
	frame.powerbaroverlay = self:CreateOverlay(frame, frame.powerbar, "_PowerbarOverlay")

	-- Text Fields
	frame.fkeytext = frame.nameframe:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.fkeytext:SetPoint("TOPRIGHT", frame.nameframe, "TOPRIGHT", -8, -6)			-- remove this once we have a full option set for customizing this

	frame.leveltext = frame.levelframe:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.leveltext:SetPoint("CENTER", frame.levelframe, "CENTER", 0, 0)				-- remove this once we have a full option set for customizing this

	frame.nametext = frame.nameframe:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.nametext:SetWidth(frame.nametext:GetParent():GetWidth() - 10)
	frame.nametext:SetHeight(frame.nametext:GetParent():GetHeight())
	frame.nametext:SetNonSpaceWrap(false)
	frame.nametext:SetWordWrap(false)
	frame.nametext:SetPoint("CENTER", frame.nameframe, "CENTER", 0, 0)					-- remove this once we have a full option set for customizing this

	frame.currentmaxhealthtext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.currentmaxhealthtext:SetPoint("TOP", frame.healthbar, "TOP", 0, 1)			-- remove this once we have a full option set for customizing this

	frame.currentmaxpowertext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.currentmaxpowertext:SetPoint("TOP", frame.powerbar, "TOP", 0, 1)				-- remove this once we have a full option set for customizing this

	frame.percenthealthtext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.percenthealthtext:SetPoint("TOP", frame.healthbar, "TOP", 0, 1)				-- remove this once we have a full option set for customizing this

	frame.percentpowertext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.percentpowertext:SetPoint("TOP", frame.powerbar, "TOP", 0, 1)					-- remove this once we have a full option set for customizing this

	frame.deficithealthtext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.deficithealthtext:SetPoint("RIGHT", frame.healthbar, "RIGHT", 100, 0)			-- remove this once we have a full option set for customizing this

	frame.deficitpowertext = frame.statsframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.deficitpowertext:SetPoint("RIGHT", frame.powerbar, "RIGHT", 100, 0)			-- remove this once we have a full option set for customizing this

	-- Art Pieces
	-- frame.classicon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	-- frame.classicon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
	-- frame.classicon:SetPoint("TOPLEFT", frame.levelframe, "TOPLEFT", 5, -5)			-- remove this once we have a full option set for customizing this
	-- frame.classicon:SetHeight(24)													-- remove this once we have a full option set for customizing this
	-- frame.classicon:SetWidth(24)														-- remove this once we have a full option set for customizing this

	-- frame.combatresticon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	-- frame.combatresticon:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
	-- frame.combatresticon:SetPoint("RIGHT", frame.nameframe, "RIGHT", 0, 0)			-- remove this once we have a full option set for customizing this
	-- frame.combatresticon:SetHeight(32)												-- remove this once we have a full option set for customizing this
	-- frame.combatresticon:SetWidth(31)												-- remove this once we have a full option set for customizing this

	frame.deathicon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.deathicon:SetTexture("Interface\\TargetingFrame\\TargetDead")
	frame.deathicon:SetPoint("TOPRIGHT", frame.nameframe, "TOPRIGHT", -25, -4)			-- remove this once we have a full option set for customizing this
	frame.deathicon:SetHeight(16)														-- remove this once we have a full option set for customizing this
	frame.deathicon:SetWidth(16)														-- remove this once we have a full option set for customizing this

	frame.disconnectedicon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.disconnectedicon:SetTexture("Interface\\CharacterFrame\\Disconnect-Icon")
	frame.disconnectedicon:SetPoint("TOPRIGHT", frame.nameframe, "TOPRIGHT", -35, 3)	-- remove this once we have a full option set for customizing this
	frame.disconnectedicon:SetHeight(32)												-- remove this once we have a full option set for customizing this
	frame.disconnectedicon:SetWidth(32)													-- remove this once we have a full option set for customizing this

	frame.leadericon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.leadericon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
	frame.leadericon:SetPoint("TOP", frame.nameframe, "TOP", 0, 7)						-- remove this once we have a full option set for customizing this
	frame.leadericon:SetHeight(16)														-- remove this once we have a full option set for customizing this
	frame.leadericon:SetWidth(16)														-- remove this once we have a full option set for customizing this

	frame.portrait2d = frame.portraitframe:CreateTexture(nil, "ARTWORK", nil)
	frame.portrait2d:SetPoint("TOP", frame.portraitframe, "TOP", 0, -6)					-- remove this once we have a full option set for customizing this
	frame.portrait2d:SetHeight(52)														-- remove this once we have a full option set for customizing this
	frame.portrait2d:SetWidth(52)														-- remove this once we have a full option set for customizing this

	frame.portrait3d = CreateFrame("PlayerModel", nil, frame)							-- remove this final and if classic ever gets this API
	frame.portrait3d:SetPoint("TOP", frame.portraitframe, "TOP", 0, -6)					-- remove this once we have a full option set for customizing this
	frame.portrait3d:SetHeight(52)														-- remove this once we have a full option set for customizing this
	frame.portrait3d:SetWidth(52)														-- remove this once we have a full option set for customizing this

	frame.pvpicon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.pvpicon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")
	frame.pvpicon:SetPoint("TOPLEFT", frame.nameframe, "TOPLEFT", 2, -3)				-- remove this once we have a full option set for customizing this
	frame.pvpicon:SetHeight(32)															-- remove this once we have a full option set for customizing this
	frame.pvpicon:SetWidth(32)															-- remove this once we have a full option set for customizing this

	frame.questicon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.questicon:SetTexture("Interface\\TargetingFrame\\PortraitQuestBadge")
	frame.questicon:SetPoint("TOPRIGHT", frame.nameframe, "TOPRIGHT", -5, -4)			-- remove this once we have a full option set for customizing this
	frame.questicon:SetHeight(16)														-- remove this once we have a full option set for customizing this
	frame.questicon:SetWidth(16)														-- remove this once we have a full option set for customizing this

	frame.raidicon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	frame.raidicon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	frame.raidicon:SetPoint("CENTER", frame.nameframe, "TOPRIGHT", 45, -10)				-- remove this once we have a full option set for customizing this
	frame.raidicon:SetHeight(26)														-- remove this once we have a full option set for customizing this
	frame.raidicon:SetWidth(26)															-- remove this once we have a full option set for customizing this

	-- frame.speakericon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	-- frame.speakericon:SetTexture("Interface\\Common\\VoiceChat-Speaker")
	-- frame.speakericon:SetPoint("CENTER", frame.nameframe, "TOPRIGHT", -35, -12)		-- remove this once we have a full option set for customizing this
	-- frame.speakericon:SetHeight(16)													-- remove this once we have a full option set for customizing this
	-- frame.speakericon:SetWidth(16)													-- remove this once we have a full option set for customizing this

	-- frame.speakersoundicon = frame.nameframe:CreateTexture(nil, "OVERLAY", nil)
	-- frame.speakersoundicon:SetTexture("Interface\\Common\\VoiceChat-On")
	-- frame.speakersoundicon:SetPoint("CENTER", frame.nameframe, "TOPRIGHT", -35, -12)	-- remove this once we have a full option set for customizing this
	-- frame.speakersoundicon:SetHeight(16)												-- remove this once we have a full option set for customizing this
	-- frame.speakersoundicon:SetWidth(16)												-- remove this once we have a full option set for customizing this

	-- Buffs
	frame.buffs = {}	-- The group for buffs is made and populated here
	for i=1,20 do
		table.insert(frame.buffs, i, self:CreateBuff(frame, i))
	end

	--Debuffs
	frame.debuffs = {}	-- The group for debuffs is made and populated here
	local j = self:GetDebuffNumberForFrame(unit)
	for i=1,j do
		table.insert(frame.debuffs, i, self:CreateDebuff(frame, i))
	end

	-- Groups
	frame.frames = {frame.nameframe, frame.levelframe, frame.statsframe, frame.portraitframe}
	frame.bars = {frame.healthbar, frame.powerbar}
	frame.barbackgrounds = {frame.healthbarbg, frame.powerbarbg}
	frame.healthtexts = {frame.currentmaxhealthtext, frame.percenthealthtext, frame.deficithealthtext}
	frame.powertexts = {frame.currentmaxpowertext, frame.percentpowertext, frame.deficitpowertext}
	frame.frameoverlays = {frame.nameframeoverlay, frame.levelframeoverlay, frame.statsframeoverlay, frame.portraitframeoverlay}
	frame.baroverlays = {frame.healthbaroverlay, frame.powerbaroverlay}

	return frame
end

function pcUF:CreateOverlay(frame, parent, name)
	local overlay = CreateFrame("Button", frame:GetName()..name, parent, "SecureUnitButtonTemplate")	-- Give these frames a name so they can be managed by Clique

	overlay:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
	overlay:RegisterForClicks("AnyUp")
	overlay:RegisterForDrag("LeftButton")
	overlay:SetScript("OnDragStart", function () pcUF:DragStart(frame) end)
	overlay:SetScript("OnDragStop", function () pcUF:DragStop(frame) end)
	overlay:SetScript("OnEnter", function () UnitFrame_OnEnter(frame) end)
	overlay:SetScript("OnLeave", function () UnitFrame_OnLeave(frame) end)
	overlay:SetHeight(parent:GetHeight())
	overlay:SetWidth(parent:GetWidth())
	pcUF:Overlay_OnLoad(frame, overlay, frame.unit)

	return overlay
end

function pcUF:CreateBuff(frame, id)
	local buff = CreateFrame("Button", nil, frame, nil)

	buff:SetScript("OnEnter", function () self:BuffTooltip(buff) end)
	buff:SetScript("OnLeave", function () GameTooltip:Hide() end)
	buff:SetHeight(24)
	buff:SetWidth(24)

	buff.id = id
	buff.unit = frame.unit

	buff.icon = buff:CreateTexture(nil, "ARTWORK", nil)
	buff.icon:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0)
	buff.icon:SetHeight(buff:GetHeight())
	buff.icon:SetWidth(buff:GetWidth())

	buff.count = buff:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
	buff.count:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", 0, 1)

	buff.cooldown = CreateFrame("Cooldown", nil, buff, "CooldownFrameTemplate")
	buff.cooldown:SetPoint("CENTER", buff, "CENTER", 0, -1)
	buff.cooldown:SetReverse(true)

	return buff
end

function pcUF:CreateDebuff(frame, id)
	local debuff = CreateFrame("Button", nil, frame, nil)

	debuff:SetScript("OnEnter", function () self:DebuffTooltip(debuff) end)
	debuff:SetScript("OnLeave", function () GameTooltip:Hide() end)
	debuff:SetHeight(24)
	debuff:SetWidth(24)

	debuff.id = id
	debuff.unit = frame.unit

	debuff.icon = debuff:CreateTexture(nil, "ARTWORK", nil)
	debuff.icon:SetPoint("TOPLEFT", debuff, "TOPLEFT", 0, 0)
	debuff.icon:SetHeight(debuff:GetHeight())
	debuff.icon:SetWidth(debuff:GetWidth())

	debuff.border = debuff:CreateTexture(nil, "ARTWORK", nil)
	debuff.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
	debuff.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
	debuff.border:SetPoint("TOPLEFT", debuff, "TOPLEFT", 0, 0)
	debuff.border:SetHeight(debuff:GetHeight())
	debuff.border:SetWidth(debuff:GetWidth())

	debuff.count = debuff:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
	debuff.count:SetPoint("BOTTOMRIGHT", debuff, "BOTTOMRIGHT", 0, 1)

	debuff.cooldown = CreateFrame("Cooldown", nil, debuff, "CooldownFrameTemplate")
	debuff.cooldown:SetPoint("CENTER", debuff, "CENTER", 0, -1)
	debuff.cooldown:SetReverse(true)

	return debuff
end
