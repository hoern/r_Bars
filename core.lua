local rClass = select(2, UnitClass("player"))

PlayerFrame_AnimateOut = function(self) return end

rBar = CreateFrame("Frame")
local scale = 0.8
local bsize,_ = _G["ActionButton1"]:GetSize()
local bsize = tonumber(bsize) * scale

rBar.textures = {
	BonusActionBarFrameTexture1,
	BonusActionBarFrameTexture2,
	BonusActionBarFrameTexture3,
	PossessBackground1,
	PossessBackground2,
	SlidingActionBarTexture0,
	SlidingActionBarTexture1,
	ShapeshiftBarLeft,
	ShapeshiftBarRight,
	ShapeshiftBarMiddle
}

rBar.bars = {
	ReputationWatchBar,
	MainMenuExpBar,
	MainMenuBarArtFrame,
	VehicleMenuBarArtFrame,
	VehicleMenuBarLeaveButton,
  ReputationWatchStatusBar
}

rBar.totemButtons = {
	MultiCastSummonSpellButton,
	MultiCastActionPage1,
	MultiCastActionPage2,
	MultiCastActionPage3,
	MultiCastSlotButton1,
	MultiCastSlotButton2,
	MultiCastSlotButton3,
	MultiCastSlotButton4,
	MultiCastFlyoutFrame,
	MultiCastFlyoutButton,
	MultiCastRecallSpellButton,
}

for k, v in pairs(rBar.textures) do
	v:SetTexture(nil)
	v:SetAlpha(0)
end

for k,v in pairs(rBar.bars) do
	v:Hide()
	v:SetAlpha(0)
	v:SetWidth(0.001)
	if v:IsShown() then
		v:Hide()
	end
end

function rFrame(name, pos)
	local b = CreateFrame("Frame", name, UIParent)
	b:SetPoint(pos.anchor, UIParent, pos.anchorTo, pos.x, pos.y)
	b:SetWidth(0.1)
	b:SetHeight(0.1)
	return b
end

MainMenuBar:ClearAllPoints()

wpb = NUM_ACTIONBAR_BUTTONS / 2
spb = NUM_SHAPESHIFT_SLOTS
len = (wpb * bsize)
blen = (spb * bsize)

print(len)

rBar.mainBar =  rFrame("rMain",  {anchor = "TOPRIGHT",    anchorTo = "BOTTOM",     x = -(len+80), y = 170 })
rBar.blBar =    rFrame("rBl",    {anchor = "TOPRIGHT",    anchorTo = "BOTTOM",     x = -(len+80), y = 100 })
rBar.brBar =    rFrame("rBr",    {anchor = "TOPRIGHT",    anchorTo = "BOTTOM",     x = 80,        y = 170 })
rBar.mblBar =   rFrame("rmBl",   {anchor = "TOPRIGHT",    anchorTo = "BOTTOM",     x = 80,      	y = 100 })
rBar.mbrBar =   rFrame("rmBr",   {anchor = "BOTTOMRIGHT", anchorTo = "BOTTOMLEFT", x = 0,       	y = 0   })
rBar.shapeBar = rFrame("rShape", {anchor = "CENTER",      anchorTo = "BOTTOM",     x = -(blen/2), y = 0   })
rBar.totemBar = rFrame("tBar",   {anchor = "CENTER",      anchorTo = "BOTTOM",     x = -(blen/2), y = 0   })
rBar.petBar =   rFrame("pBar",   {anchor = "CENTER",      anchorTo = "BOTTOMRIGHT",x = -len-10, y = 5   })
rBar.vBar =     rFrame("vBar",   {anchor = "TOPRIGHT",    anchorTo = "BOTTOM",     x = -(len+80), y = 170 })

function rRepos(type, anchor, parent, wrap, scale, numbs)
	for i=1, numbs do
		local button = _G[type.."Button"..i]
		if not button then return end
		button:SetScale(scale)
		if type == "Action" then
			button:SetParent(parent)
			button:SetAttribute("showgrid", 1);
		end
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", 0, 0)
		elseif i ~= 7 or not wrap then
			button:SetPoint("TOPLEFT", _G[type.."Button"..i-1], "TOPRIGHT", 2, 0)
		elseif i == 7 and wrap then
			button:SetPoint("TOPLEFT", _G[type.."Button"..1], "BOTTOMLEFT", 0, 2)
		end
	end
end

rRepos("Action",              rBar.mainBar,   MainMenuBar,    true,  scale, NUM_ACTIONBAR_BUTTONS)
rRepos("BonusAction",         rBar.mainBar,   MainMenuBar,    true,  scale, NUM_ACTIONBAR_BUTTONS)
rRepos("MultiBarBottomLeft",  rBar.blBar,     rBar.blBar,     true,  scale, NUM_ACTIONBAR_BUTTONS)
rRepos("MultiBarBottomRight", rBar.brBar,     rBar.brBar,     true,  scale, NUM_ACTIONBAR_BUTTONS)
rRepos("MultiBarRight",       rBar.mbrBar,    rBar.mbrBar,    false, scale, NUM_ACTIONBAR_BUTTONS)
rRepos("MultiBarLeft",        rBar.mblBar,    rBar.mblBar,    true,  scale, NUM_ACTIONBAR_BUTTONS)
rRepos("Shapeshift",          rBar.shapeBar,  rBar.shapeBar,  true,  scale, NUM_SHAPESHIFT_SLOTS)
rRepos("PetAction",           rBar.petBar,    rBar.petBar,    false, scale, NUM_PET_ACTION_SLOTS)
rRepos("VehicleMenuBarAction", rBar.vBar,     rBar.vBar,      true,  scale, NUM_ACTIONBAR_BUTTONS)

-- MainMenuBar:SetParent(MainMenuBar)
BonusActionBarFrame:SetParent(MainMenuBar)
MultiBarBottomLeft:SetParent(rBar.blBar)
MultiBarBottomRight:SetParent(rBar.brBar)
MultiBarRight:SetParent(rBar.mbrBar)
MultiBarRight:SetParent(rBar.mblBar)
ShapeshiftBarFrame:SetParent(rBar.shapeBar)
PetActionBarFrame:SetParent(rBar.petBar)

local vms,_ = _G["VehicleMenuBarActionButton1"]:GetSize()
VehicleMenuBar:ClearAllPoints()
VehicleMenuBar:SetPoint("RIGHT", Minimap, "LEFT", 0, 0)

if rClass == "SHAMAN" then
	-- override totem bar location
	rBar.totemBar:SetPoint("BOTTOMLEFT", rBar.mainBar, "TOPLEFT", 0, 45)
	rBar.totemBar:SetWidth(230)
	rBar.totemBar:SetHeight(40)
	rBar.totemBar:SetScale(scale)
	rBar.totemBar:Show()
	for _, f in pairs(rBar.totemButtons) do
		f:SetParent(rBar.totemBar);
	end
	MultiCastSummonSpellButton:ClearAllPoints();
	MultiCastSummonSpellButton:SetPoint("BOTTOMLEFT", 3, 3);
	local page;
	for i = 1, NUM_MULTI_CAST_PAGES do
		page = _G["MultiCastActionPage"..i];
		page:SetPoint("BOTTOMLEFT", 50, 3);
	end
	MultiCastRecallSpellButton:SetPoint("BOTTOMLEFT", 50, 3);
	TotemFrame:ClearAllPoints()
	TotemFrame:SetPoint("CENTER", Minimap, "TOP", 0, 22)
end

-- Clean Up BonusBar

function rOverride()
	local barType = GetBonusBarOverrideBarType() or "default"
	BonusActionBarFrame.currentType = barType;
end

SetupBonusActionBar = rOverride

local function rxFrame(f,num,alpha)
	for i=1, num do
		_G[f..i]:SetAlpha(alpha)
	end
end

BonusActionBarFrame:HookScript("OnShow", function(self) rxFrame("ActionButton",12,0) end)
BonusActionBarFrame:HookScript("OnHide", function(self) rxFrame("ActionButton",12,1) end)

-- Vehicle Code

rVehicle = CreateFrame("BUTTON", nil, UIParent, "SecureActionButtonTemplate")
rVehicle:SetSize(35,35)
rVehicle:SetPoint("TOPRIGHT", rBar.mainBar, "TOPLEFT", 0, 0)
rVehicle:RegisterForClicks("AnyUp")
rVehicle:SetScript("OnClick", function() VehicleExit() end)
rVehicle:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
rVehicle:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
rVehicle:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
rVehicle:SetAlpha(0)
rVehicle:Hide()
rVehicle:RegisterEvent("UNIT_ENTERING_VEHICLE")
rVehicle:RegisterEvent("UNIT_ENTERED_VEHICLE")
rVehicle:RegisterEvent("UNIT_EXITING_VEHICLE")
rVehicle:RegisterEvent("UNIT_EXITED_VEHICLE")
rVehicle:RegisterEvent("ZONE_CHANGED_NEW_AREA")
rVehicle:SetScript("OnEvent", function(self, event, ...)
	local arg1 = ...;
	if(((event=="UNIT_ENTERING_VEHICLE") or (event=="UNIT_ENTERED_VEHICLE")) and arg1 == "player") then
			rVehicle:Show()
			rVehicle:SetAlpha(1)
			VehicleMenuBar:SetScale(0.7)
	elseif (((event=="UNIT_EXITING_VEHICLE") or (event=="UNIT_EXITED_VEHICLE")) and arg1 == "player") or (event=="ZONE_CHANGED_NEW_AREA" and not UnitHasVehicleUI("player")) then
			rVehicle:Hide()
			rVehicle:SetAlpha(0)
	end
end)