local addonName, MaelstromWeapon = ...

local L = MaelstromWeapon.L

local classFilename, classId = UnitClassBase("player")

--Shaman only addon, so disable for anything non-Shaman
if classId ~= 7 then
	return
end

local DefaultSettings = {
	showCooldownText = false,
	textOnRight = false,
	showBackdrop = true,
	cooldownFontSize = 14,
	cooldownFont = STANDARD_TEXT_FONT,
	pulseGlow = true,
	enableBurstAnim = true,
	enableDecorAnim = true,
	scale = 1,
	backdropColor = {r = 1, g = 1, b = 1, a = 1},
	glowColor = {r = 0, g = 0.8, b = 1, a = 0.8},
	coverColor = {r = 1, g = 1, b = 1, a = 1},
	fillColor1_5 = {r = 0.75, g = 0.75, b = 1, a = 1},
	fillColor6_10 = {r = 1, g = 0.35, b = 0.35, a = 1},
};

local function InitDefaults()
	if not MaelWeap_DB then MaelWeap_DB = {} end
	for k, v in pairs(DefaultSettings) do
		if MaelWeap_DB[k] == nil then
			if type(v) == "table" then
				MaelWeap_DB[k] = CopyTable(v);
			else
				MaelWeap_DB[k] = v;
			end
		end
	end
end

local MW = CreateFrame("frame", nil, UIParent)
MW:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
MW:SetSize(256,100)
MW:SetFrameStrata("MEDIUM")
MW:SetScale(.90)
MW:SetClampedToScreen(true);

MW.glowTex = MW:CreateTexture(nil, "BACKGROUND", nil, -1)
MW.glowTex:SetAllPoints(MW)
MW.glowTex:SetTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Backdrop.png")
MW.glowTex:SetBlendMode("ADD")
MW.glowTex:Hide()

MW.glowAnimGroup = MW.glowTex:CreateAnimationGroup()
MW.glowAnimGroup:SetLooping("BOUNCE")
local alphaAnim = MW.glowAnimGroup:CreateAnimation("Alpha")
alphaAnim:SetFromAlpha(0.1)
alphaAnim:SetToAlpha(1)
alphaAnim:SetDuration(0.6)

local editFrame = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
editFrame:SetFrameStrata("HIGH")
editFrame:SetAllPoints(MW)
local backdropInfo = {
	bgFile = "interface\\editmode\\editmodeuihighlightbackground",
	edgeFile = "Interface\\Buttons\\WHITE8X8",
	edgeSize = 2,
	insets = { left = 1, right = 1, top = 1, bottom = 1, },
};
editFrame:SetBackdrop(backdropInfo)
editFrame:SetBackdropColor(1,1,1,1) -- Black background
editFrame:SetBackdropBorderColor(.227,.773,1.00,1) -- White border

local function SaveFramePosition()
	local point, relativeTo, relativePoint, xOfs, yOfs = MW:GetPoint();
	MaelWeap_DB.position = {point = point, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs};
end

local function LoadFramePosition()
	if MaelWeap_DB and MaelWeap_DB.position then
		local pos = MaelWeap_DB.position;
		MW:ClearAllPoints();
		MW:SetPoint(pos.point, UIParent, pos.relativePoint, pos.xOfs, pos.yOfs);
	else
		MW:ClearAllPoints();
		MW:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
	end
end

local function SetFrameScale(scale)
	if MaelWeap_DB and MaelWeap_DB.scale then
		MW:SetScale(MaelWeap_DB.scale);
	else
		MW:SetScale(scale or 1);
	end
end

local function ApplyColors()
	if not MaelWeap_DB then return end
	
	local gc = MaelWeap_DB.glowColor or DefaultSettings.glowColor
	MW.glowTex:SetVertexColor(gc.r, gc.g, gc.b, gc.a)
	
	local cc = MaelWeap_DB.coverColor or DefaultSettings.coverColor
	if MW.charge then
		for i = 1, 5 do
			if MW.charge[i] and MW.charge[i].texCover then
				MW.charge[i].texCover:SetVertexColor(cc.r, cc.g, cc.b, cc.a);
			end
		end
	end
	
	if MW.ChargeCheck then
		MW.ChargeCheck();
	end
end

local function ApplyCooldownTextSettings()
	if not MaelWeap_DB then return end
	
	MW.durationText:SetFont(MaelWeap_DB.cooldownFont, MaelWeap_DB.cooldownFontSize, "OUTLINE")
	MW.durationText:ClearAllPoints()
	
	if MaelWeap_DB.textOnRight then
		MW.durationText:SetPoint("LEFT", MW.charge[5], "RIGHT", 10, 0);
	else
		MW.durationText:SetPoint("RIGHT", MW.charge[1], "LEFT", -10, 0);
	end
	
	if not MaelWeap_DB.showCooldownText then
		MW.durationText:Hide();
	else
		MW.durationText:Show();
	end
end

local function ApplyBackdropSettings()
	if not MaelWeap_DB or not MW.tex then return; end
	
	if MaelWeap_DB.showBackdrop then
		MW.tex:Show();
	else
		MW.tex:Hide();
	end

	local bc = MaelWeap_DB.backdropColor or DefaultSettings.backdropColor
	MW.tex:SetVertexColor(bc.r, bc.g, bc.b, bc.a)
end

local function ClearSettings()
	if MaelWeap_DB then MaelWeap_DB = nil end
	InitDefaults();
	LoadFramePosition();
	SetFrameScale();
	ApplyColors();
	ApplyCooldownTextSettings();
	ApplyBackdropSettings();
end

function editFrame.OnShow()
	editFrame:Show();
	MW:EnableMouse(true);
	MW:SetMovable(true);
	MW:RegisterForDrag("LeftButton");
	MW:SetScript("OnDragStart", MW.StartMoving);
	MW:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing();
		SaveFramePosition();
	end)
end
function editFrame.OnHide()
	editFrame:Hide();
	MW:EnableMouse(false);
	MW:SetMovable(false);
end

editFrame.scaler = CreateFrame("Frame", nil, UIParent, "BackdropTemplate");
local ScaleSettings = editFrame.scaler;
ScaleSettings:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
ScaleSettings:SetWidth(280);
ScaleSettings:SetHeight(480);
ScaleSettings:SetBackdrop(backdropInfo);
ScaleSettings:SetFrameStrata("HIGH");
ScaleSettings:EnableMouse(true);
ScaleSettings:Hide();
ScaleSettings:SetBackdropColor(0,0,0,1);
ScaleSettings.closebutton = CreateFrame("Button", nil, ScaleSettings, "UIPanelCloseButton");
ScaleSettings.closebutton:SetWidth(24);
ScaleSettings.closebutton:SetHeight(24);
ScaleSettings.closebutton:SetPoint("TOPRIGHT", ScaleSettings, "TOPRIGHT", 1, 1);
ScaleSettings.closebutton:SetScript("OnClick", function(self, button)
	ScaleSettings:Hide();
end)

do 
	ScaleSettings.ScaleSlider = CreateFrame("Slider", nil, ScaleSettings, "MinimalSliderWithSteppersTemplate");
	local ScaleSlider = ScaleSettings.ScaleSlider
	ScaleSlider:SetPoint("TOPLEFT", ScaleSettings, "TOPLEFT", 45, -30);
	ScaleSlider:SetWidth(190)

	local initialValue = 1
	local minValue = .5
	local maxValue = 3
	local steps = 25

	local formatters = {
		[MinimalSliderWithSteppersMixin.Label.Left] = function(value) return minValue end,
		[MinimalSliderWithSteppersMixin.Label.Right] = function(value) return maxValue end,
		[MinimalSliderWithSteppersMixin.Label.Top] = function(value) return (HUD_EDIT_MODE_SETTING_UNIT_FRAME_FRAME_SIZE or UI_SCALE) .. ": " .. format("%.1f", ScaleSlider.Slider:GetValue()) end,
	};

	-- Initialize the slider with the values and formatters
	ScaleSlider:Init(initialValue, minValue, maxValue, steps, formatters);

	local function SliderFuncTest()
		if not MaelWeap_DB then MaelWeap_DB = {} end
		MaelWeap_DB.scale = ScaleSlider.Slider:GetValue();
		SetFrameScale(MaelWeap_DB.scale);
	end
	-- Set up a listener for the value changed event
	ScaleSlider:RegisterCallback("OnValueChanged",SliderFuncTest)
	ScaleSlider:SetEnabled(true)
end

do 
	ScaleSettings.TextSizeSlider = CreateFrame("Slider", nil, ScaleSettings, "MinimalSliderWithSteppersTemplate");
	local TextSizeSlider = ScaleSettings.TextSizeSlider
	TextSizeSlider:SetPoint("TOPLEFT", ScaleSettings, "TOPLEFT", 45, -80);
	TextSizeSlider:SetWidth(190)

	local initialValue = DefaultSettings.cooldownFontSize
	local minValue = 8
	local maxValue = 32
	local steps = maxValue - minValue

	local formatters = {
		[MinimalSliderWithSteppersMixin.Label.Left] = function(value) return minValue end,
		[MinimalSliderWithSteppersMixin.Label.Right] = function(value) return maxValue end,
		[MinimalSliderWithSteppersMixin.Label.Top] = function(value) return "Text Size: " .. format("%.0f", TextSizeSlider.Slider:GetValue()) end,
	};

	TextSizeSlider:Init(initialValue, minValue, maxValue, steps, formatters);

	local function TextSliderFunc()
		if not MaelWeap_DB then MaelWeap_DB = {} end
		MaelWeap_DB.cooldownFontSize = TextSizeSlider.Slider:GetValue();
		ApplyCooldownTextSettings();
	end
	TextSizeSlider:RegisterCallback("OnValueChanged", TextSliderFunc)
	TextSizeSlider:SetEnabled(true)
end

local function CreateCheckbox(parent, labelText, dbKey, point, callback)
	local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	cb:SetPoint(unpack(point))
	cb.text = cb:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	cb.text:SetPoint("LEFT", cb, "RIGHT", 5, 0)
	cb.text:SetText(labelText)
	
	cb:SetScript("OnShow", function(self)
		self:SetChecked(MaelWeap_DB[dbKey]);
	end)
	cb:SetScript("OnClick", function(self)
		MaelWeap_DB[dbKey] = self:GetChecked();
		if callback then
			callback();
		end
	end)
	return cb;
end

local function CreateColorPicker(parent, labelText, dbKey, point, callback)
	local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	label:SetPoint(unpack(point))
	label:SetText(labelText)

	local swatch = CreateFrame("Button", nil, parent, "ColorSwatchTemplate")
	swatch:SetPoint("LEFT", label, "RIGHT", 10, 0)
	
	swatch:SetScript("OnShow", function(self)
		local c = MaelWeap_DB[dbKey] or DefaultSettings[dbKey];
		self.Color:SetVertexColor(c.r, c.g, c.b, c.a);
	end)

	swatch:SetScript("OnClick", function()
		local current = MaelWeap_DB[dbKey] or DefaultSettings[dbKey]
		local info = {}
		info.r, info.g, info.b, info.opacity = current.r, current.g, current.b, current.a
		info.hasOpacity = true
		
		info.swatchFunc = function()
			local r, g, b = ColorPickerFrame:GetColorRGB();
			local a = ColorPickerFrame:GetColorAlpha();
			MaelWeap_DB[dbKey] = {r=r, g=g, b=b, a=a};
			swatch.Color:SetVertexColor(r, g, b, a);
			if callback then
				callback();
			end
		end
		
		info.cancelFunc = function()
			local r, g, b, a = ColorPickerFrame:GetPreviousValues();
			MaelWeap_DB[dbKey] = {r=r, g=g, b=b, a=a};
			swatch.Color:SetVertexColor(r, g, b, a);
			if callback then
				callback();
			end
		end
		
		ColorPickerFrame:SetupColorPickerAndShow(info)
	end)
	return swatch
end

CreateCheckbox(ScaleSettings, L["Setting_CDText"], "showCooldownText", {"TOPLEFT", ScaleSettings, "TOPLEFT", 20, -120}, ApplyCooldownTextSettings)
CreateCheckbox(ScaleSettings, L["Setting_TextRight"], "textOnRight", {"TOPLEFT", ScaleSettings, "TOPLEFT", 20, -150}, ApplyCooldownTextSettings)
CreateCheckbox(ScaleSettings, L["Setting_PulseGlow"], "pulseGlow", {"TOPLEFT", ScaleSettings, "TOPLEFT", 20, -180}, function() MW.ChargeCheck() end)
CreateCheckbox(ScaleSettings, L["Setting_BurstAnim"], "enableBurstAnim", {"TOPLEFT", ScaleSettings, "TOPLEFT", 20, -210}, function() MW.ChargeCheck() end)
CreateCheckbox(ScaleSettings, L["Setting_DecorAnim"], "enableDecorAnim", {"TOPLEFT", ScaleSettings, "TOPLEFT", 20, -240}, function() MW.ChargeCheck() end)
CreateCheckbox(ScaleSettings, L["Setting_BackdropTex"], "showBackdrop", {"TOPLEFT", ScaleSettings, "TOPLEFT", 20, -270}, ApplyBackdropSettings)

CreateColorPicker(ScaleSettings, L["Setting_BackdropColor"], "backdropColor", {"TOPLEFT", ScaleSettings, "TOPLEFT", 20, -310}, ApplyBackdropSettings)
CreateColorPicker(ScaleSettings, L["Setting_BackdropGlowColor"], "glowColor", {"TOPLEFT", ScaleSettings, "TOPLEFT", 20, -340}, ApplyColors)
CreateColorPicker(ScaleSettings, L["Setting_CoverTexColor"], "coverColor", {"TOPLEFT", ScaleSettings, "TOPLEFT", 20, -370}, ApplyColors)
CreateColorPicker(ScaleSettings, L["Setting_ChargeFill1_5TexColor"], "fillColor1_5", {"TOPLEFT", ScaleSettings, "TOPLEFT", 20, -400}, ApplyColors)
CreateColorPicker(ScaleSettings, L["Setting_ChargeFill6_10TexColor"], "fillColor6_10", {"TOPLEFT", ScaleSettings, "TOPLEFT", 20, -430}, ApplyColors)


function editFrame.ShowScaleButton()
	editFrame.scaler:Show();
end

local Dropdown = CreateFrame("DropdownButton", nil, editFrame, "WowStyle1DropdownTemplate")
Dropdown:SetDefaultText(MAIN_MENU)
Dropdown:SetPoint("BOTTOMRIGHT", editFrame, "BOTTOMRIGHT", 0, 0);
Dropdown:SetSize(150,30)
Dropdown:SetupMenu(function(dropdown, rootDescription)
	rootDescription:CreateButton(LOCK_FRAME, editFrame.OnHide)
	rootDescription:CreateButton(SETTINGS, editFrame.ShowScaleButton)
	rootDescription:CreateDivider()
	rootDescription:CreateButton(RESET_TO_DEFAULT, ClearSettings)
end)

editFrame:Hide()

MW.tex = MW:CreateTexture()
MW.tex:SetAllPoints()
MW.tex:SetTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Backdrop.png")

MW.charge = CreateFrame("frame")
MW.charge:SetAllPoints(MW)
MW.charge:RegisterEvent("UNIT_AURA")
MW.charge:RegisterEvent("SPELL_UPDATE_COOLDOWN")

MW.durationText = MW:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
MW:SetScript("OnUpdate", function(self, elapsed)
	if self.expirationTime and MaelWeap_DB and MaelWeap_DB.showCooldownText then
		local remain = self.expirationTime - GetTime()
		if remain > 0 then
			self.durationText:SetFormattedText("%.1f", remain)
		else
			self.durationText:SetText("")
			self.expirationTime = nil
		end
	else
		self.durationText:SetText("")
	end
end)

for i = 1,5 do
	MW.charge[i] = CreateFrame("frame", nil, MW)
	MW.charge[i]:SetPoint("CENTER", MW.charge, "CENTER", -80+(i*27), 0)
	MW.charge[i]:SetWidth(35)
	MW.charge[i]:SetHeight(35)

	MW.charge[i].texBase = MW.charge[i]:CreateTexture(nil, "BACKGROUND", nil, 1)
	MW.charge[i].texBase:SetAllPoints(MW.charge[i])
	MW.charge[i].texBase:SetTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Charge_Empty.png")
	
	MW.charge[i].texFill = MW.charge[i]:CreateTexture(nil, "BACKGROUND", nil, 2)
	MW.charge[i].texFill:SetAllPoints(MW.charge[i])
	MW.charge[i].texFill:SetTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Points_Fill.png")
	
	MW.charge[i].texCover = MW.charge[i]:CreateTexture(nil, "BACKGROUND", nil, 3)
	MW.charge[i].texCover:SetAllPoints(MW.charge[i])
	MW.charge[i].texCover:SetTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Charge_Cover.png")
	
	MW.charge[i].cooldown = CreateFrame("Cooldown", nil, MW.charge[i], "CooldownFrameTemplate")
	MW.charge[i].cooldown:SetPoint("TOPLEFT", MW.charge[i], "TOPLEFT", -.5, .5)
	MW.charge[i].cooldown:SetPoint("BOTTOMRIGHT", MW.charge[i], "BOTTOMRIGHT", .5, -.5)
	MW.charge[i].cooldown:SetReverse(true)
	MW.charge[i].cooldown:SetSwipeTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Charge_Empty.png", 0, 0, 0, 1)
	MW.charge[i].cooldown:SetEdgeTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Charge_Edge.png", 1, 0, 0, 1)
	MW.charge[i].cooldown:SetUseCircularEdge(true)
	MW.charge[i].cooldown:SetEdgeScale(1)
	
	MW.charge[i].cooldown:SetHideCountdownNumbers(true)

	MW.charge[i].texFill:Hide()

	MW.charge[i].burstTex = MW.charge[i]:CreateTexture(nil, "OVERLAY")
	MW.charge[i].burstTex:SetPoint("CENTER", MW.charge[i], "CENTER", 0, 0)
	MW.charge[i].burstTex:SetSize(60, 60) 
	MW.charge[i].burstTex:SetAtlas("dragonriding_sgvigor_burst_flipbook")
	MW.charge[i].burstTex:SetBlendMode("ADD")
	MW.charge[i].burstTex:Hide()

	MW.charge[i].burstAnimGroup = MW.charge[i].burstTex:CreateAnimationGroup()
	local burstAnim = MW.charge[i].burstAnimGroup:CreateAnimation("FlipBook")
	burstAnim:SetDuration(0.4)
	burstAnim:SetFlipBookRows(4)
	burstAnim:SetFlipBookColumns(4)
	burstAnim:SetFlipBookFrames(16)
	
	MW.charge[i].burstAnimGroup:SetScript("OnFinished", function()
		MW.charge[i].burstTex:Hide()
	end)
	MW.charge[i].burstAnimGroup:SetScript("OnPlay", function()
		MW.charge[i].burstTex:Show()
	end)
end

MW.decorLeftTex = MW:CreateTexture(nil, "OVERLAY")
MW.decorLeftTex:SetPoint("RIGHT", MW.charge[1], "LEFT", 35, 0)
MW.decorLeftTex:SetSize(65, 65)
MW.decorLeftTex:SetAtlas("dragonriding_sgvigor_decor_flipbook_left")
MW.decorLeftTex:SetBlendMode("ADD")
MW.decorLeftTex:Hide()

MW.decorLeftAnimGroup = MW.decorLeftTex:CreateAnimationGroup()
local leftAnim = MW.decorLeftAnimGroup:CreateAnimation("FlipBook")
leftAnim:SetDuration(0.5)
leftAnim:SetFlipBookRows(2)
leftAnim:SetFlipBookColumns(4)
leftAnim:SetFlipBookFrames(8)

MW.decorLeftAnimGroup:SetScript("OnFinished", function() MW.decorLeftTex:Hide() end)
MW.decorLeftAnimGroup:SetScript("OnPlay", function() MW.decorLeftTex:Show() end)

-- Right Decor
MW.decorRightTex = MW:CreateTexture(nil, "OVERLAY")
MW.decorRightTex:SetPoint("LEFT", MW.charge[5], "RIGHT", -35, 0)
MW.decorRightTex:SetSize(65, 65)
MW.decorRightTex:SetAtlas("dragonriding_sgvigor_decor_flipbook_right")
MW.decorRightTex:SetBlendMode("ADD")
MW.decorRightTex:Hide()

MW.decorRightAnimGroup = MW.decorRightTex:CreateAnimationGroup()
local rightAnim = MW.decorRightAnimGroup:CreateAnimation("FlipBook")
rightAnim:SetDuration(0.5)
rightAnim:SetFlipBookRows(2)
rightAnim:SetFlipBookColumns(4)
rightAnim:SetFlipBookFrames(8)

MW.decorRightAnimGroup:SetScript("OnFinished", function() MW.decorRightTex:Hide() end)
MW.decorRightAnimGroup:SetScript("OnPlay", function() MW.decorRightTex:Show() end)

function MW.SpecCheck()
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC or WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
		return true
	end
	local id, name, description, icon, role, primaryStat = GetSpecializationInfo(GetSpecialization())
	if id == 263 then
		--[[
		if TotemFrame:IsShown() == true then
			TotemFrame:SetPoint("TOPLEFT", PlayerFrame, "BOTTOM", -46, 5)
			TotemFrame:SetScale(.9)
		end
		]]
		return true
	end
end

function MW.ClearCharges()
	MW.expirationTime = nil
	MW.durationText:SetText("")
	for i = 1,5 do
		MW.charge[i].texFill:Hide();
		local c = (MaelWeap_DB and MaelWeap_DB.fillColor1_5) or DefaultSettings.fillColor1_5
		MW.charge[i].texFill:SetVertexColor(c.r, c.g, c.b, c.a)
	end
end

local buffInfo = {
	344179, -- Retail
	408505, -- Classic Era
	53817, -- Wrath/Cata
};

function MW.ChargeCheck()
	MW.ClearCharges()
	
	local c1 = (MaelWeap_DB and MaelWeap_DB.fillColor1_5) or DefaultSettings.fillColor1_5
	local c2 = (MaelWeap_DB and MaelWeap_DB.fillColor6_10) or DefaultSettings.fillColor6_10

	local activeAura = nil

	for k, v in pairs(buffInfo) do
		local aura = C_UnitAuras.GetPlayerAuraBySpellID(v)
		if aura and not (issecretvalue and issecretvalue(aura)) then
			activeAura = aura
			break
		end
	end
	
	if activeAura then
		local chargeCount = activeAura.applications
		local duration = activeAura.duration
		local expirationTime = activeAura.expirationTime

		if duration and expirationTime then
			MW.expirationTime = expirationTime;
		else
			MW.expirationTime = nil;
		end

		if not MW.lastChargeCount then
			MW.lastChargeCount = 0;
		end
		if not MW.lastExpirationTime then
			MW.lastExpirationTime = 0;
		end
		
		local burstEnabled = true
		local decorEnabled = true
		if MaelWeap_DB then
			if MaelWeap_DB.enableBurstAnim ~= nil then
				burstEnabled = MaelWeap_DB.enableBurstAnim;
			end
			if MaelWeap_DB.enableDecorAnim ~= nil then
				decorEnabled = MaelWeap_DB.enableDecorAnim;
			end
		end

		if burstEnabled then
			if chargeCount > MW.lastChargeCount then
				for i = MW.lastChargeCount + 1, chargeCount do
					local index = (i > 5) and (i - 5) or i
					if MW.charge[index] and MW.charge[index].burstAnimGroup then
						MW.charge[index].burstAnimGroup:Stop();
						MW.charge[index].burstAnimGroup:Play();
					end
				end
			elseif chargeCount == 10 and MW.lastChargeCount == 10 and expirationTime and expirationTime > MW.lastExpirationTime then
				for i = 1, 5 do
					if MW.charge[i] and MW.charge[i].burstAnimGroup then
						MW.charge[i].burstAnimGroup:Stop();
						MW.charge[i].burstAnimGroup:Play();
					end
				end
			end
		end
		
		if decorEnabled then
			if chargeCount >= 5 and MW.lastChargeCount < 5 then
				MW.decorLeftAnimGroup:Stop();
				MW.decorLeftAnimGroup:Play();
				MW.decorRightAnimGroup:Stop();
				MW.decorRightAnimGroup:Play();
			end

			if chargeCount == 10 then
				MW.decorLeftAnimGroup:SetLooping("REPEAT");
				MW.decorRightAnimGroup:SetLooping("REPEAT");
				if not MW.decorLeftAnimGroup:IsPlaying() then
					MW.decorLeftAnimGroup:Play();
				end
				if not MW.decorRightAnimGroup:IsPlaying() then
					MW.decorRightAnimGroup:Play();
				end
			else
				MW.decorLeftAnimGroup:SetLooping("NONE");
				MW.decorRightAnimGroup:SetLooping("NONE");
			end
		else
			MW.decorLeftAnimGroup:Stop();
			MW.decorRightAnimGroup:Stop();
			MW.decorLeftTex:Hide();
			MW.decorRightTex:Hide();
		end
		
		MW.lastChargeCount = chargeCount
		MW.lastExpirationTime = expirationTime or 0

		if MaelWeap_DB and MaelWeap_DB.pulseGlow and chargeCount >= 5 then
			if not MW.glowAnimGroup:IsPlaying() then
				MW.glowTex:Show();
				MW.glowAnimGroup:Play();
			end
		else
			if MW.glowAnimGroup:IsPlaying() then
				MW.glowAnimGroup:Stop();
				MW.glowTex:Hide();
			end
		end
		--[[
			if TotemFrame:IsShown() == true then
				TotemFrame:SetPoint("TOPLEFT", PlayerFrame, "BOTTOM", -46, 5)
				TotemFrame:SetScale(.9)
			end
		]]

		if chargeCount <= 5 then
			for i = 1, 5 do
				MW.charge[i].texCover:SetTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Charge_Cover.png")
			end
			
			for i = 1,chargeCount do
				MW.charge[i].texFill:Show();
				MW.charge[i].texFill:SetVertexColor(c1.r, c1.g, c1.b, c1.a)
				if duration and expirationTime then
					local startTime = expirationTime - duration
					MW.charge[i].cooldown:SetCooldown(startTime, duration)
				else
					MW.charge[i].cooldown:Clear() -- Clear if no duration
				end
			end
		end

		if chargeCount > 5 then
			for i = 1, 5 do
				MW.charge[i].texFill:Show();
				MW.charge[i].texFill:SetVertexColor(c1.r, c1.g, c1.b, c1.a)
				MW.charge[i].texCover:SetTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Charge_Cover.png")
				if duration and expirationTime then
					local startTime = expirationTime - duration
					MW.charge[i].cooldown:SetCooldown(startTime, duration)
				else
					MW.charge[i].cooldown:Clear() -- Clear if no duration
				end
			end
			for i = 1,(chargeCount-5) do
				MW.charge[i].texFill:Show();
				MW.charge[i].texFill:SetVertexColor(c2.r, c2.g, c2.b, c2.a)
				MW.charge[i].texCover:SetTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Overcharge_Cover.png")
				if duration and expirationTime then
					local startTime = expirationTime - duration
					MW.charge[i].cooldown:SetCooldown(startTime, duration)
				else
					MW.charge[i].cooldown:Clear() -- Clear if no duration
				end
			end
		end

		return chargeCount
	else
		MW.lastChargeCount = 0;
		MW.lastExpirationTime = 0;
		
		MW.decorLeftAnimGroup:SetLooping("NONE");
		MW.decorRightAnimGroup:SetLooping("NONE");
		MW.decorLeftAnimGroup:Stop();
		MW.decorRightAnimGroup:Stop();
		MW.decorLeftTex:Hide();
		MW.decorRightTex:Hide();
		
		for i = 1, 5 do
			MW.charge[i].texFill:Hide();
			MW.charge[i].cooldown:Clear(); -- Clear cooldown if no aura
			MW.charge[i].texFill:SetVertexColor(c1.r, c1.g, c1.b, c1.a);
			MW.charge[i].texCover:SetTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Charge_Cover.png");
		end
		
		if MW.glowAnimGroup:IsPlaying() then
			MW.glowAnimGroup:Stop();
			MW.glowTex:Hide();
		end
	end
end

MW:Hide()

MW.commands = {
	["Show"] = function()
		editFrame.OnShow()
	end,
};

local function HandleSlashCommands(str)
	if (#str == 0) then
		MW.commands["Show"]();
		return;
	end

	local args = {};
	for _dummy, arg in ipairs({ string.split(' ', str) }) do
		if (#arg > 0) then
			table.insert(args, arg);
		end
	end

	local path = MW.commands; -- required for updating found table.

	for id, arg in ipairs(args) do

		if (#arg > 0) then --if string length is greater than 0
			arg = arg:lower();          
			if (path[arg]) then
				if (type(path[arg]) == "function") then
					-- all remaining args passed to our function!
					path[arg](select(id + 1, unpack(args))); 
					return;                 
				elseif (type(path[arg]) == "table") then
					path = path[arg]; -- another sub-table found!
				end
			else
				MW.commands["Show"]();
				return;
			end
		end
	end
end

local EventsTable = {
	"TRAIT_CONFIG_UPDATED",
	"PLAYER_TALENT_UPDATE",
	"PLAYER_ENTERING_WORLD",
	"ACTIVE_TALENT_GROUP_CHANGED",
	"PLAYER_TALENT_UPDATE",
	"SPEC_INVOLUNTARILY_CHANGED",
};

local EventsTableClassic = {
	"TRAIT_CONFIG_UPDATED",
	"PLAYER_TALENT_UPDATE",
	"PLAYER_ENTERING_WORLD",
	"ACTIVE_TALENT_GROUP_CHANGED",
	"PLAYER_TALENT_UPDATE",
};

MW:RegisterEvent("ADDON_LOADED");

MW:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "MaelstromWeapon" then
		InitDefaults();
		LoadFramePosition();
		SetFrameScale();
		ApplyColors();
		ApplyCooldownTextSettings();
		ApplyBackdropSettings();
        
		editFrame.scaler.ScaleSlider:SetValue(MaelWeap_DB.scale or 1)
		editFrame.scaler.TextSizeSlider:SetValue(MaelWeap_DB.cooldownFontSize or DefaultSettings.cooldownFontSize)

		SLASH_MAELSTROMWEAPON1 = L["SLASH_MW1"];
		SLASH_MAELSTROMWEAPON2 = L["SLASH_MW2"];
		SLASH_MAELSTROMWEAPON3 = L["SLASH_MW3"];
		SLASH_MAELSTROMWEAPON4 = L["SLASH_MW4"];
		SLASH_MAELSTROMWEAPON5 = L["SLASH_MW5"];
		SLASH_MAELSTROMWEAPON6 = L["SLASH_MW6"];
		SlashCmdList.MAELSTROMWEAPON = HandleSlashCommands;

		if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
			for k, v in pairs(EventsTable) do
				MW:RegisterEvent(v)
			end
		else
			for k, v in pairs(EventsTableClassic) do
				MW:RegisterEvent(v)
			end
		end
	end

	if event ~= "ADDON_LOADED" then
		if MW.SpecCheck() == true then
			MW:Show()
		else
			MW:Hide()
		end
	end

end);

MW.charge:SetScript("OnEvent", MW.ChargeCheck);