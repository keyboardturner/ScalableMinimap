local defaultsTable = {
	cluster = 1,
	minimap = 1,
}
--TOP MinimapCluster TOP 10 -13

local SMMScalerPanel = CreateFrame("FRAME");
SMMScalerPanel.name = "Scalable Minimap";

SMMScalerPanel.Headline = SMMScalerPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
SMMScalerPanel.Headline:SetFont(SMMScalerPanel.Headline:GetFont(), 23);
SMMScalerPanel.Headline:SetTextColor(0,1,0,1);
SMMScalerPanel.Headline:ClearAllPoints();
SMMScalerPanel.Headline:SetPoint("TOPLEFT", SMMScalerPanel, "TOPLEFT",12,-12);
SMMScalerPanel.Headline:SetText("Scalable Minimap");

SMMScalerPanel.Version = SMMScalerPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
SMMScalerPanel.Version:SetFont(SMMScalerPanel.Version:GetFont(), 12);
SMMScalerPanel.Version:SetTextColor(1,1,1,1);
SMMScalerPanel.Version:ClearAllPoints();
SMMScalerPanel.Version:SetPoint("TOPLEFT", SMMScalerPanel, "TOPLEFT",400,-21);
SMMScalerPanel.Version:SetText("Version: " .. GetAddOnMetadata("ScalableMinimap", "Version"));

------------------------------------------------------------------------------------------------------------------

SMMScalerPanel.ClusterSlider = CreateFrame("Slider", "SMMScalerClusterSlider", SMMScalerPanel, "OptionsSliderTemplate");
SMMScalerPanel.ClusterSlider:SetWidth(300);
SMMScalerPanel.ClusterSlider:SetHeight(15);
SMMScalerPanel.ClusterSlider:SetMinMaxValues(50,250);
SMMScalerPanel.ClusterSlider:SetValueStep(1);
SMMScalerPanel.ClusterSlider:ClearAllPoints();
SMMScalerPanel.ClusterSlider:SetPoint("TOPLEFT", SMMScalerPanel, "TOPLEFT",12,-53);
getglobal(SMMScalerPanel.ClusterSlider:GetName() .. 'Low'):SetText('50');
getglobal(SMMScalerPanel.ClusterSlider:GetName() .. 'High'):SetText('250');
getglobal(SMMScalerPanel.ClusterSlider:GetName() .. 'Text'):SetText('Cluster Frame Size');
SMMScalerPanel.ClusterSlider:SetScript("OnValueChanged", function()
	local scaleValue = getglobal(SMMScalerPanel.ClusterSlider:GetName()):GetValue() / 100;
	ScaleMinimap_DB.cluster = scaleValue;
	MinimapCluster:SetScale(scaleValue);
end)

------------------------------------------------------------------------------------------------------------------

SMMScalerPanel.MinimapSlider = CreateFrame("Slider", "SMMScalerMinimapSlider", SMMScalerPanel, "OptionsSliderTemplate");
SMMScalerPanel.MinimapSlider:SetWidth(300);
SMMScalerPanel.MinimapSlider:SetHeight(15);
SMMScalerPanel.MinimapSlider:SetMinMaxValues(50,250);
SMMScalerPanel.MinimapSlider:SetValueStep(1);
SMMScalerPanel.MinimapSlider:ClearAllPoints();
SMMScalerPanel.MinimapSlider:SetPoint("TOPLEFT", SMMScalerPanel, "TOPLEFT",12,-53*2);
getglobal(SMMScalerPanel.MinimapSlider:GetName() .. 'Low'):SetText('50');
getglobal(SMMScalerPanel.MinimapSlider:GetName() .. 'High'):SetText('250');
getglobal(SMMScalerPanel.MinimapSlider:GetName() .. 'Text'):SetText('Minimap Frame Size');
SMMScalerPanel.MinimapSlider:SetScript("OnValueChanged", function()
	local scaleValue = getglobal(SMMScalerPanel.MinimapSlider:GetName()):GetValue() / 100;
	ScaleMinimap_DB.minimap = scaleValue;
	Minimap:SetScale(scaleValue);
end)

------------------------------------------------------------------------------------------------------------------

SMMScalerPanel.Button = CreateFrame("Button", nil, SMMScalerPanel, "UIPanelButtonTemplate")
SMMScalerPanel.Button:SetPoint("TOPLEFT", 350, -53)
SMMScalerPanel.Button:SetText("Reset Size")
SMMScalerPanel.Button:SetWidth(100)
SMMScalerPanel.Button:SetScript("OnClick", function()
	ScaleMinimap_DB.cluster = 1;
	ScaleMinimap_DB.minimap = 1;
	MinimapCluster:SetScale(1);
	SMMScalerPanel.ClusterSlider:SetValue(ScaleMinimap_DB.cluster*100)
	SMMScalerPanel.MinimapSlider:SetValue(ScaleMinimap_DB.minimap*100)
	Minimap:ClearAllPoints()
	Minimap:SetPoint("TOP", MinimapCluster, "TOP", 10, -13)
end)


------------------------------------------------------------------------------------------------------------------

InterfaceOptions_AddCategory(SMMScalerPanel);

------------------------------------------------------------------------------------------------------------------

local SMMEventFrame = CreateFrame("Frame");
SMMEventFrame:RegisterEvent("ADDON_LOADED");
SMMEventFrame:RegisterEvent("PLAYER_LOGOUT");


------------------------------------------------------------------------------------------------------------------

function SMMEventFrame:OnEvent(event,arg1)
	if event == "ADDON_LOADED" and arg1 == "ScalableMinimap" then
		if not ScaleMinimap_DB then
			ScaleMinimap_DB = defaultsTable;
		end
		if not ScaleMinimap_DB.cluster then
			ScaleMinimap_DB.cluster = defaultsTable.cluster;
		end
		if not ScaleMinimap_DB.minimap then
			ScaleMinimap_DB.minimap = defaultsTable.minimap;
		end
		SMMScalerPanel.ClusterSlider:SetValue(ScaleMinimap_DB.cluster*100);
		SMMScalerPanel.MinimapSlider:SetValue(ScaleMinimap_DB.minimap*100);
		MinimapCluster:SetClampedToScreen(true);
		Minimap:SetClampedToScreen(true);
	end
	if event == "PLAYER_LOGOUT" then
		MinimapCluster:SetScale(1)
		Minimap:SetScale(1)
	end
end
SMMEventFrame:SetScript("OnEvent",SMMEventFrame.OnEvent);