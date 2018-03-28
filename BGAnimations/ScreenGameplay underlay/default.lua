-- load certain preferences before gameplay initializes
local modslevel = topscreen  == "ScreenEditOptions" and "ModsLevel_Stage" or "ModsLevel_Preferred"
local playeroptions = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions(modslevel)
playeroptions:Mini( 2 - playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).ReceptorSize/50 )
local profile = PROFILEMAN:GetProfile(PLAYER_1)
if profile:IsCurrentChartPermamirror() then	-- turn on mirror if song is flagged as perma mirror
	playeroptions:Mirror( true )
end

local bgtype = playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).BackgroundType
local songoptions = GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred')
-- this seems really stupid - mina
if bgtype == 1 then
	songoptions:StaticBackground(false)
	songoptions:RandomBGOnly(false)
elseif bgtype == 2 then 
	songoptions:StaticBackground(true)
	songoptions:RandomBGOnly(false)
elseif bgtype == 3 then
	songoptions:StaticBackground(false)
	songoptions:RandomBGOnly(true)
end

-- semi-transparent quad at the top of ScreenGameplay
t[#t+1] = LoadActor("Header.lua")

local t = Def.ActorFrame{}
t[#t+1] = LoadActor("bg")
t[#t+1] = LoadActor("ScreenFilter")
return t