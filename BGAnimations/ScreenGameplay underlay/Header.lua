return Def.Quad{
	Name="TopBar",
	InitCommand=function(self)
		self:diffuse(0,0,0,0.85):zoomtowidth(_screen.w):valign(0):xy( _screen.cx, 0 )
 		self:zoomtoheight(80)
	end
}