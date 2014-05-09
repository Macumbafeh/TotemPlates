local AddOn = "TotemPlates"

local Table = {
	["Nameplates"] = {},
	["Totems"] = {
		["Mana Spring Totem V"] = false,
		["Poison Cleansing Totem"] = false,
		["Magma Totem V"] = false,
		["Magma Totem I"] = false,
		["Earth Elemental Totem"] = false,
		["Earthbind Totem"] = false,
		["Fire Resistance Totem IV"] = false,
		["Fire Nova Totem VII"] = false,
		["Frost Resistance Totem IV"] = false,
		["Grounding Totem"] = true,
		["Healing Stream Totem VI"] = false,
		["Nature Resistance Totem VI"] = false,
		["Searing Totem VII"] = false,
		["Searing Totem I"] = false,
		["Sentry Totem"] = false,
		["Stoneclaw Totem VII"] = false,
		["Stoneclaw Totem I"] = false,
		["Stoneskin Totem VIII"] = false,
		["Strength of Earth Totem VI"] = false,
		["Totem of Wrath III"] = false,
		["Tremor Totem"] = true,
		["Wrath of Air Totem"] = false,
		["Fire Elemental Totem"] = false,
		["Wrath of Air Totem I"] = false,
		["Mana Tide Totem"] = false,
		["Windfury Totem V"] = false,
		["Windfury Totem I"] = false,
		["Grace of Air Totem III"] = false,
	},
	xOfs = 0,
	yOfs =  5,
	Scale = 1,
}
local function log(msg) DEFAULT_CHAT_FRAME:AddMessage(msg) end -- alias for convenience

local function UpdateObjects(hp)
	frame = hp:GetParent()
	local hpborder, cbborder, cbicon, overlay, oldname, level, bossicon, raidicon = frame:GetRegions()
	--local overlayRegion, castBarOverlayRegion, spellIconRegion, highlightRegion, nameTextRegion, bossIconRegion, levelTextRegion, raidIconRegion = frame:GetRegions()
	local name = oldname:GetText()

	for totem in pairs(Table["Totems"]) do
		if ( name == totem and Table["Totems"][totem] == true ) then
			overlay:SetAlpha(0) 
			hpborder:Hide()
			oldname:Hide()
			level:Hide()
			hp:SetAlpha(0)
			raidicon:Hide()
			if not frame.totem then
				frame.totem = frame:CreateTexture(nil, "BACKGROUND")
				frame.totem:ClearAllPoints()
				frame.totem:SetPoint("CENTER",frame,"CENTER",Table.xOfs,Table.yOfs)
			else
				frame.totem:Show()
			end	
			frame.totem:SetTexture("Interface\\AddOns\\" .. AddOn .. "\\Textures\\" .. totem)
			frame.totem:SetWidth(64 *Table.Scale)
			frame.totem:SetHeight(64 *Table.Scale)
			break
		elseif ( name == totem ) then
			overlay:SetAlpha(0) 
			hpborder:Hide()
			oldname:Hide()
			level:Hide()
			hp:SetAlpha(0)
			raidicon:Hide()
			break
		else
			overlay:SetAlpha(1) 
			hpborder:Show()
			oldname:Show()
			level:Show()
			hp:SetAlpha(1)
			if frame.totem then frame.totem:Hide() end
		end
	end
end

local function SkinObjects(frame)
	local HealthBar, CastBar = frame:GetChildren()
	--local threat, hpborder, cbshield, cbborder, cbicon, overlay, oldname, level, bossicon, raidicon, elite = frame:GetRegions()
	local overlayRegion, castBarOverlayRegion, spellIconRegion, highlightRegion, nameTextRegion, bossIconRegion, levelTextRegion, raidIconRegion = frame:GetRegions()

	HealthBar:SetScript("OnShow", UpdateObjects)
	HealthBar:SetScript("OnSizeChanged", UpdateObjects)

	UpdateObjects(HealthBar)
	Table["Nameplates"][frame] = true
end

local select = select
local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
		local region = frame:GetRegions()
		if ( not Table["Nameplates"][frame] and not frame:GetName() and region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\Tooltips\\Nameplate-Border" ) then
			SkinObjects(frame)						
			frame.region = region
		end
	end
end

local Frame = CreateFrame("Frame")
Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
Frame:SetScript("OnUpdate", function(self, elapsed)
	if ( WorldFrame:GetNumChildren() ~= numChildren ) then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())		
	end
end)
Frame:SetScript("OnEvent", function(self, event, name) 
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		if ( not _G[AddOn .. "_PlayerEnteredWorld"] ) then
			DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff" .. AddOn .. "|cffffffff Loaded")
			_G[AddOn .. "_PlayerEnteredWorld"] = true
		end	
	end
end)