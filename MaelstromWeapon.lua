local classFilename, classId = UnitClassBase("player")

--Shaman only addon, so disable for anything non-Shaman
if classId ~= 7 then
	return
end

local MW = CreateFrame("frame", nil, UIParent)
MW:SetPoint("CENTER", PlayerFrame, "BOTTOM", 37,16)
MW:SetSize(256,100)
MW:SetFrameStrata("BACKGROUND")
MW:SetScale(.90)

local editFrame = CreateFrame("Frame", "MyFrame", MW, BackdropTemplateMixin and "BackdropTemplate")
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

function editFrame.OnShow()
	editFrame:Show();
	MW:EnableMouse(true)
	MW:SetMovable(true)
	MW:RegisterForDrag("LeftButton")
	MW:SetScript("OnDragStart", MW.StartMoving)
	MW:SetScript("OnDragStop", MW.StopMovingOrSizing)
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


	MW.charge[i].texFill:Hide();
end

function MW.SpecCheck()
	local id, name, description, icon, role, primaryStat = GetSpecializationInfo(GetSpecialization())
	if id == 263 then
		if TotemFrame:IsShown() == true then
			TotemFrame:SetPoint("TOPLEFT", PlayerFrame, "BOTTOM", -46, 5)
			TotemFrame:SetScale(.9)
		end
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
		if C_UnitAuras.GetPlayerAuraBySpellID(v) then
			local chargeCount = C_UnitAuras.GetPlayerAuraBySpellID(v).applications
			if TotemFrame:IsShown() == true then
				TotemFrame:SetPoint("TOPLEFT", PlayerFrame, "BOTTOM", -46, 5)
				TotemFrame:SetScale(.9)
			end
			if chargeCount <= 5 then
				for i = 1,chargeCount do
					MW.charge[i].texFill:Show();
					MW.charge[i].texFill:SetVertexColor(.75,.75,1)
				end
			end
			if chargeCount > 5 then
				for i = 1, 5 do
					MW.charge[i].texFill:Show();
					MW.charge[i].texFill:SetVertexColor(.75,.75,1)
				end
				for i = 1,(chargeCount-5) do
					MW.charge[i].texFill:Show();
					MW.charge[i].texFill:SetVertexColor(1,.35,.35)
				end
			end
			return chargeCount
		else
			local chargeCount = 0
			for i = 1,5 do
				MW.charge[i].texFill:Hide();
				MW.charge[i].texFill:SetVertexColor(.75,.75,1)
			end
			return chargeCount
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

MW:RegisterEvent("ADDON_LOADED")

MW:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "MaelstromWeapon" then


		SLASH_MAELSTROMWEAPON1 = "/".."maelstromweapon"
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

MW.charge:SetScript("OnEvent", MW.ChargeCheck)