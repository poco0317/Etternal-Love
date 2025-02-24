local active = true
local numericinputactive = false
local whee

local function input(event)
	if event.type ~= "InputEventType_Release" and active then
		if numericinputactive == false then
			for i=1,8 do
				if event.DeviceInput.button == "DeviceButton_"..i then
					setTabIndex(i-1)
					MESSAGEMAN:Broadcast("TabChanged")
				end
			end
		end
		if event.DeviceInput.button == "DeviceButton_left mouse button" then
			MESSAGEMAN:Broadcast("MouseLeftClick")
		elseif event.DeviceInput.button == "DeviceButton_right mouse button" then
			MESSAGEMAN:Broadcast("MouseRightClick")
		end
	end
	return false
end

local t = Def.ActorFrame{
	OnCommand=function(self) 
		SCREENMAN:GetTopScreen():AddInputCallback(input)
		whee = SCREENMAN:GetTopScreen():GetMusicWheel()
	end,
	BeginCommand=function(self) resetTabIndex() end,
	PlayerJoinedMessageCommand=function(self) resetTabIndex() end,
	BeginningSearchMessageCommand=function(self) active = true end,	-- this is for disabling numeric input in the text search and is unused atm
	EndingSearchMessageCommand=function(self) active = true end,
	NumericInputActiveMessageCommand=function(self) numericinputactive = true end,
	NumericInputEndedMessageCommand=function(self) numericinputactive = false end,
}

-- Just for debug
--[[
t[#t+1] = LoadFont("Common Normal") .. {
	InitCommand=function(self)
		self:xy(300,300):halign(0):zoom(2):diffuse(getMainColor(2))
	end;
	BeginCommand=function(self)
		self:queuecommand("Set")
	end;
	SetCommand=function(self)
		self:settext(getTabIndex())
	end;
	CodeMessageCommand=function(self)
		self:queuecommand("Set")
	end;
};
--]]
--======================================================================================

local tabNames = {"General","MSD","Score","Search","Profile","Filters", "Goals", "Playlists"} -- this probably should be in tabmanager.

local frameWidth = (SCREEN_WIDTH*(403/854))/(#tabNames-1)
local frameX = frameWidth/2
local frameY = SCREEN_HEIGHT-70

function tabs(index)
	local t = Def.ActorFrame{
		Name="Tab"..index;
		InitCommand=function(self)
			self:xy(frameX+((index-1)*frameWidth),frameY)
		end;
		BeginCommand=function(self)
			self:queuecommand("Set")
		end;
		SetCommand=function(self)
			self:finishtweening()
			self:linear(0.1)
			--show tab if it's the currently selected one
			if getTabIndex() == index-1 then
				self:y(frameY)
				self:diffusealpha(1)
			else -- otherwise "Hide" them
				self:y(frameY)
				self:diffusealpha(0.65)
			end;
		end;
		TabChangedMessageCommand=function(self)
			self:queuecommand("Set")
		end;
		PlayerJoinedMessageCommand=function(self)
			self:queuecommand("Set")
		end;
	};

	t[#t+1] = Def.Quad{
		Name="TabBG";
		InitCommand=function(self)
			self:y(-2):valign(0):zoomto(frameWidth+16,20):diffusecolor(getMainColor('frames')):diffusealpha(0.85)
		end;
		MouseLeftClickMessageCommand=function(self)
			if isOver(self) then
				setTabIndex(index-1)
				MESSAGEMAN:Broadcast("TabChanged")
			end;
		end;
	};
		
	t[#t+1] = LoadFont("_wendy small") .. {
		InitCommand=function(self)
			self:y(-3):valign(0):zoom(0.22):diffuse(getMainColor('positive'))
		end,
		BeginCommand=function(self)
			self:queuecommand("Set")
		end,
		SetCommand=function(self)
			self:settext(tabNames[index])
			if isTabEnabled(index) then
				if index == 6 and FILTERMAN:AnyActiveFilter() then
					self:diffuse(color("#cc66ff"))
				else					
					self:diffuse(getEtternalColor(index))
				end
			else
				self:diffuse(color("#1E282F"))
			end
		end,
		PlayerJoinedMessageCommand=function(self)
			self:queuecommand("Set")
		end,
		UpdateFilterMessageCommand=function(self)
			self:queuecommand("Set")
		end,
	};
	return t
end;

--Make tabs
for i=1,#tabNames do
	t[#t+1] =tabs(i)
end;

return t
