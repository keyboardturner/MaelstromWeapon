local classFilename, classId = UnitClassBase("player")

--Shaman only addon, so disable for anything non-Shaman
if classId ~= 7 then
	return
end

local MW = CreateFrame("frame", nil, UIParent)
MW:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
MW:SetSize(256,100)
MW:SetFrameStrata("BACKGROUND")
MW:SetScale(.90)
MW:SetClampedToScreen(true);

local editFrame = CreateFrame("Frame", nil, MW, BackdropTemplateMixin and "BackdropTemplate")
editFrame:SetWidth(500)
editFrame:SetHeight(300)
editFrame:SetAllPoints(MW)
local backdropInfo = {
	bgFile = "interface\\editmode\\editmodeuihighlightbackground",
	edgeFile = "Interface\\Buttons\\WHITE8X8",
	edgeSize = 2,
	insets = { left = 1, right = 1, top = 1, bottom = 1, },
}
editFrame:SetBackdrop(backdropInfo)
editFrame:SetBackdropColor(1,1,1,1) -- Black background
editFrame:SetBackdropBorderColor(.227,.773,1.00,1) -- White border

local function SaveFramePosition()
	if not MaelWeap_DB then MaelWeap_DB = {} end
	local point, relativeTo, relativePoint, xOfs, yOfs = MW:GetPoint();
	MaelWeap_DB.position = {point = point, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs};
end

local function LoadFramePosition()
	if MaelWeap_DB and MaelWeap_DB.position then
		local pos = MaelWeap_DB.position;
		MW:SetPoint(pos.point, UIParent, pos.relativePoint, pos.xOfs, pos.yOfs);
	else
		MW:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
	end
end

function editFrame.OnShow()
	editFrame:Show();
	MW:EnableMouse(true)
	MW:SetMovable(true)
	MW:RegisterForDrag("LeftButton")
	MW:SetScript("OnDragStart", MW.StartMoving)
	MW:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		SaveFramePosition()
	end)
end
function editFrame.OnHide()
		editFrame:Hide()
		MW:EnableMouse(false)
		MW:SetMovable(false)
end

local function WPDropDownDemo_Menu(frame, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	info.text, info.checked = "Blue Pill", true
	UIDropDownMenu_AddButton(info)
	info.text, info.checked = "Red Pill", false
	UIDropDownMenu_AddButton(info)
end

local Dropdown = CreateFrame("DropdownButton", nil, editFrame, "WowStyle1DropdownTemplate")
Dropdown:SetDefaultText("Options")
Dropdown:SetPoint("BOTTOMRIGHT", editFrame, "BOTTOMRIGHT", 0, 0);
Dropdown:SetSize(150,30)
Dropdown:SetupMenu(function(dropdown, rootDescription)
	rootDescription:CreateButton("Lock Button", editFrame.OnHide)
end)

editFrame:Hide()


MW.tex = MW:CreateTexture()
MW.tex:SetAllPoints()
MW.tex:SetTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Backdrop.blp")

MW.charge = CreateFrame("frame")
MW.charge:SetAllPoints(MW)
MW.charge:RegisterEvent("UNIT_AURA")
MW.charge:RegisterEvent("SPELL_UPDATE_COOLDOWN")
for i = 1,5 do
	MW.charge[i] = CreateFrame("frame", nil, MW)
	MW.charge[i]:SetPoint("CENTER", MW.charge, "CENTER", -80+(i*27), 0)
	MW.charge[i]:SetWidth(35)
	MW.charge[i]:SetHeight(35)

	MW.charge[i].texBase = MW.charge[i]:CreateTexture(nil, "BACKGROUND", nil, 1)
	MW.charge[i].texBase:SetAllPoints(MW.charge[i])
	MW.charge[i].texBase:SetTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Charge_Empty.blp")
	MW.charge[i].texFill = MW.charge[i]:CreateTexture(nil, "BACKGROUND", nil, 2)
	MW.charge[i].texFill:SetAllPoints(MW.charge[i])
	MW.charge[i].texFill:SetTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Points_Fill.blp")
	MW.charge[i].texCover = MW.charge[i]:CreateTexture(nil, "BACKGROUND", nil, 3)
	MW.charge[i].texCover:SetAllPoints(MW.charge[i])
	MW.charge[i].texCover:SetTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Charge_Cover.blp")
	MW.charge[i].cooldown = CreateFrame("Cooldown", nil, MW.charge[i], "CooldownFrameTemplate")
	MW.charge[i].cooldown:SetPoint("TOPLEFT", MW.charge[i], "TOPLEFT", -.5, .5)
	MW.charge[i].cooldown:SetPoint("BOTTOMRIGHT", MW.charge[i], "BOTTOMRIGHT", .5, -.5)
	MW.charge[i].cooldown:SetReverse(true)
	MW.charge[i].cooldown:SetSwipeTexture("Interface\\AddOns\\MaelstromWeapon\\Textures\\Charge_Cover.blp", 0,0,0,1)
	MW.charge[i].cooldown:SetUseCircularEdge(true)
	MW.charge[i].cooldown:SetEdgeScale(.8)


	MW.charge[i].texFill:Hide();
end

function MW.SpecCheck()
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
	for i = 1,5 do
		MW.charge[i].texFill:Hide();
		MW.charge[i].texFill:SetVertexColor(.75,.75,1)
	end
end

local buffInfo = {
	344179, -- Retail
	408505, -- Classic Era
	53817, -- Wrath/Cata
};

function MW.ChargeCheck()
	MW.ClearCharges()
	for k, v in pairs(buffInfo) do
		local aura = C_UnitAuras.GetPlayerAuraBySpellID(v)
		if aura then
			local chargeCount = aura.applications
			local duration = aura.duration
			local expirationTime = aura.expirationTime

			--[[
			if TotemFrame:IsShown() == true then
				TotemFrame:SetPoint("TOPLEFT", PlayerFrame, "BOTTOM", -46, 5)
				TotemFrame:SetScale(.9)
			end
			]]

			for i = 1, chargeCount do
				MW.charge[i].texFill:Show()
				MW.charge[i].texFill:SetVertexColor(.75, .75, 1)
				if duration and expirationTime then
					local startTime = expirationTime - duration
					MW.charge[i].cooldown:SetCooldown(startTime, duration)
				else
					MW.charge[i].cooldown:Clear() -- Clear if no duration
				end
			end

			if chargeCount > 5 then
				for i = 1, (chargeCount - 5) do
					MW.charge[i].texFill:SetVertexColor(1, .35, .35)
				end
			end

			return chargeCount
		else
			for i = 1, 5 do
				MW.charge[i].texFill:Hide()
				MW.charge[i].cooldown:Clear() -- Clear cooldown if no aura
				MW.charge[i].texFill:SetVertexColor(.75, .75, 1)
			end
			return 0
		end
	end
end

MW:Hide()

MW.commands = {
	["Show"] = function()
		editFrame.OnShow()
	end,

	--[[
	["test"] = function()
		Print("Test.");
	end,

	["hello"] = function(subCommand)
		if not subCommand or subCommand == "" then
			Print("No Command");
		elseif subCommand == "world" then
			Print("Specified Command");
		else
			Print("Invalid Sub-Command");
		end
	end,
	]]

	["help"] = function() --because there's not a lot of commands, don't use this yet.
		local concatenatedString
		for k, v in pairs(MW.commands) do
			if concatenatedString == nil then
				concatenatedString = "|cFF00D1FF"..k.."|r"
			else
				concatenatedString = concatenatedString .. ", ".. "|cFF00D1FF"..k.."|r"
			end
			
		end
		print("List Commands: " .. " " .. concatenatedString)
	end
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

MW:RegisterEvent("ADDON_LOADED");

local LOCALE = GetLocale();

local slashCmdLocalized_1 = "/maelstromweapon";

local function adjustSlashCmd()

	if LOCALE == "enUS" then
		-- The EU English game client also
		-- uses the US English locale code.
		slashCmdLocalized_1 = "/maelstromweapon";
	return end

	if LOCALE == "esES" or LOCALE == "esMX" then
		-- Spanish translations go here

		slashCmdLocalized_1 = "/armavorágine";
	return end

	if LOCALE == "deDE" then
		-- German translations go here

		slashCmdLocalized_1 = "/waffedesmahlstroms";
	return end

	if LOCALE == "frFR" then
		-- French translations go here

		slashCmdLocalized_1 = "/armedumaelström";
	return end

	if LOCALE == "itIT" then
		-- French translations go here

		slashCmdLocalized_1 = "/armadelmaelstrom";
	return end

	if LOCALE == "ptBR" then
		-- Brazilian Portuguese translations go here

		slashCmdLocalized_1 = "/armadavoragem";
	-- Note that the EU Portuguese WoW client also
	-- uses the Brazilian Portuguese locale code.
	return end

	if LOCALE == "ruRU" then
		-- Russian translations go here

		slashCmdLocalized_1 = "/оружиеводоворота";
	return end

	if LOCALE == "koKR" then
		-- Korean translations go here

		slashCmdLocalized_1 = "/소용돌이치는무기";
	return end

	if LOCALE == "zhCN" then
		-- Simplified Chinese translations go here

		slashCmdLocalized_1 = "/漩涡武器";
	return end

	if LOCALE == "zhTW" then
		-- Traditional Chinese translations go here

		slashCmdLocalized_1 = "/漩涡武器";
	return end

end


MW:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "MaelstromWeapon" then
		adjustSlashCmd();

		LoadFramePosition();

		SLASH_MAELSTROMWEAPON1 = slashCmdLocalized_1;
		SlashCmdList.MAELSTROMWEAPON = HandleSlashCommands;

		for k, v in pairs(EventsTable) do
			MW:RegisterEvent(v)
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